%Script running separate optimisation problems in Xpress

MoselFile = 'Stability5_3.mos'; 
for i=1:3
  moselexec(MoselFile, ['nameapp=' num2str(i)]);
end
