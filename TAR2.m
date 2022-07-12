function tar2_mat = TAR2(bands_cell, n_channels, len, ref_len, smooth)
% 1 -> delta
% 2 -> theta
% 3 -> alpha
% 4 -> beta
% 5 -> gamma

theta_number = 2;
alpha_number = 3;

tar2_mat = zeros(n_channels, len);
for channel=1:n_channels
    tar2_mat(channel, :) = ...
        bands_cell{theta_number, 1}(channel, ref_len+1:end) ./ ...
        bands_cell{alpha_number, 1}(channel, ref_len+1:end);
end

if (smooth)
    tar2_mat = smoothdata(tar2_mat, 2, 'rlowess', 10);
end

end