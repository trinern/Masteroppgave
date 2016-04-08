%This file opens files

%filePrice=fopen('Test1_Price.txt','w');
%fileCycle=fopen('Swansea_T2_CycleTimes.txt','w');

format_filenPeriods = ['Swansea_T2_Cycle_nPeriods' num2str(nCycles) '.txt'];
format_fileDataExpress = ['Cycle_Data' num2str(nCycles) '.txt'];
format_fileCycleStart = ['Swansea_T2_CycleStartTime' num2str(nCycles) '.txt'];
format_fileCheckCyle = ['Check_Cycle_Data' num2str(nCycles) '.txt'];
%filename = ['string_' num2str(variable) ... '.txt'];

%Data used in Xpress
%fileResHeight= fopen('Swansea_T2_reservoir_height.txt','w');
%fileFlow= fopen('Swansea_T2_flow.txt','w');
%filePower= fopen('Swansea_T2_power_output.txt','w');
%fileStartHeight=fopen('Swansea_T2_Start_Height.txt','w');
filenPeriods=fopen(format_filenPeriods,'wt');
fileDataExpress=fopen(format_fileDataExpress,'wt');

%only used in matlab
fileCycleStart=fopen(format_fileCycleStart,'wt');

%to control cycle
fileCheckCyle=fopen(format_fileCheckCyle,'wt');