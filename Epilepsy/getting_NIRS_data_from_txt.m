# Title: Getting NIRS data from *.txt files 
# Description: When NIRS data is exported as *.txt file, you use this code!
# Date: 2019.12
# Writer: Cogreen

cd('Y:\CLINIC\01APM\01NIRS_EEG\Data\20191226');

%% Variable setting
NIRS_fname='20190822_46083575_KSC_EEG_1_1.txt';

%% Read 200 lines of '20190821_KJC_EEG1.txt' and save it to 'new.txt'
fid1 = fopen(NIRS_fname,'rt+');         % open '20190821_KJC_EEG1.txt'
fid2 = fopen('new.txt','w');            % open 'new.txt'file

for c=1:500
    line = fgetl(fid1);                 % read line by line
    fprintf(fid2,'%s\r\n',line);        % write the line to the new file with new line for MS text, otherwise use \n
end
fclose(fid1);
fclose(fid2);

%% Read data into a cell variable 'data'

data = fileread('new.txt');               % read data from a file

            
data = regexp(data, '\n', 'split');       % split lines and save into a cell variable 'data'
tmp = size(data);
tmp = tmp(2)-1;
data = data(1:tmp); 

%% Create a cell variable 'legend'

% find the loctaion of 'Legend:'
leg_ind = find(contains(data,'Legend:')); 

% confirm data(1,4) is an empty cell (or line) 
tmp = find(strcmp(data, data(1,4)));

% find empty cells (or lines)
data_init = tmp(end)+1; 

% create a cell variable 'legend'
legend = data(leg_ind+1:data_init-1); 
tmp = ~strcmp(legend, data(1,4));
legend = legend(tmp);
legend = legend'; 

%% Create a cell varialbe 'NIRS' - not needed
tmp = size(data); 
tmp = tmp(2); 
NIRS = data(data_init:tmp);
NIRS = NIRS';

%% Read a file without headerlines, etc. => data 

% open '20190821_KJC_EEG1.txt';
fid1 = fopen(NIRS_fname,'rt+'); 

tmp = size(legend); 
tmp = tmp(1)-1; 
data2 = textscan(fid1, [repmat('%f64',[1,tmp])], 'HeaderLines', data_init-1, 'EndOfLine', '\n');
fclose(fid1);

data2=cell2mat(data2);
