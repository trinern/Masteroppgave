%Script running separate optimisation problems in Xpress

MoselFile = 'Stability2SD5_3.mos'; 
for i=1:12
  moselexec(MoselFile, ['nameapp=' num2str(i)]);
end
