%Script running separate optimisation problems in Xpress
%addpath(fullfile(getenv('XPRESSDIR'),'/matlab'));
Cycles=3;
MoselFile = 'Opr.mos'; 
Selected=[6 20 34];

for i=1:Cycles
  moselexec(MoselFile, ['nameapp='  num2str(Selected(i))]);
end
