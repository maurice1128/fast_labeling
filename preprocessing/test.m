%%Time specifications:
   Fs = 1000;                   % samples per second
   dt = 1/Fs;                   % seconds per sample
   StopTime = 900;             % seconds
   t = (0:dt:StopTime-dt)';     % seconds
   %%Sine wave:
   Fc = 60;                     % hertz
   cosine_wave = cos(2*pi*Fc*t);
   % Plot the signal versus time:
   bandpass_default_Ecog = designfilt('bandpassiir', 'FilterOrder',4, ...
                'PassbandFrequency1', 0.5, ...
                'PassbandFrequency2', 30, ...
                'SampleRate', 1000);

%draw unfilter
plot(t,cosine_wave)
hold on

%draw filter
cosine_wave_filter = filtfilt(bandpass_default_Ecog,cosine_wave)
detrend(cosine_wave_filter )
plot(t,cosine_wave_filter)
   