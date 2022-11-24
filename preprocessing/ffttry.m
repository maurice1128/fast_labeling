
clc
mat_file = '/Users/mauricewang/Desktop/CL-DBS_4/mat_file_no_zscore'


contrast_power = []


for i = 1
    i
    load([mat_file '/Re0' num2str(i) '_CL-DBS_4']);
    for sec = 21:870

sec;
x = EEG.Data(1,:);
x = x(1000*(sec)-20000+1:1000*(sec)+20000);
n = length(x);
fs = 1000;
y = fft(x,n);
f = (0:n-1)*(fs/n);
power = abs(y).^2/n;   

NREM = sum(power(17:161));
REM = sum(power(201:345));
contrast = NREM/ REM;
contrast_power = [contrast_power , contrast];

    end
end


plot(21:870 , contrast_power);

axis([21 870 0 2]);
grid on
