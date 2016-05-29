%Script running separate optimisation problems in Xpress
%addpath(fullfile(getenv('XPRESSDIR'),'/matlab'));
Cycles=7;
MoselFile = 'OprCase2_2.mos'; 
Selected=[3 9 15 21 27 33 39];

for i=1:Cycles
  moselexec(MoselFile, ['nameapp='  num2str(Selected(i))]);
end
