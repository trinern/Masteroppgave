%Script running separate optimisation problems in Xpress
%addpath(fullfile(getenv('XPRESSDIR'),'/matlab'));
%Cycles=40;
N=3;
%N=2;
%Cycles=[1 3 16];
%Cycles=[19 20 22];
Cycles=[20 22 23];
MoselFile = 'OprCase2_2.mos'; 


for i=1:N
  moselexec(MoselFile, ['nameapp='  num2str(Cycles(i))]);
end
