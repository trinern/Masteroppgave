%Script running separate optimisation problems in Xpress

Cycles=40;
MoselFile = 'OprCase2_2.mos'; 


for i=1:Cycles
  moselexec(MoselFile, ['nameapp='  num2str(i)]);
end
