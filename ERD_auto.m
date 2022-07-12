clear;
clc;

signals_path = 'C:\Users\arazf\Desktop\AMIR';

cd(signals_path);
signals_dir = dir(signals_path);

% smooth or not parameter
smooth = false;

smooth_string = '';
if (smooth)
    smooth_string = '_smooth';
end 

expression = '(6|11)(n|p)_(corrected)_bands\.mat';
for subj=3:length(signals_dir)
    subject = char(signals_dir(subj).name);
    features_path = [signals_path, '\', subject, '\features'];
    features_dir = dir(features_path);
    cd(features_path);
    disp(["Entered ", subject]);
    
    for file_idx=3:length(features_dir)
        file_name = char(features_dir(file_idx).name);
        [tokens,matches] = regexp(file_name,expression,'tokens','match');
        
        if (~isempty(matches))
            disp(["Processing ", file_name]);
            
            clear('bands_cell');
            load(file_name);
            
            video_number = tokens{1}{1};
            video_type = tokens{1}{2};
            signal_type = tokens{1}{3};
            save_name = [video_number, video_type, '_', signal_type, '_ERD', smooth_string];
            
            n_channels = 29;
            if (video_number == "6")
                len = 290;
            elseif(video_number == "11")
                len = 342;
            end
            erd_cell = ERD(bands_cell, n_channels, len, smooth);
            
            save(save_name, "erd_cell");
        end
        
    end
end