function[Psph_ef]=P_aniso_sph(C0,J,K)

muef = C0(6,6)/2 ;
kef = C0(1,1) - J(1,1) * 4 * muef ;

alpha_ef = 3*kef / (3 * kef + 4 * muef);
beta_ef = 6*(kef + 2 * muef) / (5 * (3 * kef + 4 * muef));

Ssphef = alpha_ef * J + beta_ef * K ;

Psph_ef = Ssphef * inv(C0) ;


