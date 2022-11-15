% 0806 ver.
% seq = [3 4 5;6 7 8;7 8 9;13 14 15;17 18 19;21 22 23;26 27 28;41 42 43;45 46 47;49 50 51;57 58 59];



%要填的地方
    mouse_name = {'WT_1';'Sham_2';'CL-DBS_3'}
    save_path = ['/Users/mauricewang/Desktop/recording' ]




for count = 1: max(size(mouse_name))
    
i = 0;
record_count = 0
[filePath,folder] = EEG_tools_new.getFilePath(false,'/',  [save_path '/' char(mouse_name(count)) '/mat_file']);
window = waitbar(0,'data processing... 0%') %set progess bar windwow
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
    new_dir = [save_path '/' char(mouse_name(count)) '/fig_file']

mkdir  (new_dir)

for i = 1:4
    savefig = figure;
    subplot(2,1,1);
    plot(t,temp(i,:));
    title(char(title_ECoG(i)));
    axis([0 900 -6 6])
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
    saveas(savefig,fullfile(save_path,[char(mouse_name(count)) '/fig_file'],save_name_),'fig');
   
end
%
%plot EMG
for i = 1:2
    savefig = figure;
    subplot(2,1,1);
    plot(t,temp(i+4,:));
    title(char(title_EMG(i)));
    axis([0 900 -6 6])
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
    saveas(savefig,fullfile(save_path,[char(mouse_name(count)) '/fig_file'],save_name_),'fig');
%     hcb = colorbar;
%     ylabel(hcb,'power/frequency(db/hz)','Fontsize',36,'Rotation',90);

end
end
end



