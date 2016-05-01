%Script running separate optimisation problems in Xpress

MoselFile = 'Stability15_3.mos'; 
for i=1:3
  moselexec(MoselFile, ['nameapp=' num2str(i)]);
end
