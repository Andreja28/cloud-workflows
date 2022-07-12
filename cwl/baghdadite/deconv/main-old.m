% clear all
% close all
% clc

format short;
fprintf('\n');
disp('Matlab-routine for analysis');
disp('of the histogram-data');
disp('of indentation tests,');
disp('(N Gauss-curves)');
disp('Bagdadite')
disp('Institute for Mechanics of Materials and Structures');
disp('2022 - TU WIEN - Austria')


%zz=1;                 % fitting based on 1...pdf, 2...cdf
%nz=5;                 % number of peaks 
%vf2=0.5;              % sigma-value for fitting
%sz=2;                 % step size of stiffness distribution
%tz=2;                 % step size of hardness distribution 
%Emax=200;             % max. Young's modulus
% zz=
% nz=
% vf2=
% sz=
% tz=
% Emax=
Fmax = Emax*(tz/sz);
cp1=cputime;          

% Data file with indentation results
DatE=['Nanoindentation_data.txt'];
% this is based on the raw data (in processed form)

% Reading the data
fid2=fopen(DatE);
E_data = textscan(fid2,'%f',99999);
fclose(fid2);

% Number of rows
hnm=size(E_data{1});
hnx=hnm(1)/2;
En=0;
for Ez=1:hnx
    ck(Ez)=Ez;
    for Es=1:2
        En=En+1;
        MHd(Ez,Es)=E_data{1}(En);
    end
end

% Histogram
% Number of steps
hn=round(Emax/sz + 0.4999);

% Sorting the data for CDF
CHd = sort(MHd);

% Initial values
% for PDF
for su=1:hn
    Edat(su,1)=(su-1)*sz;
    Edat(su,2)=0;
    Edat(su,3)=0;
    Fdat(su,1)=(su-1)*tz;
    Fdat(su,2)=0;
    Fdat(su,3)=0;
end

% Initial values
% for CDF
for tu=1:hnx
    Ecat(tu,1)=CHd(tu,1);
    Ecat(tu,2)=tu/hnx;
    Ecat(tu,3)=tu/hnx;
    Fcat(tu,1)=CHd(tu,2);
    Fcat(tu,2)=tu/hnx;
    Fcat(tu,3)=tu/hnx;
end

% Definitions
Mza=0;
Hza=0;
for st=1:hnx
    % Rounded values
    Ero=round(MHd(st,1)/sz+0.5);
    Hro=round(MHd(st,2)/tz+0.5);
    if Ero<hn+1
        Mza=Mza+1;
        Edat(Ero,2)=Edat(Ero,2)+1;
    end
    if Hro<hn+1
        Hza=Hza+1;
        Fdat(Hro,2)=Fdat(Hro,2)+1;
    end
end

% Fractions
for su=1:hn
    Edat(su,3)=Edat(su,2)/Mza;
    Fdat(su,3)=Fdat(su,2)/Hza;
end
ccn=0;
dcn=0;
for Fz=1:hn
    ccn=ccn+Edat(Fz,2);
    hc(Fz)=Edat(Fz,2);
    hd(Fz)=Edat(Fz,1);
    he(Fz)=Edat(Fz,3);
    dcn=dcn+Fdat(Fz,2);
    gc(Fz)=Fdat(Fz,2);
    gd(Fz)=Fdat(Fz,1);
    ge(Fz)=Fdat(Fz,3);
end
jc=Ecat(:,2);
jd=Ecat(:,1);
je=Ecat(:,3);
ic=Fcat(:,2);
id=Fcat(:,1);
ie=Fcat(:,3);
xplot = 1:numel(hc);
a0 = [12,53,80,100,125,8,14,8,8,14,12,53,80,100,125,8,14,8,8,14,0.43,0.25,0.08,0.10,0.14];   
% a0 (search intervals) needs to be changed for new dataset
% values 1 to 5 ...  initial stiffness mean values for fitting
% values 6 to 10 ... initial standard deviation of fitted stiffness
% values 11 to 15 ...initial hardness mean for for fitting
% values 16 to 20 ... initial hardness deviation of fitted stiffness
% values 21 to 25 ... volume fractions of phases

% Parameter for fmincon, Minima & Maxima
% Parameter for fmincon
Aw = 10000;
for ny=1:nz
    for nw=1:5
        bmin((ny-1)*5+nw)=Aw;
    end
end

lb= a0;
ub = a0;
Amin=eye(nz*5);

% Fitting of Gauss-distributions (Sum of least square)
if zz==1
    f=@(a) sum((he-(sz*curvsum1(nz,a,hd))).^2 + (ge-(tz*curvsuh1(nz,a,gd))).^2);
else
    f=@(a) sum((je-(curvsum2(nz,a,jd))).^2 + (ie-(curvsuh2(nz,a,id))).^2);
end
options = optimset('MaxFunEvals',1e+8,'MaxIter',1e+8,'TolFun',1e-18,'TolX',1e-18,'Algorithm','interior-point');
nonlcon=@(a) constrain26(a,nz,vf2);
af=fmincon(f,a0,Amin,bmin,[],[],lb,ub,nonlcon,options);

