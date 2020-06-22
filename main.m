% Created by Junbong Jang
% 6/15/2020 
% Loading, and organizing data for HACKS visualization

clear all;
close all;
% addpath(genpath('\\research.wpi.edu\leelab\Lab\Matlab'));

%% Define these parameters before running
data_granularity = 'Coarse'; % Coarse or FineGrained

% For edge and windowing evolution image and movie
edge_evolution_line_thickness = 1;
frame_interval = 5;
start_frame = 1;
end_frame = -1; % set it to -1 to generate movie until the last frame
video_format = '.avi';

% set the color for the different cluster.
HACKS_cmap = [[0,0,0];[37,22,5]/255;[193,193,193]/255; [178,189,126]/255; [116,156,117]/255; [238,51,119]/255];
deepHACKS_cmap = [[0,0,0];[37,22,5]/255;[193,193,193]/255;[51,187,238]/255; [178,189,126]/255; [116,156,117]/255; [233,217,133]/255; [238,51,119]/255; [0,0,0]];
FG_cluster_cmap = [[1,1,1];[37,22,5]/255;[193,193,193]/255;
    [79,245,250]/255;[51,94,238]/255;[130,60,161]/255;[51,187,238]/255;
    [233,217,133]/255; [178,189,126]/255; [116,156,117]/255; 
    [195,51,238]/255;[238,51,188]/255;[238,51,119]/255];

%% heejune data 6/3/2020
custom_table = readtable('assets/060320_ClusterHeatMap_pairedCyD.csv');
custom_table_cellnames = custom_table{:,1}';
custom_table_hacks_cluster = custom_table{:,2}';
custom_table_deephacks_cluster = custom_table{:,3}';
custom_table_deephacks_cluster = fillmissing(custom_table_deephacks_cluster,'constant',7);

% g3-1 case
% path_windowing = 'HeeJune\Image_Data\PtK1_CyD\Windowing\111017\';
% path_cluster = 'Chauncey\Projects\paper1\2017-11-19-pooled_paired_data_g3_g4\Case\results\protrusion_parameters\symbolic.feat.data.ratio.4.alpha.size.4dist_acf\0.46\4\cluster_assignment.mat';
% path_cellnames = 'Chauncey\Projects\paper1\2017-11-19-pooled_paired_data_g3_g4\Case.mat';
path_dminpool1 = 'Chauncey\Projects\paper1\2017-11-16-PtK1Data_g3_1\Case\results\larger_56\dminpool_more_56.mat';
% selected_cellnames = {'111017_PtK1_S01_1ml_CyD100_05';'111017_PtK1_S01_1ml_CyD100_07';'111017_PtK1_S01_1ml_CyD100_08-2';'111017_PtK1_S01_1ml_CyD100_08'};
% 
% g3-2 case
% path_windowing = 'HeeJune\Image_Data\PtK1_CyD\Windowing\111417\';
% path_cluster = 'Chauncey\Projects\paper1\2017-11-19-pooled_paired_data_g3_g4\Case\results\protrusion_parameters\symbolic.feat.data.ratio.4.alpha.size.4dist_acf\0.46\4\cluster_assignment.mat';
% path_cellnames = 'Chauncey\Projects\paper1\2017-11-19-pooled_paired_data_g3_g4\Case.mat';
path_dminpool2 = 'Chauncey\Projects\paper1\2017-11-17-PtK1Data_g3_2\Case\results\larger_56\dminpool_more_56.mat';
% selected_cellnames = {'111417_PtK1_S01_CyD100_03';'111417_PtK1_S01_CyD100_05';'111417_PtK1_S01_CyD100_07';'111417_PtK1_S01_CyD100_08'};

% g4 case
% path_windowing = 'HeeJune\Image_Data\PtK1_CyD\Windowing\111417\';
% path_cluster = 'Chauncey\Projects\paper1\2017-11-19-pooled_paired_data_g3_g4\Case\results\protrusion_parameters\symbolic.feat.data.ratio.4.alpha.size.4dist_acf\0.46\4\cluster_assignment.mat';
% path_cellnames = 'Chauncey\Projects\paper1\2017-11-19-pooled_paired_data_g3_g4\Case.mat';
path_dminpool3 = 'Chauncey\Projects\paper1\2017-11-18-PtK1Data_g4\Case\results\larger_56\dminpool_more_56.mat';
% selected_cellnames = {'111417_S02_CyD100_06';'111417_S02_CyD100_07';'111417_S02_CyD100_08';'111417_S02_CyD100_12'};

