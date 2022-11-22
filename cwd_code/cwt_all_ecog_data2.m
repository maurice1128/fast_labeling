path = 'G:\data_pre\data\2022-08-16_18-31-22\';
path2 = [path '*.mat'];
file_names = dir(path2);
filter_bandpass=[1 30]
%%
for i=1:length(file_names)
    file_name = file_names(i).name;
    mat_name = file_name(1:find(file_name == '.') - 1);
    file_name = [path file_name];
    load(file_name)
    EEG = pop_eegfilt( EEG, filter_bandpass(1), filter_bandpass(2), [], [0], 0, 0, 'fir1', 0);
    Data=EEG.data;
    %
    all_power_1_5=[];
    all_power_3_5=[];
    all_power_5_10=[];
    all_power_5_20=[];
    all_power_7_20=[];
    for i_ch=1:4
        detected_data=Data(i_ch,:);
        [wt period]=cwt(detected_data,1000);
        for i_time=1:length(wt(1,:))
            all_power_1_5(i_ch,i_time)=mean(abs(wt(65:88,i_time)));
            all_power_3_5(i_ch,i_time)=mean(abs(wt(65:72,i_time)));
            all_power_5_10(i_ch,i_time)=mean(abs(wt(55:65,i_time)));
            all_power_5_20(i_ch,i_time)=mean(abs(wt(45:65,i_time)));
            all_power_7_20(i_ch,i_time)=mean(abs(wt(45:60,i_time)));
        end 
    end
    file_name
    save(file_name,'EEG','period','all_power_1_5','all_power_3_5','all_power_5_10','all_power_5_20','all_power_7_20')
end
