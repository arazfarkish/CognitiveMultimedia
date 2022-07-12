clear
clc;

% 1 -> delta
% 2 -> theta
% 3 -> alpha
% 4 -> beta
% 5 -> gamma

% 1 -> p
% 2 -> n
addpath('F:\THESIS\eeglab2020_0');

signals_path = 'F:\THESIS\signals';

region_f =  [1 2 3 9 10 11 17 18];
region_fc = [5 13 19 20 21];
region_lt = [4 6 7 8];
region_rt = [12 14 15 16];
region_p =  [22 23 24 25 26];
region_o =  [27 28 29];

regions_cell = cell(6, 1);
regions_cell{1, 1} = region_f;
regions_cell{2, 1} = region_fc;
regions_cell{3, 1} = region_lt;
regions_cell{4, 1} = region_rt;
regions_cell{5, 1} = region_p;
regions_cell{6, 1} = region_o;

n_regions = 6;
n_channels = 29;

seconds_in_segment = 1;
len_6 = floor( 290 / seconds_in_segment );
len_11 = floor( 342 / seconds_in_segment );
n_channels = 29;
smoothing_window_size = 10;
band = 2;

group_11p = zeros(n_channels, len_11, 20);
group_11n = zeros(n_channels, len_11, 20);

VI_WA_p = zeros(20, 2);
VI_WA_n = zeros(20, 2);

counter_11p = 0;
counter_11n = 0;

