path = 'C:\Users\ALANBER\Desktop\eeg 癲癇\李老師data\2022-04-07_19-00-03_channel_2\';
path2 = [path '*.mat'];
file_names = dir(path2);
filter_bandpass=[1 30];
load('C:\Users\ALANBER\Desktop\eeg 癲癇\run_main.mat')
%%
for i=1%:length(file_names)
     real_name=batch_path(i).name;
     real_name_index=real_name(10:length(real_name));
     %
     file_name = file_names(i).name;
     mat_name = file_name(1:find(file_name == '.') - 1);
     file_name = [path file_name];
     load(file_name)
     %
     save_name=['C:\Users\ALANBER\Desktop\new_dataserial\' 'Re0' real_name_index '.mat']
     save(save_name,'EEG','period','all_power_1_5','all_power_3_5','all_power_5_10','all_power_5_20','all_power_7_20')
end