
classdef fast_label
    
    properties

    end
    
    methods (Static)
        
        function fig2im(new_im_filedir,original_im_filedir,name_pattern_Ecog,name_pattern_EMG,range,new_foldername)
            mkdir new_im_filedir new_foldername

            for num = range
                fig = (original_im_filedir+"/"+name_pattern_Ecog+num+".fig")
                openfig(fig);
                F = getframe(gcf)
                saveas(gcf,new_im_filedir+"/"+new_foldername+"/test"+num+".png")
            end

    

        end


%         function im_converge()
%             out = imtile({'test.png','test2.png','test3.png',},'GridSize', [3 1]);
%             imwrite(out,'test5.png');

        function gTruth2excel(imfiledir,record_num)
                
   


dir = imfiledir +"/gTruth"
load(dir,'gTruth')
        section_count_array_WAKE = []
        section_count_array_NREM = []
        section_count_array_REM = []
        WAKE_record = []
        NREM_record = []
        REM_record = []
        LAST_record = []
        FIRST_record = []
        border = []
        WAKE_count = 0
        NREM_count =0
        REM_count = 0
        section_final = {}
        % record_num = 1:2
        section_start = {}
        section_end = {}
        section_group= {}
        section_timeadd ={}
        border = []
        border2 = []
        border3 = []
        border4 = []

        
        
        
       
        
        
        
        for num = 1:record_num
             section_start_temp = []
             section_end_temp = []
             section_group_temp= {}
             section_timeadd_temp =[]
             section_start_temp_sorted = []
             section_end_temp_sorted = []
             section_group_temp_sorted= {}
             section_timeadd_temp_sorted =[]
             array_for_excel = []
             total_time = 0
             NREM_time = 0
             REM_time = 0
             WAKE_time = 0
            time_multiply = 0
WAKE_last =[]
REM_last =[]
NREM_last =[]


             %count how many section each group in the certain recording
             section_count_WAKE = max(size(gTruth.LabelData.WAKE{num}));
             section_count_NREM = max((size(gTruth.LabelData.NREM{num})));
             section_count_REM = max(size(gTruth.LabelData.REM{num}));
             section_count_array_WAKE_temp = [section_count_array_WAKE , section_count_WAKE];
             section_count_array_NREM_temp = [section_count_array_NREM , section_count_NREM];
             section_count_array_REM_temp = [section_count_array_REM , section_count_REM];
                %create a temp array for certain recording which(section)
                %record total time for each group and last time
                %goup 1 = WAKE,goup 2 = NREM, group 3 =REM

             for count = 1:section_count_WAKE
                 if isempty(gTruth.LabelData.WAKE{num}) ==0
                 section_start_temp = [section_start_temp,min(gTruth.LabelData.WAKE{num}{count}(1),gTruth.LabelData.WAKE{num}{count}(2))];
                 section_end_temp = [section_end_temp,max(gTruth.LabelData.WAKE{num}{count}(1),gTruth.LabelData.WAKE{num}{count}(2))];
                 section_group_temp= [section_group_temp,"WAKE"];
                 section_timeadd_temp =[section_timeadd_temp ,max(gTruth.LabelData.WAKE{num}{count}(1),gTruth.LabelData.WAKE{num}{count}(2))- min(gTruth.LabelData.WAKE{num}{count}(1),gTruth.LabelData.WAKE{num}{count}(2))];
                total_time = total_time+max(gTruth.LabelData.WAKE{num}{count}(1),gTruth.LabelData.WAKE{num}{count}(2))- min(gTruth.LabelData.WAKE{num}{count}(1),gTruth.LabelData.WAKE{num}{count}(2))
                WAKE_time = total_time
                WAKE_count = WAKE_count+1

                if count == section_count_WAKE
                    WAKE_last = max(gTruth.LabelData.WAKE{num}{count}(1),gTruth.LabelData.WAKE{num}{count}(2))
                    
                end
                 end


             end
        
             for count = 1:section_count_NREM
                 if isempty(gTruth.LabelData.NREM{num}) ==0
                 section_start_temp = [section_start_temp,min(gTruth.LabelData.NREM{num}{count}(1),gTruth.LabelData.NREM{num}{count}(2))];
                 section_end_temp = [section_end_temp,max(gTruth.LabelData.NREM{num}{count}(1),gTruth.LabelData.NREM{num}{count}(2))];
                 section_group_temp = [section_group_temp,"NREM"];
                 section_timeadd_temp =[section_timeadd_temp ,max(gTruth.LabelData.NREM{num}{count}(1),gTruth.LabelData.NREM{num}{count}(2))-min(gTruth.LabelData.NREM{num}{count}(1),gTruth.LabelData.NREM{num}{count}(2))];
                 total_time = total_time+max(gTruth.LabelData.NREM{num}{count}(1),gTruth.LabelData.NREM{num}{count}(2))-min(gTruth.LabelData.NREM{num}{count}(1),gTruth.LabelData.NREM{num}{count}(2))
                 NREM_time = total_time-WAKE_time
                 NREM_count = NREM_count+1

                 if count == section_count_NREM
                    NREM_last = max(gTruth.LabelData.NREM{num}{count}(1),gTruth.LabelData.NREM{num}{count}(2))
                   
                 end
                 end


                 
             end
        
             for count = 1:section_count_REM
                 if isempty(gTruth.LabelData.REM{num}) ==0
                 section_start_temp = [section_start_temp,min(gTruth.LabelData.REM{num}{count}(1),gTruth.LabelData.REM{num}{count}(2))];
                 section_end_temp = [section_end_temp,max(gTruth.LabelData.REM{num}{count}(1),gTruth.LabelData.REM{num}{count}(2))];
                 section_group_temp=[section_group_temp,"REM"];
                 section_timeadd_temp =[section_timeadd_temp ,max(gTruth.LabelData.REM{num}{count}(1),gTruth.LabelData.REM{num}{count}(2))-min(gTruth.LabelData.REM{num}{count}(1),gTruth.LabelData.REM{num}{count}(2))];
                 total_time = total_time+max(gTruth.LabelData.REM{num}{count}(1),gTruth.LabelData.REM{num}{count}(2))-min(gTruth.LabelData.REM{num}{count}(1),gTruth.LabelData.REM{num}{count}(2))
                 REM_time = total_time-NREM_time-WAKE_time
                 REM_count = REM_count+1

                
                 if count == section_count_REM
                    REM_last = max(gTruth.LabelData.REM{num}{count}(1),gTruth.LabelData.REM{num}{count}(2))
                   
                 end
                 end
             end




             