% Standard deviations frequency (=RMS)
if zz==1
    lsq0=sum((he-(sz*curvsum1(nz,af,hd))).^2 + (ge-(tz*curvsuh1(nz,af,gd))).^2);
    lsq1=sum((he-(sz*curvsum1(nz,af,hd))).^2);
    lsq2=sum((ge-(tz*curvsuh1(nz,af,gd))).^2);
else
    lsq0=sum((je-(curvsum2(nz,af,jd))).^2 + (ie-(curvsuh2(nz,af,id))).^2);
    lsq1=sum((je-(curvsum2(nz,af,jd))).^2);
    lsq2=sum((ie-(curvsuh2(nz,af,id))).^2);
end
sd0=sqrt(lsq0/ccn);
sd1=sqrt(lsq1/ccn);
sd2=sqrt(lsq2/ccn);
nd0=sqrt(lsq0*ccn);
nd1=sqrt(lsq1*ccn);
nd2=sqrt(lsq2*ccn);
ko1=0;
ko2=0;
lo1=0;
lo2=0;

% Sum of points for PDF
for cq=1:hn
    cs(cq,1)=hc(cq);
    cs(cq,2)=0;
    for cr=1:nz
        cs(cq,cr+2)=ccn*sz*(af(nz*4+cr)*(normpdf(hd(cq),af(cr),af(cr+nz))));
        cs(cq,2)=cs(cq,2)+cs(cq,cr+2);
    end
    ko1=ko1+cs(cq,1);
    ko2=ko2+cs(cq,2);
    ds(cq,1)=gc(cq);
    ds(cq,2)=0;
    for cr=1:nz
        ds(cq,cr+2)=dcn*tz*(af(nz*4+cr)*(normpdf(gd(cq),af(cr+2*nz),af(cr+3*nz))));
        ds(cq,2)=ds(cq,2)+ds(cq,cr+2);
    end
    lo1=lo1+ds(cq,1);
    lo2=lo2+ds(cq,2);
end
ko3=ko2/ko1;
lo3=lo2/lo1;

% Sum of points for CDF
for cq=1:hnx
    es(cq,1)=jc(cq);
    es(cq,2)=0;
    for cr=1:nz
        es(cq,cr+2)=hnx*(af(nz*4+cr)*(normcdf(jd(cq),af(cr),af(cr+nz))));
        es(cq,2)=es(cq,2)+es(cq,cr+2);
    end
    fs(cq,1)=ic(cq);
    fs(cq,2)=0;
    for cr=1:nz
        fs(cq,cr+2)=hnx*(af(nz*4+cr)*(normcdf(id(cq),af(cr+2*nz),af(cr+3*nz))));
        fs(cq,2)=fs(cq,2)+fs(cq,cr+2);
    end
end

