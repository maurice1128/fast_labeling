close all
clc
clear all
%%%要填的地方
run_main_path = '/Users/mauricewang/Desktop/Ecog_lab/code/cwd_code/run_main.mat'
path_big_folder = '/Users/mauricewang/Desktop/test'


try

%%%用名字的長度去確定是不是空的資料夾
path_option = dir([path_big_folder '/' ])

for i = 1:5
if  max(size(path_option(1).name))<=10
   
    path_option(1) = []
end
end

%%%開始跑
for mouse = 1 : length(path_option)


path = [path_option(mouse).folder '/' path_option(mouse).name ];
path2 = [path '/*.mat'];
file_names = dir(path2);
filter_bandpass=[1 30];
load(run_main_path)
make_dir_path = [path '_corrected']
mkdir(make_dir_path)
%%
for i=1:length(file_names)
     real_name=batch_path(i).name;
     real_name_index=real_name(10:length(real_name));
     %
     file_name = file_names(i).name;
     mat_name = file_name(1:find(file_name == '.') - 1);
     file_name = [path '/' file_name];
     load(file_name)
     %
     %%%%%%%%%%%修改區
     save_name= [make_dir_path '/Re0' num2str(i) '.mat']
     save(save_name,'EEG','period','all_power_1_5','all_power_3_5','all_power_5_10','all_power_5_20','all_power_7_20')
end

end



path_option = dir([path_big_folder '/*corrected'])


for mouse = 1 : length(path_option)



path = [path_option(mouse).folder '/' path_option(mouse).name ];
path2 = [path '/*.mat'];
file_names = dir(path2);
filter_bandpass=[1 30];
make_dir_path_2 = [path '/fig_file_cwt']
make_dir_path_2_png = [path '/png_file_cwt']
mkdir(make_dir_path_2)
mkdir(make_dir_path_2_png)
%%
for i=1:length(file_names)
    file_name = file_names(i).name;
    mat_name = file_name(1:find(file_name == '.') - 1);
    file_name = [path '/' file_name];
    load(file_name)

    Data=EEG.data;
    %
    for i_ch=2%:4
        bandpass_default = designfilt('bandpassiir', 'FilterOrder',4, ...
                'PassbandFrequency1', filter_bandpass(1), ...
                'PassbandFrequency2', filter_bandpass(2), ...
                'SampleRate', 1000);
        detected_data=Data(i_ch,:);
        detected_data=filtfilt(bandpass_default, detected_data);
        [wt period]=cwt(detected_data,1000);
    end


    save_fig = figure
    subplot(2,1,1)
    time=1:length(detected_data);
    time=time/1000;
    plot(time,detected_data)
    axis([0 inf -800 800])
    set(gca,'XTick', []);
    set(gca,'YTick', []);
    subplot(2,1,2)
    imagesc(abs(wt(45:88,:)))
    yticks([1 5 11 21 44])
    yticklabels({'20','15','10','5','1'})
    colormap jet

%     saveas(save_fig,[make_dir_path_2 '/' mat_name], 'fig')
    saveas(save_fig,[make_dir_path_2_png '/' mat_name], 'png')
    close all


end
end


gmail.send_mail_from_maurice_nycu('mauricewang1128@gmail.com','cwt_rename&fig_success','yeah~~~~~~')



catch ME
    
    gmail.send_mail_from_maurice_nycu('mauricewang1128@gmail.com','cwt_rename&fig_error','why~~~~~~')
rethrow(ME)
end
