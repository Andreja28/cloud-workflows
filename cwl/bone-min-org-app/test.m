
clear x y
x = [1:100];
y = [1,100];
[X,Y] = meshgrid(x,y);
   
    figure1=figure('Position', [150, 150, 950, 1000]);
    %sgtitle([{'Homogenized mechanical parameters'},{'Macro - bone - material'}])
    annotation('textbox', [0.02, 0.05, 1, 0], 'string', 'BonePoreDenseAPP I - v1.0 @IMWS 2022-01', 'FontSize',7,'Color', 'red')
    
    %1st Plot: Longitudinal Young's modulus
    ax1 = subplot(3,2,1,'align');
    hold on; grid on; box on
    contourf(X,Y,meshgrid(x,y),'ShowText','on')
    title('(a) Longitudinal Young''s modulus [GPa]','FontSize',10)
    %xticks(0:10:100)
    set(ax1, 'XTick', 0:10:100)
    xlim([0 max(X(num,:))])
    colorbar
    xlabel('\phi_{vas} [%]')
    ylabel('\rho_{excel} [g/cm^3]')