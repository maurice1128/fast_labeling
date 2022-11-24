
clc
mat_file = '/Users/mauricewang/Desktop/CL-DBS_4/mat_file_zscore'


contrast_power = []
middle_outer_power = []
EMG_power = []
for i =14
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

NREM = sum(power(29:161));
REM = sum(power(201:333));
middle = sum(power(161:241));
outer = sum(power(81:160))+sum(power(242:321));
contrast = NREM/ REM;
contrast_power = [contrast_power , contrast];
 middle_outer_power = [middle_outer_power , middle/outer];



 x = EEG.Data(5,:);
x = x(1000*(sec)-5000+1:1000*(sec)+5000);
n = length(x);
fs = 1000;
y = fft(x,n);
f = (0:n-1)*(fs/n);
power = abs(y).^2/n; 

EMG = sum(power(101:12001));
EMG_power = [EMG_power , EMG];

    end
end


plot(21:870 , contrast_power);
hold on 
plot(21:870 , middle_outer_power)
hold off
axis([21 870 0 2]);
grid on


plot(EMG_power)






