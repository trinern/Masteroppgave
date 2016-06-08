%Script running separate optimisation problems in Xpress
%addpath(fullfile(getenv('XPRESSDIR'),'/matlab'));
Cycles=40;
MoselFile = 'Opr15_3.mos'; 
%Selected=[1 15 29];

for i=1:4:Cycles
  moselexec(MoselFile, ['nameapp='  num2str(i)]);
end