% g3-1 control
% path_windowing = 'HeeJune\Image_Data\PtK1_CyD\Windowing\111017\';
% path_cluster = 'Chauncey\Projects\paper1\2017-11-19-pooled_paired_data_g3_g4\Control\results\protrusion_parameters\symbolic.feat.data.ratio.4.alpha.size.4dist_acf\0.46\4\cluster_assignment.mat';
% path_cellnames = 'Chauncey\Projects\paper1\2017-11-19-pooled_paired_data_g3_g4\Control.mat';
path_dminpool4 = 'Chauncey\Projects\paper1\2017-11-16-PtK1Data_g3_1\Control\results\larger_56\dminpool_more_56.mat';
% selected_cellnames = {'111017_PtK1_S01_1ml_DMSO_05';'111017_PtK1_S01_1ml_DMSO_07';'111017_PtK1_S01_1ml_DMSO_08-2';'111017_PtK1_S01_1ml_DMSO_08'};

% g3-2 control
% path_windowing = 'HeeJune\Image_Data\PtK1_CyD\Windowing\111417\';
% path_cluster = 'Chauncey\Projects\paper1\2017-11-19-pooled_paired_data_g3_g4\Control\results\protrusion_parameters\symbolic.feat.data.ratio.4.alpha.size.4dist_acf\0.46\4\cluster_assignment.mat';
% path_cellnames = 'Chauncey\Projects\paper1\2017-11-19-pooled_paired_data_g3_g4\Control.mat';
path_dminpool5 = 'Chauncey\Projects\paper1\2017-11-17-PtK1Data_g3_2\Control\results\larger_56\dminpool_more_56.mat';
% selected_cellnames = {'111417_PtK1_S01_DMSO_03';'111417_PtK1_S01_DMSO_05';'111417_PtK1_S01_DMSO_07';'111417_PtK1_S01_DMSO_08'};

% g4 control
path_windowing = 'HeeJune\Image_Data\PtK1_CyD\Windowing\111417\';
% path_cluster = 'Chauncey\Projects\paper1\2017-11-19-pooled_paired_data_g3_g4\Control\results\protrusion_parameters\symbolic.feat.data.ratio.4.alpha.size.4dist_acf\0.46\4\cluster_assignment.mat';
% path_cellnames = 'Chauncey\Projects\paper1\2017-11-19-pooled_paired_data_g3_g4\Control.mat';
path_dminpool6 = 'Chauncey\Projects\paper1\2017-11-18-PtK1Data_g4\Control\results\larger_56\dminpool_more_56.mat';
selected_cellnames = {'111417_S02_DMSO_06';'111417_S02_DMSO_07';'111417_S02_DMSO_08';'111417_S02_DMSO_12'};


%% Fine Grained Accelerating / Bursting
% path_cluster_FG_Acc = 'Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-02-2020-Acceleration_DeepFeatures_Including_alldata\420 DMSO_CC_K_DeepFeatures_truncated_community.mat';
% path_total_FG_Acc = 'Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-02-2020-Acceleration_DeepFeatures_Including_alldata\Data_total.mat';
% path_cluster_FG_Burst = 'Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-03-2020-Bursting_DeepFeatures_Including_alldata\340 Bursting_K_DeepFeatures_truncated_community.mat';
% path_total_FG_Burst = 'Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-03-2020-Bursting_DeepFeatures_Including_alldata\Data_total.mat';

% path_windowing = 'Lab\Previous_data\Image_data_jj\';
% path_cluster = 'Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-10-2020-Florescence\ordered_cluster_label_K_260.mat';
% path_cellnames = 'Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-10-2020-Florescence\truncated_dataset.mat';
% path_dminpool = 'Chauncey\Projects\paper1-2\results\larger_56\dminpool_more_56.mat';
% selected_cellnames = {'Actin_dual_C5';'Actin_dual_C6';'Actin_dual_C7';'Actin_dual_C8';'Actin_dual_C11'};

% path_windowing = 'Lab\Previous_data\Image_data_jj\';
% path_cluster = 'Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-10-2020-Florescence\ordered_cluster_label_K_260.mat';
% path_cellnames = 'Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-10-2020-Florescence\truncated_dataset.mat';
% path_dminpool = 'Chauncey\Projects\paper1\2017-12-14-Ref_data_with_additional_arp3_GFP\Control\results\larger_56\dminpool_more_56.mat';
% selected_cellnames = {'new_Arp23_C1';'new_Arp23_C3'};

% path_windowing = 'QCI dropbox\Kwonmoo\Windowing\120217_CK666-CK689_not_Paired_50uM\';
% path_cluster = 'Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\03-29-2020-CK666\ordered_CK689_CK666_K_truncated_240_community.mat';
% %'Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\03-30-2020-DMSO_CyD\ordered_cluster_label_K_770.mat';
% path_cellnames = 'Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\03-29-2020-CK666\truncated_dataset.mat';
% path_dminpool = 'Chauncey\Projects\paper1\2017-12-15-arp23_inhibitor_50nm\Control\results\larger_56\dminpool_more_56.mat';
% % selected_cellnames = {'120217_S02_CK689_50uM_06'; '120217_S02_CK689_50uM_09'; '120217_S02_CK689_50uM_07'; '120217_S02_CK689_50uM_08'; '120217_S02_CK689_50uM_13'};
% selected_cellnames = {'120217_S02_CK689_50uM_03';'120217_S02_CK689_50uM_07'; '120217_S02_CK689_50uM_08'; '120217_S02_CK689_50uM_13'};

