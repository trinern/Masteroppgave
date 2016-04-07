%open script for 
    %DAprice.txt
    %IDprice.txt
    %TimeExtremePoints.txt
    %PeriodsPerCycle.txt

%input
Scenarios=2;
Cycles=5;

%import data
% DAprice=importDAprice();
% IDprice=importIDprice();
TimeExtremePoints=importTimeExtremePoints();
Periods=importPeriodsPerCycle();

%open workspace PriceGenWorkspace

%Parameters
Years=4;
Days=365;
MaxPeriods=26; %check this
M=12;
DaysMonth=30;

%declaration of matrices
DAscenarios=zeros(Scenarios, MaxPeriods, Cycles);
IDscenarios=zeros(Scenarios, MaxPeriods, Cycles);

%%%No seasonality%%%
% %fill scenario matrices with sampled values
% for s=1:Scenarios 
%     for c=1:Cycles
%         %r=get_season(c);
%         y=randi(Years); %random year for each cycle
%         d=randi(Days);%random day in a season
%         p=1;
%         while p<Periods(c)%writes elem in the Xpress order
%             hh=get_hour(TimeExtremePoints(c),p);%finds half hour in a day corresponding to c,p
%             DAscenarios(s,p,c)=DAprice(y,d,hh);
%             IDscenarios(s,p,c)=IDprice(y,d,hh);
%             p=p+1;     
%         end
%     end
% end

%%%With seasonality%%%
%fill scenario matrices with sampled values
for c=1:Cycles
    [Dmin, Dmax]=get_month(TimeExtremePoints(c));%first and last day in cycle's month
    for s=1:Scenarios
        y=randi(Years); %random year for each cycle
        d=randi([Dmin,Dmax]);%random day in the cycle's month 
        p=1;
        while p<=Periods(c)%writes elem in the Xpress order
            hh=get_hour(TimeExtremePoints(c),p);%finds half hour in a day corresponding to c,p       
            DAscenarios(s,p,c)=DAprice(y,d,hh);
            IDscenarios(s,p,c)=IDprice(y,d,hh); 
            p=p+1;
        end
    end
end

% write to file
IDScenFile=fopen('IDPriceScenario.txt', 'w');
DAScenFile=fopen('DAPriceScenario.txt', 'w');
fprintf(IDScenFile, ' %f', IDscenarios);
fprintf(DAScenFile, ' %f', DAscenarios);
    
fclose('all');

