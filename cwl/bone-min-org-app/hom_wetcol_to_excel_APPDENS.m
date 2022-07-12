% Homogenization from WET COLLAGEN to EXTRACELLULAR MATRIX
% based on extracellular APPARENT DENSITIES
function [Chom_excel]=hom_wetcol_to_excel_APPDENS(rho_org_excel,rho_HA_excel)
% Edited: IMWS Pircher Ukaj 2022-01-19
% Input: rho_org_excel ... apparent organic mass density in excel = m_org_excel /
% V_excel  [g/cm3]
% rho_HA_excel ... apparent mineral density in excel = m_HA_excel / V_excel
% [g/cm3]
% Output: Chom_excel ... homogenized stiffness matrix of extracellular
% matrix in [GPa]

%% 1.0 Specification of Parameters
%% 1.1 General - Tensordefinition
% 4th-order identity tensor
I=[1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1];
% volumetric part of the 4th-order identity tensor
J=[1/3 1/3 1/3 0 0 0; 1/3 1/3 1/3 0 0 0; 1/3 1/3 1/3 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];
% deviatoric part of the 4th-order identity tensor
K=I-J;
% second-order unit tensor
one2=eye(3);

%% 1.2 Material Properties General
%%%%%%%%%% REAL MASS DENSITIES START %%%%%%%%%%
rho_org = 1.42; %g/cm3
rho_HA = 3.00; %g/cm3
rho_H2O = 1.00; %g/cm3
%ionic fluid
rho_fl = rho_H2O; %g/cm3

%%%%%%%%%% REAL MASS DENSITIES END %%%%%%%%%%

%%%%%%%%%% VOLUME FRACTIONS START %%%%%%%%%%
% f_i_j = Volume fraction of phase i in space j
% f_i_j = V_i / V_j

%%%%% RVE excel - Extracellular bone matrix %%%%%
% Apparent Mass density to Volume Fractions
f_HA_excel = rho_HA_excel / rho_HA;
f_org_excel = rho_org_excel / rho_org;
f_H20_excel = 1 - f_HA_excel - f_org_excel;

% 90% of organic material is collagen (Urist 1983)
f_col_excel = 0.9 * f_org_excel;

%%% Introducing neutron diffraction spacings
%%% to determine saturated mineralized volume fractions
%%% Sources see (Vass et al 2013)
dmax=1.52; %nm; fully saturated-non mineralized spacing
ddry=1.09;%nm; fully dried-non mineralized spacing

% Volume fractions for fully mineralized saturated phases
f_HAINF_excel = f_HA_excel;
f_colINF_excel = f_col_excel;
f_flINF_excel = f_H20_excel;

f_ef0_excel = 1 - 1/0.88* ((dmax/ddry)^2) * f_colINF_excel / ( rho_HA*f_HAINF_excel / rho_fl + f_flINF_excel + f_colINF_excel ) ;%f_ef unmineralized saturated (Vass et al 2013 (34) )
f_col0_excel = f_colINF_excel / (rho_HA*f_HAINF_excel / rho_fl + f_flINF_excel + f_colINF_excel);% (Vass et al 2013 (40) )

f_fibINF_excel = 1 - f_ef0_excel *( (1+(rho_HA/rho_fl -1)*f_HAINF_excel ) + (1-rho_HA/rho_fl)*f_HAINF_excel /  (1-f_col0_excel) ) ;%(Vass et al 2013 (39) )

% Volume fraction for fibrils (fully saturated, fully mineralized=inf)
f_fib_excel = f_fibINF_excel;
f_ef_excel = 1 - f_fib_excel;

%%%%% RVE HA-extrafibrillar %%%%%
phi_HAef_ec = f_ef_excel / ( 1-f_col_excel); %rate of HAef to total HA (Vass et al 2013 (61) )
% Volume fractions extrafibrilar
f_efHA_ef = f_HA_excel*phi_HAef_ec/f_ef_excel; % (Vass et al 2013 (61) )
f_efIC_ef = 1 - f_efHA_ef; % (Vass et al 2013 (61) )

