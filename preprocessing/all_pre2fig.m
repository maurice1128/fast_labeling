%%%
% 1. set the saving path
% 2.
%% preprocess   
close all
clc
clear all

error = [];
replace = true;




%要填的地方
total_mouse = 3
mouse_name = {'CL-DBS_1','WT_3','CL-DBS_4'}
%recording前一個資料夾
savePath = '/Users/mauricewang/Desktop/test' 


%設定channel數
chosse_channel = {[1,2,7,8,9,10,15,16];[17 18 23 24 25 26 31 32];[33,34,39,40,41,42,47,48];[49,50,55,56,57,58,63,64]};


%create mat file


for i = 1:total_mouse
make_dir = [savePath  '/' char(mouse_name(i)) '/mat_file_zscore'    ];
mkdir(make_dir);

make_dir = [savePath  '/' char(mouse_name(i)) '/mat_file_no_muscle_substract_zscore'    ];
mkdir(make_dir);


make_dir = [savePath  '/' char(mouse_name(i)) '/mat_file_no_zscore'    ];
mkdir(make_dir);

make_dir = [savePath  '/' char(mouse_name(i)) '/mat_file_no_muscle_substract_no_zscore'    ];
mkdir(make_dir);

dir_4png = [savePath '/' char(mouse_name(i)) '/png_all'];
    mkdir(dir_4png);
    dir_4png = [savePath '/' char(mouse_name(i)) '/png_all/png_zscore'];
    mkdir(dir_4png);
    dir_4png = [savePath '/' char(mouse_name(i)) '/png_all/png_no_zscore'];
    mkdir(dir_4png);
