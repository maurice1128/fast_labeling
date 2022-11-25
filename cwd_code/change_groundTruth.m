load /Users/mauricewang/Desktop/癲癇標注/2022-05-24_19-00-03_channel_2_corrected/png_file/gTruth.mat
a.LabelData = gTruth.LabelData(1:96,:);
clear gTruth
ascii = [1,10:19,2,20:29,3,30:39,4,40:49,5,50:59,6,60:69,7,70:79,8,80:89,9,90:99]
for i = 1:96

b.LabelData(i,:) = a.LabelData(ascii(i),:) 

end


gTruth = b

save('change_groundTruth.mat' , 'gTruth')


