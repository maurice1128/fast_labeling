clc
close all
clear all

% path = "E:\20220810\baseline_data";
path = "G:\2022-08-02_19-00-02\Record Node 130\experiment1";

batch_path = dir(path);

batch_number = 1;

% SvaePaths = [{"I:\20220810\baseline_data\1_day-6_veh__x", 2},
%              {"I:\20220810\baseline_data\3_day-4_J4__03", 2},
%              {"I:\20220810\baseline_data\3_day-4_J4__04", 3},
%              {"I:\20220810\baseline_data\3_day-4_veh_02", 1},
%              {"I:\20220810\baseline_data\3_day-6_J4__03", 2},
%              {"I:\20220810\baseline_data\3_day-6_J4__04", 3},
%              {"I:\20220810\baseline_data\3_day-6_veh_02", 1},
%              {"I:\20220810\baseline_data\4_day-4_tsc_01", 1},
%              {"I:\20220810\baseline_data\4_day-4_tsc_02", 2},
%              {"I:\20220810\baseline_data\4_day-4_tsc_04", 3},
%              {"I:\20220810\baseline_data\4_day-4_tsc_05", 4}];

chosse_channel = {[1,2,7,8,9,10,15,16];[17 18 23 24 25 26 31 32];[33,34,39,40,41,42,47,48];[49,50,55,56,57,58,63,64]};
error = [];
replace = true;

now = 1;
for i = 3:1:length(batch_path)
    if length(batch_path(i).name) <= 2
        disp("check folder name : " + batch_path(i).name);
    else
        Parameter{now, 1} = path + "\" + batch_path(i).name;
        disp(batch_path(i).name)
        x = input("data channel\n", "s");
        x = str2num(x);
        Parameter{now, 2} = x;
        
        [filePath,~] = EEG_tools.getFilePath(true,'\');
        Parameter{now, 3} = filePath;
        disp(Parameter{now, 1} + ", " + Parameter{now, 2} + ", " + Parameter{now, 3}{1})
        
        now = now + 1;
    end
end

% 
% 
% save("auto_Run2.mat", "Parameter", "chosse_channel", "error", "replace", "batch_number")









