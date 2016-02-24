
close all
clc

fileProdHead= fopen('production_head.txt','w');
fileStartProd= fopen('startTime_production.txt','w');
fileEndProd= fopen('endTime_production.txt','w');
fileStartEndProd=fopen('start_end_production.txt','w');
fileIntervalsCycle=fopen('nIntervalsCycle.txt','w');
filePrice=fopen('Price.txt','w');

% timeDiscretisation [min]: length of time period
% horizon [days]: lengt og planning horizon
% H0[meters]: average level of water level over 19 years, given location
% ComponentMatrix: period, amplitude, phase
% period[hours]: period in cycle
% amplitude [cm]: amplitude of tide cycle component, given location
% phase [Degrees]: phase shift of tide cycle component, given location
timeDiscretisation=1;%min
horizon=30; %dager
H0=0; %NOTE: must be zero for min function to work.
correctionHead=0.3; %height difference not utilized.
lengthInterval=15; %length of intervall used in modell

%import tide cycle data (harmonic constituents)
%import from excel file, update on new laptop
componentMatrix=get_tide_Kvalsund(); %no imput, returns componentMatrix for Kvalsund
%create tide cycle based on data
tideCycle=get_tide_cycle(timeDiscretisation,horizon,H0,componentMatrix); %returns tide cycle vector
minTideCycle=tideCycle*(-1); %inverse function (to find min peaks)

% figure
% plot(tideCycle)
% hold on
% plot(minTideCycle)

[tideMax,imax] = findpeaks(tideCycle); %returns a vector (1) with the local maxima (peaks) of the input signal vector, data, and vector (2) with indicies of the location.
[tideMin,imin] = findpeaks(minTideCycle);
tideMin=tideMin*(-1); %correct min values.
tmax=timeDiscretisation*(imax-1);%converts index to time stamp for max points
tmin=timeDiscretisation*(imin-1);%converts index to time stamp for min points
maxmin=false; % true if start with max point
minmax=false; % true if start with min point
equal=false; % true if equal amount max and min points
nMin=false; %true if more min than max points
nMax=false; %true if more max than min points

%Find max, min production head and start point/end point
correctedTideMax=tideMax-correctionHead;
correctedTideMin=tideMin+correctionHead;
   
if tmax(1)<tmin(1)
    maxmin=true;
elseif tmin(1)<tmax(1)
    minmax=true;
else
      error('Min and Max at same point???')
end

if length(tideMin)==length(tideMax)
    equal=true;
elseif length(tideMin)<length(tideMax)
    nMax=true;
else %length(tideMax)<length(tideMin)
    nMin=true;
end

%finds possible production start time and end time for each cycle starting
%from first max point
counterS=0;
counterE=0;
istartProd=nan(1,(length(tideMax)+length(tideMin)-1));
iendProd=nan(1,(length(tideMax)+length(tideMin)-1));

if minmax % add first cycle if starts with min point
    setStartPointMin=true;
    setEndPointMax=true;
        for k=(imin(1)+1):imax(1)
            if(setStartPointMin && tideCycle(k)>correctedTideMin(1))
                setStartPointMin=false;
                counterS=counterS+1;
                istartProd(counterS)=k;        
            elseif (setEndPointMax && tideCycle(k)>=correctedTideMax(1))
                setEndPointMax=false;
                counterE=counterE+1;
                iendProd(counterE)=k-1;  
            end
        end
 end

for i=1:(length(tideMax)-1)%for all max points 
    setStartPointMax=true;
    setEndPointMax=true;
    setStartPointMin=true;
    setEndPointMin=true;
    for j=(imax(i)+1):imin(i+minmax) % from max to min
        if (setStartPointMax && tideCycle(j)<correctedTideMax(i)) %find start time
               setStartPointMax=false;
               counterS=counterS+1;
               istartProd(counterS)=j;
        elseif(setEndPointMin && tideCycle(j) <=correctedTideMin(i+minmax)) %find endtime
               setEndPointMin=false;
               counterE=counterE+1;
               iendProd(counterE)=j-1; %change to include handle case of j=1?
        end          
    end
    for j=(imin(i+minmax)+1):imax(i+1)%from min max
            if(setStartPointMin && tideCycle(j)>correctedTideMin(i+minmax))%set starttime
               setStartPointMin=false;
               counterS=counterS+1;
               istartProd(counterS)=j;
            elseif (setEndPointMax && tideCycle(j) >=correctedTideMax(i+1))%set endtime
               setEndPointMax=false;
               counterE=counterE+1;
               iendProd(counterE)=j-1;
            end
    end
end


