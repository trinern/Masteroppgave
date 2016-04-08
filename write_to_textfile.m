%this file writes to textfile


formatSpec = 'Height:%2.1f meters; Time: Day %3.0f at %2.0f:%2.0f\n';
fprintf(fileCheckCyle,formatSpec,checkData);

%cycleInfo=[startTimeCycle; nIntervalsCycle];

%write number of periods in cycle to datafile
fprintf(fileDataExpress,'%6s\n','nPeriods:[');
fprintf(fileDataExpress,' %d',nIntervalsCycle);
fprintf(fileDataExpress,'\n%s\n\n',']');
%write start height to datafile
fprintf(fileDataExpress,'%6s\n','StartH:[');
fprintf(fileDataExpress, ' %f', startHeightCycle);
fprintf(fileDataExpress,'\n%s\n\n',']');
%write reservoir head matrix to datafile
fprintf(fileDataExpress,'%6s\n','ResHead:[');
fprintf(fileDataExpress,' %f',ResHeightMatrix); %height given in meters, prints for (c=1, m=1; c=1,m=2; ....c=1, m=M....C=nCycles, m=M)
fprintf(fileDataExpress,'\n%s\n\n',']');
%write flow vector to datafile
fprintf(fileDataExpress,'%6s\n','Flow:[');
fprintf(fileDataExpress,' %d',flowVector); %flow given in m^3/s
fprintf(fileDataExpress,'\n%s\n\n',']');
%wrtite power matrix to datafile
fprintf(fileDataExpress,'%6s\n','Power:[');
fprintf(fileDataExpress,' %f',powerMatrixExpress);
fprintf(fileDataExpress,'\n%s',']');

%fprintf(fileResHeight,' %f',ResHeightMatrix); %height given in meters, prints for (c=1, m=1; c=1,m=2; ....c=1, m=M....C=nCycles, m=M)
%fprintf(fileFlow,' %d',flowVector); %flow given in m^3/s
%fprintf(filePower,' %f',powerMatrix); %Prints value for: (c=1, t=1, f=1, h=1; c=2, t=1; f=1,h=1;...c=nCycles); then t=2..nPeriods (c=1..nCycles for each t); then f=2...nFlow, then h=1..nHead
%fprintf(filePower,' %f',powerMatrixExpress);
%fprintf(fileCycle,' %f',cycleInfo); %prints (starttime cycle 1; nPeriods cycle 1; starttime cycle 2; nPeriods cycle 2....for nCycles)
%fprintf(fileStartHeight, ' %f', startHeightCycle);

%to use in matlab
fprintf(fileCycleStart,' %f',startTimeCycle);
fprintf(filenPeriods,' %d',nIntervalsCycle);

%fprintf(filePrice,' %f', Price); % matrix prints: column 1,2,3... (1,1;2,1;3,1;etc)