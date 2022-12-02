try

for count = 1:24
clearvars -except count
close all
clc

path_option={
    'L:\4th_raw\2022-08-02_19-00-02\Record Node 130\experiment1';
'L:\4th_raw\2022-08-02_19-00-02\Record Node 130\experiment1';
'L:\4th_raw\2022-08-02_19-00-02\Record Node 130\experiment1';
'L:\4th_raw\2022-08-02_19-00-02\Record Node 130\experiment1';
'L:\4th_raw\2022-08-04_14-00-02\Record Node 130\experiment1';
'L:\4th_raw\2022-08-04_14-00-02\Record Node 130\experiment1';
'L:\4th_raw\2022-08-04_14-00-02\Record Node 130\experiment1';
'L:\4th_raw\2022-08-04_14-00-02\Record Node 130\experiment1';
'L:\4th_raw\2022-08-16_18-31-22\Record Node 135\experiment1';
'L:\4th_raw\2022-08-16_18-31-22\Record Node 135\experiment1';
'L:\4th_raw\2022-08-16_18-31-22\Record Node 135\experiment1';
'L:\4th_raw\2022-08-16_18-31-22\Record Node 135\experiment1';
'J:\4th Raw\2022-08-18_17-18-46\Record Node 142\experiment1';
'J:\4th Raw\2022-08-18_17-18-46\Record Node 142\experiment1';
'J:\4th Raw\2022-08-18_17-18-46\Record Node 142\experiment1';
'J:\4th Raw\2022-08-20_20-15-08\Record Node 148\experiment1';
'J:\4th Raw\2022-08-23_19-00-02\Record Node 153\experiment1';
'J:\4th Raw\2022-08-23_19-00-02\Record Node 153\experiment1';
'J:\4th Raw\2022-08-23_19-00-02\Record Node 153\experiment1';
'J:\4th Raw\2022-08-23_19-00-02\Record Node 153\experiment1';
'J:\4th Raw\2022-08-25_19-00-02\Record Node 118\experiment1';
'J:\4th Raw\2022-08-25_19-00-02\Record Node 118\experiment1';
'J:\4th Raw\2022-08-25_19-00-02\Record Node 118\experiment1';
}
savePath_option = {
'H:\cwt_amor_4th_data\2022-08-02_19-00-02_channel_1';
'H:\cwt_amor_4th_data\2022-08-02_19-00-02_channel_2';
'H:\cwt_amor_4th_data\2022-08-02_19-00-02_channel_3';
'H:\cwt_amor_4th_data\2022-08-02_19-00-02_channel_4';
'H:\cwt_amor_4th_data\2022-08-04_14-00-02_channel_1';
'H:\cwt_amor_4th_data\2022-08-04_14-00-02_channel_2';
'H:\cwt_amor_4th_data\2022-08-04_14-00-02_channel_3';
'H:\cwt_amor_4th_data\2022-08-04_14-00-02_channel_4';
'H:\cwt_amor_4th_data\2022-08-16_18-31-22_channel_1';
'H:\cwt_amor_4th_data\2022-08-16_18-31-22_channel_2';
'H:\cwt_amor_4th_data\2022-08-16_18-31-22_channel_3';
'H:\cwt_amor_4th_data\2022-08-16_18-31-22_channel_4';
'H:\cwt_amor_4th_data\2022-08-18_17-18-46_channel_1';
'H:\cwt_amor_4th_data\2022-08-18_17-18-46_channel_2';
'H:\cwt_amor_4th_data\2022-08-18_17-18-46_channel_3';
'H:\cwt_amor_4th_data\2022-08-20_20-15-08_channel_1';
'H:\cwt_amor_4th_data\2022-08-23_19-00-02_channel_1';
'H:\cwt_amor_4th_data\2022-08-23_19-00-02_channel_2';
'H:\cwt_amor_4th_data\2022-08-23_19-00-02_channel_3';
'H:\cwt_amor_4th_data\2022-08-23_19-00-02_channel_4';
'H:\cwt_amor_4th_data\2022-08-25_19-00-02_channel_1';
'H:\cwt_amor_4th_data\2022-08-25_19-00-02_channel_2';
'H:\cwt_amor_4th_data\2022-08-25_19-00-02_channel_4';
}
chosse_channel_option =[[1,2,7,8,9,10,15,16];
[17 18 23 24 25 26 31 32];
[33,34,39,40,41,42,47,48];
[49,50,55,56,57,58,63,64];
[1,2,7,8,9,10,15,16];
[17 18 23 24 25 26 31 32];
[33,34,39,40,41,42,47,48];
[49,50,55,56,57,58,63,64];
[1,2,7,8,9,10,15,16];
[17 18 23 24 25 26 31 32];
[33,34,39,40,41,42,47,48];
[49,50,55,56,57,58,63,64];
[1,2,7,8,9,10,15,16];
[17 18 23 24 25 26 31 32];
[33,34,39,40,41,42,47,48];
[1,2,7,8,9,10,15,16];
[1,2,7,8,9,10,15,16];
[17 18 23 24 25 26 31 32];
[33,34,39,40,41,42,47,48];
[49,50,55,56,57,58,63,64];
[1,2,7,8,9,10,15,16];
[17 18 23 24 25 26 31 32];
[33,34,39,40,41,42,47,48];


]


