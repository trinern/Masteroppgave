%Script running separate optimisation problems in Xpress

MoselFile = 'Stability3_3.mos'; 
for i=1:20
  moselexec(MoselFile, ['nameapp=' num2str(i)]);
end
