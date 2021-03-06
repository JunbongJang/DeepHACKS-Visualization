% Created by Chauncey Wang
% Modified by Junbong Jang for Prof.Lee's chalktalk preparation
% 5/18/2020 
% Draw windows and edge evolution image with clusters in different colors.

function make_evolution_image(movieData, windowing, time, HACKS_cluster, deepHACKS_cluster, duration_time, movie_HACKS_cmap, movie_deepHACKS_cmap, frame_list, edge_evolution_line_thickness, savePath, hacks_type)
%Use the raw data as the image directories.
iWinProc = movieData.getProcessIndex('WindowingProcess', 1, 1);
imDir = movieData.getChannelPaths{1};
imDir = replace_root_path(imDir);
imNames = dir([imDir, '\*.tif']);

%load the image
img = imread([imDir filesep imNames(frame_list(1,1), 1).name]);
[row, col] = size(img);
img = normalizeIntensity(img, row, col);

imgRGB(:,:,1) = img;
imgRGB(:,:,2) = img;
imgRGB(:,:,3) = img;

fig = figure(1)  
imagesc(imgRGB), axis image, axis off;
edgeEvolution(movieData, imgRGB, row, col, edge_evolution_line_thickness, frame_list, savePath)

fig = figure(2)   
imagesc(imgRGB), axis image, axis off;
windowingEvolution(movieData, imgRGB, row, col, edge_evolution_line_thickness, windowing, time, HACKS_cluster, duration_time, movie_HACKS_cmap, iWinProc, frame_list, savePath, 'HACKS');

fig = figure(3)   
imagesc(imgRGB), axis image, axis off;
windowingEvolution(movieData, imgRGB, row, col, edge_evolution_line_thickness, windowing, time, deepHACKS_cluster, duration_time, movie_deepHACKS_cmap, iWinProc, frame_list, savePath, 'deepHACKS');

