function percentage_cell = percentageChange(bands_cell)
% 1 -> delta
% 2 -> theta
% 3 -> alpha
% 4 -> beta
% 5 -> gamma

percentage_cell = cell(5, 1);

seconds_before_video = 8;
seconds_in_segment = 1;
video_second = seconds_before_video / seconds_in_segment;

for band=1:5
    
    baseline_power = mean(bands_cell{band, 1}(:, 2:video_second), 2);
    percentage_cell{band, 1} = ...
        ( ( bands_cell{band, 1}(:, video_second+1:end) - baseline_power ) ./ baseline_power ) * 100;
    
end

end