cd(signals_path);
signals_dir = dir(signals_path);
expression = '(6|11)(p|n)_corrected_ERD\.mat';
for subj=3:length(signals_dir)
    subject = char(signals_dir(subj).name);
    
    temp_VI = 0;
    temp_WA = 0;
    style_path = [signals_path, '\', subject, '\style'];
    cd(style_path);
    if(exist('VI.csv') == 2)
        style_mat = readmatrix('VI.csv');
        temp_VI = style_mat(6);
    end
    if(exist('WA.csv') == 2)
        style_mat = readmatrix('WA.csv');
        temp_WA = style_mat(6);
    end
    
    features_path = [signals_path, '\', subject, '\features'];
    features_dir = dir(features_path);
    cd(features_path);
    disp(["Entered ", subject]);

    for idx=3:length(features_dir)
        feature_file = char(features_dir(idx).name);
        [tokens,matches] = regexp(feature_file,expression,'tokens','match');

        if (~isempty(matches))
            disp(["Processing ", feature_file]);

            video_number = tokens{1}{1};
            video_type = tokens{1}{2};
            
            load(feature_file);
            feature = filloutliers(erd_cell{band, 1}, 'spline', 2);
                
            if(video_number == "11")
                
                if(video_type == "p")
                    counter_11p = counter_11p + 1;
                    group_11p(:, :, counter_11p) = feature;
                    
                    VI_WA_p(counter_11p, 1) = temp_VI;
                    VI_WA_p(counter_11p, 2) = temp_WA;
                    
                elseif(video_type == "n")
                    counter_11n = counter_11n + 1;
                    group_11n(:, :, counter_11n) = feature;
                    
                    VI_WA_n(counter_11n, 1) = temp_VI;
                    VI_WA_n(counter_11n, 2) = temp_WA;
                    
                end
                
            end


        end
    end
end

group_11p = group_11p(:, :, 1:counter_11p);
group_11n = group_11n(:, :, 1:counter_11n);

load('F:\THESIS\principles.mat');
p_11 = principles;

load('F:\THESIS\p_types.mat');

intervals_signaling = [37:39 45:48 79:81 167:168 195:199 272:274];
intervals_coherence = [70:71 84:85 108:109 186:187 226:227 287:289 304:307 310:314];
intervals_temporal = [145:147 180:181 258:260];
intervals_spatial = [101:104 148:150 256:257];
intervals_redundancy = [149:153 154:161 256:258 260:262 313:319];

principle_in_region = zeros(n_regions, 5);
principles_anova = zeros(n_regions, 5);
mean_in_principle_region_11p = zeros(n_regions, 5);
mean_in_principle_region_11n = zeros(n_regions, 5);

principle_region_vrb = zeros(n_regions, 5);
principle_anova_vrb = zeros(n_regions, 5);

principle_region_img = zeros(n_regions, 5);
principle_anova_img = zeros(n_regions, 5);

principle_region_hol = zeros(n_regions, 5);
principle_anova_hol = zeros(n_regions, 5);

principle_region_anl = zeros(n_regions, 5);
principle_anova_anl = zeros(n_regions, 5);


for region=1:n_regions
    
    %----%
    region_mean_11p = reshape(mean( group_11p(regions_cell{region, 1}, :, :) ), len_11, counter_11p );
    region_mean_11p = region_mean_11p';
    region_mean_11n = reshape(mean( group_11n(regions_cell{region, 1}, :, :) ), len_11, counter_11n );
    region_mean_11n = region_mean_11n';
    
    %----%
    y = zeros(counter_11p, 2);
    
    v_p = mean( region_mean_11p(:, intervals_signaling), 2 );
    v_n = mean( region_mean_11n(:, intervals_signaling), 2 );
    principle_in_region(region, 1) = effectSize(v_p, v_n, 'c');
    y(:, 1)  = v_p;
    y(:, 2)  = v_n;
    [~, principles_anova(region, 1)] = ttest2(v_p, v_n);
    mean_in_principle_region_11p(region, 1) = mean( v_p );
    mean_in_principle_region_11n(region, 1) = mean( v_n );
    
    
    v_p = mean( region_mean_11p(:, intervals_coherence), 2 );
    v_n = mean( region_mean_11n(:, intervals_coherence), 2 );
    principle_in_region(region, 2) = effectSize(v_p, v_n, 'c');
    y(:, 1)  = v_p;
    y(:, 2)  = v_n;
    [~, principles_anova(region, 2)] = ttest2(v_p, v_n);
    mean_in_principle_region_11p(region, 2) = mean( v_p );
    mean_in_principle_region_11n(region, 2) = mean( v_n );
    
    v_p = mean( region_mean_11p(:, intervals_temporal), 2 );
    v_n = mean( region_mean_11n(:, intervals_temporal), 2 );
    principle_in_region(region, 3) = effectSize(v_p, v_n, 'c');
    y(:, 1)  = v_p;
    y(:, 2)  = v_n;
    [~, principles_anova(region, 3)] = ttest2(v_p, v_n);
    mean_in_principle_region_11p(region, 3) = mean( v_p );
    mean_in_principle_region_11n(region, 3) = mean( v_n );
    
    v_p = mean( region_mean_11p(:, intervals_spatial), 2 );
    v_n = mean( region_mean_11n(:, intervals_spatial), 2 );
    principle_in_region(region, 4) = effectSize(v_p, v_n, 'c');
    y(:, 1)  = v_p;
    y(:, 2)  = v_n;
    [~, principles_anova(region, 4)] = ttest2(v_p, v_n);
    mean_in_principle_region_11p(region, 4) = mean( v_p );
    mean_in_principle_region_11n(region, 4) = mean( v_n );
    
    v_p = mean( region_mean_11p(:, intervals_redundancy), 2 );
    v_n = mean( region_mean_11n(:, intervals_redundancy), 2 );
    principle_in_region(region, 5) = effectSize(v_p, v_n, 'c');
    y(:, 1)  = v_p;
    y(:, 2)  = v_n;
    [~, principles_anova(region, 5)] = ttest2(v_p, v_n);
    mean_in_principle_region_11p(region, 5) = mean( v_p );
    mean_in_principle_region_11n(region, 5) = mean( v_n );
      
end

 vi = [VI_WA_p(VI_WA_p(:, 1) > 0, 1) ; VI_WA_n(VI_WA_n(:, 1) > 0, 1)];
 wa = [VI_WA_p(VI_WA_p(:, 2) > 0, 2) ; VI_WA_n(VI_WA_n(:, 2) > 0, 2)];
 median_vi = median(vi);
 median_wa = median(wa);
 
 img_pidx = VI_WA_p(:, 1) >= median_vi;
 img_nidx = VI_WA_n(:, 1) >= median_vi;
 
 vrb_pidx = VI_WA_p(:, 1) < median_vi & VI_WA_p(:, 1) > 0;
 vrb_nidx = VI_WA_n(:, 1) < median_vi & VI_WA_n(:, 1) > 0;
 
 anl_pidx = VI_WA_p(:, 2) >= median_wa;
 anl_nidx = VI_WA_n(:, 2) >= median_wa;
 
 hol_pidx = VI_WA_p(:, 2) < median_wa & VI_WA_p(:, 2) > 0;
 hol_nidx = VI_WA_n(:, 2) < median_wa & VI_WA_n(:, 2) > 0;

for region=1:n_regions
    
    %----%
    region_mean_11p = reshape(mean( group_11p(regions_cell{region, 1}, :, :) ), len_11, counter_11p );
    region_mean_11p = region_mean_11p';
    region_mean_11n = reshape(mean( group_11n(regions_cell{region, 1}, :, :) ), len_11, counter_11n );
    region_mean_11n = region_mean_11n';
    
    
    %%- verbal -%%
    v_p = mean( region_mean_11p(vrb_pidx, intervals_signaling), 2 );
    v_n = mean( region_mean_11n(vrb_nidx, intervals_signaling), 2 );
    principle_region_vrb(region, 1) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_vrb(region, 1)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(vrb_pidx, intervals_coherence), 2 );
    v_n = mean( region_mean_11n(vrb_nidx, intervals_coherence), 2 );
    principle_region_vrb(region, 2) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_vrb(region, 2)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(vrb_pidx, intervals_temporal), 2 );
    v_n = mean( region_mean_11n(vrb_nidx, intervals_temporal), 2 );
    principle_region_vrb(region, 3) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_vrb(region, 3)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(vrb_pidx, intervals_spatial), 2 );
    v_n = mean( region_mean_11n(vrb_nidx, intervals_spatial), 2 );
    principle_region_vrb(region, 4) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_vrb(region, 4)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(vrb_pidx, intervals_redundancy), 2 );
    v_n = mean( region_mean_11n(vrb_nidx, intervals_redundancy), 2 );
    principle_region_vrb(region, 5) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_vrb(region, 5)] = ttest2(v_p, v_n);
    
    
    %%- imagery -%%
    v_p = mean( region_mean_11p(img_pidx, intervals_signaling), 2 );
    v_n = mean( region_mean_11n(img_nidx, intervals_signaling), 2 );
    principle_region_img(region, 1) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_img(region, 1)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(img_pidx, intervals_coherence), 2 );
    v_n = mean( region_mean_11n(img_nidx, intervals_coherence), 2 );
    principle_region_img(region, 2) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_img(region, 2)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(img_pidx, intervals_temporal), 2 );
    v_n = mean( region_mean_11n(img_nidx, intervals_temporal), 2 );
    principle_region_img(region, 3) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_img(region, 3)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(img_pidx, intervals_spatial), 2 );
    v_n = mean( region_mean_11n(img_nidx, intervals_spatial), 2 );
    principle_region_img(region, 4) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_img(region, 4)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(img_pidx, intervals_redundancy), 2 );
    v_n = mean( region_mean_11n(img_nidx, intervals_redundancy), 2 );
    principle_region_img(region, 5) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_img(region, 5)] = ttest2(v_p, v_n);
    
    
    %%- holistic -%%
    v_p = mean( region_mean_11p(hol_pidx, intervals_signaling), 2 );
    v_n = mean( region_mean_11n(hol_nidx, intervals_signaling), 2 );
    principle_region_hol(region, 1) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_hol(region, 1)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(hol_pidx, intervals_coherence), 2 );
    v_n = mean( region_mean_11n(hol_nidx, intervals_coherence), 2 );
    principle_region_hol(region, 2) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_hol(region, 2)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(hol_pidx, intervals_temporal), 2 );
    v_n = mean( region_mean_11n(hol_nidx, intervals_temporal), 2 );
    principle_region_hol(region, 3) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_hol(region, 3)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(hol_pidx, intervals_spatial), 2 );
    v_n = mean( region_mean_11n(hol_nidx, intervals_spatial), 2 );
    principle_region_hol(region, 4) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_hol(region, 4)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(hol_pidx, intervals_redundancy), 2 );
    v_n = mean( region_mean_11n(hol_nidx, intervals_redundancy), 2 );
    principle_region_hol(region, 5) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_hol(region, 5)] = ttest2(v_p, v_n);
    
    
    %%- analytic -%%
    v_p = mean( region_mean_11p(anl_pidx, intervals_signaling), 2 );
    v_n = mean( region_mean_11n(anl_nidx, intervals_signaling), 2 );
    principle_region_anl(region, 1) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_anl(region, 1)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(anl_pidx, intervals_coherence), 2 );
    v_n = mean( region_mean_11n(anl_nidx, intervals_coherence), 2 );
    principle_region_anl(region, 2) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_anl(region, 2)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(anl_pidx, intervals_temporal), 2 );
    v_n = mean( region_mean_11n(anl_nidx, intervals_temporal), 2 );
    principle_region_anl(region, 3) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_anl(region, 3)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(anl_pidx, intervals_spatial), 2 );
    v_n = mean( region_mean_11n(anl_nidx, intervals_spatial), 2 );
    principle_region_anl(region, 4) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_anl(region, 4)] = ttest2(v_p, v_n);
    
    v_p = mean( region_mean_11p(anl_pidx, intervals_redundancy), 2 );
    v_n = mean( region_mean_11n(anl_nidx, intervals_redundancy), 2 );
    principle_region_anl(region, 5) = effectSize(v_p, v_n, 'c');
    [~, principle_anova_anl(region, 5)] = ttest2(v_p, v_n);
    
    