end
%%
function edgeEvolution(movieData, imgRGB, row, col, edge_evolution_line_thickness, frame_list, savePath)
    mask_path = [movieData.processes_{1,2}.outFilePaths_{1,1}, '\'];
    mask_path = replace_root_path(mask_path)
    mask_file_names = dir([mask_path, '*.tif']);
    
    color_grad = colormap(jet(length(frame_list)));
    for_loop_counter = 1
    for iFrame = frame_list
        disp(iFrame)
        %% Extracting the boundary of edge from Mask
        patch_name = mask_file_names(iFrame, 1).name;
        mask_region = imread([mask_path, patch_name]);
        mask = extract_edge(mask_region, 0);
        mask = imresize(mask, size(imgRGB,1,2));
        mask = normalizeIntensity(mask, row, col);

        %% Visualization of Edge Evolution
        se = strel('square',edge_evolution_line_thickness);
        BW2_mask = imdilate(mask,se);
        
        red_mask = BW2_mask*color_grad(for_loop_counter,1);
        green_mask = BW2_mask*color_grad(for_loop_counter,2);
        blue_mask = BW2_mask*color_grad(for_loop_counter,3);
        for_loop_counter = for_loop_counter + 1;
        
        imgRGB(:, :, 1) = imgRGB(:, :, 1) + red_mask;
        imgRGB(:, :, 2) = imgRGB(:, :, 2) + green_mask;
        imgRGB(:, :, 3) = imgRGB(:, :, 3) + blue_mask;
        imshow(imgRGB)
    end
    colormap(color_grad)
    colorbar('YTick', linspace(0, 1, length(frame_list)), 'YTickLabel', frame_list)
    saveas(gcf, [savePath, '\edge_evolution.png']);
end

%%
function windowingEvolution(movieData, imgRGB, row, col, edge_evolution_line_thickness, windowing, time, clusters, duration_time, cluster_cmap, iWinProc, frame_list, savePath, hacks_type) 
    mask_path = [movieData.processes_{1,2}.outFilePaths_{1,1}, '\'];
    mask_path = replace_root_path(mask_path)
    mask_file_names = dir([mask_path, '*.tif']);
    
    mask_loop_counter = 1;
    window_index_indicator = 0;
    
    for iFrame = frame_list
        disp(iFrame)
        
        %% Extracting the boundary of edge from Mask
        patch_name = mask_file_names(iFrame, 1).name;
        mask_region = imread([mask_path, patch_name]);
        mask = extract_edge(mask_region, 0);
        mask = imresize(mask, size(imgRGB,1,2));
        mask = normalizeIntensity(mask, row, col);

        %% Visualization of Edge Evolution
        se = strel('square',edge_evolution_line_thickness);
        BW2_mask = imdilate(mask,se);
        
        red_mask = BW2_mask*mask_loop_counter/length(frame_list);
        mask_loop_counter = mask_loop_counter + 1;
        
        %% Get the windows
        windows_path = movieData.processes_{iWinProc}.outFilePaths_;
        windows_path = replace_root_path(windows_path);
        wins = load([windows_path, '\windows_frame__frame_', sprintf( '%03d', iFrame ) ]).windows;
        window_exist = 0;
        
        %for each window in a frame, draw patch with corresponding cluster label
        index = 1;
        %indexed by windows
        for iWin = windowing
            
            %check whether the protrusion oneset starts or not
            if (time(index) <= iFrame) && (time(index) + duration_time(index, 1) >= iFrame )
                if length(wins)>=iWin && ~isempty(wins{iWin})
                    if ~isempty(wins{iWin}{1})
                        windowsPoly = [wins{iWin}{1}{:}];
                        if range(windowsPoly(1,:))<3*movieData.processes_{iWinProc}.funParams_.ParaSize
                            window_exist = 1;
%                             draw window index text in the image
%                             if window_index_indicator == 0
%                                 imgRGB = insertText(imgRGB,[windowsPoly(1,1), windowsPoly(2,1)],'start                 ','AnchorPoint','Center','BoxColor','red','BoxOpacity',0.4,'FontSize',8,'TextColor','white');
%                                 window_index_indicator = 1;
%                             end
                            break;
                        end
                    end
                end
            end 
            index = index + 1;
        end
        
        if window_exist
            imgRGB(:, :, 1) = imgRGB(:, :, 1) + red_mask;
            imgRGB(:, :, 2) = imgRGB(:, :, 2) + red_mask;
            imgRGB(:, :, 3) = imgRGB(:, :, 3) + red_mask;
        end
        imshow(imgRGB)
    end

    for iFrame = frame_list
        %% Get the windows
        windows_path = movieData.processes_{iWinProc}.outFilePaths_;
        windows_path = replace_root_path(windows_path);
        wins = load([windows_path, '\windows_frame__frame_', sprintf( '%03d', iFrame ) ]).windows;
    %     wins = movieData.processes_{iWinProc}.loadChannelOutput(iFrame);
        iFrame
        %for each frame and window, draw different sample and different
        %cluster.    
        index = 1;
        %indexed by windows
        for iWin = windowing
            
            %check whether the protrusion oneset starts or not
            if (time(index) <= iFrame) && (time(index) + duration_time(index, 1) >= iFrame )
                if length(wins)>=iWin && ~isempty(wins{iWin})
                    if ~isempty(wins{iWin}{1})
                        windowsPoly = [wins{iWin}{1}{:}];
                        if range(windowsPoly(1,:))<3*movieData.processes_{iWinProc}.funParams_.ParaSize
                              h = patch(windowsPoly(1,:), windowsPoly(2,:), cluster_cmap(clusters(1, index),:));
                        end
                    end
                end
            end 
            
            index = index + 1; 
        end 
    end
    colormap(cluster_cmap)
    colorbar('Ticks',  linspace(0, 1, size(cluster_cmap,1)), 'YTickLabel', num2cell(1:size(cluster_cmap,1)))
    saveas(gcf, [savePath, '\windowing_evolution_', hacks_type, '.png']);
end

%%
function normalized_img = normalizeIntensity(img, row, col)
    maxIm = max(img(:));
    minIm = min(img(:));
    normalized_img = (double(img) - double(repmat(minIm, row, col))) ./ double(maxIm - minIm);
end
