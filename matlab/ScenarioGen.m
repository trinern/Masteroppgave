%open workspace PriceGenWorkspace 

%input
Scenarios=1;

%import data for a specified number of cycles
%CycleStart=importCycleStart1409();
%Periods=importPeriods1409();
CycleStart=importCycleStart115();
Periods=importPeriods115();

%open workspace PriceGenWorkspace
%Parameters
Years=4;
Days=365;
MaxPeriods=13; %check this
M=12;
%DaysMonth=30;
Cycles=length(Periods);
BidPoints=4;

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

%Generate bid prices for each cycle and period
BidPrice=zeros(BidPoints,MaxPeriods,Cycles);
for c=1:Cycles
    for p=1:Periods(c)
        BidPrice(1,p,c)=min(DAscenarios(1:Scenarios,p,c));
        %BidPrice(2,p,c)=quantile(DAscenarios(1:Scenarios,p,c),0.25);
        BidPrice(2,p,c)=quantile(DAscenarios(1:Scenarios,p,c),0.33);
        %BidPrice(3,p,c)=quantile(DAscenarios(1:Scenarios,p,c),0.75);
        BidPrice(3,p,c)=quantile(DAscenarios(1:Scenarios,p,c),0.66);
        BidPrice(4,p,c)=max(DAscenarios(1:Scenarios,p,c))+0.01;
    end
end

% write to file
ScenFile=fopen(['PriceC' num2str(Cycles) 'S' num2str(Scenarios) '.txt'], 'w');%evt wt
fprintf(ScenFile,'%6s\n', 'PriceRT: [');
fprintf(ScenFile,' %f', IDscenarios);
fprintf(ScenFile,'%6s\n', '] ' );
fprintf(ScenFile, '%6s\n', 'PriceDA: [');
fprintf(ScenFile,' %f', DAscenarios);
fprintf(ScenFile,'%6s\n', ']');
fprintf(ScenFile,'%6s\n', 'BidPrice: [');
fprintf(ScenFile,' %f', BidPrice);
fprintf(ScenFile,'%6s\n', '] ' );
    
fclose('all');

