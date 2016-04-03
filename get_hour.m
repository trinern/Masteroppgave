function [ halfHour ] = get_hour( T0_cycle, period )
%converts a specified cycle and period into a specific half hour during a day

T=15;
HHPerDay=48;
MinPerHH=30;

min=T0_cycle+(period-1)*T;
hhAbs=1+floor(min/MinPerHH);
if mod(hhAbs,HHPerDay)>0
    halfHour=mod(hhAbs,HHPerDay);
else
    halfHour=48;
end

%day=(halfHourFromStart-halfhour)/48+1;
end

