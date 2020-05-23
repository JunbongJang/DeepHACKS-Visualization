% Created by Chauncey Wang
% Modified by Junbong Jang for Prof.Lee's chalktalk preparation
% 5/18/2020 

% addpath(genpath('\\research.wpi.edu\leelab\Lab\Matlab'));
clear all;
close all;
%% Define these parameters before running
path_windowing = '\\research.wpi.edu\leelab\QCI dropbox\Kwonmoo\Windowing\120217_CK666-CK689_not_Paired_50uM\';
path_windowing_package = 'WindowingPackage\protrusion_samples';
path_cluster = '\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\03-30-2020-DMSO_CyD\ordered_cluster_label_K_770.mat';

% Fine Grained Accelerating / Bursting
path_cluster_FG_Acc = '\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-02-2020-Acceleration_DeepFeatures_Including_alldata\420 DMSO_CC_K_DeepFeatures_truncated_community.mat'
path_total_FG_Acc = '\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-02-2020-Acceleration_DeepFeatures_Including_alldata\Data_total.mat'

path_cluster_FG_Burst = '\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-03-2020-Bursting_DeepFeatures_Including_alldata\340 Bursting_K_DeepFeatures_truncated_community.mat'
path_total_FG_Burst = '\\research.wpi.edu\leelab\Chauncey\Projects\Paper_DeepHACKS_V3_10\Data_analysis_each_EXP\05-03-2020-Bursting_DeepFeatures_Including_alldata\Data_total.mat'

path_dminpool = '\\research.wpi.edu\leelab\Chauncey\Projects\paper1\2017-12-15-arp23_inhibitor_50nm\Control\results\larger_56\dminpool_more_56.mat';
cellnames = {'120217_S02_CK689_50uM_06'; '120217_S02_CK689_50uM_09'};
row = size(cellnames,1);

% set the color for the different cluster.
%cluster_cmap = [[1,1,1];[37,22,5]/255;[193,193,193]/255;[51,187,238]/255; [233,217,133]/255; [178,189,126]/255; [116,156,117]/255; [238,51,119]/255];
cluster_cmap = [[1,1,1];[37,22,5]/255;[193,193,193]/255;
    [79,245,250]/255;[51,94,238]/255;[130,60,161]/255;[51,187,238]/255;
    [233,217,133]/255; [178,189,126]/255; [116,156,117]/255; 
    [195,51,238]/255;[238,51,188]/255;[238,51,119]/255];

% For edge and windowing evolution image
edge_evolution_line_thickness = 1;
frame_interval = 10;
start_frame = 100;
end_frame = 200; % set it to -1 if you don't know

% For windowing evolution movie
video_format = '.avi';
frame_rate = 5;

saved_folder = '.\windowing_edge_evolution';
mkdir(saved_folder);

%%
%load the data and get the mean value
cluster_all_old = load(path_cluster).ordered_cluster_label;
cluster_FG_Acc = load(path_cluster_FG_Acc).cluster_label;
cluster_FG_Burst = load(path_cluster_FG_Burst).cluster_label;
cellname_FG_Acc = load(path_total_FG_Acc).Cellname_total;
cellname_FG_Burst = load(path_total_FG_Burst).Cellname_total;

if size(cluster_FG_Acc,1) ~= size(cellname_FG_Acc,2) || size(cluster_FG_Burst,1) ~= size(cellname_FG_Burst,2) 
    ME = MException('ClusterData:LengthDifferent', 'Cluster and cellname not same length');
    throw(ME)
end
cl = cluster_all_old;
num_cluster = max(cl(:));

%%
%load the symbolic_dataset.
dminpool_more_56 = load(path_dminpool);
symbolic_dataset = dminpool_more_56.dminpool_more_56;

