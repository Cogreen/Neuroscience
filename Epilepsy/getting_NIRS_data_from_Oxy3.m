# Title : Getting NIRS data from *.oxy3 files 
# Date: 2020.01.07
# writer: cogreen 


%% 24 channels _ ver2.2020.01.07


%% Start FieldTrip + Read Raw data
% reference site: 
% http://www.fieldtriptoolbox.org/tutorial/nirs_multichannel/#read-data-and-downsample

% Execute fieldtrip
addpath("D:\fieldtrip-20191005")

% Open *.oxy3 in the folder including files 
% Raw file - sample rate: 10hz 
% sampleinfo: 131462
% cfg             = [];
% cfg.dataset     = 'p2_raw.oxy3';
% data_raw        = ft_preprocessing(cfg);

% Raw file - sample rate: 10hz 
% sampleinfo: 40133  (39315:79448)
cfg             = [];
cfg.dataset     = '45942431_KJC_2.oxy3'; %120computer: C:\Users\user\Desktop\20191231
data_raw        = ft_preprocessing(cfg);
struct(data_raw)

%%

% optodetemplates error 
    % laoding: optodetemplates.xml
    
%%
nirs_data = data_raw.trial{1,1};
label=data_raw.label;

% Extrating Only NIRS data 
nirs = nirs_data(1:40,:);

% Transpoisng NIRS data to build NIRS dataset
nirs = nirs';


%% Build NIRS dataset based on channel and the types of hemoglobin

% seperate channles for dxy, oxy and total  
NIRS_Chs = 20;
for ch = 1:NIRS_Chs  
    eval(['O' num2str(ch) '= nirs(:, 2*', num2str(ch), ')']);
    eval(['D' num2str(ch) '= nirs(:, 2*', num2str(ch), '-1)']);
    eval(['T' num2str(ch) '= nirs(:, 2*', num2str(ch), ') + nirs(:, 2*', num2str(ch), '-1)']);
end



%% Plot test
    % Befroe plotting, make the folder to save plots

% Plotting Each NIRS Ch 
time = 2000:3000;
NIRS_Chs = 20;
for ch = 1:NIRS_Chs
    eval(['A = figure(' num2str(ch) ')'])
    eval(['y1 = D' num2str(ch) '(time)']);
    eval(['y2 = O' num2str(ch) '(time)']);
    plot(time, y1-mean(y1), time, y2-mean(y2));
    ylabel('Hb Changes');
    xlabel('Sample Rate (50Hz)');
    grid on;
    saveas(A, sprintf('NIRS_%d.jpg', ch));
    close
end

% Plotting overall NIRS Chs
time = 2000:3000;
NIRS_Chs = 20;
A = figure
for ch = 1:NIRS_Chs
    subplot(4,5,ch);
    caption = sprintf('Ch %d', ch);
    eval(['y1 = D' num2str(ch) '(time)']);
    eval(['y2 = O' num2str(ch) '(time)']);
    plot(time, y1-mean(y1), time, y2-mean(y2));
    title(caption)
    grid on;
    hold on
end
set(A, 'Position', [0,0,48000, 24000]);
saveas(A, 'NIRS_plot_test.jpg')
close


%save name error
time = 2000:3000;
NIRS_Chs = 20;
A = figure
for ch = 1:NIRS_Chs
    subplot(4,5,ch);
    caption = sprintf('Ch %d', ch);
    eval(['y1 = D' num2str(ch) '(time)']);
    eval(['y2 = O' num2str(ch) '(time)']);
    plot(time, y1-mean(y1), time, y2-mean(y2));
    title(caption)
    grid on;
    hold on
end
set(A, 'Position', [0,0,48000, 24000]);
save_name = 'NIRS_Range_%d_%d';
d1 = int2str(time(1))
d2 = int2str(time(end))
saveas(A, sprintf(save_name, d1, d2), 'jpg')
close

savename = 'NIRS_range:'    
eval(['duration = time')]


%%
save('20190922_46083575_KSC_ERP_2_NIRS.txt', 'nirs', '-ASCII','-append');
