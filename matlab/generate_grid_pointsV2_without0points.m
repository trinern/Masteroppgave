%function that generate gridpoints for each (ct)
%timeDiscretisation of original tidecycle, should be 1min
%horizon, planning period in days
%H0, average height, should be 0;
%componentMatrix: matrix with constants neccessary to generate tide cycle 
%lengthInterval: length of period in model (mosel)
%n= number of discretisations on flow (q)-axis
%m= number of discretisations on height (h^(RES))- axis

clear all
%OBS: Check section about test sets before running

timeDiscretisation=1;
horizon=1;
H0=0;
lengthInterval=15;
n=5;
m=n+1;


%efficiency cosntants, related to turbine 
alpha=3.5;
beta=1.333;
nomFlow=86; %m^3/s
xx=6;
delta=0.905;
Qmin=39; %m^3/s
Qmax=95; %m^3/s
Dt=3.72; % rotor diameter in m
Dh=1.64; %hub diameter in m

%constants in energy expression
rho=1025; %kg/m^3
g=9.81; %m^2/s


%import tide cycle data (harmonic constituents)
%import from excel file, update on new laptop
componentMatrix=get_tide_Swansea_School();
%componentMatrix=get_tide_Swansea_School2();%no imput, returns componentMatrix for Kvalsund
%componentMatrix=get_tide_Kvalsund();
%import Price data, update function on new laptop
%PriceRaw=get_price_data();

tideCycle=get_tide_cycle(timeDiscretisation,horizon,H0,componentMatrix); 
%tideCycle=get_tide_cycle2(timeDiscretisation,horizon,H0,componentMatrix);%m
minTideCycle=tideCycle*(-1); %inverse function (to find min peaks)


%define cycles
[tideMax,imax] = findpeaks(tideCycle); %returns a vector (1) with the local maxima (peaks) of the input signal vector, data, and vector (2) with indicies of the location.
[tideMin,imin] = findpeaks(minTideCycle);
tideMin=tideMin*(-1); %correct min values.
tmax=timeDiscretisation*(imax-1);%converts index to time stamp for max points in minutes from start date of tide cycle
tmin=timeDiscretisation*(imin-1);%converts index to time stamp for min points in minutes from start date of tide cycle



%creates vector with all extremepoint heights and vector with associated
%timestamps
%Note: skips beginning of tide cycle before first max min and the end after last max, min. 
isMin=false;
isMax=false;
if tmax(1)<tmin(1)
    isMax=true;
    extremePoints(1:2:(2*length(tideMax)))=tideMax;
    extremePoints(2:2:(2*length(tideMin)))=tideMin;
    timeExtremepoints(1:2:(2*length(tideMax)))=tmax;
    timeExtremepoints(2:2:(2*length(tideMin)))=tmin;
elseif tmin(1)<tmax(1)
    isMin=true;
    extremePoints(1:2:(2*length(tideMin)))=tideMin;
    extremePoints(2:2:(2*length(tideMax)))=tideMax;
    timeExtremepoints(1:2:(2*length(tideMin)))=tmin;
    timeExtremepoints(2:2:(2*length(tideMax)))=tmax; 
else
      error('Min and Max at same point???')
end

realHeight=5.12+extremePoints;
%realHeight=realHeight';
minutes=round(((timeExtremepoints/60)-floor(timeExtremepoints/60))*60);
%minutes=minutes';
days=floor(floor(timeExtremepoints/60)/24)+1;
%days=days';
hours=round(((floor(timeExtremepoints/60)/24)-floor(floor(timeExtremepoints/60)/24))*24);
%hours=hours';

checkData=[realHeight;days;hours;minutes];
%checkData=checkData';


nCycles=length(extremePoints)-1;

%%%%%%%%%%%%%%%%%%%% ---just for test sets---%%%%%%%%%%%%%%%%%%%%
% nCycles=5;
scale=1; %scale to increase head difference
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 timeCycle=zeros(1,nCycles);
 for i=1:nCycles
     timeCycle(i)=timeExtremepoints(i+1)-timeExtremepoints(i);
 end



nIntervalsCycle=round(timeCycle/lengthInterval); %adjust duration of each cycle to match length of intervals, 
nMaxIntervals=max(nIntervalsCycle);

%Writing the power price matrix "Price" for every prod interval
%define nCycles, nIntervalsCycle(c), startProdTime(c), PriceRaw, T, nMaxIntervals;
Price=zeros(nMaxIntervals,nCycles);
c=1;t=1;
T=lengthInterval;



