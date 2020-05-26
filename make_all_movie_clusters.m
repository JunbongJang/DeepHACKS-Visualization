% Created by Chauncey Wang
% Modified by Junbong Jang for Prof.Lee's chalktalk preparation
% 5/18/2020 

% addpath(genpath('\\research.wpi.edu\leelab\Lab\Matlab'));
clear all;
close all;
%% Define these parameters before running
data_granularity = 'Coarse' % Coarse or FineGrained
path_windowing_package = 'WindowingPackage\protrusion_samples';
% Fine Grained Accelerating / Bursting
path_cluster_FG_Acc = '\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-02-2020-Acceleration_DeepFeatures_Including_alldata\420 DMSO_CC_K_DeepFeatures_truncated_community.mat';
path_total_FG_Acc = '\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-02-2020-Acceleration_DeepFeatures_Including_alldata\Data_total.mat';
path_cluster_FG_Burst = '\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-03-2020-Bursting_DeepFeatures_Including_alldata\340 Bursting_K_DeepFeatures_truncated_community.mat';
path_total_FG_Burst = '\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-03-2020-Bursting_DeepFeatures_Including_alldata\Data_total.mat';

% path_windowing = '\\research.wpi.edu\leelab\QCI dropbox\Kwonmoo\Windowing\120217_CK666-CK689_not_Paired_50uM\';
% path_cluster = '\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\03-29-2020-CK666\ordered_CK689_CK666_K_truncated_240_community.mat';
% %'\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\03-30-2020-DMSO_CyD\ordered_cluster_label_K_770.mat';
% path_truncated = '\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\03-29-2020-CK666\truncated_dataset.mat';
% path_dminpool = '\\research.wpi.edu\leelab\Chauncey\Projects\paper1\2017-12-15-arp23_inhibitor_50nm\Control\results\larger_56\dminpool_more_56.mat';
% my_cellnames = {'120217_S02_CK689_50uM_06'; '120217_S02_CK689_50uM_09'; '120217_S02_CK689_50uM_07'; '120217_S02_CK689_50uM_08'; '120217_S02_CK689_50uM_13'};
% my_cellnames = {'120217_S02_CK689_50uM_07'; '120217_S02_CK689_50uM_08'; '120217_S02_CK689_50uM_13'};

path_windowing = '\\research.wpi.edu\leelab\QCI dropbox2\HeeJune (QCI)\Windowing\CyD 122217\';
path_cluster = '\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\03-30-2020-DMSO_CyD\ordered_cluster_label_K_770.mat';
path_truncated = '\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\03-30-2020-DMSO_CyD\truncated_dataset.mat';
path_dminpool = '\\research.wpi.edu\leelab\Chauncey\Projects\paper1\2017-12-26-CyD_50uM_patch2\Control\results\larger_56\dminpool_more_56.mat';
% my_cellnames = {'122217_S02_DMSO_01'; '122217_S02_DMSO_02'; '122217_S02_DMSO_05';'122217_S02_DMSO_06';'122217_S02_DMSO_07';'122217_S02_DMSO_08';'122217_S02_DMSO_09'; ...
%'122217_S02_DMSO_11';'122217_S02_DMSO_12';'122217_S02_DMSO_14';'122217_S02_DMSO_16';'122217_S02_DMSO_17';'122217_S02_DMSO_20';'122217_S02_DMSO_21';'122217_S02_DMSO_22'};  % cell label 7
my_cellnames = {'122217_S02_DMSO_11';'122217_S02_DMSO_12';'122217_S02_DMSO_14';'122217_S02_DMSO_16';'122217_S02_DMSO_17'};  % cell label 7

% my_cellnames = {'122217_S02_DMSO_01'; '122217_S02_DMSO_05';'122217_S02_DMSO_06';'122217_S02_DMSO_07';'122217_S02_DMSO_08';'122217_S02_DMSO_09';'122217_S02_DMSO_11'; ...
%     '122217_S02_DMSO_12';'122217_S02_DMSO_14';'122217_S02_DMSO_16';'122217_S02_DMSO_17'};

%%
row = size(my_cellnames,1);

% set the color for the different cluster.
cluster_cmap = [[1,1,1];[37,22,5]/255;[193,193,193]/255;[51,187,238]/255; [233,217,133]/255; [178,189,126]/255; [116,156,117]/255; [238,51,119]/255];
FG_cluster_cmap = [[1,1,1];[37,22,5]/255;[193,193,193]/255;
    [79,245,250]/255;[51,94,238]/255;[130,60,161]/255;[51,187,238]/255;
    [233,217,133]/255; [178,189,126]/255; [116,156,117]/255; 
    [195,51,238]/255;[238,51,188]/255;[238,51,119]/255];

% For edge and windowing evolution image
edge_evolution_line_thickness = 1;
frame_interval = 10;
start_frame = 1;
end_frame = -1; % set it to -1 if you don't know

% For windowing evolution movie
video_format = '.avi';
frame_rate = 5;

