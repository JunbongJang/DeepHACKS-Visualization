% Created by Chauncey Wang
% Modified by Junbong Jang for Prof.Lee's chalktalk preparation
% 5/20/2020 
% Create a video of windowed edge evolution with different clusters in different colors.

function make_evolution_movie(movieData, windowing, time, clusters, N, duration_time, cluster_cmap, cell_name, video_format, frame_rate, savePath)

nFrame = movieData.nFrames_;

%%
%Use the raw data as the image directories.
imDir = movieData.getChannelPaths{1};
imDir = replace_root_path(imDir);
imNames = dir([imDir, '\*.tif']);
iWinProc = movieData.getProcessIndex('WindowingProcess', 1, 1);

% create video with image sequence
video_path = [savePath, '\..\', cell_name, '_video', video_format];
outputVideo = VideoWriter(video_path);
outputVideo.FrameRate = frame_rate;
open(outputVideo);

%Load the image(s).
for iFrame = 1 : nFrame
	fig = figure('visible','off','units','pixels','position',[0 0 1920 1080]);
    axis tight
    iFrame
    %load the image
    img = imread([imDir filesep imNames(iFrame, 1).name]);
    [row, col] = size(img);
    %normalize the intensity value.
    maxIm = max(img(:));
    minIm = min(img(:));
    img = (double(img) - double(repmat(minIm, row, col))) ./ double(maxIm - minIm);
    imgRGB(:,:,1) = img;
    imgRGB(:,:,2) = img;
    imgRGB(:,:,3) = img;
    imagesc(imgRGB), axis image, axis off;
    
    hold on;
    
    %get the windows
    windows_path = movieData.processes_{iWinProc}.outFilePaths_;
    windows_path = replace_root_path(windows_path);
    wins = load([windows_path, '\windows_frame__frame_', sprintf( '%03d', iFrame ) ]).windows;
    
    [m, nWin] = size(wins);
    imSize = size(imgRGB);
    
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
                    if range(windowsPoly(1,:))<3*movieData.processes_{iWinProc}.funParams_.ParaSize %why, I do not know
                          h = patch(windowsPoly(1,:), windowsPoly(2,:), cluster_cmap(clusters(1, index),:));
                        hold on;
                    end
                end
            end
        end 
        index = index + 1; 
    end 
    hold off;
    colormap(cluster_cmap);
    colorbar('Ticks',  linspace(0, 1, size(cluster_cmap,1)), 'YTickLabel', num2cell(1:size(cluster_cmap,1)));
%     saveas(gcf, fullfile(savePath, ['iFrame_' num2str(iFrame) '.tif']));
    
    F = getframe(gcf);
    [image, Map] = frame2im(F);
    writeVideo(outputVideo,image);
    close all;
end
close(outputVideo);
