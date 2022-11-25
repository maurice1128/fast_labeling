for record_count =1:96


load(['/Users/mauricewang/Desktop/CL-DBS_4/mat_file_no_zscore/Re0' num2str(record_count) '_CL-DBS_4.mat'])
temp = EEG.Data;

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
    a = imagesc(T, F, (p.^2).*0.0002);
    ylabel('Freqency(hz)','FontSize', font_size);
    ylim([0 20]);
    ax = gca;
    ax.YDir = 'normal';
    ax.FontSize = font_size;
    caxis([0 100]);
    save_name_ = (['denoise_ecog' num2str(i)])
    saveas(savefig,fullfile('/Users/mauricewang/Desktop/test',save_name_),'fig');
    close all
    same = i;
    num = record_count;
        %save2png
    fig = fullfile('/Users/mauricewang/Desktop/test',save_name_)
    openfig(fig)
    F = getframe(gcf)
    saveas(gcf,['/Users/mauricewang/Desktop/test/Re' num2str(num) '_ECoG[' num2str(same) ']'],'png');
close(gcf);

   
end
%
%plot EMG
% for i = 1:2
%     savefig = figure;
%     subplot(2,1,1);
%     plot(t,temp(i+4,:));
%     title(char(title_EMG(i)));
%     axis([0 900 -6 6]);
%     ax =gca;
%     ax.FontSize = font_size;
%     xlabel('Time(s)','FontSize', font_size);
%     ylabel('z-score','FontSize', font_size);
%     
%     subplot(2,1,2);
%     [s,F,T,p]=spectrogram(temp(1+4,:),time_window,overlap,Fs/fre_resolution,Fs,'yaxis');
%     a = imagesc(T, F, p);
%     ylabel('Freqency(hz)','FontSize', font_size);
%     ylim([10 300]);
%     ax = gca;
%     ax.YDir = 'normal';
%     ax.FontSize = font_size;
%     caxis([0 0.001]);
%     save_name_ = (['denoise_emg' num2str(i)])
%     saveas(savefig,fullfile('/Users/mauricewang/Desktop/test',save_name_),'fig');
% 
%     close all
%     num = record_count;
%     same = i;
%     fig = fullfile('/Users/mauricewang/Desktop/test',save_name_)
%     openfig(fig);
%     F = getframe(gcf);
%     saveas(gcf,['/Users/mauricewang/Desktop/test/Re0' num2str(num) '_EMG[' num2str(same) '].png'])
%     close(gcf)
% %     hcb = colorbar;
% %     ylabel(hcb,'power/frequency(db/hz)','Fontsize',36,'Rotation',90);
% 
% end

end