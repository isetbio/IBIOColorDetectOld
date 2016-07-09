function visualizeIsomerizationAndPhotocurrentSequences(theMosaic, timeAxis, renderVideo)
    % Determine ranges
    isomerizationRange = [min(theMosaic.absorptions(:)) max(theMosaic.absorptions(:))];
    photocurrentRange = [min(theMosaic.current(:)) max(theMosaic.current(:))];
    eyeMovementSequence = theMosaic.emPositions;
    
    hFig = figure(1); 
    set(hFig, 'Position', [10 10 1070 520], 'Color', [1 1 1]);
    clf; colormap(bone(1024));
    
    if (renderVideo)
        % Open video stream
        videoFilename = sprintf('IsomerizationsWithEyeMovements.m4v');
        writerObj = VideoWriter(videoFilename, 'MPEG-4'); % H264 format
        writerObj.FrameRate = 15; 
        writerObj.Quality = 100;
        writerObj.open();
    end
    
    mosaicXaxis = -theMosaic.cols/2:theMosaic.cols/2;
    mosaicYaxis = -theMosaic.rows/2:theMosaic.rows/2;
    for timeStep = 1:size(theMosaic.absorptions,3)
        subplot('Position', [0.01 0.03 0.45 0.94]);
        imagesc(mosaicXaxis, mosaicYaxis, theMosaic.absorptions(:,:,timeStep));
        hold on;
        idx = max([1 timeStep-100]);
        plot(eyeMovementSequence(idx:timeStep,1), -eyeMovementSequence(idx:timeStep,2), 'w-', 'LineWidth', 2.0);
        plot(eyeMovementSequence(idx:timeStep,1), -eyeMovementSequence(idx:timeStep,2), 'r.-');
        hold off;
        xlabel(sprintf('%2.0f microns (%2.2f deg)', theMosaic.width*1e6, theMosaic.fov(1)), 'FontSize', 14, 'FontName', 'Menlo');
        axis 'image'
        set(gca, 'CLim', isomerizationRange, 'XTick', [], 'YTick', []);
        hCbar = colorbar(); % 'Ticks', cbarStruct.ticks, 'TickLabels', cbarStruct.tickLabels);
        hCbar.Orientation = 'vertical'; 
        hCbar.Label.String = 'isomerization rate (R*/cone/sec)'; 
        hCbar.FontSize = 14; 
        hCbar.FontName = 'Menlo'; 
        hCbar.Color = [0.2 0.2 0.2];
        title(sprintf('isomerization map (t: %2.2f ms)', timeAxis(timeStep)*1000), 'FontSize', 16, 'FontName', 'Menlo');

        subplot('Position', [0.52 0.05 0.45 0.94]);
        imagesc(theMosaic.current(:,:,timeStep));
        xlabel(sprintf('%2.0f microns (%2.2f deg)', theMosaic.width*1e6, theMosaic.fov(1)), 'FontSize', 14, 'FontName', 'Menlo');
        axis 'image'
        set(gca, 'CLim', photocurrentRange, 'XTick', [], 'YTick', []);
        hCbar = colorbar(); % 'Ticks', cbarStruct.ticks, 'TickLabels', cbarStruct.tickLabels);
        hCbar.Orientation = 'vertical'; 
        hCbar.Label.String = 'photocurrent (pAmps)'; 
        hCbar.FontSize = 14; 
        hCbar.FontName = 'Menlo'; 
        hCbar.Color = [0.2 0.2 0.2];
        title(sprintf('photocurrent map (t: %2.2f ms)', timeAxis(timeStep)*1000), 'FontSize', 16, 'FontName', 'Menlo');

        drawnow;
        if (renderVideo)
            writerObj.writeVideo(getframe(hFig));
        end
    end
    if (renderVideo)
        writerObj.close();
    end
    fprintf('Movie saved in %s\n', videoFilename);
end
