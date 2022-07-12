% Homogenization from WET COLLAGEN to EXTRACELLULAR MATRIX
function [Chom_macro]=hom_excel_to_macro(Chom_excel,phi_vas,phi_lac)
% Edited: IMWS Pircher Ukaj 2022-01-19
% Input: Chom_excel ... homogenized stiffness matrix of extracellular
% matrix in [GPa]
% phi_vas ... vascular porosity = V_vas / V_macro
% phi_lac ... lacunar porosity = V_lac / V_macro
% Output: Chom_macro ... homogenized stiffness matrix of macro bone
% material in [GPa]


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

%%%%%%%%%% STIFFNESS PARAMETERS START %%%%%%%%%%
% Stiffness Water
K_H2O = 2.3; %GPa
mu_H2O = 0.0; %GPa

% Stiffness lac = lacunae pores (water filled pores)
K_lac = K_H2O; %GPa
mu_lac = mu_H2O; %GPa
Cmat_lac = 3*K_lac*J + 2*mu_lac*K ;%;%GPa

% Stiffness vas = vascular pores (water filled pores)
K_vas = K_H2O; %GPa
mu_vas = mu_H2O; %GPa
Cmat_vas = 3*K_vas*J + 2*mu_vas*K ;%;%GPa

%%%%%%%%%% STIFFNESS PARAMETERS END %%%%%%%%%%

%% 1.3 Volume Fractions
% RVE macro - Macro bone material
f_vas_macro = phi_vas;
f_exvas_macro = 1-f_vas_macro;

% RVE exvas - Extravascular bone material
f_lac_exvas = phi_lac / f_exvas_macro;
f_excel_exvas = 1-f_lac_exvas;


%% 2.5 RVE EXVAS - Extravascular bone material
% Extravascular bone material - Mori Tanaka Scheme
% Phase 1 = Matrix: excel
% Phase 2 = lac = spherical inclusions in transversal isotropic matrix

% Morphology Tensors = Hill Tensors
P_sph_in_Chom_excel = P_isotrans_sph(Chom_excel);

% Infinite Strain Concentration Tensors
A_inf_excel = I;
A_inf_lac = inv(I + P_sph_in_Chom_excel*(Cmat_lac - Chom_excel));

% Actual Strain Concentration Tensors
A_excel = A_inf_excel* inv( f_excel_exvas * A_inf_excel + f_lac_exvas * A_inf_lac );
A_lac = A_inf_lac* inv( f_excel_exvas * A_inf_excel + f_lac_exvas * A_inf_lac );

% Estimated Homogenized Stiffness
Chom_exvas = f_excel_exvas * Chom_excel * A_excel + f_lac_exvas * Cmat_lac * A_lac;


%% 2.6 RVE MACRO - Macro bone material
% Macro bone material - Mori Tanaka Scheme
% Phase 1 = Matrix: exvas
% Phase 2 = vas = cylindrical inclusions in transversal isotropic matrix

% Morphology Tensors = Hill Tensors
P_cyl_in_Chom_exvas = P_isotrans_cyl(Chom_exvas);

% Infinite Strain Concentration Tensors
A_inf_exvas = I;
A_inf_vas = inv(I + P_cyl_in_Chom_exvas*(Cmat_vas - Chom_exvas));

% Actual Strain Concentration Tensors
A_exvas = A_inf_exvas* inv( f_exvas_macro * A_inf_exvas + f_vas_macro * A_inf_vas );
A_vas = A_inf_vas* inv( f_exvas_macro * A_inf_exvas + f_vas_macro * A_inf_vas );

% Estimated Homogenized Stiffness
Chom_macro = f_exvas_macro * Chom_exvas * A_exvas + f_vas_macro * Cmat_vas * A_vas;
