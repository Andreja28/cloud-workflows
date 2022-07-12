function G = curvsum2(nz,b,hd)
% sum of Gauss-curves
sux=0;
for x1=1:nz
    sux=sux + b(nz*4+x1)*(normcdf(hd,b(x1),b(nz+x1)));
end
G = sux;
