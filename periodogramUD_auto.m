clear;
clc;

signals_path = 'C:\Users\arazf\Desktop\AMIR';

cd(signals_path);
signals_dir = dir(signals_path);

expression = '(6|11)(n|p)_(corrected)\.mat';
for subj=3:length(signals_dir)
    subject = char(signals_dir(subj).name);
    subject_path = [signals_path, '\', subject];
    subject_dir = dir(subject_path);  
    cd(subject_path);
    disp(["Entered ", subject]);
  
    for file_idx=3:length(subject_dir)
        file_name = char(subject_dir(file_idx).name);
        [tokens,matches] = regexp(file_name,expression,'tokens','match');
        
        if (~isempty(matches))
            disp(["Processing", file_name]);
            
            video_number = tokens{1}{1};
            video_type = tokens{1}{2};
            signal_type = tokens{1}{3};
            save_name = [video_number, video_type, '_', signal_type, '_bands'];
            
            clear('final_corrected');
            load(file_name);
            
            bands_cell = periodogramUD(final_corrected);
            
            save(['features\', save_name], "bands_cell");
            
        end
    end
end