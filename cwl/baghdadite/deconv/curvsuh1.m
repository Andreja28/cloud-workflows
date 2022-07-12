function H = curvsuh1(nz,b,hd)
% sum of Gauss-curves
sux=0;
for x1=1:nz
    sux=sux + b(nz*4+x1)*(normpdf(hd,b(2*nz+x1),b(3*nz+x1)));
end
H = sux;
