


mat_file = '/Users/mauricewang/Desktop/CL-DBS_5/mat_file_zscore'
excel_file = '/Users/mauricewang/Desktop/CL-DBS_5/final_analysis.xlsx'






contrast_power = []
middle_outer_power = []
EMG_power = []

for recording = 1:96


range = ['A' num2str(recording+1) ':W' num2str(recording+1)]
T = readcell(excel_file,'range',range)





x_axis = 2
start_time_temp= 0
WAKE_start = []
NREM_start = []
REM_start = []
NREM_lasting = []
 WAKE_lasting  = []
REM_lasting =[]
i = 0
start_all = []


    while isequal(class(T{1,x_axis}) ,'missing') ==false
i = i+1
x_axis

a = T{1,x_axis+1}
start_all = [start_all ,start_time_temp]
switch a

    case 'WAKE'
        1
        WAKE_start = [WAKE_start ,start_time_temp];
        WAKE_lasting = [WAKE_lasting str2num(T{1,x_axis})];

    case 'NREM'
        c = 'b'
        NREM_start = [NREM_start ,start_time_temp];
        NREM_lasting = [NREM_lasting str2num(T{1,x_axis})];
    case 'REM'
        3
        REM_start = [REM_start ,start_time_temp];
        REM_lasting = [REM_lasting str2num(T{1,x_axis})];

    otherwise
        warning('theres a weird thing');

end

start_time_temp = start_time_temp +str2num(T{1,x_axis});
x_axis =x_axis+2;



    end
    
  x_axis = x_axis-2






start_edge = 20
end_edge = 870

i = recording
    load([mat_file '/Re0' num2str(i) '_CL-DBS_5']);

if isempty(NREM_start) ==false


if NREM_start(1) <start_edge &NREM_lasting(1) <start_edge
NREM_start(1) = []
NREM_lasting(1) = []


elseif NREM_start(1) <start_edge &NREM_lasting(1) >start_edge
    NREM_lasting(1) = NREM_lasting(1) - (start_edge- NREM_start(1))
    NREM_start(1) = start_edge
end

if NREM_start(end)+NREM_lasting(end) > end_edge &NREM_start(end)<end_edge
     NREM_lasting(end) = end_edge -NREM_start(end)

elseif NREM_start(end)>end_edge
    NREM_lasting(end) = []
    NREM_start(end) = []


   
end



    for NREM_section = 1:length(NREM_start)
        

    for sec = NREM_start(NREM_section):NREM_start(NREM_section)+NREM_lasting(NREM_section)

sec;
x = EEG.Data(3,:);
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



%  x = EEG.Data(5,:);
% x = x(1000*(sec)-5000+1:1000*(sec)+5000);
% n = length(x);
% fs = 1000;
% y = fft(x,n);
% f = (0:n-1)*(fs/n);
% power = abs(y).^2/n; 
% 
% EMG = sum(power(101:12001));
% EMG_power = [EMG_power , EMG];

    end


    end
end


end




wake_percentage = [];


for tr = 0:0.01:2
    tr
    wake_time = 0;
    for i = 1:length(contrast_power);
    if contrast_power(i)<=tr
        wake_time = wake_time+1;
    end
    
    end
    wake_percentage = [wake_percentage , wake_time/(900*96)];
end
plot(0:0.01:2 , wake_percentage);
grid on