% %adjust price vector to tide cycle
% while c<=nCycles
%     i=timeCycle(c);%start time for prod interval in min after Jan 1st
%     while t<=nIntervalsCycle(c)
%         j=floor(i/60);%prod interval in hours after Jan 1st
%         Price(t,c)=PriceRaw(j,1);%power price at c and t for Xpress, to be written to text file
%         i=i+T;  %time for next prod interval in min after Jan 1st
%         t=t+1;  %counter for prod intervals in cycle
%     end
%     t=1;
%     c=c+1;
% end


%this is the same for all cycles
minHeadMatrix=zeros(n,1);
flowVector=zeros(n,1);
stepFlow=(Qmax-Qmin)/(n-1);
%flowVector(1)=0;
%minHeadMatrix(1)=0;
for i=1:n
    flowVector(i)=floor(Qmin+stepFlow*(i-1)); %create vector with flow discretisation
    minHeadMatrix(i)=((flowVector(i)/((pi/4)*(Dt^2-Dh^2)))^2)/(2*g);
end

maxHeadMatrix=zeros(nCycles,1);
for c=1:2:(nCycles)
    if isMax
        maxHeadMatrix(c)=extremePoints(c)-extremePoints(c+1);
        if c<nCycles
        maxHeadMatrix(c+1)=extremePoints(c+2)-extremePoints(c+1);
        end
    elseif isMin
        maxHeadMatrix(c)=extremePoints(c+1)-extremePoints(c);
        if c<nCycles
        maxHeadMatrix(c+1)=extremePoints(c+1)-extremePoints(c+2);
        end
    end
end
startTimeCycle=zeros(1,nCycles);
startHeightCycle=zeros(1,nCycles);
for i=1:nCycles
    startTimeCycle(i)=timeExtremepoints(i);
    startHeightCycle(i)=extremePoints(i);
end

%for each cycle c and period t
ResHeightMatrix=zeros(m,nMaxIntervals,nCycles);
stepH=zeros(1,nCycles);