saved_folder = ['.\windowing_edge_evolution\', data_granularity];
mkdir(saved_folder);

%%
%load the data and get the mean value
cluster_coarse = load(path_cluster);
truncated_cells = load(path_truncated);
cluster_FG_Acc = load(path_cluster_FG_Acc).cluster_label;
cluster_FG_Burst = load(path_cluster_FG_Burst).cluster_label;
cellname_FG_Acc = load(path_total_FG_Acc).Cellname_total;
cellname_FG_Burst = load(path_total_FG_Burst).Cellname_total;

if size(cluster_FG_Acc,1) ~= size(cellname_FG_Acc,2) || size(cluster_FG_Burst,1) ~= size(cellname_FG_Burst,2) 
    ME = MException('ClusterData:LengthDifferent', 'Cluster and cellname not same length');
    throw(ME)
end
cl = cluster_coarse.ordered_cluster_label;
num_cluster = max(cl(:));

%%
%load the symbolic_dataset.
dminpool_more_56 = load(path_dminpool);
symbolic_dataset = dminpool_more_56.dminpool_more_56;

%%
for i = 1 : row
    close all;
    i
    cell_name = my_cellnames{i,1};
    movieData = load([path_windowing, cell_name, '\movieData.mat']);
    movieData = movieData.MD;
    nFrame = movieData.nFrames_;
    if end_frame < 0 || end_frame > nFrame
        end_frame = nFrame;
    end
    frame_list = [start_frame : frame_interval: end_frame, end_frame];
    
    % call extract_backimage_information for each cell.
    
    %% get fine grained cluster labels
    if strcmp(data_granularity, 'FineGrained')
        cell_names = truncated_cells.Cellname_truncated;
        [time, windowing, cluster, dminpoolv, duration_time] = extract_backimage_information_for_each_cell(symbolic_dataset, cell_names, cell_name, cl, 251);
    
        burst_num = sum(cluster == 2);
        accel_num = sum(cluster == 6);
        cellname_burst_indices=find_cellname_indices(cell_name,cellname_FG_Burst);
        cellname_accel_indices=find_cellname_indices(cell_name,cellname_FG_Acc);
        if burst_num ~= size(cellname_burst_indices,2) || accel_num ~= size(cellname_accel_indices,2) 
            ME = MException('ClusterData:LengthDifferent', 'Cluster and cellname not same length');
            throw(ME)
        end
        cluster = orig_to_FG_cluster(cluster, cluster_FG_Burst(cellname_burst_indices), cluster_FG_Acc(cellname_accel_indices));
        cluster_cmap = FG_cluster_cmap;
    else
        cell_names = symbolic_dataset.dminpoolc;
        [time, windowing, cluster, dminpoolv, duration_time] = extract_backimage_information_for_each_cell(symbolic_dataset, cell_names, cell_name, cl, 251);
        
    end
    
    
    %% save time windowing cluster data
    savePath = [saved_folder, '\', cell_name];
    if exist(savePath) ~= 7
        mkdir(savePath);
    end
    save([saved_folder,'\', cell_name, '\time_windowing_cluster.mat'], 'time', 'windowing', 'cluster');
    
    %% make images and movies
    movie_cluster_cmap = cluster_cmap(3:end,:,:);  % since we don't need background color and white color for frames after 251
    make_evolution_movie(movieData, windowing, time, cluster, num_cluster, duration_time, movie_cluster_cmap, cell_name, video_format, frame_rate, savePath);
    make_evolution_image(movieData, windowing, time, cluster, num_cluster, duration_time, movie_cluster_cmap, frame_list, edge_evolution_line_thickness, savePath);

    %% protrusion and cluster heatmap
    [time, windowing, cluster, dminpoolv, duration_time] = extract_backimage_information_for_each_cell(symbolic_dataset, cell_names, cell_name, cl,-1);
    make_heatmap_image(cluster_cmap, windowing, time, cluster, dminpoolv, cell_name, path_windowing, path_windowing_package, saved_folder)

end

%% helper function to get indices of a speicfic cellname
function cellname_indices=find_cellname_indices(cell_name,cellname_FG)
    cellname_indices = [];
    cellname_counter = 1;
    for a_cellname = cellname_FG
        if strcmp(cell_name, a_cellname{1,1})
            cellname_indices = [cellname_indices, cellname_counter];
        end
        cellname_counter = cellname_counter + 1;
    end
end

%% original cluster label into fine grained labels
function cluster_all = orig_to_FG_cluster(cluster_coarse, cluster_FG_Burst,cluster_FG_Acc)
    cluster_all = [];
    cluster_all_counter = 1;
    cluster_FG_Acc_counter = 1;
    cluster_FG_Burst_counter = 1;
    for a_cluster_label = cluster_coarse
        new_cluster_label = 0;
        if a_cluster_label == 1
            new_cluster_label = 1;
        elseif a_cluster_label == 2  % bursting
            burst_cluster_label = cluster_FG_Burst{cluster_FG_Burst_counter,1};
            new_cluster_label = 1 + str2num(burst_cluster_label);
            cluster_FG_Burst_counter = cluster_FG_Burst_counter + 1;
        elseif a_cluster_label == 3  % periodic
            new_cluster_label = 6;
        elseif a_cluster_label == 4
            new_cluster_label = 7;
        elseif a_cluster_label == 5
            new_cluster_label = 8;
        elseif a_cluster_label == 6  % accelerating
            accel_cluster_label = cluster_FG_Acc{cluster_FG_Acc_counter,1};
            new_cluster_label = 8 + str2num(accel_cluster_label);
            cluster_FG_Acc_counter = cluster_FG_Acc_counter + 1;
        end
        cluster_all(cluster_all_counter) = new_cluster_label;
        cluster_all_counter = cluster_all_counter + 1;
    end
end
