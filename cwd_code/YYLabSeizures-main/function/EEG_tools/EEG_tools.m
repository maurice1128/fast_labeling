%%08/28 ver. (check path, get filepath)
% created by HC
% 
classdef EEG_tools
    % NTK Lab preprocessing  version1
    % by Skull20220517 and HC20220628 
    
    properties

    end
    
    methods (Static)
        %% get_file_path
        function [fileDir,fileList] = getFilePath(raw,op)
            %check directionary+1
            path_list_cell = regexp(path,pathsep,'Split');
            if ~any(ismember([pwd op 'supporting_headfile'],path_list_cell))
                addpath(genpath('supporting_headfile'));
            end
            %
            if raw == true
                folder = uigetdir();
                fileList = dir(fullfile(folder,'recording*'));
                fileList = natsortfiles(fileList);
                fileDir = [];
                for i = 1:length(fileList)
                    fileDir{end+1} = [fileList(i).folder op fileList(i).name  op 'structure.oebin'];
                end
                
            else
                folder = uigetdir();
                fileList = dir(fullfile(folder,'*.mat'));
                fileList = natsortfiles(fileList);
                fileDir = [];
                for i = 1:length(fileList)
                    fileDir{end+1} = [fileList(i).folder op fileList(i).name];
                end
                
            end
        end
        %% get_data
        function data = getRawData(file_path, channel, replace)
            %check directionary+1
            path_list_cell = regexp(path,pathsep,'Split');
            if ~any(ismember([pwd '/supporting_headfile'],path_list_cell))
                addpath(genpath('/supporting_headfile'));
            end
            % load data by path
            signal_name = ['data = load_open_ephys_binary(''' , file_path , ''',' '''continuous''' ',1);'];
            eval(signal_name);
            data.Data = data.Data(channel,:);
            bit = data.Header.channels.bit_volts;
            data.Data = data.Data * bit;
            data.replace = replace;
        end

        %% detrend
        function data = detrend(data, input)
            % y=detrend(data);%channel x N
            if data.replace == true
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; detrend(input(i, :))];
                end
                data.Data = register;
%                 data.Data = detrend(input);
            else
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; detrend(input(i, :))];
                end
                data.Detrend = detrend(input);
            end
        end
    
        %% reduce mean
        function data = reduce_mean(data, input)
            if data.replace == true
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; input(i, :)-mean(input(i, :))];
                end
                data.Data = register;
            else
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; input(i, :)-mean(input(i, :))];
                end
                data.Detrend = detrend(input);
            end
        end
        %% notch filter
        function data = notch60(data, input)
            notch_default = designfilt('bandstopiir','FilterOrder',4, ...
                'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
                'DesignMethod','butter','SampleRate',data.Header.sample_rate);
            if data.replace == true
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; filtfilt(notch_default, input(i, :))];
                end
                data.Data = register;
                
            else
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; filtfilt(notch_default, input(i, :))];
                end
                data.Notch = register;
            end
        end

        %% bandpass filter
        function data = bandpass(data, input,freq_band, sample_rate)
            bandpass_default = designfilt('bandpassiir', 'FilterOrder',4, ...
                'PassbandFrequency1', freq_band(1), ...
                'PassbandFrequency2', freq_band(2), ...
                'SampleRate', sample_rate);
            if data.replace == true
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; filtfilt(bandpass_default, input(i, :))];
                end
                data.Data = register;
            else
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; filtfilt(bandpass_default, input(i, :))];
                end
                data.Data = register;
                data.Bandpass = register;
            end
        end

        %% downsample
        function data = down_sample(data, input, fs_down)
            skip = data.Header.sample_rate/fs_down;
            if data.replace ==true
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; downsample(input(i, :), skip)];
                end
                data.Data = register;
%                 data.Timestamps = downsample(data.Timestamps, skip);
            else
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; downsample(input(i, :), skip)];
                end
                data.downsample = register;
%                 data.Timestamps = downsample(data.Timestamps, skip);
            end
        end

        %% preprocessing
        function data = Preprocessing(data, input, freq_band, sample_rate, fs_down)
            data = EEG_tools.detrend(data, input);
            data = EEG_tools.reduce_mean(data, input);
            data = EEG_tools.notch60(data, input);
            data = EEG_tools.bandpass(data, input,freq_band, sample_rate);
            data = EEG_tools.down_sample(data, input, fs_down);
        end
        %% Zscore
        function data = Z_score(data, input)
            if data.replace ==true
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; zscore(input(i, :))];
                end
                data.Data = register;            
            else
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; zscore(input(i, :))];
                end
                data.zscore = register;
            end
        end
        
        %% “BurstCriterion”標準消除訊號突發的偏差截止值為 20，刪除 motion artifact
        % 'BurstCriterion' standard deviation cutoff for removal of bursts is 20 for more aggressive without
        function EEG = motion_artifact(data,sample_rate)
            EEG.etc.eeglabvers = '2022.0'; % this tracks which version of EEGLAB is being used, you may ignore it
            EEG = pop_importdata('dataformat','array','nbchan',0,'data',data,'setname','data','srate',sample_rate,'pnts',0,'xmin',0);
            EEG = eeg_checkset( EEG );
            EEG = pop_reref( EEG, []);
            EEG = eeg_checkset( EEG );
            EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion','off','WindowCriterion',0.25,'BurstRejection','off','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
            EEG = eeg_checkset( EEG );
        end
        
        %% ICA
%         function [EEG,error] = ICA(error,data,brain_graph_filename,i)
% %             try
%                 EEG.etc.eeglabvers = '2022.0'; % this tracks which version of EEGLAB is being used, you may ignore it
%                 EEG = pop_importdata('dataformat','array','nbchan',0,'data',data,'setname','data','srate',1000,'pnts',0,'xmin',0);
%                 EEG = eeg_checkset( EEG );
%                 EEG = pop_reref( EEG, []);
%                 EEG = eeg_checkset( EEG );
%                 EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1);
%                 EEG = eeg_checkset( EEG );
%                 EEG = pop_chanedit(EEG, 'lookup','standard_1005.elc','load',{brain_graph_filename,'filetype','autodetect'});
%                 EEG = eeg_checkset( EEG );
%                 EEG = pop_iclabel(EEG, 'default');
%                 EEG = eeg_checkset( EEG );
%                 EEG.class_label=EEG.etc.ic_classification.ICLabel.classes;
%                 EEG.class_prob=EEG.etc.ic_classification.ICLabel.classifications;
% %             catch
% %                 error = [error i];
% %             end
%         end
        function [EEG] = ICA(data,brain_graph_filename)
%             try
                EEG.etc.eeglabvers = '2022.0'; % this tracks which version of EEGLAB is being used, you may ignore it
                EEG = pop_importdata('dataformat','array','nbchan',0,'data',data,'setname','data','srate',1000,'pnts',0,'xmin',0);
                EEG = eeg_checkset( EEG );
                EEG = pop_reref( EEG, []);
                EEG = eeg_checkset( EEG );
                [a, b]=runica(data);
                EEG.icaweights = a;
                EEG.icasphere = b;
                EEG.icawinv = pinv( EEG.icaweights*EEG.icasphere);
                EEG.chansind = 1:size(data,1);
                EEG = pop_chanedit(EEG, 'lookup',brain_graph_filename,'load',{brain_graph_filename,'filetype','autodetect'});
                EEG = eeg_checkset( EEG );
                EEG = pop_iclabel(EEG, 'default');
                EEG.class_label=EEG.etc.ic_classification.ICLabel.classes;
                EEG.class_prob=EEG.etc.ic_classification.ICLabel.classifications;

%             catch
%                 error = [error i];
%             end
        end
        
        

        function [EEG1,EEG2,error] = ICA2(error,data,brain_graph_filename,i)
            try
                data_ch_part1 = data.Data(:,1:floor(length(data.Data(1,:))/2));
                data_ch_part2 = data.Data(:,floor(length(data.Data(1,:))/2)+1 : length(data.Data(1,:)));
               
                
                EEG1.etc.eeglabvers = '2022.0'; % this tracks which version of EEGLAB is being used, you may ignore it
                EEG1 = pop_importdata('dataformat','array','nbchan',0,'data',data_ch_part1,'setname','data','srate',1000,'pnts',0,'xmin',0);
                EEG1 = eeg_checkset( EEG1 );
                EEG1 = pop_reref( EEG1, []);
                EEG1 = eeg_checkset( EEG1 );
                EEG1 = pop_runica(EEG1, 'icatype', 'runica', 'extended',1,'interrupt','on');
                EEG1 = eeg_checkset( EEG1 );
                EEG1 = pop_chanedit(EEG1, 'lookup','standard_1005.elc','load',{brain_graph_filename,'filetype','autodetect'});
                EEG1 = eeg_checkset( EEG1 );
                EEG1 = pop_iclabel(EEG1, 'default');
                EEG1 = eeg_checkset( EEG1 );
                EEG1.class_label=EEG1.etc.ic_classification.ICLabel.classes;
                EEG1.class_prob=EEG1.etc.ic_classification.ICLabel.classifications;
    
                EEG2.etc.eeglabvers = '2022.0'; % this tracks which version of EEGLAB is being used, you may ignore it
                EEG2 = pop_importdata('dataformat','array','nbchan',0,'data',data_ch_part2,'setname','data','srate',1000,'pnts',0,'xmin',0);
                EEG2 = eeg_checkset( EEG2 );
                EEG2 = pop_reref( EEG2, []);
                EEG2 = eeg_checkset( EEG2 );
                EEG2 = pop_runica(EEG2, 'icatype', 'runica', 'extended',1,'interrupt','on');
                EEG2 = eeg_checkset( EEG2 );
                EEG2 = pop_chanedit(EEG2, 'lookup','standard_1005.elc','load',{brain_graph_filename,'filetype','autodetect'});
                EEG2 = eeg_checkset( EEG2 );
                EEG2 = pop_iclabel(EEG2, 'default');
                EEG2 = eeg_checkset( EEG2 );
                EEG2.class_label=EEG2.etc.ic_classification.ICLabel.classes;
                EEG2.class_prob=EEG2.etc.ic_classification.ICLabel.classifications;
    
%                 EEG = cell2struct([struct2cell(EEG1),struct2cell(EEG2)],fieldnames(EEG1),1);

            catch
                error = [error i];
            end
        end

        %% substract component
        function EEG = sub_com(EEG,probability)
            try
                sub = [];
                for i = 1: size(EEG.class_prob,1)
                   [M,I] = max(EEG.class_prob(i,:));
                   if I ~= 1 | M <= probability
                       sub = [sub, i];
                   end
                end
                EEG = pop_subcomp( EEG, sub, 0);
                EEG = eeg_checkset( EEG );
            end
        end
    
         function EEG = sub_com_2(EEG,probability)
            try
                for q = 1:2
                    q
                    sub = [];
                    for k = 1: size(EEG(q).class_prob,1)
                       [M,I] = max(EEG(q).class_prob(k,:));
                       if I ~= 1 | M <= probability
                           sub = [sub, k];
                       end
                    end
                    EEG(q) = pop_subcomp( EEG(q), sub, 0);
                    EEG(q) = eeg_checkset(EEG(q));
                end
            end
        end
        %% save file
        function saveICAData(EEG,folder,filename_)
            save_filename_ = [folder '/' filename_];
            save(save_filename_,'EEG');
        end
        
        %% hilbert
        function data = hilbert(data, input)
            if data.replace == true
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; hilbert(input(i, :))];
                end
                data.Data = register;
            else
                register = [];
                for i=1:1:size(input, 1)
                    register = [register ; hilbert(input(i, :))];
                end
                data.Data = register;
                data.Hilbert = register;
            end 
        end
    end
end
            
