[p_11, ranges_11] = principlesConverter("11");
[p_6, ranges_6] = principlesConverter("6");

[len_p11, ~] = size(ranges_11);
[len_p6, ~] = size(ranges_6);

n_channels = 29;
cohen_in_channels__11 = zeros(n_channels, len_p11);
cohen_in_channels__6 = zeros(n_channels, len_p6);

analysis_path = 'F:\THESIS\analysis';
cd(analysis_path);

file_name = 'alpha_FC_6.mat';
load(file_name);

for channel = 1:29
    for principle = 1:len_p6
        cohen_in_channels__6(channel, principle) = ...
            mean(feature_cell_6{channel, 1}(3, ranges_6(principle, 1):ranges_6(principle, 1)));
    end
    
end


file_name = 'alpha_FC_11.mat';
load(file_name);

for channel = 1:29
    for principle = 1:len_p11
        cohen_in_channels__11(channel, principle) = ...
            mean(feature_cell_11{channel, 1}(3, ranges_11(principle, 1):ranges_11(principle, 1)));
    end
    
end

