%% Created by Chauncey Wang
% Modified by Junbong Jang for HACKS visualization
% 5/18/2020 

function make_all_movie_clusters(path_windowing, input_HACKS_cluster, input_deepHACKS_cluster, all_cellnames, all_dminpool, unique_cellnames, ...
        edge_evolution_line_thickness, frame_interval, start_frame, end_frame, video_format, HACKS_cmap, deepHACKS_cmap, data_granularity)
    saved_folder = ['.\windowing_edge_evolution\', 'paired_CyD_DMSO', '_', data_granularity];
    mkdir(saved_folder);
    
    %%
    for i = 1 : size(unique_cellnames,1)
        close all;
        i
        cell_name = unique_cellnames{i,1}
        dminpool_cellnames_len = sum(strcmp(all_dminpool.dminpoolc, cell_name) );
        truncated_cellnames_len = sum(strcmp(all_cellnames, cell_name) );
        if dminpool_cellnames_len == truncated_cellnames_len
            cell_names = all_cellnames;
            movieData = load([path_windowing, cell_name, '\movieData.mat']);
            movieData = movieData.MD;
            nFrame = movieData.nFrames_;
            if end_frame < 0 || end_frame > nFrame
                end_frame = nFrame;
            end
            frame_list = [start_frame : frame_interval: end_frame, end_frame];

            % call extract_backimage_information for each cell.
            [time, windowing, HACKS_cluster, dminpoolv, duration_time] = extract_backimage_information_for_each_cell(all_dminpool, cell_names, cell_name, input_HACKS_cluster, 251);
            [time, windowing, deepHACKS_cluster, dminpoolv, duration_time] = extract_backimage_information_for_each_cell(all_dminpool, cell_names, cell_name, input_deepHACKS_cluster, 251);
            
            %% get fine grained cluster labels
%             if strcmp(data_granularity, 'FineGrained')
%                 [time, windowing, cluster, dminpoolv, duration_time] = extract_backimage_information_for_each_cell(all_dminpool, cell_names, cell_name, all_cluster, 251);
% 
%                 burst_num = sum(cluster == 2);
%                 accel_num = sum(cluster == 6);
%                 cellname_burst_indices=find_cellname_indices(cell_name,cellname_FG_Burst);
%                 cellname_accel_indices=find_cellname_indices(cell_name,cellname_FG_Acc);
%                 if burst_num ~= size(cellname_burst_indices,2) || accel_num ~= size(cellname_accel_indices,2) 
%                     ME = MException('ClusterData:LengthDifferent', 'Cluster and cellname not same length');
%                     throw(ME)
%                 end
%                 cluster = orig_to_FG_cluster(cluster, cluster_FG_Burst(cellname_burst_indices), cluster_FG_Acc(cellname_accel_indices));
%             end
            %% save time windowing cluster data
            save_path = [saved_folder, '\', cell_name];
            if exist(save_path) ~= 7
                mkdir(save_path);
            end
%             save([saved_folder,'\', cell_name, '\time_windowing_cluster.mat'], 'time', 'windowing', 'cluster');

            %% make images and movies
            movie_HACKS_cmap = HACKS_cmap(3:end,:,:);  % since we don't need background color and white color for frames after 251
            movie_deepHACKS_cmap = deepHACKS_cmap(3:end,:,:);
            
            make_evolution_movie(movieData, windowing, time, HACKS_cluster, duration_time, movie_HACKS_cmap, cell_name, video_format, frame_interval, save_path, 'HACKS');
            make_evolution_movie(movieData, windowing, time, deepHACKS_cluster, duration_time, movie_deepHACKS_cmap, cell_name, video_format, frame_interval, save_path, 'deepHACKS');
            make_evolution_image(movieData, windowing, time, HACKS_cluster, deepHACKS_cluster, duration_time, movie_HACKS_cmap, movie_deepHACKS_cmap, frame_list, edge_evolution_line_thickness, save_path);
            %% protrusion and cluster heatmap
            path_windowing_package = 'WindowingPackage\protrusion_samples';
            make_heatmap_image(HACKS_cmap, deepHACKS_cmap, windowing, time, HACKS_cluster, deepHACKS_cluster, dminpoolv, cell_name, path_windowing, path_windowing_package, save_path)

        end
    end
end

%% helper function to get indices of a speicfic cellname
function cellname_indices = find_cellname_indices(cell_name,cellname_FG)
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
function cluster_all = orig_to_FG_cluster(all_cluster, cluster_FG_Burst,cluster_FG_Acc)
    cluster_all = [];
    cluster_all_counter = 1;
    cluster_FG_Acc_counter = 1;
    cluster_FG_Burst_counter = 1;
    for a_cluster_label = all_cluster
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
