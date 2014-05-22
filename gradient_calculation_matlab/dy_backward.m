function [dy] = dy_backward(u)
[M N] = size(u);
dy = [u(1:end-1,:);zeros(1,N)] - [zeros(1,N);u(1:end-1,:)];