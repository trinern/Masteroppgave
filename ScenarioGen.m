%open script for 
    %DAprice.txt
    %IDprice.txt
    %TimeExtremePoints.txt
    %PeriodsPerCycle.txt

%input
Scenarios=2;

%import data
% DAprice=importDAprice();
% IDprice=importIDprice();
%CycleStart=importCycleStart();
%Periods=import_periods();
Periods=[12 12 12];
CycleStart=[ 250.000000 624.000000 994.000000];

%open workspace PriceGenWorkspace

%Parameters
Years=4;
Days=365;
MaxPeriods=13; %check this
M=12;
DaysMonth=30;
Cycles=length(Periods);

%declaration of matrices
DAscenarios=zeros(Scenarios, MaxPeriods, Cycles);
IDscenarios=zeros(Scenarios, MaxPeriods, Cycles);

%%%With seasonality%%%
%fill scenario matrices with sampled values
for c=1:Cycles
    [Dmin, Dmax]=get_month(CycleStart(c));%first and last day in cycle's month
    for s=1:Scenarios
        y=randi(Years); %random year for each cycle
        d=randi([Dmin,Dmax]);%random day in the cycle's month 
        p=1;
        while p<=Periods(c)%writes elem in the Xpress order
            hh=get_hour(CycleStart(c),p);%finds half hour in a day corresponding to c,p       
            DAscenarios(s,p,c)=DAprice(y,d,hh);
            IDscenarios(s,p,c)=IDprice(y,d,hh); 
            p=p+1;
        end
    end
end

% write to file
ScenFile=fopen('Price.txt', 'w');
fprintf(ScenFile,'%6s\n', 'PriceRT: [');
fprintf(ScenFile,' %f', IDscenarios);
fprintf(ScenFile,'%6s\n', '] ' );
fprintf(ScenFile, '%6s\n', 'PriceDA: [');
fprintf(ScenFile,' %f', DAscenarios);
fprintf(ScenFile,'%6s\n', ']');
    
fclose('all');

