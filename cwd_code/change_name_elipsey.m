a = dir('/Users/mauricewang/Desktop/癲癇標注/2022-05-12_19-00-01_channel_3_corrected/png_file_cwt')
a(1:2) = []
for i = 1:length(a)

if a(i).name(end-6) == '0'
    
    source = [a(i).folder '/' a(i).name]
    a(i).name(end-6) = []
    destination = [a(i).folder '/' a(i).name]
    movefile (source , destination)
    end
end
