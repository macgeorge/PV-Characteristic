%Matlab code to calculate the characteristic of a PV panel for various
%temperature and irradiance levels based on the Khouzam equations

%Date: 11/11/2014
%Author: George Christidis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Inputs
irradiance=[1000 1000 1000];
temperature=[0 25 60];
color=['m' 'r' 'b'];

%PV Panel: MTS180M-24V
Rs=0.0; %calculated based on the datasheet
Voc=43.64;
Isc=5.45;
Vmp=36.36;
Imp=4.95;
temperatureref=25;
irradianceref=1000;
coefP=-0.47;
coefVoc=-0.38;
coefIsc=0.1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Init
Vmax=0;
Imax=0;
Pmax=0;
a=coefIsc*Isc/100;
b=-coefVoc*Voc/100;

figure; hold on;
for i=1:length(irradiance)
    C2=(Vmp/Voc-1)/log(1-Imp/Isc);
    C1=(1-Imp/Isc)*exp(-Vmp/(C2*Voc));
    D1=a*irradiance(i)/irradianceref*(temperature(i)-temperatureref)+Isc*(irradiance(i)/irradianceref-1);
    Vmax1=C2*Voc*log((1-(0-D1)/Isc)/C1+1)-b*(temperature(i)-temperatureref)-Rs*D1;
    Vrmax=0+b*(temperature(i)-temperatureref)+Rs*D1;
    Imax1=Isc*(1-C1*(exp(Vrmax/(C2*Voc))-1))+D1;
    Pmax1=Vmax1*Imax1*0.9;
    if Vmax1>Vmax Vmax=Vmax1; end
    if Imax1>Imax Imax=Imax1; end
    if Pmax1>Pmax Pmax=Pmax1; end
    V=0:0.1:(Vmax1);
    Vr=V+b*(temperature(i)-temperatureref)+Rs*D1;
    I=Isc*(1-C1*(exp(Vr/(C2*Voc))-1))+D1;
    P=V.*I;
    subplot(2,1,1);
    plot(V,I,color(i),'LineWidth',5);
    axis([0,Vmax*1.1,0,Imax*1.3]);
    title('PV Characteristic');
    ylabel('Current [A]');
    xlabel('Voltage [V]');
    grid minor
    hold on;
    subplot(2,1,2);
    plot(V,P,color(i),'LineWidth',5);
    axis([0,Vmax*1.1,0,Pmax]);
    ylabel('Power [W]');
    xlabel('Voltage [V]');
    grid minor
    hold on;
end

%Look Up table creation for use in Simulink
PV_characteristic=zeros(length(V),2);
PV_characteristic(:,1)=V(:);
PV_characteristic(:,2)=I(:);

clearvars a b C1 C2 color D1 i I Imax Imax1 Imp irradiance irradianceref Isc mode P Pmax Pmax1 Rs temperature temperatureref V Vmax Vmax1 Vmp Voc Vr Vrmax coefIsc coefP coefVoc