if ((maxmin && equal) || (minmax && ~equal)) %add last cycle if necessary
        setStartPointMax=true;
        setEndPointMax=true;
        for j=imax(length(imax)):imin(length(imin))
            if (setStartPointMax && tideCycle(j)<correctedTideMax(length(imax)))
               setStartPointMax=false;
               counterS=counterS+1;
               istartProd(counterS)=j;
            elseif (setEndPointMax && tideCycle(j) <=correctedTideMin(length(imax)+minmax))
               setEndPointMax=false;
               counterE=counterE+1;
               iendProd(counterE)=j-1;
            end   
        end
end
 

  
%convert start and end time for production from indecies to time 
endProdTime=(iendProd-1)*timeDiscretisation;
startProdTime=(istartProd-1)*timeDiscretisation;

%calculation of average H, average production H, length of cycle and length
%of production cycle
avgH=nan(1,length(tideMax)+length(tideMin)-1);
prodH=nan(1,length(tideMax)+length(tideMin)-1);
timeCycle=nan(1,length(tideMax)+length(tideMin)-1);
timeProd=nan(1,length(tideMax)+length(tideMin)-1);
counter=0;
if (maxmin && equal)
  for i=1:length(tideMax)
      counter=counter+1;
      %for max to min cycle
      avgH(counter)=(tideMax(i)-tideMin(i))/2;
      prodH(counter)=(correctedTideMax(i)-correctedTideMin(i))/2;
      timeCycle(counter)=tmin(i)-tmax(i);
      timeProd(counter)=(endProdtime(i*2-1)-startProdTime(i*2-1));
      %for min to max cycle
      if i<length(tideMax)
          counter=counter+1;
          avgH(counter)=(tideMax(i+1)-tideMin(i))/2;
          prodH(counter)=(correctedTideMax(i+1)-correctedTideMin(i))/2;
          timeCycle(counter)=tmax(i+1)-tmin(i);
          timeProd(counter)=(endProdtime(i*2)-startProdTime(i*2));
      end
      %create merged vectors
      extremePoints(1:2:2*length(tideMax))=tideMax;
      extremePoints(2:2:2*length(tideMax))=tideMin;
      extremeProdPoints(1:2:2*length(tideMax))=correctedTideMax;
      extremeProdPoints(2:2:2*length(tideMax))=correctedTideMin;
  end
elseif(maxmin && ~equal)
    for i=1:(length(tideMax)-1)
      counter=counter+1;
      %for max to min cycle
      avgH(counter)=(tideMax(i)-tideMin(i))/2;
      prodH(counter)=(correctedTideMax(i)-correctedTideMin(i))/2;
      timeCycle(counter)=tmin(i)-tmax(i);
      timeProd(counter)=(endProdtime(i*2-1)-startProdTime(i*2-1));
      %for min to max cycle
      counter=counter+1;
      avgH(counter)=(tideMax(i+1)-tideMin(i))/2;
      prodH(counter)=(correctedTideMax(i+1)-correctedTideMin(i))/2;
      timeCycle(counter)=tmax(i+1)-tmin(i);
      timeProd(counter)=(endProdtime(i*2)-startProdTime(i*2));
    end
    %create merged vectors
    extremePoints(1:2:(2*length(tideMax)))=tideMax;
    extremePoints(2:2:(2*length(tideMax)-1))=tideMin;
    extremeProdPoints(1:2:(2*length(tideMax)))=correctedTideMax;
    extremeProdPoints(2:2:(2*length(tideMax)-1))=correctedTideMin;
elseif(minmax && equal)
    for i=1:length(tideMin)
        counter=counter+1;
        %for min to max cycle
        avgH(counter)=(tideMax(i)-tideMin(i))/2;
        prodH(counter)=(correctedTideMax(i)-correctedTideMin(i))/2;
        timeCycle(counter)=tmax(i)-tmin(i);
        timeProd(counter)=(endProdTime(i*2-1)-startProdTime(i*2-1));
        %for max to min cycle
        if i<length(tideMin)
            counter=counter+1;
            avgH(counter)=(tideMax(i)-tideMin(i+1))/2;
            prodH(counter)=(correctedTideMax(i)-correctedTideMin(i+1))/2;
            timeCycle(counter)=tmin(i+1)-tmax(i);
            timeProd(counter)=(endProdTime(i*2)-startProdTime(i*2));
        end
    end
    %create merged vectors
      extremePoints(2:2:2*length(tideMax))=tideMax;
      extremePoints(1:2:2*length(tideMax))=tideMin;
      extremeProdPoints(2:2:2*length(tideMax))=correctedTideMax;
      extremeProdPoints(1:2:2*length(tideMax))=correctedTideMin;
