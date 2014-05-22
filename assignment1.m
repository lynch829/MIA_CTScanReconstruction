function assignment1()

    clear all;
    close all;
    addpath('gradient_calculation_matlab');
    files = dir('sinograms\*.mat');
    for file = files'
        path = strcat('sinograms\',file.name);
        sino = load(path);
        img = process(sino.sinogram); 
        one = figure('visible','off'); imshow(img);
        title(file.name);
        saveas(one, strcat('results\', strcat(file.name, '_fpp.png')), 'png');
        u = rofDenoising(img, 10, 500);
        two = figure('visible','off'); imshow(u);
        title(file.name);
        saveas(two, strcat('results\', strcat(file.name, '_denoised.png')), 'png');
    end

end

function [tmp] = process(sino)

	[lines, angles] = size(sino);
    tmp = zeros(lines,lines);
    midoffset = floor(lines/2)+1;
    
    %create filter
    ramp = [lines/2:-1:0, 1:lines/2];
    rampfilter = 2* ramp / lines;
    
    %converting to rad
    theta = (0:angles-1) * (pi/180);
    
    for i = 1:angles
        %fourier transformation
        sino_fouriered = fft(sino(:,i));
        sino_fouriered = fftshift(sino_fouriered);
        %filtering
        sino_filtered = rampfilter' .* sino_fouriered;
        %reverse fourier transformation
        sino_filtered = ifftshift(sino_filtered);
        inversed_sino = real(ifft(sino_filtered));
        
        for x = 1:lines
            for y = 1:lines
                %rotate and use NN for values from sensor line
                t = (x-(floor(lines/2)+1))*cos(theta(i))+(y-(floor(lines/2)+1))*sin(theta(i))+ midoffset;
                t = round(t);
                
                if (t<1) || (t>lines)
                    continue
                end
                %smear over image
                tmp(x,y) = tmp(x,y) + inversed_sino(t)/angles;
            end   
        end
    end
end

function u = rofDenoising(f, lambda, maxIterations)
    u = f;
    tauD = 0.25;
    tauP = 0.25;
    [x,y] = size(f);
    p = double(zeros(x,y,2));
    
    for i = 1:maxIterations
        tauD = (0.2 + 0.08*i)*lambda;
        tauP = (0.5-5/(15+i))/tauD; 
        %dual update
        nabla_u = cat(3, dx_forward(u), dy_forward(u));
        p_updated = p + tauD * nabla_u;
        
        %projection of p
        temp = sqrt(p_updated(:,:,1).^2 + p_updated(:,:,2).^2);
        temp = cat(3, max(1,temp), max(1,temp));
        p_new = p_updated ./ temp;
        
        %primal update
        nabla_p = dx_backward(p_new(:,:,1)) + dy_backward(p_new(:,:,2));
        u_new = u + tauP * (nabla_p - lambda * (u - f));
        
        u = u_new;
        p = p_new;
    end
end
