%Script generating DA_seasonprices(Year, Season, Day, Hour) and 
%ID_seasonprices(Year, Season, Day, Hour)

Years=4;
Hours=24;
Days=365;

%import all Spotprices (RPD) and day-ahead prives from Raw Data, change the 
%names to ID12/13/14/15 and DA12/13/14/15

%Raw data spec
HH=48;
Hstart=2;

IDprice=zeros(Years, Days, HH);
DAprice=zeros(Years, Days, HH);

%generating an ordered matrix of half hourly spot/intraday prices and
%day-ahead prices
for d=1:Days   
    %Half hour 1 to 46
    for hh=1:(HH-Hstart)
        IDprice(1,d,hh)=ID12(d,hh+Hstart);        
        IDprice(2,d,hh)=ID13(d,hh+Hstart);
        IDprice(3,d,hh)=ID14(d,hh+Hstart);
        IDprice(4,d,hh)=ID15(d,hh+Hstart);
        if mod(hh,2)==0 %two consecutive half hours equal the hourly DA prices
            h=(hh+Hstart)/2;
        else
            h=(hh+Hstart+1)/2;
        end
        DAprice(1,d,hh)=DA12(d,h);
        DAprice(2,d,hh)=DA13(d,h);
        DAprice(3,d,hh)=DA14(d,h);
        DAprice(4,d,hh)=DA15(d,h);
    end
    %generating prices for the last hour
    for hh=(HH-Hstart+1):HH
        IDprice(1,d,hh)=ID12(d,hh-HH+Hstart);        
        IDprice(2,d,hh)=ID13(d,hh);
        IDprice(3,d,hh)=ID14(d,hh);
        IDprice(4,d,hh)=ID15(d,hh);
        h=1;
        DAprice(1,d,hh)=DA12(d,h);        
        DAprice(2,d,hh)=DA13(d,h);
        DAprice(3,d,hh)=DA14(d,h);
        DAprice(4,d,hh)=DA15(d,h);
    end  
end
% 
% %write to file
% DAfile=fopen('DAprice.txt', 'w');
% IDfile=fopen('IDprice.txt', 'w');
% fprintf(DAfile, '%10f', DAprice);
% fprintf(IDfile, '%10f', IDprice);
% 
% fclose('all');

%time=zeros(Days,HH);
% t=0;
% 
% figure(1)
% for d=1:Days
%     for hh=1:2:HH/2
%         t=t+1;
%         time(d,hh)=t;
%         %for y=1:Years
%             plot(time(d,hh),DAtemp(1,d,hh))
%             hold on
%         %end
%     end
% end
% hold off
% t=0;
% figure(2)
% for d=1:Days
%     for hh=1:2:HH/2
%         t=t+1;
%         time(d,hh)=t;
%         %for y=1:Years
%             plot(time(d,hh),DAtemp(2,d,hh))
%             hold on
%         %end
%     end
% end
% t=0;
% figure(3)
% for d=1:Days
%     for hh=1:2:HH/2
%         t=t+1;
%         time(d,hh)=t;
%         %for y=1:Years
%             plot(time(d,hh),DAtemp(3,d,hh))
%             hold on
%         %end
%     end
% end
% hold off

%generating DA prices


% %Season spec
% Seasons=3;
% DaysInSeason=[0 90 90 180];
% Dmin=[1 91 181]
% Dmax=zeros(Seasons,1);
% for s=1:Seasons-1
%     Dmin(s)=1+(DaysInSeason(s-1)-1);
%     Dmax(s)=Dmin(s+1)+1;
% end
% 
% %Declaration
% %DA_seasonprices=zeros(Years, Seasons, Days, HH);
% ID_seasonprices=zeros(Years, Seasons, Days, HH);
% 
% %generating price matrices ordered after season
% for y=1:Years
%     for s=1:Seasons
%         for d=1:
%             for h=1:Hours
%                 %DA_seasonprices(y,s,d,h)=ID;
%                 ID_seasonprices(y,s,d,h)=IDtemp(y,d;
%             end
%         end
%     end
% end