elseif(minmax && ~equal)
    for i=1:(length(tideMin)-1)
        counter=counter+1;
        %for min to max cycle
        avgH(counter)=(tideMax(i)-tideMin(i))/2;
        prodH(counter)=(correctedTideMax(i)-correctedTideMin(i))/2;
        timeCycle(counter)=tmax(i)-tmin(i);
        timeProd(counter)=(endProdTime(i*2-1)-startProdTime(i*2-1));
        %for max to min cycle
        counter=counter+1;
        avgH(counter)=(tideMax(i)-tideMin(i+1))/2;
        prodH(counter)=(correctedTideMax(i)-correctedTideMin(i+1))/2;
        timeCycle(counter)=tmin(i+1)-tmax(i);
        timeProd(counter)=(endProdTime(i*2)-startProdTime(i*2));
    end
    %create merged vectors
    extremePoints(2:2:(2*length(tideMin)-1))=tideMax;
    extremePoints(1:2:(2*length(tideMin)))=tideMin;
    extremeProdPoints(2:2:(2*length(tideMin)-1))=correctedTideMax;
    extremeProdPoints(1:2:(2*length(tideMin)))=correctedTideMin;
end

%Merge prod start time and end time vectors

helpVectorE=nan(1,length(endProdTime));
helpVectorS=nan(1,length(endProdTime));
for i=1:(length(endProdTime))
    helpVectorE(i)= endProdTime(i)-0.01;
    helpVectorS(i)= startProdTime(i)-0.01;
end

%illustrative production schedule
prodSchedule(1:4:4*length(startProdTime))=helpVectorS;
prodSchedule(2:4:4*length(startProdTime))=startProdTime;
prodSchedule(3:4:4*length(startProdTime))=helpVectorE;
prodSchedule(4:4:4*length(startProdTime))=endProdTime;

start_end_production(1:2:2*length(startProdTime))=startProdTime;
start_end_production(2:2:2*length(startProdTime))=endProdTime;

timeProdCycle=endProdTime-startProdTime;
nIntervalsCycle=round(timeProdCycle/lengthInterval);
nMaxIntervals=max(nIntervalsCycle);


shortestCycle=min(timeCycle)/60; %in hours
longestCycle=max(timeCycle)/60; %in hours
minH=min(avgH);
maxH=max(avgH);

prodHTot(1:4:(4*length(prodH)))=zeros(1,length(prodH));
prodHTot(2:4:(4*length(prodH)))=prodH;
prodHTot(3:4:(4*length(prodH)))=prodH;
prodHTot(4:4:(4*length(prodH)))=zeros(1,length(prodH));

nCycles=(length(imax)+length(imin)-1);

figure %plots average head and average production head
plot(avgH);
hold on
plot(prodH);

% figure
% plot(imax,tideMax,imin,tideMin);

figure 
subplot(2,1,1) 
plot(startProdTime,extremeProdPoints(1:end-1)); % plots extremepoints versus start production time
hold on
plot(endProdTime,extremeProdPoints(2:end));  % plots extremepoints versus end production time
subplot(2,1,2)
plot(prodSchedule,prodHTot); %plots production profile as production height as a function of time


%Writing the power price matrix "Price" for every prod interval
%define nCycles, nIntervalsCycle(c), startProdTime(c), PriceRaw, T, nMaxIntervals;
Price=zeros(nCycles,nMaxIntervals);
c=1;t=1;
T=lengthInterval;

%import Price data, update function on new laptop
PriceRaw=get_price_data();

while c<=nCycles
    i=startProdTime(c);%start time for prod interval in min after Jan 1st
    while t<=nIntervalsCycle(c)
        j=floor(i/60);%prod interval in hours after Jan 1st
        Price(c,t)=PriceRaw(j,1);%power price at c and t for Xpress, to be written to text file
        i=i+T;  %time for next prod interval in min after Jan 1st
        t=t+1;  %counter for prod intervals in cycle
    end
    t=1;
    c=c+1;
end

fprintf(fileProdHead,' %f',prodH); %height given in meters
fprintf(fileStartProd,' %f',startProdTime); %time given in minutes
fprintf(fileEndProd,' %f',endProdTime); %time given in minutes
fprintf(fileStartEndProd, ' %f', start_end_production);
fprintf(fileIntervalsCycle, ' %d',nIntervalsCycle);
fprintf(filePrice,' %f', Price); % matrix prints: column 1,2,3... (1,1;2,1;3,1;etc)

fclose('all');
