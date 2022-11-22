clear all
close all
clc

path = "G:\2022-08-02_19-00-02\Record Node 130\experiment1";% 讀資料
savePath = 'G:\swd data 221109\2022-08-02_19-00-02';%存路徑
batch_path = dir(path);
chosse_channel = [1,2,7,8,9,10,15,16];
replace = true;
%%
for i_file=3%:length(batch_path)
    file_name=[char(path) '\' batch_path(i_file).name '\structure.oebin' ];
    file_name=char(file_name);
    %load_open_ephys_binary(file_name,'continuous',1,'mmap');
    data = EEG_tools.getRawData(file_name, chosse_channel, replace);
    data = EEG_tools.Preprocessing(data,data.Data,[0.5 300],30000,1000);
    EEG.data = data.Data(1:4,:);
    saveFileName = ['Re0'   num2str(i_file)];
    EEG_tools.saveICAData(EEG,savePath,[saveFileName]);
end
