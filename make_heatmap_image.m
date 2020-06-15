% Author Junbong Jang
% 5/26/2020

%%
function make_heatmap_image(HACKS_cmap, deepHACKS_cmap, windowing, time, HACKS_cluster, deepHACKS_cluster, dminpoolv, cell_name, path_windowing, path_windowing_package, saved_folder)
    protSamples = load(fullfile(fullfile(fullfile(path_windowing, cell_name), path_windowing_package), 'protrusion_samples.mat'));
    vel = protSamples.protSamples.avgNormal;
    
    velocity_heatmap_example_fig = openfig('velocity_heatmap_colorbar_052020.fig','invisible');
    velocity_cmap = get(velocity_heatmap_example_fig,'Colormap'); 
    
    figure(3)
    font = 'Arial';
    set(gcf, 'Position', [10 10 1800 600],'DefaultTextFontName', font, 'DefaultAxesFontName', font);
    sgtitle(cell_name, 'interpreter', 'none','FontSize',20);
    
    ax1 = subplot(1,5,1);
    draw_protrusion_heatmap(ax1, velocity_cmap, vel)
    ax2 = subplot(1,5,2);
    draw_cluster_heatmap(ax2, HACKS_cmap, vel, windowing, time, HACKS_cluster, dminpoolv, -1, 'HACKS Protrusion Phenotypes')
    ax3 = subplot(1,5,3);
    draw_cluster_heatmap(ax3, deepHACKS_cmap, vel, windowing, time, deepHACKS_cluster, dminpoolv, -1, 'DeepHAKCS Protrusion Phenotypes')
    ax4 = subplot(1,5,4);
    draw_cluster_heatmap(ax4, HACKS_cmap, vel, windowing, time, HACKS_cluster, dminpoolv, 251, 'HACKS Protrusion Phenotypes(Full Segment)')
    ax5 = subplot(1,5,5);
    draw_cluster_heatmap(ax5, deepHACKS_cmap, vel, windowing, time, deepHACKS_cluster, dminpoolv, 251, 'DeepHAKCS Protrusion Phenotypes(Full Segment)')
    
    saveas(gcf, [saved_folder, '\', cell_name, '\protrusion_velocity_phenotype_cluster.fig']);
    saveas(gcf, [saved_folder, '\', cell_name, '\protrusion_velocity_phenotype_cluster.png']);
end

%%
function draw_protrusion_heatmap(ax, velocity_cmap, vel)
    imagesc(ax, vel, [-10,10]);
    xlabel('frame');
    ylabel('window index');
    t = title('Velocity','FontSize',16,'fontweight','normal');

    colormap(velocity_cmap)
    colorbar
end

function draw_cluster_heatmap(ax, cluster_cmap, vel, windowing, time, cluster, dminpoolv, end_frame, title_str)
    phenotype_cluster = zeros(size(vel));
    phenotype_cluster = spatial_labeling_cell_by_cluster(phenotype_cluster, windowing, time, cluster, dminpoolv, end_frame);

    imagesc(ax, phenotype_cluster, [-1,size(cluster_cmap,1)-1]);
    xlabel('frame');
    ylabel('window index');
    title(title_str,'FontSize',16,'fontweight','normal');
    
    colormap(gca,cluster_cmap)
    colorbar
end