%Impossible reservoir heads are possible (problem handled in xpress)
for c=1:nCycles
    %stepH(c)=(abs(extremePoints(c+1)-extremePoints(c))/(m-1));
    counter=startTimeCycle(c)-15;
    for i=1:nIntervalsCycle(c)
        counter=counter+15;
        if extremePoints(c+1)<extremePoints(c)
            for h=1:n
              ResHeightMatrix(h,i,c)=tideCycle(counter)+minHeadMatrix(h);
            end
        elseif extremePoints(c+1)>extremePoints(c)
            for h=1:n
                ResHeightMatrix(h,i,c)=tideCycle(counter)-minHeadMatrix(h);
            end
        end
        
        done=false;
        if (startHeightCycle(c)>0) &&(startHeightCycle(c)>ResHeightMatrix(n,i,c)) %hvis syklus høyere enn max grid høyde
            ResHeightMatrix(m,i,c)=startHeightCycle(c);
            done=true;
        elseif (startHeightCycle(c)>0) && (maxHeadMatrix(c)==ResHeightMatrix(n,i,c)) %hvis syklus lik max grid point
            ResHeightMatrix(m,i,c)=maxHeadMatrix(c)+1;
        elseif (startHeightCycle(c)<0) &&( startHeightCycle(c)<ResHeightMatrix(n,i,c))%hvis syklus lavere enn min grid høyde
            ResHeightMatrix(m,i,c)=startHeightCycle(c);
            done=true;
        elseif (startHeightCycle(c)<0) && (maxHeadMatrix(c)==ResHeightMatrix(n,i,c)) %hvis syklus lik min grid point
            ResHeightMatrix(m,i,c)=maxHeadMatrix(c)-11;
        elseif (startHeightCycle(c)>0)&& (startHeightCycle(c)<ResHeightMatrix(n,i,c)) %hvis syklus lavere enn max grid høyde, men positiv
            for h=(n-1):-1:1
                if (startHeightCycle(c)-ResHeightMatrix(h,i,c))>0.05 && ~done %hvis syklus lavere enn res høyde og ikke satt inn     
                    for k=n:-1:(h+1)
                        ResHeightMatrix(k+1,i,c)=ResHeightMatrix(k,i,c);
                        done=true;
                    end
                    ResHeightMatrix(h+1,i,c)=startHeightCycle(c);
                elseif startHeightCycle(c)==ResHeightMatrix(h,i,c) && ~done %hvis syklus lik res høyde og ikke satt inn
                    for k=n:-1:(h+1)
                        ResHeightMatrix(k+1,i,c)=ResHeightMatrix(k,i,c);
                        done=true;
                    end
                    ResHeightMatrix(h+1,i,c)=(ResHeightMatrix(h,i,c)+ResHeightMatrix(h+1,i,c))/2;
                    %ResHeightMatrix(h+1,i,c)=-1;
                end
            end
                if startHeightCycle(c)~=ResHeightMatrix(1,i,c) && ~done %hvis syklus mellom null og neste punkt
                    for k=n:-1:2
                        ResHeightMatrix(k+1,i,c)=ResHeightMatrix(k,i,c);
                        done=true;
                    end
                    ResHeightMatrix(2,i,c)=(ResHeightMatrix(1,i,c)+ResHeightMatrix(2,i,c))/2;
                end 
        elseif (startHeightCycle(c)<0)&& startHeightCycle(c)>ResHeightMatrix(n,i,c) %hvis syklus høyere enn min grid høyde, men negativ
            for h=(n-1):-1:1
                if (startHeightCycle(c)-ResHeightMatrix(h,i,c))<-0.05 && ~done %hvis syklus lavere enn res høyde og ikke satt inn
                    for k=n:-1:(h+1)
                        ResHeightMatrix(k+1,i,c)=ResHeightMatrix(k,i,c);
                        done=true;
                    end
                    ResHeightMatrix(h+1,i,c)=startHeightCycle(c);
                elseif (startHeightCycle(c)<0)==ResHeightMatrix(h,i,c)&& ~done %hvis syklus lik res høyde og ikke satt inn
                    for k=n:-1:(h+1)
                        ResHeightMatrix(k+1,i,c)=ResHeightMatrix(k,i,c);
                        done=true;
                    end
                    ResHeightMatrix(h+1,i,c)=(ResHeightMatrix(h+1,i,c)+ResHeightMatrix(h+3,i,c))/2;
                    
                end
            end 
            if startHeightCycle(c)~=ResHeightMatrix(1,i,c) && ~done %hvis syklus mellom null og neste punkt
                    for k=n:-1:2
                        ResHeightMatrix(k+1,i,c)=ResHeightMatrix(k,i,c);
                        done=true;
                    end
                    ResHeightMatrix(2,i,c)=(ResHeightMatrix(1,i,c)+ResHeightMatrix(2,i,c))/2;
            end  
        end
        
    end
end


%for each cycle and time period
powerMatrix=zeros(nCycles,nMaxIntervals,n,n);
powerMatrixExpress=zeros(m,n,nMaxIntervals,nCycles);

heightTide=zeros(nMaxIntervals,nCycles);
effect=zeros(1,length(flowVector));
 for c=1:nCycles;
     for i=1:nIntervalsCycle(c)
         timestamp=timeExtremepoints(c)+lengthInterval*(i-1);
         heightTide(i,c)=scale*(tideCycle(timestamp)+tideCycle(timestamp+lengthInterval))/2; %level of tide for period t is set to the average heght in that period 
         for f=1:n
            flow=flowVector(f);
            effect(f)=(1-(alpha*abs(1-beta*(flow/nomFlow))^xx))*delta;
            for h=1:m
                heightRes=ResHeightMatrix(h,i,c);        
                %powerMatrixExpress(h,f,i,c)=abs(rho*g*effect(f)*abs(heightRes-heightTide(i,c))*flow);
                if abs(heightRes-heightTide(i,c))>=minHeadMatrix(f)
                 powerMatrix(c,i,f,h)=abs(rho*g*effect(f)*abs(heightRes-heightTide(i,c))*flow);
                 powerMatrixExpress(h,f,i,c)=abs(rho*g*effect(f)*abs(heightRes-heightTide(i,c))*flow);
                else
                 powerMatrix(c,i,f,h)= -1;
                 powerMatrixExpress(h,f,i,c)= -1;
                end
            end
         end
     end
 end



%cycleInfo=[startTimeCycle; nIntervalsCycle];



open_textfiles;

write_to_textfile;

%powerVector()=powerMatrix(1,2,:,:);


gridPoints=true;
fclose('all');
