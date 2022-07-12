clear
clc;

% 1 -> delta
% 2 -> theta
% 3 -> alpha
% 4 -> beta
% 5 -> gamma

signals_path = 'F:\THESIS\signals_rejected';

expression = '(11)[pn]_corrected_ERD\.mat';

space = 200:100:3000;

cd(signals_path);
signals_dir = dir(signals_path);
    
smoothing_window_size = 9;
band = 2;
for subj=3:length(signals_dir)
    
    subject = char(signals_dir(subj).name);
    features_path = [signals_path, '\', subject, '\features'];
    features_dir = dir(features_path);
    cd(features_path);
    disp(["Entered ", subject]);

    for idx=3:length(features_dir)
        feature_file = char(features_dir(idx).name);
        [tokens,matches] = regexp(feature_file,expression,'tokens','match');

        if (~isempty(matches))
            disp(["Processing ", feature_file]);
            clear('erd_cell');
            load(feature_file);

            video_number = tokens{1}{1};
            
            erd = erd_cell{band, 1};         
            erd = filloutliers(erd, 'spline', 2);
            erd = smoothdata(erd, 2,  'sgolay', smoothing_window_size);
            plot_erd = bsxfun(@plus, erd, space');
            
            fig = figure;
%             plot_erd(26, :) = 0;
%             plot_erd(24, :) = 0;
            plot(plot_erd(:, 10:end)');
            
            waitfor(fig);
            
        end
    end
    
    
end    

    






