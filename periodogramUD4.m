function bands_cell = periodogramUD4(signal)
% delta_lo = 1;   delta_hi = 3;
% theta_lo = 4;   theta_hi = 7;
% alpha_lo = 8;   alpha_hi = 12;
% beta_lo = 13;   beta_hi = 29;
% gamma_lo = 30;  gamma_hi = 45;
% Faghat ARAZ

bands_cell = cell(5, 1);
[rows, cols] = size(signal);
segment_len = 4000;
segments = floor(cols / segment_len);

delta_band = zeros(segments, rows);
theta_band = zeros(segments, rows);
alpha_band = zeros(segments, rows);
beta_band = zeros(segments, rows);
gamma_band = zeros(segments, rows);

% has an offset of 1, because frequency starts from 0 in index 1
delta_range = 5:16;
theta_range = 17:32;
alpha_range = 33:52;
beta_range = 53:120;
gamma_range = 121:184;

w = hann(segment_len, 'periodic');
nfft = 4000;
fs = 1000;

% delta x
dx = 2000;

pxx_tri = zeros(2001, 29, 3);

for segment=2:segments-1
    
    win_start = ( (segment - 2) * 4000 ) + 2000;
    for it=1:3
        
        [pxx_tri(:, :, it), f] = ...
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

end