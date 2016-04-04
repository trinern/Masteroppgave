%Script generating DA_price(Year, Day, HalfHour) and 
%ID_price(Year, Day, HalfHour)

Years=4;
Hours=24;
Days=365;
HH=48;

%import all Spotprices (RPD) and day-ahead prives from Raw Data, change the 
%names to ID12/13/14/15 and DA12/13/14/15

%Raw data spec
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

% %calculating avg monthly prices
% Mduration=[31 28 31 30 31 30 31 31 30 31 30 31];
% Mstart=zeros(12,1);
% Mstart(1)=1;
% 
% for m=2:12
%     Mstart(m)=Mstart(m-1)+Mduration(m-1);
% end

% DAsum=zeros(12,1);
% IDsum=zeros(12,1);
% 
% for m=1:12
%     for y=1:Years   
%         for d=0:(Mduration(m)-1)
%             for hh=1:48
%                 DAsum(m)=DAsum(m)+DAprice(y,Mstart(m)+d,hh);
%                 IDsum(m)=IDsum(m)+IDprice(y,Mstart(m)+d,hh);
%             end
%         end
%     end
% end
% 
% AvgDA=zeros(12,1);
% AvgID=zeros(12,1);
% 
% for m=1:12
%     t=HH*Mduration(m)*Years;
%     AvgDA(m)=DAsum(m)/t;
%     AvgID(m)=IDsum(m)/t;
% end
% M=1:12;
% figure(10)
% plot(M,AvgDA,M,AvgID)


%
%write to file
DAfile=fopen('DAprice.txt', 'w');
IDfile=fopen('IDprice.txt', 'w');
fprintf(DAfile, '%10f', DAprice);
fprintf(IDfile, '%10f', IDprice);

fclose('all');

% time=zeros(Days,HH);
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
