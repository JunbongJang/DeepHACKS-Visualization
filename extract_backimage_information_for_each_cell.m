function [time, windows, cluster, dminpoolv, duration_time] = extract_backimage_information_for_each_cell(symbolic_dataset, cell_marker, clusters)
%This function mainly extracted time and winow, clusters information for
%each cluster.

%find the sample from the sepcific cell based on the cell_marker;
cell_label = symbolic_dataset.dminpoolc;
num_samples = length(cell_label);
cell_index = zeros(1, num_samples);
for i = 1 : num_samples
    if strcmp(cell_label{i}, cell_marker)
        cell_index(1, i) = 1;
    end
end

cell_index = logical(cell_index);
time = symbolic_dataset.dminpoolt(1, cell_index);
windows = symbolic_dataset.dminpoolw(1, cell_index);
cluster = clusters(1, cell_index);
dminpoolv = symbolic_dataset.dminpoolv(cell_index,:);
duration_time = sum(~isnan(dminpoolv(:, 201:end)), 2);
