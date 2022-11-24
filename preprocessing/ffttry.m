

mat_file = '/Users/mauricewang/Desktop/CL-DBS_4/mat_file_no_zscore'


contrast_power = []


for i = 1:96
    load([mat_file '/Re0' num2str(i) '_CL-DBS_4'])
    for sec = 11:880


x = EEG.Data(1,:)
x = x(1000*(i)-10000:1000*(i)+10000)
n = length(x)
fs = 1000
y = fft(x,length(n))
f = (0:n-1)*(fs/n);
power = abs(y).^2/n;   

NREM = sum(power(9:81))
REM = sum(power(101:173))
contrast = NREM/ REM
contrast_power = [contrast_power , contrast]

    end
end

axis([11 880 0 2])
grid on
plot(11:880 , contrast_power)