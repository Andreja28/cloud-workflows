% BoneMinOrgAPP
%
% Edited: IMWS Pircher Ukaj 2022-01-19
% Input: input_APPII.txt
% Output: Contour plots of homogenized macro bone material parameters

clear all; clc; close all;

%% reading from a file
fileID=fopen('input_APPII.txt','r');
formatSpec='%f %*[^\n]';
input_values = fscanf(fileID,formatSpec);
fclose(fileID);

if length(input_values) ~=3
    error_message = 'Please enter 3 values: the real value of lacunar porosity (larger than 0, less than 10), \n one value between 1 and 99.5 for the number of different vascular porosities and \n one value between 10 and 100 for the resolution!';
    fprintf(fid,error_message);
    fclose(fid);
    return
end
phi_lac = input_values(1)/100;
N = input_values(2);
resolution= input_values(3);

if length(phi_lac)~=1 || phi_lac <= 0 || phi_lac>10 || length(N)~=1 || N <= 0 || N>99.5 || length(resolution)~=1 || resolution < 10 || resolution >100
    fid = fopen('calculation_error_APPII.txt', 'w');
    error_message = 'Please enter the real value of lacunar porosity (higher than 0, less than 1), \n one value between 1 and 99.5 for the number of different vascular porosities and \n one value between 10 and 100 for the resolution!';
    fprintf(fid,error_message);
    fclose(fid);
    return
end

%actual code:

%% 1.0 General Input Parameters
% Note: some material parameters are defined in nested functions
% phi_lac = phi_lac; %from Input File
phi_vas_list = linspace(0,99.5,N)/100*(1-phi_lac); % volume of vascular pores / volume of macroscopic piece of bone

rho_org_excel_list = linspace(0.3,0.6,resolution); %g/cm3
rho_HA_excel_list = linspace(0.5,2.0,resolution); %g/cm3

%% 2.0 Matrix Homogenization
% Emptyvalues
Chom_excel_list=zeros(6,6,length(rho_org_excel_list),length(rho_HA_excel_list));
%% 2.1 Matrixstiffness Chom_excel

% Homogenization up to Exctracellular Level as a function of rho_excel

% IF NEW CALCULATION for each value in rho_org_excel_list and rho_HA_excel_list
for i_rhoorgexcel = 1:1:length(rho_org_excel_list)
    for i_rhoHAexcel = 1:1:length(rho_HA_excel_list)
        clear rho_org_excel_i rho_HA_excel_i
        rho_org_excel_i  = rho_org_excel_list(i_rhoorgexcel);
        rho_HA_excel_i   = rho_HA_excel_list(i_rhoHAexcel);
        Chom_excel_list(:,:,i_rhoorgexcel,i_rhoHAexcel) = hom_wetcol_to_excel_APPDENS(rho_org_excel_i,rho_HA_excel_i);
    end
end

% IF ALREADY PRECOMPUTED
% load('BoneMinOrgAPP_Chomexcel_list')

% Cutting all values at 10^-10
Chom_excel_list=round(Chom_excel_list,10);

%% 2.2 Matrixstiffness Chom_macro

% Homogenization up to Macro Level
% as function of phi_vas, rho_org_excel, rho_HA_excel
Emacro_0_matrix = zeros(length(rho_org_excel_list),length(rho_HA_excel_list),length(phi_vas_list));
Emacro_90_matrix = zeros(length(rho_org_excel_list),length(rho_HA_excel_list),length(phi_vas_list));
NUmacro_strain90load0_matrix = zeros(length(rho_org_excel_list),length(rho_HA_excel_list),length(phi_vas_list));
NUmacro_strain0load90_matrix = zeros(length(rho_org_excel_list),length(rho_HA_excel_list),length(phi_vas_list));
NUmacro_strain90load90_matrix = zeros(length(rho_org_excel_list),length(rho_HA_excel_list),length(phi_vas_list));

