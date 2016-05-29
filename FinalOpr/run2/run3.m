%Script running separate optimisation problems in Xpress
%addpath(fullfile(getenv('XPRESSDIR'),'/matlab'));
Cycles=3;
MoselFile = 'OprCase1_2.mos'; 
Selected=[7 8 9];

for i=1:Cycles
  moselexec(MoselFile, ['nameapp='  num2str(Selected(i))]);
end