%%%%% RVE fibrillar %%%%%
f_fibHA_fib = f_HA_excel*(1-phi_HAef_ec)/f_fib_excel; % (Vass et al 2013 (62) )
f_wetcol_fib = 1 - f_fibHA_fib; % (Vass et al 2013 (62) )

%%%%% RVE wetcol %%%%%
f_molcol_wetcol = f_col_excel / (f_fib_excel*f_wetcol_fib);% (Vass et al 2013 (63) )
f_im_wetcol = 1 - f_molcol_wetcol; % (Vass et al 2013 (63) )
%%%%%%%%%% VOLUME FRACTIONS END %%%%%%%%%%

%%%%%%%% VOLUME FRACTIONS TESTING START %%%%%%
ftest_RVEwetcol = f_molcol_wetcol+f_im_wetcol;
ftest_RVEfib = f_fibHA_fib + f_wetcol_fib;
ftest_RVEef = f_efHA_ef + f_efIC_ef;
ftest_RVEexcel = f_fib_excel + f_ef_excel;
%%%%%%%% VOLUME FRACTIONS TESTING END %%%%%%%

%%%%%%%%%% STIFFNESS PARAMETERS START %%%%%%%%%%
% Stiffness HA
% (Katz Ukraincik 1971) assume ISOTROPIC HA behaviour
% Sources see (Vass et al 2013)
% Bulk modulus K [GPa] and Shear modulus [GPa]
K_HA = 82.6; %GPa
mu_HA = 44.9; %GPa
Cmat_HA = 3*K_HA*J + 2*mu_HA*K ;%; %GPa

% Stiffness ic (intercristalline=hosting waterfilled pores)
K_H2O = 2.3; %GPa
mu_H2O = 0.0; %GPa

K_IC = K_H2O; %GPa
mu_IC = mu_H2O; %GPa
Cmat_IC = 3*K_IC*J + 2*mu_IC*K ;%;%GPa

