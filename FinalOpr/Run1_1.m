%Script running separate optimisation problems in Xpress
%addpath(fullfile(getenv('XPRESSDIR'),'/matlab'));
Cycles=40;
MoselFile = 'OprCase1_1.mos'; 


for i=1:Cycles
  moselexec(MoselFile, ['nameapp='  num2str(i)]);
end
