path = '/Users/mauricewang/Desktop/test';
path2 = [path '/' '*.mat'];
file_names = dir(path2);
filter_bandpass=[1 30];
%%



for i=1%:length(file_names)
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
    subplot(2,1,1)
    time=1:length(detected_data);
    time=time/1000;
    plot(time,detected_data)
    axis([0 inf -1000 800])
    subplot(2,1,2)
    imagesc(abs(wt(45:121,:)),[0 150])
    yticks([1 5 11 21 44 77])
    yticklabels({'20','15','10','5','1','0.1'})
    colormap jet
end