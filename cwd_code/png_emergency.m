make_dir_path = '/Volumes/maurice_ec2/2022-04-07_19-00-03_channel_2_name_corrected/png'
file_names = dir(make_dir_path)
file_names(1:6) = []

for i=1:length(file_names)
     real_name=batch_path(i).name;
     real_name_index=real_name(10:length(real_name));
     %
     file_name = file_names(i).name;
     mat_name = file_name(1:find(file_name == '.') - 1);
     file_name = [path '/' file_name];
      save_name= [ '/Volumes/maurice_ec2/2022-04-07_19-00-03_channel_2_name_corrected/png_corrected/Re0' real_name_index '.png']
      original_name = [make_dir_path '/Re0' num2str(i) '.png' ]
      movefile (original_name , save_name)

end
