function bands_cell = pwelchUD(signal, smooth)
% delta_lo = 1;   delta_hi = 4;
% theta_lo = 4;   theta_hi = 8;
% alpha_lo = 8;   alpha_hi = 13;
% beta_lo = 13;   beta_hi = 30;
% gamma_lo = 30;  gamma_hi = 45;

bands_cell = cell(5, 1);
[rows, cols] = size(signal);
srate = 1000;
window = 1000;
nfft = 1000;
noverlap = 0;
segment_len = 1000;

delta_band = zeros(rows, floor(cols / segment_len));
theta_band = zeros(rows, floor(cols / segment_len));
alpha_band = zeros(rows, floor(cols / segment_len));
beta_band = zeros(rows, floor(cols / segment_len));
gamma_band = zeros(rows, floor(cols / segment_len));

% signal = smoothdata(signal, 2, 'sgolay', 101);
segmented = segmenter(signal, segment_len);

for segment=1 : floor(cols / segment_len)
    [spectra,freqs] = pwelch(segmented(:, :, segment)', [], [], [], srate);
    
    % Set the following frequency bands: delta=1-4, theta=4-8, alpha=8-13, beta=13-30, gamma=30-80.
    deltaIdx = find(freqs>1 & freqs<4);
    thetaIdx = find(freqs>4 & freqs<8);
    alphaIdx = find(freqs>8 & freqs<13);
    betaIdx  = find(freqs>13 & freqs<30);
    gammaIdx = find(freqs>30 & freqs<45);
    
    for channel=1 : rows
        deltaPower = mean(spectra(deltaIdx, channel));
        thetaPower = mean(spectra(thetaIdx, channel));
        alphaPower = mean(spectra(alphaIdx, channel));
        betaPower  = mean(spectra(betaIdx, channel));
        gammaPower = mean(spectra(gammaIdx, channel));
        
        delta_band(channel, segment) = deltaPower;
        theta_band(channel, segment) = thetaPower;
        alpha_band(channel, segment) = alphaPower;
        beta_band(channel, segment) = betaPower;
        gamma_band(channel, segment) = gammaPower;
    end
end

bands_cell{1, 1} = delta_band;
bands_cell{2, 1} = theta_band;
bands_cell{3, 1} = alpha_band;
bands_cell{4, 1} = beta_band;
bands_cell{5, 1} = gamma_band;

if (smooth)
    for band=1:5
        bands_cell{band, 1} = smoothdata(bands_cell{band, 1}, 2, 'rlowess', 10);
    end
end

end