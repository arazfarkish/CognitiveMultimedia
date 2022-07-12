function bands_cell = periodogramUD(signal)
% delta_lo = 1;   delta_hi = 3;
% theta_lo = 4;   theta_hi = 7;
% alpha_lo = 8;   alpha_hi = 12;
% beta_lo = 13;   beta_hi = 29;
% gamma_lo = 30;  gamma_hi = 45;
% Faghat ARAZ

bands_cell = cell(5, 1);
[rows, cols] = size(signal);
segment_len = 1000;
segments = floor(cols / segment_len);

delta_band = zeros(segments, rows);
theta_band = zeros(segments, rows);
alpha_band = zeros(segments, rows);
beta_band = zeros(segments, rows);
gamma_band = zeros(segments, rows);

% has an offset of 1, because frequency starts from 0 in index 1
delta_range = 2:4;
theta_range = 5:8;
alpha_range = 9:13;
beta_range = 14:30;
gamma_range = 31:46;

w = hann(segment_len, 'periodic');
nfft = 1000;
fs = 1000;

% delta x
dx = 500;

pxx_tri = zeros(501, 29, 3);

for segment=2:segments-1
    
    win_start = ( (segment - 2) * 1000 ) + 500;
    for it=1:3
        
        [pxx_tri(:, :, it), ~] = ...
            periodogram(signal(:, win_start+1 : win_start+segment_len)', w, nfft, fs);
        win_start = win_start + dx;
        
    end
    pxx = mean(pxx_tri, 3);
    
    delta_band(segment, :) = mean( pxx(delta_range, :) );
    theta_band(segment, :) = mean( pxx(theta_range, :) );
    alpha_band(segment, :) = mean( pxx(alpha_range, :) );
    beta_band(segment, :) = mean( pxx(beta_range, :) );
    gamma_band(segment, :) = mean( pxx(gamma_range, :) );
    
end




bands_cell{1, 1} = delta_band';
bands_cell{2, 1} = theta_band';
bands_cell{3, 1} = alpha_band';
bands_cell{4, 1} = beta_band';
bands_cell{5, 1} = gamma_band';

% signal = smoothdata(signal, 2, 'sgolay', 101);
% if (smooth)
%     for band=1:5
%         bands_cell{band, 1} = smoothdata(bands_cell{band, 1}, 2, 'rlowess', 10);
%     end
% end

end