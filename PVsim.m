%Κώδικας για δημιουργία χαρακτηριστικών ενός φωτοβολταϊκού πλαισίου για
%διαφορετικές τιμές ακτινοβολίας και θερμοκρασίας βασισμένο στις εξισώσεις
%Khouzam

%Revision 0.1: Draft
%Date: 11/11/2014
%Author: George Christidis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mode=1; 
%mode1: υπολογισμός ρεύματος ως συνάρτηση τάσης
%mode2: υπολογισμός τάσης ως συνάρτηση ρεύματος
%mode3: δημιουργία lookuptable από mode1 για χρήση σε simulink για το πρώτο
%ζεύγος input

%Inputs
irradiance=[500 1000 1000];
temperature=[25 25 60];
color=['m' 'r' 'b']; %οι τρεις πίνακες θα πρέπει να έχουν το ίδιο μέγεθος

%Parameters
%Δεδομένα για τα Φ/Β SolarNova PXQ 36/53 D
% Rs=0.0; %πρέπει να υπολογίζεται από το datasheet
% Voc=43.64;
% Isc=5.45;
% Vmp=36.36;
% Imp=4.95;
% temperatureref=25;
% irradianceref=1000;
% coefP=-0.47;
% coefVoc=-0.38;
% coefIsc=0.1;

%Δεδομένα για τα Φ/Β BP Solar MX110
Rs=0.0; %πρέπει να υπολογίζεται από το datasheet
Voc=41.2;
Isc=3.69;
Vmp=32.9;
Imp=3.34;
temperatureref=25;
irradianceref=1000;
coefP=-0.47;
coefVoc=-0.38;
coefIsc=0.1;


% %Parameters
% %Δεδομένα για τα Φ/Β SolarNova PXQ 36/53 D
% Rs=0.1; %πρέπει να υπολογίζεται από το datasheet
% Voc=21.88;
% Isc=3.15;
% Vmp=17.7;
% Imp=2.99;
% temperatureref=25;
% irradianceref=1000;
% a=0.8/1000; %από το datasheet
% b=75/1000; %από το datasheet

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Init
Vmax=0;
Imax=0;
Pmax=0;
a=coefIsc*Isc/100;
b=-coefVoc*Voc/100;

%Caclulation Current
if mode==1;    
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
end

%Caclulation Voltage
if mode==2   
    figure; hold on;
    for i=1:length(irradiance)
        C2=(Vmp/Voc-1)/log(1-Imp/Isc);
        C1=(1-Imp/Isc)*exp(-Vmp/(C2*Voc));
        D1=a*irradiance(i)/irradianceref*(temperature(i)-temperatureref)+Isc*(irradiance(i)/irradianceref-1);
        Vmax1=C2*Voc*log((1-(0-D1)/Isc)/C1+1)-b*(temperature(i)-temperatureref)-Rs*D1;
        Vrmax=0+b*(temperature(i)-temperatureref)+Rs*D1;
        Imax1=Isc*(1-C1*(exp(Vrmax/(C2*Voc))-1))+D1
        Pmax1=Vmax1*Imax1*0.9;
        if Vmax1>Vmax Vmax=Vmax1; end
        if Imax1>Imax Imax=Imax1; end
        if Pmax1>Pmax Pmax=Pmax1; end
        I=0:0.01:Imax1;
        V=C2*Voc*log((1-(I-D1)/Isc)/C1+1)-b*(temperature(i)-temperatureref)-Rs*D1;
        P=I.*V;
        subplot(2,1,1);
        plot(V,I,color(i),'LineWidth',5);
        axis([0,Vmax+1,0,Imax+1]);
        grid minor
        title('PV Characteristic');
        ylabel('Current [A]');
        xlabel('Voltage [V]');
        hold on;
        subplot(2,1,2);
        plot(V,P,color(i),'LineWidth',5);
        ylabel('Current [A]');
        xlabel('Power [W]');
        grid minor
        axis([0,Vmax+1,0,Pmax]);
        hold on;
    end
end



%Δημιουργία LUT
if mode==3;
        C2=(Vmp/Voc-1)/log(1-Imp/Isc);
        C1=(1-Imp/Isc)*exp(-Vmp/(C2*Voc));
        D1=a*irradiance(1)/irradianceref*(temperature(1)-temperatureref)+Isc*(irradiance(1)/irradianceref-1);
        Vmax1=C2*Voc*log((1-(0-D1)/Isc)/C1+1)-b*(temperature(1)-temperatureref)-Rs*D1;
        Vrmax=0+b*(temperature(1)-temperatureref)+Rs*D1;
        Imax1=Isc*(1-C1*(exp(Vrmax/(C2*Voc))-1))+D1;
        V=0:0.1:Vmax1;
        Vr=V+b*(temperature(1)-temperatureref)+Rs*D1;
        I=Isc*(1-C1*(exp(Vr/(C2*Voc))-1))+D1;
        PV_characteristic=zeros(length(V),2);
        PV_characteristic(:,1)=V(:);
        PV_characteristic(:,2)=I(:);
end

clearvars a b C1 C2 color D1 i I Imax Imax1 Imp irradiance irradianceref Isc mode P Pmax Pmax1 Rs temperature temperatureref V Vmax Vmax1 Vmp Voc Vr Vrmax coefIsc coefP coefVoc
