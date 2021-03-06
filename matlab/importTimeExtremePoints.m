function [TimeExtremePoints]=importTimeExtremePoints( )
%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\Trine\Dropbox\Masteroppgave\Matlab\TimeExtremePoints.txt
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2016/03/31 16:26:42

%% Initialize variables.
filename = 'C:\Users\Trine\Dropbox\Masteroppgave\Matlab\TimeExtremePoints.txt';

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%10f%11f%11f%12f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
TimeExtremePoints = [dataArray{1:end-1}];
%% Clear temporary variables
clearvars filename formatSpec fileID dataArray ans;