%%
for i = 1 : 1 %row
    i
    cell_name = cellnames{i,1};
    movieData = load([path_windowing, cell_name, '\movieData.mat']);
    movieData = movieData.MD;
    nFrame = movieData.nFrames_;
    if end_frame < 0 || end_frame > nFrame
        end_frame = nFrame;
    end
    frame_list = [start_frame : frame_interval: end_frame];
    
    % call extract_backimage_information for each cell.
    [time, windowing, cluster, dminpoolv, duration_time] = extract_backimage_information_for_each_cell(symbolic_dataset, cell_name, cl);
    
    %% get fine grained cluster labels
    burst_num = sum(cluster == 2)
    accel_num = sum(cluster == 6)
    cellname_burst_indices=find_cellname_indices(cell_name,cellname_FG_Burst);
    cellname_accel_indices=find_cellname_indices(cell_name,cellname_FG_Acc);
    
    FG_cluster = orig_to_FG_cluster(cluster, cluster_FG_Burst(cellname_burst_indices), cluster_FG_Acc(cellname_accel_indices));
    
    %% save time windowing cluster data
    savePath = [saved_folder '\', cell_name];
    if exist(savePath) ~= 7
        mkdir(savePath);
    end
    save([saved_folder,'\', cell_name, '\time_windowing_cluster.mat'], 'time', 'windowing', 'cluster');
    
    %% make images and movies
    movie_cluster_cmap = cluster_cmap(3:end,:,:);  % since we don't need background color and white color for frames after 251
%     make_evolution_movie(movieData, windowing, time, FG_cluster, num_cluster, duration_time, movie_cluster_cmap, cell_name, video_format, frame_rate, savePath);
    make_evolution_image(movieData, windowing, time, FG_cluster, num_cluster, duration_time, movie_cluster_cmap, frame_list, edge_evolution_line_thickness, savePath);

    %% protrusion and cluster heatmap
%     protSamples = load(fullfile(fullfile(fullfile(path_windowing, cell_name), path_windowing_package), 'protrusion_samples.mat'));
%     vel = protSamples.protSamples.avgNormal;
%     
%     figure(3)
%     font = 'Arial';
%     set(gcf, 'Position', [10 10 1800 600],'DefaultTextFontName', font, 'DefaultAxesFontName', font);
%     sgtitle(cell_name, 'interpreter', 'none','FontSize',20);
%     
%     subplot(1,3,1);
%     draw_protrusion_heatmap(vel, cell_name, saved_folder)
%     subplot(1,3,2);
%     draw_cluster_heatmap(cluster_cmap, vel, windowing, time, cluster, dminpoolv, cell_name, saved_folder, -1, '')
%     subplot(1,3,3);
%     draw_cluster_heatmap(cluster_cmap, vel, windowing, time, cluster, dminpoolv, cell_name, saved_folder, 251, [newline, '(selected timeseries)'])
%     
%     saveas(gcf, [saved_folder, '\', cell_name, '\protrusion_velocity_phenotype_cluster.fig']);
%     saveas(gcf, [saved_folder, '\', cell_name, '\protrusion_velocity_phenotype_cluster.png']);
    
end

%% helper function to get indices of a speicfic cellname
function cellname_indices=find_cellname_indices(cell_name,cellname_FG)
    cellname_indices = []
    cellname_counter = 1
    for a_cellname = cellname_FG
        if strcmp(cell_name, a_cellname{1,1})
            cellname_indices = [cellname_indices, cellname_counter];
        end
        cellname_counter = cellname_counter + 1;
    end
end

%% original cluster label into fine grained labels
function cluster_all = orig_to_FG_cluster(cluster_all_old, cluster_FG_Burst,cluster_FG_Acc)
    cluster_all = [];
    cluster_all_counter = 1;
    cluster_FG_Acc_counter = 1;
    cluster_FG_Burst_counter = 1;
    for a_cluster_label = cluster_all_old
        new_cluster_label = 0;
        if a_cluster_label == 1
            new_cluster_label = 1;
        elseif a_cluster_label == 2  % bursting
            burst_cluster_label = cluster_FG_Burst{cluster_FG_Burst_counter,1};
            new_cluster_label = 1 + str2num(burst_cluster_label);
            cluster_FG_Burst_counter = cluster_FG_Burst_counter + 1
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

%%
function draw_protrusion_heatmap(vel, cell_name, saved_folder)
    imagesc(vel, [-10,10]);
    xlabel('frame');
    ylabel('window index');
    t = title('Velocity','FontSize',16,'fontweight','normal');
    velocity_heatmap_example_fig = openfig('velocity_heatmap_colorbar_052020.fig','invisible');
    velocity_heatmap_cmap = get(velocity_heatmap_example_fig,'Colormap'); 

    colormap(velocity_heatmap_cmap)
    colorbar
%     saveas(gcf, [saved_folder, '\', cell_name, '\protrusion_velocity.fig']);
%     saveas(gcf, [saved_folder, '\', cell_name, '\protrusion_velocity.png']);
end

function draw_cluster_heatmap(cluster_cmap, vel, windowing, time, cluster, dminpoolv, cell_name, saved_folder, end_frame, version_str)
    phenotype_cluster = zeros(size(vel));
    phenotype_cluster = spatial_labeling_cell_by_cluster(phenotype_cluster, windowing, time, cluster, dminpoolv, end_frame);

    imagesc(phenotype_cluster, [-1,size(cluster_cmap,1)-1]);
    xlabel('frame');
    ylabel('window index');
    title(['Protrusion phenotypes', version_str],'FontSize',16,'fontweight','normal');
    colormap(gca,cluster_cmap)
    colorbar   

%     save([saved_folder, '\', cell_name, '\protrusion_phenotype_cluster_',version_str,'.mat'], 'phenotype_cluster');
%     saveas(gcf, [saved_folder, '\', cell_name, '\protrusion_phenotype_cluster_',version_str,'.fig']);
%     saveas(gcf, [saved_folder, '\', cell_name, '\protrusion_phenotype_cluster_',version_str,'.png']);
end