% Coefficients of Correlation
co2=corr(hc',cs(:,2));
do2=corr(gc',ds(:,2));

% Distributions seperately
figure(1);
set(1,'Position',[20 200 1000 500]);
gb = bar(hd,cs(:,3:2+nz),0.9);
for xu=1:nz
    set(gb(1), 'LineWidth', 1.0);
end
axis([0 max(hd) 0 max(max(cs(:,3:2+nz)))+1]);
set(gca,'FontSize',8);
set(gca,'XTick', hd);
set(gca,'XTickLabel', hd,'XTickLabelRotation', 90);
Ueber=['Normal distributions of elastic Modulus E_r'];
title(Ueber,'FontSize',16,'FontWeight','bold');
xlabel('E_r (GPa)','FontSize',15);
ylabel('number of indents','FontSize',15);

saveas(gcf, 'Figure1.png')
if zz==2

% Cumulative functions
figure(3);
set(3,'Position',[400 320 1000 500]);
set(0,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontName','Times New Roman');

% plot(jd,jc*hnx,'o','color','r');
hold on;
plot(jd,es(:,2),'-','color','b');
for gn=1:nz
    plot(jd,es(:,2+gn),'--','color','r');
end
hold off;
axis([0 max(hd) 0 hnx+1]);
Ticks = 0:10:max(hd);
set(gca, 'XTickMode', 'manual', 'XTick', Ticks, 'xlim', [0,max(hd)]); 
Ueber=['Cumulative functions of modulus'];
title(Ueber,'FontSize',15,'FontWeight','bold');
xlabel('E_r (GPa)','FontSize',15);
ylabel('number of indents','FontSize',15);
figure(4);
set(4,'Position',[400 520 1000 500]);
set(0,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontName','Times New Roman');
h = histogram(E_r,60);
h.FaceColor = [0.9 0.9 0.9];
h.EdgeColor = 'k';
hold on;
plot(id,fs(:,2),'-','color','b');
for gn=1:nz
    plot(id,fs(:,2+gn),'--','color','k');
end
end

% Comparision of test & fit
figure(5);
set(5,'Position',[900 20 1000 500]);
set(0,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontName','Times New Roman');
bar(gd,ds(:,1),'w','LineWidth', 0.5,'BarWidth', 1); % plots histogram 
x0 = 0:0.1:max(hd);
y0 = spline(hd,cs(:,2),x0);
hold on;
plot(x0,y0,'-','color','b'); % sum of Gaussian distribution
for gn=1:nz % makes the Gaussians distributions
    ye = spline(hd,cs(:,2+gn),x0);
    plot(x0,ye,'--','color','r');
end
grid on
hold off;
axis([0 max(hd) 0 max(hc)+1]);
Ticks = 0:10:max(hd);
set(gca, 'XTickMode', 'manual', 'XTick', Ticks, 'xlim', [0,max(hd)]); 
Ueber=['Histogram of modulus E_r'];
title(Ueber,'FontSize',15,'FontWeight','bold');
xlabel('E_r (GPa)','FontSize',15);
ylabel('number of indents','FontSize',15);
legend('Histogram on experimental data ', 'Sum of 5 modeled distributions',...
'Modeled Gaussian distributions')
saveas(gcf, 'Figure5.png')
% set('legend','FontSize',16)
if zz==1
    ag(1:nz) = af(1:nz) + sz/2;
    ag(2*nz+1:3*nz) = af(2*nz+1:3*nz) + tz/2;
else
    ag(1:nz) = af(1:nz);
    ag(2*nz+1:3*nz) = af(2*nz+1:3*nz);
end
ag(nz+1:2*nz) = af(nz+1:2*nz);
ag(3*nz+1:4*nz) = af(3*nz+1:4*nz);
ag(4*nz+1:5*nz) = af(4*nz+1:5*nz);
% Data lists
fprintf('\n');
Text7=['Correlations R between statistical dist. and sum of normal dist.:'];
fprintf(Text7);
fprintf('\n');
fprintf(' %.3f',co2);
fprintf('\n');
fprintf(' %.3f',do2);
fprintf('\n');
fprintf('\n');
Text7=['Percentage of fits within histogram-range:'];
fprintf(Text7);
fprintf('\n');
fprintf(' %.4f',ko3);
fprintf('\n');
fprintf(' %.4f',lo3);
fprintf('\n');
fprintf('\n');
Text8=['Standard deviations (RMSE) for frequency (total/ modulus/ modulus):'];
fprintf(Text8);
fprintf('\n');
fprintf(' %.6f',sd0);
fprintf('    %.6f',sd1);
fprintf('    %.6f',sd2);
fprintf('\n');
fprintf('\n');
Text9=['Standard deviations (RMSE) for number of indents:'];
fprintf(Text9);
fprintf('\n');
fprintf(' %.3f',nd0);
fprintf('    %.3f',nd1);
fprintf('    %.3f',nd2);
fprintf('\n');
fprintf('\n');
Text4=['Modulus:'];
fprintf(Text4);
fprintf('\n');
Text5=['Expectations of the normal distributions [GPa]:'];
fprintf(Text5);
fprintf('\n');
fprintf('%+.1f',ag(1));
for xt0=2:nz
    fprintf('    %+.1f',ag(xt0));
end
fprintf('\n');
fprintf('\n');
Text5=['Sigma of the normal distributions [GPa]:'];
fprintf(Text5);
fprintf('\n');
fprintf('%+.1f',ag(nz+1));
for xt0=2:nz
    fprintf('    %+.1f',ag(xt0+nz));
end
fprintf('\n');
fprintf('\n');
Text6=['Distances of the normal distributions over minimum:'];
fprintf(Text6);
fprintf('\n');
for xt0=1:nz-1
    fprintf('    %+.1f',ag(xt0+1)-ag(xt0)-vf2*(ag(xt0+nz)+ag(xt0+nz+1)));
end
fprintf('\n');
fprintf('\n');
Text4=['Modulus:'];
fprintf(Text4);
fprintf('\n');
Text5=['Expectations of the normal distributions [GPa]:'];
fprintf(Text5);
fprintf('\n');
fprintf('%+.2f',ag(2*nz+1));
for xt0=2:nz
    fprintf('    %+.2f',ag(xt0+2*nz));
end
fprintf('\n');
fprintf('\n');
Text5=['Sigma of the normal distributions [GPa]:'];
fprintf(Text5);
fprintf('\n');
fprintf('%+.2f',ag(3*nz+1));
for xt0=2:nz
    fprintf('    %+.2f',ag(xt0+3*nz));
end
fprintf('\n');
fprintf('\n');
Text6=['Distances of the normal distributions over minimum:'];
fprintf(Text6);
fprintf('\n');
for xt0=1:nz-1
    fprintf('    %+.2f',ag(xt0+1+2*nz)-ag(xt0+2*nz)-vf2*(ag(xt0++3*nz)+ag(xt0+3*nz+1)));
end
fprintf('\n');
fprintf('\n');
Text7=['Fractions of the normal distributions:'];
fprintf(Text7);
fprintf('\n');
fprintf('%+.3f',ag(4*nz+1));
for xt0=2:nz
    fprintf('    %+.3f',ag(xt0+4*nz));
end
fprintf('\n');
fprintf('\n');
cp2=cputime;
cp0=cp2-cp1;
Text4=['Computing time [s]:'];
fprintf(Text4);
fprintf(' %.1f',cp0);
fprintf('\n');
fprintf('\n');

exit;
