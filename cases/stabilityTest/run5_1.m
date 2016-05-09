%Script running separate optimisation problems in Xpress

MoselFile = 'Stability5_1.mos'; 
for i=1:21
  moselexec(MoselFile, ['nameapp=' num2str(i)]);
end
