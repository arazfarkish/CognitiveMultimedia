% intro steps
signals_path = "C:\Users\arazf\Desktop\AMIR";
eeglab_path = "F:\THESIS\eeglab2020_0";
addpath(eeglab_path);

cd(signals_path);
subjects_dir = dir(signals_path);
subjects_names = [subjects_dir(3:end).name, " "];
disp(subjects_names);

expression = '(6|11)(n|p)_raw\.mat';
for subj=1:length(subjects_dir)
    subject = char(subjects_dir(subj).name);
    subject_path = signals_path + "\" + subject;
    cd(subject_path);
    
    disp(["Entered ", subject]);
    
    subject_dir = dir(subject_path);
    subject_files = [subject_dir(3:end).name, " "];
    disp(subject_files);
    
    for filei=3:length(subject_dir)
        
        file_name = char(subject_dir(filei).name);
        [tokens,matches] = regexp(file_name,expression,'tokens','match');
        if (~isempty(matches))
            disp(["Processing", file_name]);
            
            file_path = subject_path + "\" + file_name;
            
            % setup
            eeglab nogui;

            video_number = tokens{1}{1};
            video_type = tokens{1}{2};
            set_name = [video_number,video_type];

            EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',file_path,'setname',set_name,'srate',1000,'pnts',0,'xmin',0);
            EEG = pop_chanedit(EEG, 'load',{'F:\\THESIS\\electrode_locations_29.txt','filetype','loc'});

            % filter [1 45]
            EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',45,'plotfreqz',0);

            % compute median as initial reference
            EEG_temp = EEG;
            data = EEG_temp.data;
            med_data = median(data);
            data = data - med_data;
            EEG_temp.data = data;

            % loop to find the true reference signal
            bad_channels = [];
            while 1
                removed_channels = [];
                EEG_channsremoved = pop_clean_rawdata(EEG_temp, 'FlatlineCriterion',4,'ChannelCriterion',0.85,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion','off','WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
                if (isfield(EEG_channsremoved.etc, 'clean_channel_mask'))
                    removed_channels = find(EEG_channsremoved.etc.clean_channel_mask==0);
                end
                previous_bad = bad_channels;
                bad_channels = union(bad_channels, removed_channels);
                if (isequal(bad_channels, previous_bad))
                    break;
                end

                EEG_interpolated = eeg_interp(EEG, bad_channels, 'spherical');
                interpolated_mean = mean(EEG_interpolated.data);
                EEG_temp.data = EEG.data - interpolated_mean;
            end

            EEG_temp = eeg_interp(EEG, bad_channels, 'spherical');
            reference_signal = mean(EEG_temp.data);
            EEG.data = EEG.data - reference_signal;

            % detect bad channels
            EEG_channsremoved = pop_clean_rawdata(EEG, 'FlatlineCriterion',4,'ChannelCriterion',0.85,'LineNoiseCriterion',4,'Highpass','off','BurstCriterion','off','WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
            bad_channels = [];
            if (isfield(EEG_channsremoved.etc, 'clean_channel_mask'))
                bad_channels = find(EEG_channsremoved.etc.clean_channel_mask==0);
            end

            % corrected signal
            EEG_asr = pop_clean_rawdata(EEG_channsremoved, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',10,'WindowCriterion','off','BurstRejection','off','Distance','Euclidian');
            EEG_interpolated = eeg_interp(EEG_asr, EEG.chanlocs, 'spherical');
            EEG = pop_reref( EEG_interpolated, []);

            % ICA for corrected signal
            EEG = pop_runica(EEG, 'icatype', 'binica', 'extended',1);
            EEG = pop_iclabel(EEG, 'default');
            EEG = pop_icflag(EEG, [NaN NaN;0.5 1;0.5 1;NaN NaN;NaN NaN;0.7 1;0.7 1]);
            rejected = find(EEG.reject.gcompreject==1);
            EEG = pop_subcomp( EEG, rejected, 0);
            final_corrected = EEG.data;
            save([set_name, '_corrected'], "final_corrected");
%             pop_eegplot( EEG, 1, 1, 1);

%             % cut signal
%             EEG = pop_clean_rawdata(EEG_channsremoved, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',10,'WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 5] );
% 
%             % ICA for cut signal
%             EEG = pop_runica(EEG, 'icatype', 'binica', 'extended',1);
%             EEG = pop_iclabel(EEG, 'default');
%             EEG = pop_icflag(EEG, [NaN NaN;0.5 1;0.5 1;NaN NaN;NaN NaN;0.7 1;0.7 1]);
%             rejected = find(EEG.reject.gcompreject==1);
%             EEG = pop_subcomp( EEG, rejected, 0);
%             final_cut = EEG.data;
%             save([set_name, '_cut'], "final_cut");
%             event_ = EEG.event;
%             save([set_name, '_event'], "event_");
%             save([set_name, '_badchannels'], "bad_channels");
% %             bad_json(subject, set_name, bad_channels, EEG.event);
% %             pop_eegplot( EEG, 1, 1, 1);

            clc;
        end
        
    end
end
