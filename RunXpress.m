%Script running separate optimisation problems in Xpress

%Cycles=1409;
MoselFile = 'OperationalPart_FP4HP5_S10_T1.mos'; 
Case = '';
for i=1:3
  moselexec(MoselFile, ['nameapp=' strcat(Case, num2str(i))]);
end
