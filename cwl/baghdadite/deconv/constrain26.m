% Constrain routine
function [c, ceq] = constrain26(a,nz,vf2)
clear am
vf = vf2;
[Ca,Ja] = sort(a(1:nz));
for so=1:nz
    ab(so) = a(Ja(so));
    ab(so+nz) = a(Ja(so)+nz);
    ab(so+nz*2) = a(Ja(so)+nz*2);
    ab(so+nz*3) = a(Ja(so)+nz*3);
    ab(so+nz*4) = a(Ja(so)+nz*4);
end
% Distances between curves
am(1:nz-1) = ab(2:nz) - ab(1:nz-1) -vf*(ab(1+nz:2*nz-1) + ab(2+nz:2*nz));
am(nz:2*nz-2) = ab(2+2*nz:3*nz) - ab(1+2*nz:3*nz-1) -vf*(ab(3*nz+1:4*nz-1) + ab(3*nz+2:4*nz));
am(2*nz-1:3*nz-2) = ab(4*nz+1:5*nz);
su=0;
% Sum of fractions
for sr=1:nz
    su=su+ab(4*nz+sr);
end
am(3*nz-1) = 1 - su;
am(3*nz) = 0.00001 - abs(am(3*nz-1));
c = -min(am);
ceq = [];