path =char(path_option(count));% 讀資料
savePath =char(savePath_option(count));%存路徑


mkdir(savePath);
batch_path = dir(path);
batch_path(1:2) = []
chosse_channel = [chosse_channel_option(count,:)]
replace = true;
name_correction = [1,10:19,2,20:29,3,30:39,4,40:49,5,50:59,6,60:69,7,70:79,8,80:89,9,90:99,100];
for i_file=1:length(batch_path)
    file_name=[char(path) '\' batch_path(i_file).name '\structure.oebin' ];
    file_name=char(file_name);
    %load_open_ephys_binary(file_name,'continuous',1,'mmap');
    data = EEG_tools.getRawData(file_name, chosse_channel, replace);
    data = EEG_tools.Preprocessing(data,data.Data,[0.5 300],30000,1000);
    EEG.data = data.Data(1:4,:);
    saveFileName = ['Re0'   num2str(name_correction(i_file))];
    EEG_tools.saveICAData(EEG,savePath,[saveFileName]);
end



% clearvars except- count path_option savePath_option chosse_channel_option

close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count_record  = count;

path = char(savePath_option(count));
path2 = [path '\*.mat'];
file_names = dir(path2);
filter_bandpass=[1 30];
%%
for i=1:length(file_names)
    file_name = file_names(i).name;
    mat_name = file_name(1:find(file_name == '.') - 1);
    file_name = [path '\' file_name];
    load(file_name);

    Data=EEG.data;
    %
    
    for i_ch=2
        detected_data=Data(i_ch,:);
        [wt period]=cwt(detected_data,1000,'amor');
        wt = wt(43:87,:);
    end
    file_name
    save(file_name,'EEG','wt' ,'period');
end


path = savePath;
path2 = [path '/*.mat'];
file_names = dir(path2);
filter_bandpass=[1 30];
make_dir_path_2 = [path '/fig_file_cwt'];
make_dir_path_2_png = [path '/png_file_cwt'];
mkdir(make_dir_path_2);
mkdir(make_dir_path_2_png);

for i=1:length(file_names)
    file_name = file_names(i).name;
    mat_name = file_name(1:find(file_name == '.') - 1);
    file_name = [path '/' file_name];
    load(file_name);

    
    %
     Data=EEG.data;
      detected_data=Data(i_ch,:);

    save_fig = figure;
    subplot(2,1,1);
    time=1:length(detected_data);
    time=time/1000;
    plot(time,detected_data);
    axis([0 inf -800 800]);
    set(gca,'XTick', []);
    set(gca,'YTick', []);
    subplot(2,1,2);
    clims = [0 4];
    imagesc(zscore(abs(wt),0,'all'),clims);
    yticks([1 5 11 21 44]);
    yticklabels({'20','15','10','5','1'})
    colormap jet

    colorbar

%     saveas(save_fig,[make_dir_path_2 '/' mat_name], 'fig')
    saveas(save_fig,[make_dir_path_2_png '/' mat_name], 'png')
    close all


end
end
gmail.send_mail_from_maurice_nycu('mauricewang1128@gmail.com' ,'cwt_finish'  , 'cwt_finish')
gmail.send_mail_from_maurice_nycu('a10811001.be08@nycu.edu.tw' ,'cwt_finish'  , 'cwt_finish')

catch ME

gmail.send_mail_from_maurice_nycu('mauricewang1128@gmail.com' ,'cwt_finish' , 'error_happen')
 gmail.send_mail_from_maurice_nycu('a10811001.be08@nycu.edu.tw' ,'cwt_finish' , 'error_happen')
rethrow(ME)
end