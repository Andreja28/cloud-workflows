function[Pcyl_GLOBAL]=P_iso_cyl(theta1,phi1,C0,J)

C0 = compress(rot2(theta1,phi1,expand(C0)));

muef = C0(6,6)/2 ;
kef = C0(1,1) - J(1,1) * 4 * muef ;

nuef = (3*kef - 2*muef)/(6*kef + 2*muef);

S=zeros(3,3,3,3);
% in local base
S(1,1,1,1) = (5-4*nuef)/(8*(1-nuef));
S(2,2,2,2) = S(1,1,1,1);
S(1,1,2,2) = (-1+4*nuef)/(8*(1-nuef));
S(2,2,1,1) = S(1,1,2,2);
S(1,1,3,3) = nuef / (2*(1-nuef));
S(2,2,3,3) = S(1,1,3,3);
S(2,3,2,3) = 1/4 ;
S(3,2,3,2) = 1/4 ;
S(3,2,2,3) = 1/4 ;
S(2,3,3,2) = 1/4 ;
S(3,1,3,1) = 1/4 ;
S(1,3,1,3) = 1/4 ;
S(1,3,3,1) = 1/4 ;
S(3,1,1,3) = 1/4 ;
S(1,2,1,2) = (3-4*nuef)/(8*(1-nuef));
S(2,1,2,1) = (3-4*nuef)/(8*(1-nuef));
S(2,1,1,2) = (3-4*nuef)/(8*(1-nuef));
S(1,2,2,1) = (3-4*nuef)/(8*(1-nuef));

Pcyl_GLOBAL = compress(rot2retour(theta1,phi1,expand(compress(S)* inv(C0))));
