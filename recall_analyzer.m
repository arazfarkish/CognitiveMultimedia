clear
clc;

% 1 -> delta
% 2 -> theta
% 3 -> alpha
% 4 -> beta
% 5 -> gamma

% 1 -> p
% 2 -> n

active_path = 'F:\THESIS\recall\active';
load('F:\THESIS\recall\key_6');
load('F:\THESIS\recall\key_11');

questions = 12;

recall_6p = zeros(20, 1);
recall_6n = zeros(20, 1);
recall_11p = zeros(20, 1);
recall_11n = zeros(20, 1);

counter_6p = 0;
counter_6n = 0;
counter_11p = 0;
counter_11n = 0;

cd(active_path);
active_dir = dir(active_path);

expression = 'recall_(6|11)(p|n)\.mat';

for subj=3:length(active_dir)
    subject = char(active_dir(subj).name);
    recall_path = [active_path, '\', subject];
    recall_dir = dir(recall_path);
    cd(recall_path);
    disp(["Entered ", subject]);

    for idx=3:length(recall_dir)
        recall_file = char(recall_dir(idx).name);
        [tokens,matches] = regexp(recall_file,expression,'tokens','match');

        if (~isempty(matches))
            disp(["Processing ", recall_file]);

            video_number = tokens{1}{1};
            video_type = tokens{1}{2};
            
            load(recall_file);
            
            if(video_number == "6")
                
                percent = ( sum( recall == key_6 ) / questions ) * 100;
                
                if(video_type == "p")
                    counter_6p = counter_6p + 1;
                    recall_6p(counter_6p) = percent;
                    
                elseif(video_type == "n")
                    counter_6n = counter_6n + 1;
                    recall_6n(counter_6n) = percent;
                    
                end
                
            elseif(video_number == "11")
                
                percent = ( sum( recall == key_11 ) / questions ) * 100;
                
                if(video_type == "p")
                    counter_11p = counter_11p + 1;
                    recall_11p(counter_11p) = percent;
                    
                elseif(video_type == "n")
                    counter_11n = counter_11n + 1;
                    recall_11n(counter_11n) = percent;
                    
                end
                
            end


        end
    end
end
