%Script running separate optimisation problems in Xpress

%If running on NTNU-PC
addpath(fullfile(getenv('XPRESSDIR'),'/matlab'));
%Cycles=1409;
MoselFile = 'MatlabTest.mos'; 
Case = '';
for i=1:3
  moselexec(MoselFile, ['nameapp=' strcat(Case, num2str(i))]);
end
