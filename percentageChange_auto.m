clear;
clc;

signals_path = 'F:\THESIS\signals';

cd(signals_path);
signals_dir = dir(signals_path);

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
            save_name = [video_number, video_type, '_', signal_type, '_ERD'];
            
            erd_cell = percentageChange(bands_cell);
            
            save(save_name, "erd_cell");
        end
        
    end
end