function erd_cell = ERD(bands_cell, n_channels, video_len, smooth)
% 1 -> delta
% 2 -> theta
% 3 -> alpha
% 4 -> beta
% 5 -> gamma

erd_cell = cell(5, 1);

seconds_before_video = 8;
seconds_in_segment = 1;
video_second = seconds_before_video / seconds_in_segment;
video_segments = floor( video_len / seconds_in_segment );

for band=1:5
    erd_cell{band, 1} = zeros(n_channels, video_segments);
%     bands_cell{band, 1} = filloutliers(bands_cell{band, 1}, 'spline', 2);
    
    for chan=1:n_channels
        
%         ref_power = mean(bands_cell{band, 1}(chan, 1:video_second));
        ref_power = mean(bands_cell{band, 1}(chan, 1:5));
        erd_cell{band, 1}(chan, :) = ...
            ( ( bands_cell{band, 1}(chan, video_second+1:end) - ref_power ) / ref_power) * 100;
    end
    
    if (smooth)
        erd_cell{band, 1} = smoothdata(erd_cell{band, 1}, 2, 'rlowess', 10);
    end
    
end

end