% path_windowing = 'QCI dropbox2\HeeJune (QCI)\Windowing\CyD 122217\';
% path_cluster = 'Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\03-30-2020-DMSO_CyD\ordered_cluster_label_K_770.mat';
% path_cellnames = 'Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\03-30-2020-DMSO_CyD\truncated_dataset.mat';
% path_dminpool = 'Chauncey\Projects\paper1\2017-12-26-CyD_50uM_patch2\Control\results\larger_56\dminpool_more_56.mat';
% selected_cellnames = {'122217_S02_DMSO_01'; '122217_S02_DMSO_05';'122217_S02_DMSO_06';'122217_S02_DMSO_07';'122217_S02_DMSO_08';'122217_S02_DMSO_09';'122217_S02_DMSO_11'; ...
%     '122217_S02_DMSO_12';'122217_S02_DMSO_14';'122217_S02_DMSO_16';'122217_S02_DMSO_17'};
%% Use paths defined above to load data
path_cluster = 'Chauncey\0_DeepHACKs\Paper_DeepHACKS_V3_10\paired_data_g3_g4\3_Clustering\ordered_cluster_label_K_270.mat';
path_cellnames = 'Chauncey\0_DeepHACKs\Paper_DeepHACKS_V3_10\paired_data_g3_g4\3_Clustering\data.mat';
root_path = '\\research.wpi.edu\leelab\';

path_windowing = [root_path, path_windowing];
path_cluster = [root_path, path_cluster];
path_cellnames = [root_path, path_cellnames];

%load the data and get the mean value
all_cluster = load(path_cluster);
% all_cluster = all_cluster.cl;
hacks_cluster = custom_table_hacks_cluster;
deephacks_cluster = all_cluster.ordered_cluster_label;

all_cellnames = load(path_cellnames);
all_cellnames = all_cellnames.truncated_Cell %.case_dminpoolc; %.control_dminpoolc;
% all_cellnames = custom_table_cellnames;

path_dminpool_list = {path_dminpool1, path_dminpool2, path_dminpool3, path_dminpool4, path_dminpool5, path_dminpool6};
all_dminpool = load_dminpool_list(root_path, path_dminpool_list);
    
    %%
%     if strcmp(data_granularity, 'FineGrained')
%         cluster_cmap = FG_cluster_cmap;
%         cluster_FG_Acc = load([root_path, path_cluster_FG_Acc]).cluster_label;
%         cluster_FG_Burst = load([root_path, path_cluster_FG_Burst]).cluster_label;
%         cellname_FG_Acc = load([root_path, path_total_FG_Acc]).Cellname_total;
%         cellname_FG_Burst = load([root_path, path_total_FG_Burst]).Cellname_total;
% 
%         if size(cluster_FG_Acc,1) ~= size(cellname_FG_Acc,2) || size(cluster_FG_Burst,1) ~= size(cellname_FG_Burst,2) 
%             ME = MException('ClusterData:LengthDifferent', 'Cluster and cellname not same length');
%             throw(ME)
%         end
%     end


%% One important function that creates the movie and cluster heatmaps
% just put loaded data into this function
make_all_movie_clusters(path_windowing, hacks_cluster, deephacks_cluster, all_cellnames, all_dminpool, selected_cellnames, ...
        edge_evolution_line_thickness, frame_interval, start_frame, end_frame, video_format, HACKS_cmap, deepHACKS_cmap, data_granularity);
    
%% helper function to combine multiple dminpool data into one
function merged_symbolic_dataset = load_dminpool_list(root_path, path_dminpool_list)
    % combine multiple symbolic datasets
    merged_symbolic_dataset = struct;
    for dminpool_index = 1:length(path_dminpool_list)
        a_path_dminpool = path_dminpool_list{1,dminpool_index};
        dminpool_more_56 = load([root_path, a_path_dminpool]);
        if dminpool_index == 1
            merged_symbolic_dataset = dminpool_more_56.dminpool_more_56;
        else
            symbolic_dataset = dminpool_more_56.dminpool_more_56;
            f = {'dminpoolt','dminpoolw','dminpoolc'};
            for i = 1:length(f)
                merged_symbolic_dataset.(f{i}) = [merged_symbolic_dataset.(f{i}), symbolic_dataset.(f{i})];
            end
            f = {'dminpoolv'};
            for i = 1:length(f)
                merged_symbolic_dataset.(f{i}) = [merged_symbolic_dataset.(f{i}); symbolic_dataset.(f{i})];
            end
        end
    end
end
    