%find who's biggest in single_recording
if isempty(NREM_last) ==1
    NREM_last = 0
end

if isempty(REM_last) ==1
    REM_last = 0
end

if isempty(WAKE_last) ==1
    WAKE_last = 0
end


biggest = [WAKE_last,NREM_last,REM_last]
[a,b] = max(biggest)

biggest_name_choose = {'WAKE','NREM','REM'}

biggest = char(biggest_name_choose(b))

            








            %set from sample point to 450s
            time_multiply = 900/total_time 
            
            section_timeadd_temp = section_timeadd_temp.*time_multiply 
             %sort 
            [sorted_section_start,I] = sort(section_start_temp)
            section_end_temp_sorted=section_end_temp(I)
            section_group_temp_sorted=section_group_temp(I)
            section_timeadd_temp_sorted=section_timeadd_temp(I)


             %find total time and last record
            WAKE_record = [WAKE_record,WAKE_time*time_multiply ]
            NREM_record = [NREM_record,NREM_time*time_multiply ]
            REM_record = [REM_record,REM_time*time_multiply ]
            LAST_record{end+1} = biggest
            FIRST_record{end+1} = char(section_group_temp_sorted(1))


            


            


            %array for excel
        
            for count = 1:max(size(section_end_temp_sorted))
        
                array_for_excel = [array_for_excel,section_timeadd_temp_sorted(count)]
                array_for_excel = [array_for_excel,section_group_temp_sorted(count)]
            end
        
            %save to excel
            num_for_excel = num+1
           
            writematrix(array_for_excel,imfiledir+"/final_analysis.xlsx",'range',"B"+num_for_excel)
            




                % save as final cell array which (record_num,section)
                
                section_start = [section_start,section_start_temp];
                section_end = [section_end,section_end_temp];
                section_group= [section_group,{section_group_temp}];
                section_timeadd =[section_timeadd,section_timeadd_temp];
              

                border = [border;"Re"+num]
                border2 = [border2 , "Re"+num]
                border3 = ["WAKE_time";"NREM_time";"REM_time"]
                border4 = ["WAKE_count","NREM_count","REM_count"]
        
                
        
        
       
        
        
       
        
                
        num_for_section_excel = num_for_excel+3
        
                 end
                %print_excel_border
                
               num_for_border_start = 2
               num_for_border_start_2 = num_for_excel+2
               num_for_border_start_3 = num_for_excel+6
               writematrix(border,imfiledir+"/final_analysis.xlsx",'range',"A"+num_for_border_start)
               writematrix(border2,imfiledir+"/final_analysis.xlsx",'range',"B"+num_for_border_start_2)
               writematrix(border3,imfiledir+"/final_analysis.xlsx",'range',"A"+num_for_section_excel)
               writematrix(border4,imfiledir+"/final_analysis.xlsx",'range',"B"+num_for_border_start_3)
               

                
                 %print_excel for total_section_time and transition
           total_WAKE_time = 0
           total_NREM_time = 0
           total_REM_time = 0


                num_for_section_excel = num_for_excel+3
                 array_for_excel_section_time = [WAKE_record;NREM_record;REM_record]
                 for i = 1:record_num
        total_WAKE_time = total_WAKE_time +WAKE_record(i)
        total_NREM_time = total_NREM_time +NREM_record(i)
        total_REM_time = total_REM_time +REM_record(i)

                 end

                 num_for_percentage = num_for_section_excel +7
                 num_for_percentage_border = num_for_section_excel +6
percentage_border = ["WAKE_percentage" "NREM_percentage" "REM_percentage"]
                 total_percentage = [total_WAKE_time/864 ,total_NREM_time/864,total_REM_time/864]
                  writematrix(total_percentage,imfiledir+"/final_analysis.xlsx",'range',"B"+num_for_percentage)
                 writematrix(percentage_border,imfiledir+"/final_analysis.xlsx",'range',"B"+num_for_percentage_border)
                 
                 
                 writematrix(array_for_excel_section_time,imfiledir+"/final_analysis.xlsx",'range',"B"+num_for_section_excel)
                 

                 tran_WAKE = WAKE_count
                 tran_NREM = NREM_count
                 tran_REM = REM_count

                 for num = 1:record_num-1
                     if convertCharsToStrings(FIRST_record{1,num+1}) == convertCharsToStrings(LAST_record{1,num})
                         switch FIRST_record{1,num+1}
                             case 'WAKE'
                                 tran_WAKE = tran_WAKE-1
                                 
                             case 'NREM'
                                 tran_NREM = tran_NREM-1
                                 
                             case 'REM'
                                 tran_REM=tran_REM-1
                                 
                             otherwise
                         end
                     end
                 end

                     trans = [tran_WAKE,tran_NREM,tran_REM]
                     num_for_trans = num_for_section_excel+4
                writematrix(trans,imfiledir+"/final_analysis.xlsx",'range',"B"+num_for_trans)


        



        end
    end
end




        
