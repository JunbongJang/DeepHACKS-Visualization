function label_cluster = spatial_labeling_cell_by_cluster(label_cluster, windowing, time, cluster, dminpoolv, end_frame)
    num_window = length(windowing);
    for i = 1 : num_window
        vel = dminpoolv(i, :);
        if end_frame < 0
            len_vel = sum(~isnan(vel(1, 201:end)));
            label_cluster(windowing(i), time(i): time(i) + len_vel - 1) = cluster(1, i);
        else
            total_len_vel = sum(~isnan(vel(1, 201:end)));
            len_vel = sum(~isnan(vel(1, 201:end_frame)));
            label_cluster(windowing(i), time(i): time(i) + total_len_vel - 1) = -1;  % first color whole segment white
            label_cluster(windowing(i), time(i): time(i) + len_vel - 1) = cluster(1, i);  % 50 frames to cluster color
        end
    end
end