% Stiffness col (pure collagen)
% We follow the backcalculation of Vass2013, who translated Young'sModulus
% of Sasaki and Odajima 1996 (E=2,9GPa) and assuming a Poissons Ratio 0,34 as a
% middle value of the values nu_13=0,42 nu_12=0,26 measured by Cusack and
% Miller 1976: 0,34=(0,42+0,26)/2; translated these to account for the
% additional 12% microporosity that Sasaki did not account for (they
% assumed all collagen molecules being arranged in the generalized pattern when cutting a
% cross-section -- but in reality there will be some pattern-spaces where no collagen-molecule is present because they are replaced by
% HA-crystals due to cross linking gaps/overlapping gaps:
% This yields E_molcol = 3,28 GPa; Poissons ratio = 0,33
K_molcol = 3.28 / (3*(1-2*0.33)); %GPa
mu_molcol = 3.28 / (2*(1+0.33)); %GPa;
Cmat_molcol = 3*K_molcol*J + 2*mu_molcol*K ;%;%GPa

% Stiffness im = intermolecular space (water filled pores)
K_im = K_H2O; %GPa
mu_im = mu_H2O; %GPa
Cmat_im = 3*K_im*J + 2*mu_im*K ;%;%GPa

%%%%%%%%%% STIFFNESS PARAMETERS END %%%%%%%%%%

%% 2.0 Homogenization

%% 2.1 RVE WET COLLAGEN
% Wet Collagen - Mori Tanka Scheme with
% Phase 1 = Matrix: molcol
% Phase 2 = cylyndrical inclusions: im
phase_theta_im = 0;
phase_phi_im = 0;

% Morphology Tensors = Hill Tensors
%%% says how an inclusion A (with certain geometry) interacts within a
%%% matrix that has a certain stiffness Cmat
P_cyl_in_Cmatmolcol = P_iso_cyl(phase_theta_im,phase_phi_im,Cmat_molcol,J);

% Infinite Strain Concentration Tensors
A_inf_molcol = I;
A_inf_im = inv(I + P_cyl_in_Cmatmolcol*(Cmat_im - Cmat_molcol));

% Actual Strain Concentration Tensors
A_molcol = A_inf_molcol* inv( f_molcol_wetcol * A_inf_molcol + f_im_wetcol * A_inf_im );
A_im = A_inf_im* inv( f_molcol_wetcol * A_inf_molcol + f_im_wetcol * A_inf_im );

% Estimated Homogenized Stiffness
Chom_wetcol = f_molcol_wetcol * Cmat_molcol * A_molcol + f_im_wetcol * Cmat_im * A_im;

%% 2.2 RVE FIBRILAR SPACE = MINERALIZED COLLAGEN FIBRILS
% Mineralized Collage Fibrils = Self-consistent scheme
% Phase 1 = wetcol - cylindrical inclusion within transversly
% isotropic SCS-matrix
% Phase 2 = fibHA - spherical inclusions within transversly isotropic
% SCS-matrix

% SCS - sequence initiations
% Inititation SCS-Matrixstiffnesstensor with wetcollagenstiffness
Ctemp_start_fib = Chom_wetcol;
% Initiation of error with 1
F=1; % is reestimated after each run

while F>0.001
    % Morphology Tensors = Hill Tensors
    % P_isotrans_cyl ( transversal isotropic Stiffness matrix - symmetry axis
    % e3) for cylinders in e3 direction !!!
    P_cyl_in_Ctemp_fib_start = P_isotrans_cyl(Ctemp_start_fib);
    
    % P_isosph ( transversal isotropic Stiffness matrix - symmetry axis e3)
    P_sph_in_Ctemp_fib_start = P_isotrans_sph(Ctemp_start_fib);
    
    % Infinite Strain Concentration Tensors
    A_inf_wetcol = inv(I + P_cyl_in_Ctemp_fib_start*(Chom_wetcol - Ctemp_start_fib));
    A_inf_fibHA = inv(I + P_sph_in_Ctemp_fib_start*(Cmat_HA - Ctemp_start_fib));
    
    % Actual Strain Concentration Tensors
    A_wetcol = A_inf_wetcol* inv( f_wetcol_fib * A_inf_wetcol + f_fibHA_fib * A_inf_fibHA );
    A_fibHA = A_inf_fibHA* inv( f_wetcol_fib * A_inf_wetcol + f_fibHA_fib * A_inf_fibHA );
    
    % Estimated Homogenized Stiffness
    Ctemp_hom_fib = f_wetcol_fib * Chom_wetcol * A_wetcol + f_fibHA_fib * Cmat_HA * A_fibHA;
    
    % Error calculation
    F = abs((norm(Ctemp_hom_fib)-norm(Ctemp_start_fib))/(norm(Ctemp_hom_fib)));
    
    % Newdefinition of starting value for next sequence
    Ctemp_start_fib = Ctemp_hom_fib;
end

% Homogenized estimated Stiffness
Chom_fib = Ctemp_hom_fib;

%% 2.3 RVE HA-FOAM EXTRAFIBRILLAR
% Extrafibrillar space = Self-consistent scheme
% Phase 1 = efHA - infinitely many cylindrical inclusion within
% isotropic SCS-matrix
% Phase 2 = efIC - spherical inclusions within isotropic
% SCS-matrix

%%%%%%%%%%  NEEDLE FAMILIES PARAMETERS START %%%%%%%%%%
%
% Following the code approach of "badel and leblond2004"
%%% include 120 points
load('leblond.mat')
%%% define location-vectors-on-unit-sphere based on 120 discretisation
%%% points
%%% measurement of angles:
%%% theta is measured from e3-homogenizedmatrix
%%% phi is measured from e1-homogenizedmatrix
vector_cos_theta=cos(theta) ;
vector_sin_theta_sin_phi=sin(theta) .* sin(phi) ;
vector_sin_theta_cos_phi=sin(theta) .* cos(phi) ;
%%% gauss-weight per point
weight(:)=weight(:)/sum(weight);
%%% familiy count
max_fam = length(vector_cos_theta) ;
%%%%%%%%%%  NEEDLE FAMILIES PARAMETERS END %%%%%%%%%%


% SCS - sequence initiations
% Inititation SCS-Matrixstiffnesstensor with wetcollagenstiffness
Ctemp_ef_start = Cmat_HA;
% Initiation of error with 1
F=1; % is reestimated after each run

%%%%%% TBATBATBATBA
while F>0.001
    
    %We need to SUM UP the 120 different Concentration tensors for the
    %cylinder inclusions into one; we need a starting tensor
    Atemp_inf_efHA = zeros(6,6);
    
    %Calculate the Morphology and A_inf for each point and A tensor
    for gaussintegrationpointindex=1:length(vector_cos_theta)
        % gauss-point-angles
        theta1=theta(gaussintegrationpointindex);
        phi1 = phi(gaussintegrationpointindex);
        % Morphology Tensors = Hill Tensors efHA
        % P_iso_cyl ( isotropic Stiffness matrix ) for cylinders in
        % theta1,phi1-direction
        % function[Pcyl_GLOBAL]=P_iso_cyl(theta1,phi1,C0,J)
        %     P_cyltheta1phi1_in_Ctemp_efHA_ef = P_iso_cyl(theta1,phi1,Ctemp_start_ef,J);
        
        %Infinity concentration tensor --> redefined for each angles with its
        %according gauss-weight
        %     Ainf = inv(I + P_cyltheta1phi1_in_Ctemp_efHA_ef*( Cmat_HA -  Ctemp_start_ef));
        Atemp_inf_efHA_gaussintegrationpointindex = inv(I + P_iso_cyl(theta1,phi1,Ctemp_ef_start,J)*( Cmat_HA -  Ctemp_ef_start));
        Atemp_inf_efHA = Atemp_inf_efHA + weight(gaussintegrationpointindex)*Atemp_inf_efHA_gaussintegrationpointindex;
    end
    
    % Morphology Tensors = Hill Tensors efIM
    % P_isosph ( isotropic Stiffness matrix)
    P_sph_in_Ctemp_start_ef = P_iso_sph(Ctemp_ef_start,J,K);
    
    % Infinite Strain Concentration Tensors efIM
    A_inf_efHA = Atemp_inf_efHA ;
    A_inf_efIC = inv(I + P_sph_in_Ctemp_start_ef*(Cmat_IC - Ctemp_ef_start));
    
    % Actual Strain Concentration Tensors
    A_efHA = A_inf_efHA* inv( f_efHA_ef * A_inf_efHA + f_efIC_ef * A_inf_efIC );
    A_efIC = A_inf_efIC* inv( f_efHA_ef * A_inf_efHA + f_efIC_ef * A_inf_efIC );
    
    % Estimated Homogenized Stiffness
    Ctemp_hom_ef = f_efHA_ef * Cmat_HA * A_efHA + f_efIC_ef * Cmat_IC * A_efIC;
    
    % Error calculation
    F = abs((norm(Ctemp_hom_ef)-norm(Ctemp_ef_start))/(norm(Ctemp_hom_ef)));
    
    % Newdefinition of starting value for next sequence
    Ctemp_ef_start = Ctemp_hom_ef;
end

Chom_ef = Ctemp_hom_ef;

%% 2.4 RVE EXCEL - Extracellular bone matrix
% Extracellular bone matrix - Mori Tanaka Scheme
% Phase 1 = Matrix: ef
% Phase 2 = fib = cylindrical inclusions in isotropic matrix
phase_theta_fib = 0;
phase_phi_fib = 0;

% Morphology Tensors = Hill Tensors
P_cyl_in_Chom_ef = P_iso_cyl(phase_theta_fib,phase_phi_fib,Chom_ef,J);

% Infinite Strain Concentration Tensors
A_inf_ef = I;
A_inf_fib = inv(I + P_cyl_in_Chom_ef*(Chom_fib - Chom_ef));

% Actual Strain Concentration Tensors
A_ef = A_inf_ef* inv( f_ef_excel * A_inf_ef + f_fib_excel * A_inf_fib );
A_fib = A_inf_fib* inv( f_ef_excel * A_inf_ef + f_fib_excel * A_inf_fib );

% Estimated Homogenized Stiffness
Chom_excel = f_ef_excel * Chom_ef * A_ef + f_fib_excel * Chom_fib * A_fib;

end