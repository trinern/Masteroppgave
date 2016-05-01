clear all;
clc

components=['M2' 'S2' 'N2' 'K2' 'K1' 'O1' 'P1' 'Q1'];
%components=[M2 S2 N2 K2 K1 O1 P1 Q1];
d=1; % the day number of the year
y=2016; %year number, greater or equal 1975

D=d+365*(y-1975)+floor((y-1975)/4);
T=(27392.500528+1.0000000356*D)/36525;
h0=279.69668+36000.768930485*T+3.03*10^(-4)*T^2;
s0=270.434358+481267.88314137*T-0.001133*T^2+1.9*10^(-6)*T^3;
p0=334.329653+4069.0340329575*T-0.010325*T^2-1.2*10^(-5)*T^3;
astronomicalArgument=[2*h0-2*s0 0 2*h0-3*s0+p0 2*h0 h0+90 h0-2*s0-90 h0-90 h0-3*s0*p0-90];

components;
astronomicalArgument;
arguments=[components;astronomicalArgument];

formatSpec = 'Component %2s has the astronomic argument: %8.10f\n';
fprintf(formatSpec,arguments);