for i_phivas = 1:1:length(phi_vas_list)
    %Vascular porisity in loop
    clear phi_vas
    phi_vas = phi_vas_list(i_phivas);
    
    for i_rhoorgexcel = 1:1:length(rho_org_excel_list)
        for i_rhoHAexcel = 1:1:length(rho_HA_excel_list)
            
            %Homogenization excel-to-macro for each case
            %and direct inversing to gain Dhom_macro
            clear InvChom_macro_ijk
            InvChom_macro_ijk = inv(hom_excel_to_macro(Chom_excel_list(:,:,i_rhoorgexcel,i_rhoHAexcel),phi_vas,phi_lac ) );
            
            %Compute image raw data as matrix entries = material parameters in 3D array
            % Transversal Isotropy:
            % Axis of symmetry = (3,3) = 0 degr;
            % Transversal = (1,1) or (2,2) = 90 degr;
            
            % Young's-modulus of macro bone material
            Emacro_0_matrix(i_rhoorgexcel,i_rhoHAexcel,i_phivas) = 1/InvChom_macro_ijk(3,3);
            Emacro_90_matrix(i_rhoorgexcel,i_rhoHAexcel,i_phivas) = 1/InvChom_macro_ijk(1,1); %1,1 and 2,2 need to be equal for transv.isotropy
            %      Emacro_902_matrix(i_rhoorgexcel,i_rhoHAexcel,i_phivas) = 1/InvChom_macro_ijk(2,2); %1,1 and 2,2 need to be equal for transv.isotropy
            
            % Poisson's-ratio of macro bone material
            NUmacro_strain90load0_matrix(i_rhoorgexcel,i_rhoHAexcel,i_phivas) = -InvChom_macro_ijk(3,1) / InvChom_macro_ijk(3,3);
            NUmacro_strain0load90_matrix(i_rhoorgexcel,i_rhoHAexcel,i_phivas) = -InvChom_macro_ijk(3,1) / InvChom_macro_ijk(1,1);
            NUmacro_strain90load90_matrix(i_rhoorgexcel,i_rhoHAexcel,i_phivas) = -InvChom_macro_ijk(2,1) / InvChom_macro_ijk(1,1);
        end
    end
end


