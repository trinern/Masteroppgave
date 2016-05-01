%Script running separate optimisation problems in Xpress

MoselFile = 'OperationalTurbTest_1.mos'; 

for i=1:2
  moselexec(MoselFile, ['nameapp=' num2str(i)]);
end