end

load('F:\THESIS\chanlocs.mat');
mean_of_subjs_p = mean(group_11p, 3);
mean_of_subjs_n = mean(group_11n, 3);
mean_of_subjs_diff = mean_of_subjs_p - mean_of_subjs_n;

mean_diff_signaling = mean( mean_of_subjs_diff(:, :), 2 );
figure;
topoplot(mean_diff_signaling, chanlocs, 'electrodes', 'labels');
c = cbar('vert',0,[-1 1]*max(abs(mean_diff_signaling)));
c.FontSize = 19;
c.FontWeight = 'bold';

% mean_diff_signaling = mean( mean_of_subjs_diff(:, intervals_signaling), 2 );
% figure;
% topoplot(mean_diff_signaling, chanlocs, 'electrodes', 'labels');
% c = cbar('vert',0,[-1 1]*max(abs(mean_diff_signaling)));
% c.FontSize = 19;
% c.FontWeight = 'bold';

% mean_diff_coherence = mean( mean_of_subjs_diff(:, intervals_coherence), 2 );
% figure;
% topoplot(mean_diff_coherence, chanlocs, 'electrodes', 'labels');
% c = cbar('vert',0,[-1 1]*max(abs(mean_diff_coherence)));
% c.FontSize = 19;
% c.FontWeight = 'bold';
% 
% mean_diff_temporal = mean( mean_of_subjs_diff(:, intervals_temporal), 2 );
% figure;
% topoplot(mean_diff_temporal, chanlocs, 'electrodes', 'labels');
% c = cbar('vert',0,[-1 1]*max(abs(mean_diff_temporal)));
% c.FontSize = 19;
% c.FontWeight = 'bold';
% 
% mean_diff_spatial = mean( mean_of_subjs_diff(:, intervals_spatial), 2 );
% figure;
% topoplot(mean_diff_spatial, chanlocs, 'electrodes', 'labels');
% c = cbar('vert',0,[-1 1]*max(abs(mean_diff_spatial)));
% c.FontSize = 19;
% c.FontWeight = 'bold';