dir_4png = [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_zscore'];
     mkdir(dir_4png)      ;
     dir_4png = [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_no_zscore'];
     mkdir(dir_4png);

    dir_4png = [savePath '/' char(mouse_name(i)) '/png_combine'];
    mkdir(dir_4png);

    dir_4png = [savePath '/' char(mouse_name(i)) '/png_contrast'];
    mkdir(dir_4png);

end



[filePath,~] = EEG_tools_new.getFilePath(true,'/',savePath);
i=1;

i = 0

for Path = filePath
    
   
    for k = 1:total_mouse %mouse_name 
        Path = char(Path);
        data = EEG_tools_new.getRawData(Path, cell2mat(chosse_channel(k)), replace);
        data_raw = data;
%         data = EEG_tools_new.Preprocessing(data,data.Data,[0.5,30],[10 300],data.Header.sample_rate,1000); 
        data = EEG_tools_new.detrend(data, data.Data);
        data = EEG_tools_new.reduce_mean(data, data.Data);
       data = EEG_tools_new.notch60(data, data.Data);
         data = EEG_tools_new.bandpass(data, data.Data,[0.5,30],[10 300], data.Header.sample_rate);
        data = EEG_tools_new.down_sample(data, data.Data, 1000);
        saveFileName = ['Re0' num2str(i+1) '_'  char(mouse_name(k)) ];
         EEG = data
        EEG_tools_new.saveICAData(EEG,[savePath '/' char(mouse_name(k)) '/' 'mat_file_no_muscle_substract_zscore'],saveFileName);
        EEG_tools_new.saveICAData(EEG,[savePath '/' char(mouse_name(k)) '/' 'mat_file_no_muscle_substract_no_zscore'],saveFileName);
        data.Data(5,:)=data.Data(5,:)-data.Data(6,:);
        data.Data(6,:)=data.Data(7,:)-data.Data(8,:);
        data.Data(7,:)=[];
        data.Data(7,:) = [];

        

         EEG = data;

        

       
        saveFileName = ['Re0' num2str(i+1) '_'  char(mouse_name(k)) ];
        
        EEG_tools_new.saveICAData(EEG,[savePath '/' char(mouse_name(k)) '/' 'mat_file_zscore'],saveFileName);
        EEG_tools_new.saveICAData(EEG,[savePath '/' char(mouse_name(k)) '/' 'mat_file_no_zscore'],saveFileName);
        
        

    end
    str = ['data processing...',num2str((i/length(filePath))*100),'%'];
    
    
    i = i+1;
end
delete(window);

recording_count = i;


%%zscore處理正常
% z-score
for k = 1:total_mouse
zscore_temp = [];
zscore_count = [0];
temp = dir([savePath '/' char(mouse_name(k)) '/mat_file_zscore']);
temp = natsortfiles(temp);

%將時間串起來
    for i = 1:recording_count
        
            
                load([char(temp(i).folder) '/' 'Re0' num2str(i) '_'  char(mouse_name(k))]);
                zscore_temp = [zscore_temp,EEG.Data];
                zscore_count = [zscore_count,zscore_count(i)+max(size(EEG.Data))];
    
    end




%將數據zscore
    for i = 1:recording_count

        for m = 1:size(EEG.Data,1)
        
            zscore_temp(m,:) = zscore(zscore_temp(m,:));

         
        end
        EEG.Data = zscore_temp (:,zscore_count(i)+1:zscore_count(i+1));
        saveFileName = ['Re0' num2str(i) '_'  char(mouse_name(k))  ];
        
        EEG_tools_new.saveICAData(EEG, [savePath '/' char(mouse_name(k)) '/' 'mat_file_zscore'],saveFileName);
    end



end

%%zscore 處理muscle substract-zscore
% z-score
for k = 1:total_mouse
zscore_temp = [];
zscore_count = [0];
temp = dir([savePath '/' char(mouse_name(k)) '/mat_file_no_muscle_substract_zscore']);
temp = natsortfiles(temp);

%將時間串起來
    for i = 1:recording_count
        
            
                load([char(temp(i).folder) '/' 'Re0' num2str(i) '_'  char(mouse_name(k))]);
                zscore_temp = [zscore_temp,EEG.Data];
                zscore_count = [zscore_count,zscore_count(i)+max(size(EEG.Data))];
    
    end




%將數據zscore
    for i = 1:recording_count

        for m = 1:size(EEG.Data,1)
        
            zscore_temp(m,:) = zscore(zscore_temp(m,:));

         
        end
        EEG.Data = zscore_temp (:,zscore_count(i)+1:zscore_count(i+1));
        saveFileName = ['Re0' num2str(i) '_'  char(mouse_name(k))  ];
        
        EEG_tools_new.saveICAData(EEG, [savePath '/' char(mouse_name(k)) '/' 'mat_file_no_muscle_substract_zscore'],saveFileName);
    end



end




clear zscore_temp;



    





%%%%%%畫正常的fig
    
    save_path = savePath;

    



for count = 1: max(size(mouse_name))
    
i = 0;
record_count = 0;
[filePath,folder] = EEG_tools_new.getFilePath(false,'/',  [save_path '/' char(mouse_name(count)) '/mat_file_zscore']);

for Path = filePath
    record_count  = record_count+1   ;

    %% parameter
    Path = char(Path);
    load(Path);
    
    temp = EEG.Data;
    time = length(temp(1,:)) * (1/1000);
    t=linspace(0,time,length(temp(1,:)));
    fre_resolution = 0.5; 
    time_window = 1000;
    overlap = 950;
    Fs = 1000;%sample rate
    save_name = num2str(i);
    font_size = 12;
    
    title_ECoG = {'ch17 left parietal ica','ch18 left frontal ica','ch23 right frontal ica','ch24 right parietal ica'};
    title_EMG = {'ch9 MA2','ch10 MA1','ch15 MB1','ch16 MB2'};
    new_dir = [save_path '/' char(mouse_name(count)) '/fig_file_zscore'];

mkdir  (new_dir);

for i = 1:4
    savefig = figure;
    subplot(2,1,1);
    plot(t,temp(i,:));
    title(char(title_ECoG(i)));
    axis([0 900 -6 6]);
    ax =gca;
    ax.FontSize = font_size;
    xlabel('Time(s)','FontSize', font_size);
    ylabel('z-score','FontSize', font_size);
    
    subplot(2,1,2);
    [s,F,T,p]=spectrogram(temp(1,:),time_window,overlap,Fs/fre_resolution,Fs,'yaxis');
    a = imagesc(T, F, p);
    ylabel('Freqency(hz)','FontSize', font_size);
    ylim([0 20]);
    ax = gca;
    ax.YDir = 'normal';
    ax.FontSize = font_size;
    caxis([0 0.001]);
    save_name_ = ['Re' num2str(record_count) '_ECoG[' num2str(i) ']_' char(mouse_name(count)) ];
    saveas(savefig,fullfile(save_path,[char(mouse_name(count)) '/fig_file_zscore'],save_name_),'fig');
    close all
    same = i;
    num = record_count;
        %save2png
    fig = ([savePath '/' char(mouse_name(count)) '/fig_file_zscore/Re' num2str(num) '_ECoG[' num2str(same) ']_' char(mouse_name(count))]);
    openfig(fig)
    F = getframe(gcf)
    saveas(gcf,[savePath '/' char(mouse_name(count)) '/png_all/png_zscore/Re' num2str(num) '_ECoG[' num2str(same) ']'],'png');
close(gcf);

   
end
%
%plot EMG
for i = 1:2
    savefig = figure;
    subplot(2,1,1);
    plot(t,temp(i+4,:));
    title(char(title_EMG(i)));
    axis([0 900 -6 6]);
    ax =gca;
    ax.FontSize = font_size;
    xlabel('Time(s)','FontSize', font_size);
    ylabel('z-score','FontSize', font_size);
    
    subplot(2,1,2);
    [s,F,T,p]=spectrogram(temp(1+4,:),time_window,overlap,Fs/fre_resolution,Fs,'yaxis');
    a = imagesc(T, F, p);
    ylabel('Freqency(hz)','FontSize', font_size);
    ylim([10 300]);
    ax = gca;
    ax.YDir = 'normal';
    ax.FontSize = font_size;
    caxis([0 0.001]);
    save_name_ = ['Re' num2str(record_count) '_EMG[' num2str(i) ']_' char(mouse_name(count)) ];
    saveas(savefig,fullfile(save_path,[char(mouse_name(count)) '/fig_file_zscore'],save_name_),'fig');

    close all
    num = record_count;
    same = i;
    fig = ([savePath '/' char(mouse_name(count)) '/fig_file_zscore/Re' num2str(num) '_EMG[' num2str(same) ']_' char(mouse_name(count))])
    openfig(fig);
    F = getframe(gcf);
    saveas(gcf,[savePath '/' char(mouse_name(count)) '/png_all/png_zscore/Re0' num2str(num) '_EMG[' num2str(same) '].png'])
    close(gcf)
%     hcb = colorbar;
%     ylabel(hcb,'power/frequency(db/hz)','Fontsize',36,'Rotation',90);

end
end
end


%%%%%%畫no_zscore的fig
    
    save_path = savePath




for count = 1: max(size(mouse_name))
    
i = 0;
record_count = 0;
[filePath,folder] = EEG_tools_new.getFilePath(false,'/',  [save_path '/' char(mouse_name(count)) '/mat_file_no_zscore']);

for Path = filePath
    record_count  = record_count+1   

    %% parameter
    Path = char(Path);
    load(Path);
    
    temp = EEG.Data;
    time = length(temp(1,:)) * (1/1000);
    t=linspace(0,time,length(temp(1,:)));
    fre_resolution = 0.5; 
    time_window = 1000;
    overlap = 950;
    Fs = 1000;%sample rate
    save_name = num2str(i);
    font_size = 12;
    
    title_ECoG = {'ch17 left parietal ica','ch18 left frontal ica','ch23 right frontal ica','ch24 right parietal ica'};
    title_EMG = {'ch9 MA2','ch10 MA1','ch15 MB1','ch16 MB2'};
    new_dir = [save_path '/' char(mouse_name(count)) '/fig_file_no_zscore'];

mkdir  (new_dir)

for i = 1:4
    savefig = figure;
    subplot(2,1,1);
    plot(t,temp(i,:));
    title(char(title_ECoG(i)));
    axis([0 900 -1000 1000]);
    ax =gca;
    ax.FontSize = font_size;
    xlabel('Time(s)','FontSize', font_size);
    ylabel('z-score','FontSize', font_size);
    
    subplot(2,1,2);
    [s,F,T,p]=spectrogram(temp(1,:),time_window,overlap,Fs/fre_resolution,Fs,'yaxis');
    a = imagesc(T, F, p);
    ylabel('Freqency(hz)','FontSize', font_size);
    ylim([0 20]);
    ax = gca;
    ax.YDir = 'normal';
    ax.FontSize = font_size;
    caxis([0 50]);
    save_name_ = ['Re' num2str(record_count) '_ECoG[' num2str(i) ']_' char(mouse_name(count)) ]


    same = i;
    saveas(savefig,fullfile(save_path,[char(mouse_name(count)) '/fig_file_no_zscore'],save_name_),'fig');
    fig = ([savePath '/' char(mouse_name(count)) '/fig_file_no_zscore/Re' num2str(record_count) '_ECoG[' num2str(same) ']_' char(mouse_name(count))])
    
    openfig(fig);
    F = getframe(gcf)
    
    saveas(gcf,[savePath '/' char(mouse_name(count)) '/png_all/png_no_zscore/Re' num2str(record_count) '_ECoG[' num2str(same) '].png']);
close(gcf)
fig = [fig '.fig'];
 delete (fig)  ;
 
 close all
end
%
%plot EMG
for i = 1:2
    savefig = figure;
    subplot(2,1,1);
    plot(t,temp(i+4,:));
    title(char(title_EMG(i)));
    axis([0 900 -1000 1000]);
    ax =gca;
    ax.FontSize = font_size;
    xlabel('Time(s)','FontSize', font_size);
    ylabel('z-score','FontSize', font_size);
    
    subplot(2,1,2);
    [s,F,T,p]=spectrogram(temp(1+4,:),time_window,overlap,Fs/fre_resolution,Fs,'yaxis');
    a = imagesc(T, F, p);
    ylabel('Freqency(hz)','FontSize', font_size);
    ylim([10 300]);
    ax = gca;
    ax.YDir = 'normal';
    ax.FontSize = font_size;
    caxis([0 50]);
    save_name_ = ['Re' num2str(record_count) '_EMG[' num2str(i) ']_' char(mouse_name(count)) ];
    saveas(savefig,fullfile(save_path,[char(mouse_name(count)) '/fig_file_no_zscore'],save_name_),'fig');
    close all
    same = i;
    num = record_count;
    fig = ([savePath '/' char(mouse_name(count)) '/fig_file_no_zscore/Re' num2str(num) '_EMG[' num2str(same) ']_' char(mouse_name(count))]);
    openfig(fig);
    F = getframe(gcf)
    saveas(gcf,[savePath '/' char(mouse_name(count)) '/png_all/png_no_zscore/Re0' num2str(num) '_EMG[' num2str(same) '].png']);
close(gcf)
fig = [fig '.fig'];
 delete (fig)  ;
end
%     hcb = colorbar;
%     ylabel(hcb,'power/frequency(db/hz)','Fontsize',36,'Rotation',90);

end
end









%%%%%%畫no_muscle_substract_zscore的fig
    
    save_path = savePath




for count = 1: max(size(mouse_name))
    
i = 0;
record_count = 0
[filePath,folder] = EEG_tools_new.getFilePath(false,'/',  [save_path '/' char(mouse_name(count)) '/mat_file_no_muscle_substract_zscore']);

for Path = filePath
    record_count  = record_count+1   ;

    %% parameter
    Path = char(Path);
    load(Path);
    
    temp = EEG.Data;
    time = length(temp(1,:)) * (1/1000);
    t=linspace(0,time,length(temp(1,:)));
    fre_resolution = 0.5; 
    time_window = 1000;
    overlap = 950;
    Fs = 1000;%sample rate
    save_name = num2str(i);
    font_size = 12;
    
    title_ECoG = {'ch17 left parietal ica','ch18 left frontal ica','ch23 right frontal ica','ch24 right parietal ica'};
    title_EMG = {'ch9 MA2','ch10 MA1','ch15 MB1','ch16 MB2'};
    new_dir = [save_path '/' char(mouse_name(count)) '/fig_file_no_muscle_substract_zscore'];

mkdir  (new_dir);

for i = 1:4
    savefig = figure;
    subplot(2,1,1);
    plot(t,temp(i,:));
    title(char(title_ECoG(i)));
    axis([0 900 -6 6]);
    ax =gca;
    ax.FontSize = font_size;
    xlabel('Time(s)','FontSize', font_size);
    ylabel('z-score','FontSize', font_size);
    
    subplot(2,1,2);
    [s,F,T,p]=spectrogram(temp(1,:),time_window,overlap,Fs/fre_resolution,Fs,'yaxis');
    a = imagesc(T, F, p);
    ylabel('Freqency(hz)','FontSize', font_size);
    ylim([0 20]);
    ax = gca;
    ax.YDir = 'normal';
    ax.FontSize = font_size;
    caxis([0 0.001]);
    save_name_ = ['Re' num2str(record_count) '_ECoG[' num2str(i) ']_' char(mouse_name(count)) ];
    saveas(savefig,fullfile(save_path,[char(mouse_name(count)) '/fig_file_no_muscle_substract_zscore'],save_name_),'fig');
    close all
    same = i;
    num = record_count;
    fig = ([savePath '/' char(mouse_name(count)) '/fig_file_no_muscle_substract_zscore/Re' num2str(num) '_ECoG[' num2str(same) ']_' char(mouse_name(count))]);
    openfig(fig);
    F = getframe(gcf)
    saveas(gcf,[savePath '/' char(mouse_name(count)) '/png_all/png_no_muscle_substract_zscore/Re' num2str(num) '_ECoG[' num2str(same) '].png'])
close(gcf)
fig = [fig '.fig'];
 delete (fig)  ;
end
%
%plot EMG
for i = 1:4
    savefig = figure;
    subplot(2,1,1);
    plot(t,temp(i+4,:));
    title(char(title_EMG(i)));
    axis([0 900 -6 6]);
    ax =gca;
    ax.FontSize = font_size;
    xlabel('Time(s)','FontSize', font_size);
    ylabel('z-score','FontSize', font_size);
    
    subplot(2,1,2);
    [s,F,T,p]=spectrogram(temp(1+4,:),time_window,overlap,Fs/fre_resolution,Fs,'yaxis');
    a = imagesc(T, F, p);
    ylabel('Freqency(hz)','FontSize', font_size);
    ylim([10 300]);
    ax = gca;
    ax.YDir = 'normal';
    ax.FontSize = font_size;
    caxis([0 0.001]);
    save_name_ = ['Re' num2str(record_count) '_EMG[' num2str(i) ']_' char(mouse_name(count)) ];
    saveas(savefig,fullfile(save_path,[char(mouse_name(count)) '/fig_file_no_muscle_substract_zscore'],save_name_),'fig');
close all
    same = i;
    num = record_count;
    fig = ([savePath '/' char(mouse_name(count)) '/fig_file_no_muscle_substract_zscore/Re' num2str(num) '_EMG[' num2str(same) ']_' char(mouse_name(count))])
    openfig(fig);
     F = getframe(gcf)
     saveas(gcf,[savePath '/' char(mouse_name(count)) '/png_all/png_no_muscle_substract_zscore/Re' num2str(num) '_EMG[' num2str(same) '].png']);
 close(gcf)
 fig = [fig '.fig'];
 delete (fig)  ;
%     hcb = colorbar;
%     ylabel(hcb,'power/frequency(db/hz)','Fontsize',36,'Rotation',90);

end
end
end


%%%%%%畫no_muscle_substract_no_zscore的fig
    
    save_path = savePath




for count = 1:max(size(mouse_name)) 
    
i = 0;
record_count = 0
[filePath,folder] = EEG_tools_new.getFilePath(false,'/',  [save_path '/' char(mouse_name(count)) '/mat_file_no_muscle_substract_no_zscore']);

for Path = filePath
    record_count  = record_count+1   

    %% parameter
    Path = char(Path);
    load(Path);
    
    temp = EEG.Data;
    time = length(temp(1,:)) * (1/1000);
    t=linspace(0,time,length(temp(1,:)));
    fre_resolution = 0.5; 
    time_window = 1000;
    overlap = 950;
    Fs = 1000;%sample rate
    save_name = num2str(i);
    font_size = 12;
    
    title_ECoG = {'ch17 left parietal ica','ch18 left frontal ica','ch23 right frontal ica','ch24 right parietal ica'};
    title_EMG = {'ch9 MA2','ch10 MA1','ch15 MB1','ch16 MB2'};
    new_dir = [save_path '/' char(mouse_name(count)) '/fig_file_no_muscle_substract_no_zscore']

mkdir  (new_dir)

for i = 1:4
    savefig = figure;
    subplot(2,1,1);
    plot(t,temp(i,:));
    title(char(title_ECoG(i)));
    axis([0 900 -1000 1000])
    ax =gca;
    ax.FontSize = font_size;
    xlabel('Time(s)','FontSize', font_size);
    ylabel('z-score','FontSize', font_size);
    
    subplot(2,1,2);
    [s,F,T,p]=spectrogram(temp(1,:),time_window,overlap,Fs/fre_resolution,Fs,'yaxis');
    a = imagesc(T, F, p);
    ylabel('Freqency(hz)','FontSize', font_size);
    ylim([0 20]);
    ax = gca;
    ax.YDir = 'normal';
    ax.FontSize = font_size;
    caxis([0 50]);
    save_name_ = ['Re' num2str(record_count) '_ECoG[' num2str(i) ']_' char(mouse_name(count)) ];
    saveas(savefig,fullfile(save_path,[char(mouse_name(count)) '/fig_file_no_muscle_substract_no_zscore'],save_name_),'fig');
   close all
    same = i
   num = record_count
     fig = ([savePath '/' char(mouse_name(count)) '/fig_file_no_muscle_substract_no_zscore/Re' num2str(num) '_ECoG[' num2str(same) ']_' char(mouse_name(count))])
    openfig(fig);
    F = getframe(gcf)
    saveas(gcf,[savePath '/' char(mouse_name(count)) '/png_all/png_no_muscle_substract_no_zscore/Re' num2str(num) '_ECoG[' num2str(same) '].png'])
close(gcf)
fig = [fig '.fig'];
 delete (fig)  ;
end
%
%plot EMG
for i = 1:4
    savefig = figure;
    subplot(2,1,1);
    plot(t,temp(i+4,:));
    title(char(title_EMG(i)));
    axis([0 900 -1000 1000])
    ax =gca;
    ax.FontSize = font_size;
    xlabel('Time(s)','FontSize', font_size);
    ylabel('z-score','FontSize', font_size);
    
    subplot(2,1,2);
    [s,F,T,p]=spectrogram(temp(1+4,:),time_window,overlap,Fs/fre_resolution,Fs,'yaxis');
    a = imagesc(T, F, p);
    ylabel('Freqency(hz)','FontSize', font_size);
    ylim([10 300]);
    ax = gca;
    ax.YDir = 'normal';
    ax.FontSize = font_size;
    caxis([0 50]);
    save_name_ = ['Re' num2str(record_count) '_EMG[' num2str(i) ']_' char(mouse_name(count)) ];
    saveas(savefig,fullfile(save_path,[char(mouse_name(count)) '/fig_file_no_muscle_substract_no_zscore'],save_name_),'fig');
    close all
    same = i
    num = record_count
      fig = ([savePath '/' char(mouse_name(count)) '/fig_file_no_muscle_substract_no_zscore/Re' num2str(num) '_EMG[' num2str(same) ']_' char(mouse_name(count))])
     openfig(fig);
     F = getframe(gcf);
     saveas(gcf,[savePath '/' char(mouse_name(count)) '/png_all/png_no_muscle_substract_no_zscore/Re0' num2str(num) '_EMG[' num2str(same) '].png'])
close(gcf)
fig = [fig '.fig'];
 delete (fig)  ;
%     hcb = colorbar;
%     ylabel(hcb,'power/frequency(db/hz)','Fontsize',36,'Rotation',90);

end
end
end

close all


%fig2png
range =  1 : recording_count




for i = 1: total_mouse
    for num = range
    %draw contrast    
combine_contrast = {
    [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re' num2str(num) '_ECoG[' num2str(1) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re' num2str(num) '_ECoG[' num2str(2) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re' num2str(num) '_ECoG[' num2str(3) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re' num2str(num) '_ECoG[' num2str(4) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re0' num2str(num) '_EMG[' num2str(1) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re0' num2str(num) '_EMG[' num2str(2) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re0' num2str(num) '_EMG[' num2str(1) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re0' num2str(num) '_EMG[' num2str(2) '].png'],


    [savePath '/' char(mouse_name(i)) '/png_all/png_no_zscore/Re' num2str(num) '_ECoG[' num2str(1) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_zscore/Re' num2str(num) '_ECoG[' num2str(2) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_zscore/Re' num2str(num) '_ECoG[' num2str(3) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_zscore/Re' num2str(num) '_ECoG[' num2str(4) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_zscore/Re0' num2str(num) '_EMG[' num2str(1) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_zscore/Re0' num2str(num) '_EMG[' num2str(2) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_zscore/Re0' num2str(num) '_EMG[' num2str(1) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_zscore/Re0' num2str(num) '_EMG[' num2str(2) '].png'],
    

     [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_zscore/Re' num2str(num) '_ECoG[' num2str(1) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_zscore/Re' num2str(num) '_ECoG[' num2str(2) '].png'],
     [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_zscore/Re' num2str(num) '_ECoG[' num2str(3) '].png'],
     [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_zscore/Re' num2str(num) '_ECoG[' num2str(4) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_zscore/Re' num2str(num) '_EMG[' num2str(1) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_zscore/Re' num2str(num) '_EMG[' num2str(2) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_zscore/Re' num2str(num) '_EMG[' num2str(3) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_zscore/Re' num2str(num) '_EMG[' num2str(4) '].png'],




    [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_no_zscore/Re' num2str(num) '_ECoG[' num2str(1) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_no_zscore/Re' num2str(num) '_ECoG[' num2str(2) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_no_zscore/Re' num2str(num) '_ECoG[' num2str(3) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_no_zscore/Re' num2str(num) '_ECoG[' num2str(4) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_no_zscore/Re0' num2str(num) '_EMG[' num2str(1) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_no_zscore/Re0' num2str(num) '_EMG[' num2str(2) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_no_zscore/Re0' num2str(num) '_EMG[' num2str(3) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_no_muscle_substract_no_zscore/Re0' num2str(num) '_EMG[' num2str(4) '].png'],
    }

            out = imtile(combine_contrast,'GridSize', [4,8]);

            imwrite(out,[savePath '/' char(mouse_name(i)) '/png_contrast/Re' num2str(num) '.png']);


   combine_combine = { [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re' num2str(num) '_ECoG[' num2str(1) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re' num2str(num) '_ECoG[' num2str(2) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re' num2str(num) '_ECoG[' num2str(3) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re' num2str(num) '_ECoG[' num2str(4) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re0' num2str(num) '_EMG[' num2str(1) '].png'],
    [savePath '/' char(mouse_name(i)) '/png_all/png_zscore/Re0' num2str(num) '_EMG[' num2str(2) '].png']
    }

    out = imtile(combine_combine,'GridSize', [3,2]);
if num < 10
            imwrite(out,[savePath '/' char(mouse_name(i)) '/png_combine/Re0' num2str(num) '.png']);

else
    imwrite(out,[savePath '/' char(mouse_name(i)) '/png_combine/Re' num2str(num) '.png']);
end


    end  
end