%% 3.0 Plots (contour)
%plotting is handled in the following loops
Filename=[]
Ndim=[]
Mdim=[]
phiVasList=[]
phiLac=[]
for num= 1:N
    clear x y
    x = rho_org_excel_list;
    y = rho_HA_excel_list;
    [X,Y] = meshgrid(x,y);

    [n,m]=size(X);
    Filename=[Filename;strcat('Fig',num2str(num),'_APP_II.csv')];
    Ndim=[Ndim;n];
    Mdim=[Mdim;m];
    phiVasList=[phiVasList;phi_vas_list(num)]
    phiLac=[phiLac;phi_lac]
    %dim = {num2str(num),'_APP_I.csv',n,m,phi_lac_list(num)};
    %dimensionTable = [dimensionTable;dim];
    a=zeros(n*m,7);

    a(:,1)=reshape(transpose(X),1,[]);
    a(:,2)=reshape(transpose(Y),1,[]);
    a(:,3)=reshape(transpose(Emacro_0_matrix(:,:,num)),1,[]);
    a(:,4)=reshape(transpose(Emacro_90_matrix(:,:,num)),1,[]);
    a(:,5)=reshape(transpose(NUmacro_strain90load0_matrix(:,:,num)),1,[]);
    a(:,6)=reshape(transpose(NUmacro_strain0load90_matrix(:,:,num)),1,[]);
    a(:,7)=reshape(transpose(NUmacro_strain90load90_matrix(:,:,num)),1,[]);

    %a = ['X' 'Y' 'Emacro_0_matrix' 'Emacro_90_matrix' 'NUmacro_strain90load0_matrix' 'NUmacro_strain0load90_matrix' 'NUmacro_strain90load90_matrix' ;a]
    T = array2table(a)
    T.Properties.VariableNames(1:7) = {'X', 'Y', 'Emacro_0_matrix', 'Emacro_90_matrix', 'NUmacro_strain90load0_matrix', 'NUmacro_strain0load90_matrix', 'NUmacro_strain90load90_matrix'}
    writetable(T,strcat('Fig',num2str(num),'_APP_II.csv'))
    %csvwrite(strcat('Fig',num2str(num),'_APP_II.csv'),a);
    %phi_lac_list(num)
    
    figure1=figure('Position', [150, 150, 950, 1000]);
    %sgtitle([{'Homogenized mechanical parameters'},{'Macro - bone - material'}])
    annotation('textbox', [0.02, 0.05, 1, 0], 'string', 'BonePoreDenseAPP II - v1.0 @IMWS 2022-01', 'FontSize',7,'Color', 'red')
    
    %1st Plot: Longitudinal Young's modulus
    ax1 = subplot(3,2,1,'align');
    hold on; grid on; box on
    contourf(X,Y,Emacro_0_matrix(:,:,num),'ShowText','on')
    title('(a) Longitudinal Young''s modulus [GPa]', 'FontSize',10)
    %xticks(0.3:0.05:0.6)
    xlim([0.3 0.6])
    colorbar
    xlabel('\rho_{org}^{excel} [g/cm^3]')
    ylabel('\rho_{HA}^{excel} [g/cm^3]')
    
    %2nd plot: Transverse Young's modulus
    ax2 = subplot(3,2,2,'align');
    hold on; grid on; box on
    contourf(X,Y,Emacro_90_matrix(:,:,num),'ShowText','on')
    title('(b) Transverse Young''s modulus [GPa]','FontSize',10)
    %xticks(0.3:0.05:0.6)
    xlim([0.3 0.6])
    colorbar
    xlabel('\rho_{org}^{excel} [g/cm^3]')
    ylabel('\rho_{HA}^{excel} [g/cm^3]')
    
    
    %3rd plot: Poisson's ratio quantifying longitudinal strain under
    %longitudinal loading
    ax3 = subplot(3,2,3,'align');
    hold on; grid on; box on
    contourf(X,Y,NUmacro_strain90load0_matrix(:,:,num),'ShowText','on')
    title([{'(c) Poisson''s ratio quantifying longitudinal'},{'strain under longitudinal loading'}],'FontSize',10)
    %xticks(0.3:0.05:0.6)
    xlim([0.3 0.6])
    colorbar
    xlabel('\rho_{org}^{excel} [g/cm^3]')
    ylabel('\rho_{HA}^{excel} [g/cm^3]')
    
    %4th plot: Poisson's ratio quantifying longitudinal strain under
    %transverse loading
    ax4 = subplot(3,2,4,'align');
    hold on; grid on; box on
    contourf(X,Y,NUmacro_strain0load90_matrix(:,:,num),'ShowText','on')
    title([{'(d) Poisson''s ratio quantifying longitudinal'},{'strain under transverse loading'}],'FontSize',10)
    %xticks(0.3:0.05:0.6)
    xlim([0.3 0.6])
    colorbar
    xlabel('\rho_{org}^{excel} [g/cm^3]')
    ylabel('\rho_{HA}^{excel} [g/cm^3]')
    
    %5th plot: Poisson's ratio quantifying transverse strain under
    %transverse loading
    ax5 = subplot(3,2,5,'align');
    hold on; grid on; box on
    contourf(X,Y,NUmacro_strain90load90_matrix(:,:,num),'ShowText','on')
    %xticks(0.3:0.05:0.6)
    xlim([0.3 0.6])
    title([{'(e) Poisson''s ratio quantifying transverse'},{'strain under transverse loading'}],'FontSize',10)
    colorbar
    xlabel('\rho_{org}^{excel} [g/cm^3]')
    ylabel('\rho_{HA}^{excel} [g/cm^3]')
    
    linkaxes([ax1 ax2 ax3 ax4 ax5],'xy');
    
    % values on "plot 6":
    ax6 = subplot(3,2,6,'align');
    txt_philac = ['$$\phi_{lac} = \frac{V_{lac}}{V_{macro}}$$ = ', num2str(phi_lac,'%.2f')];
    txt_phivas = ['$$\phi_{vas} = \frac{V_{vas}}{V_{macro}}$$ = ', num2str(phi_vas_list(num),'%.2f')];
    txt_philac_phivas = {txt_philac,blanks(1),txt_phivas};
    
    
    txt_E0_min = ['$$E_0^{min}$$ = ', num2str(min(min(Emacro_0_matrix(:,:,num))),'%.3f')];
    txt_E0_max = ['$$E_0^{max}$$ = ', num2str(max(max(Emacro_0_matrix(:,:,num))),'%.3f')];
    txt_E90_min = ['$$E_{90}^{min}$$  = ', num2str(min(min(Emacro_90_matrix(:,:,num))),'%.3f')];
    txt_E90_max = ['$$E_{90}^{max}$$ = ', num2str(max(max(Emacro_90_matrix(:,:,num))),'%.3f')];
    
    txt_nu_90_0_min = ['$$\nu_{strain90load0}^{min}$$ = ', num2str(min(min(NUmacro_strain90load0_matrix(:,:,num))),'%.2f')];
    txt_nu_90_0_max = ['$$\nu_{strain90load0}^{max}$$ = ', num2str(max(max(NUmacro_strain90load0_matrix(:,:,num))),'%.2f')];
    
    txt_nu_0_90_min = ['$$\nu_{strain0load90}^{min}$$ = ', num2str(min(min(NUmacro_strain0load90_matrix(:,:,num))),'%.2f')];
    txt_nu_0_90_max = ['$$\nu_{strain0load90}^{max}$$ = ', num2str(max(max(NUmacro_strain0load90_matrix(:,:,num))),'%.2f')];
    
    txt_nu_90_90_min = ['$$\nu_{strain90load90}^{min}$$ = ', num2str(min(min(NUmacro_strain90load90_matrix(:,:,num))),'%.2f')];
    txt_nu_90_90_max = ['$$\nu_{strain90load90}^{max}$$ = ', num2str(max(max(NUmacro_strain90load90_matrix(:,:,num))),'%.2f')];
    
    
    text(0.,0.8,txt_philac_phivas,'FontSize',10,'EdgeColor','r','Interpreter','latex');
    text(0.,0.51,txt_E0_min,'FontSize',10,'Interpreter','latex');
    text(0.,0.34,txt_E0_max,'FontSize',10,'Interpreter','latex');
    text(0.,0.18,txt_E90_min,'FontSize',10,'Interpreter','latex');
    text(0.,0.02, txt_E90_max,'FontSize',10,'Interpreter','latex');
    
    text(0.51,0.95,txt_nu_90_0_min,'FontSize',10,'Interpreter','latex');
    text(0.51,0.76,txt_nu_90_0_max,'FontSize',10,'Interpreter','latex');
    text(0.51,0.57,txt_nu_0_90_min,'FontSize',10,'Interpreter','latex');
    text(0.51,0.38,txt_nu_0_90_max,'FontSize',10,'Interpreter','latex');
    text(0.51,0.19,txt_nu_90_90_min,'FontSize',10,'Interpreter','latex');
    text(0.51,0,txt_nu_90_90_max,'FontSize',10,'Interpreter','latex');
    
    set (ax6,'visible','off')
    
    
    ax1.Position = ax1.Position + [0 0 0 -0.01];
    ax2.Position = ax2.Position + [0 0 0 -0.01];
    ax3.Position = ax3.Position + [0 0 0 -0.01];
    ax4.Position = ax4.Position + [0 0 0 -0.01];
    ax5.Position = ax5.Position + [0 0 0 -0.01];
    
    
    saveas(gcf,['Fig',num2str(num),'_APP_II.png'])
end

dimensions = table(Filename,Ndim,Mdim,phiLac,phiVasList)
writetable(dimensions,strcat('Dimensions_APP_II.csv'))
% close all
