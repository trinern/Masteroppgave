% timeDiscretisation [min]: length of time period
% horizon [days]: lengt og planning horizon
% H0[meters]: average level of water level over 19 years, given location
% ComponentMatrix: period, amplitude, phase, astronomic arguments
% period[hours]: period in cycle
% amplitude [cm]: amplitude of tide cycle component, given location
% phase [Degrees]: phase shift of tide cycle component, given location

function tideCycle = get_tide_cycle2(timeDiscretisation,horizon,H0,componentMatrix)

nComponents=length(componentMatrix);
 nSteps=(horizon*24*60)/timeDiscretisation; %number of periods in horizon
 t=zeros(1,nSteps); %vector of periods
 componentMatrix(:,1)= componentMatrix(:,1)./(60*60);
% componentMatrix(:,2)= componentMatrix(:,2).*(1/100); use if original data in cm

 %create discrete time vector
for i=1:nSteps
    t(i+1)=t(i)+(timeDiscretisation*60); %Note: last period not included
end
 
   % frequency=(1./componentMatrix(:,1))*360; %frequency given by period in degrees/s
    
    %pre-define matrixes
   % Period=nan(nComponents,length(t));
    %cosArg=nan(nComponents,length(t));
    comp=nan(nComponents,length(t));

    %calculations of tide-components
    for i=1:nComponents
        comp(i,:)=componentMatrix(i,2).*cosd(t.*componentMatrix(i,1)+ componentMatrix(i,4)-componentMatrix(i,3)+200);
    end

H=H0+sum(comp); %tide level as function of time
tideCycle=H;

 t=t./(60*60*24); %converts time vector to days
 
 figure(1)
 plot(t,H);