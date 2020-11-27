%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trigger Table 
% Description: From *.txt files, trigger can be marked by checking onset/ offset.  
% Date: 2020.01.28
% Writer: Cogreen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set file name 
prompt1 = 'Write the file name'
prompt2 = 'Write the file extension with dot    ex) .txt'
file_name = input(prompt1, 's')
extension = input(prompt2', 's')

%% Read all lines of '20190821_KJC_EEG1.txt' and save it to 'new.txt'
file = append(file_name, extension)

fid1 = fopen(file,'r'); %% open '1 graph.txt'
fid2 = fopen('new.txt','w'); %% open 'new.txt'file
count = 0;
while ~feof(fid1)
    line = fgetl(fid1); %% read line by line
    fprintf(fid2,'%s\r\n',line); %% write the line to the new file with new line for MS text, otherwise use \n
end
fclose(fid1);
fclose(fid2);



%% Read data into a cell variable 'data'
data=fileread('new.txt'); % read data from a file
data=regexp(data, '\n', 'split');tmp=size(data);tmp=tmp(2)-1;data=data(1:tmp); % split lines and save into a cell variable 'data'

%% Create a cell variable 'legend'
leg_ind=find(contains(data,'Legend:')); % find the loctaion of 'Legend:'
tmp=find(strcmp(data, data(1,4)));data_init=tmp(end)+1; %% confirm data(1,4) is an empty cell (or line) % find empty cells (or lines)
legend=data(leg_ind+1:data_init-1); tmp=~strcmp(legend, data(1,4));legend=legend(tmp);legend=legend'; % create a cell variable 'legend'

%% Create a cell varialbe 'NIRS'
tmp=size(data); tmp=tmp(2); NIRS=data(data_init:tmp);NIRS=NIRS';


%% tmp string manipulation
tmp=char(legend(1)); tmp1=tmp(7); tmp2=' (';legend2=split(legend, tmp1); 
tmp=char(NIRS(1)); tmp1=tmp(2);

NIRS2=split(NIRS, tmp1);

%% Save only NIRS data
file_name_nirs = append(file_name, '_nirs', extension)

writecell(NIRS, file_name_nirs,'Delimiter','tab')


%% Trigger using func. CONTAINS
% Finding Trigger cell
    % Finding PortAd_Input in legend and Definining PortAd_Input
    
    idx = contains(legend2,'PortAd_Input')                  % Change variables in [idx] as 1 when matching the string 'Port_Input' in [legend] 
    sample_num = contains(legend2,'Sample')
    for k = 1:length(legend2)                               % Count the length of [legend] 
        if idx(k,2) == 1                                    % Define the number in the 1st column of [legend] as [ad_num] when the 2nd column of [idx] is 1('PortAd_Input')
            ad_num = legend2{k, 1}                           % [ad_num]'s value will be the column which we will check to find the triggers('PortAd_input') 
        end
        if sample_num(k,2) == 1
            sam_num = legend2{k, 1}
        end
    end


%% change <string> to <double>
sam_num = str2double(sam_num);
ad_num = str2double(ad_num);
NIRS3 = str2double(NIRS2);



%% Skip these codes / Use the below codes using Table
    % Trigger info(time, trigger) depending on Sample rate 
    
        % Class as <Double>

        % Sample rate: 10Hz | Column name: Time(sec)/Trigger(voltage) 
            time = NIRS3(:, sam_num)*0.1;
            ad = NIRS3(:,ad_num);
            trigger = horzcat(time, ad);

        % Sample rate: 50Hz | Column name: Time(sec)/Trigger(voltage) 
            time = NIRS3(:, sam_num)*0.02;
            ad = NIRS3(:,ad_num);
            trigger = horzcat(time, ad);


        %% Save trigger info (double) 
            file_name_trigger = append(file_name, '_nirs_trigger', extension);

            save(file_name_trigger, 'trigger', '-ASCII','-append');



%% Trigger info(time, trigger) depending on Sample rate 
% Class as <Table>
    % Sample rate: 10Hz | Column name: Time(sec)/Trigger(voltage) 
        Time = NIRS3(2:end, sam_num)*0.1;
        Ad_Trigger = NIRS3(2:end,ad_num);
        trigger_info = table(Time, Ad_Trigger);

    % Sample rate: 50Hz | Column name: Time(sec)/Trigger(voltage)     
        Time = NIRS3(2:end, sam_num)*0.02;
        Ad_Trigger = NIRS3(2:end,ad_num);
        trigger_info = table(Time, Ad_Trigger);

%% Save trigger info (table)
file_name_trigger = append(file_name, '_nirs_trigger', extension);

% writetable(trigger_info, file_name_trigger)                     %'default: Delimiter',','
writetable(trigger_info, file_name_trigger, 'Delimiter','tab')


%% Find Onset/Offset Triggers
    % Declare new variables 
    onset_time = []                 % time 
    temp_onset_time = []
    offset_time = []
    temp_offset_time = []
    onset = []                      % trigger 
    temp_onset = []
    offset = []
    temp_offset = []
    
    % Find Onset/Ooffset Triggers
    for k = 1:height(trigger_info)
        if Ad_Trigger(k) > 4 & Ad_Trigger(k-1) == 0;
            temp_onset = Ad_Trigger(k);
            temp_onset_time = Time(k);
            onset = vertcat(onset, temp_onset);
            onset_time = vertcat(onset_time, temp_onset_time);
        elseif Ad_Trigger(k) > 0 & Ad_Trigger(k+1) == 0 ;
            temp_offset = Ad_Trigger(k);
            temp_offset_time = Time(k);
            offset = vertcat(offset, temp_offset);
            offset_time = vertcat(offset_time, temp_offset_time);
        end 
    end

%% Inidcate the types of triggers 
    % Indicate "Onset" of trigger
    for k = 1:length(onset)
        onset_info{k,1} = 'On_set';
    end
    onset_info = convertCharsToStrings(onset_info);

    % Indicate "Offset" of trigger
    for k = 1:length(offset)
        offset_info{k,1} = 'Off_set';
    end
    offset_info = convertCharsToStrings(offset_info);

%% Make the table including 'Time', 'PortAd_Trigger','On_off' 

    % Make each table (onset/offset)
    on = table(onset_time, onset, onset_info);
    off = table(offset_time, offset, offset_info);

    % Reset same variablenames 
    on.Properties.VariableNames = {'Time', 'PortAd_Trigger','On_off'};
    off.Properties.VariableNames = {'Time', 'PortAd_Trigger','On_off'};
    
    % Combine the tables
    sync_info = [on; off];

    % Sort asceding time 
    sorted_sync_info = sortrows(sync_info,'Time','ascend');
    
    
%%
file_name_sync = append(file_name, '_nirs_sync', extension);

% writetable(sorted_sync_info, file_name_sync)                     %'default: Delimiter',','
writetable(sorted_sync_info, file_name_sync, 'Delimiter','tab');
