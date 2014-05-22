function [dy] = dy_forward(u)
[M N] = size(u);
dy = [u(2:end,:); u(end,:)] - u;
