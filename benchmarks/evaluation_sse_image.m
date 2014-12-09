function [sumXYSSE, sumRGBSSE] = evaluation_sse_image(inFile, gtFile, imgFile, evFile9)
% function [sumXYSSE, sumRGBSSE] = evaluation_sse_image(inFile, gtFile, imgFile, evFile9)
%
% Calcualtes the sum of squared error of the x,y cooridnated and the RGB
% color.
%
% INPUT
%	inFile:     a collection of segmentations in a cell 'segs' stored in a mat file
%               - note that using an ultrametric contour map is not possible
%               with this evaluation function.
%	gtFile:     file containing a cell of ground truth segmentations
%   imgFIle:    correpsonding image
%   evFile9:    temporary output for this image
%
% OUTPUT
%	sumXYSSE:   sum of squared error of x,y coordinates
%   sumRGBSSE:  sum of squared error of RGB color
%
% David Stutz <david.stutz@rwth-aachen.de>

    load(inFile); 

    % Only run if we have the correct format - does not work on ucm
    if exist('segs', 'var')

        load(gtFile);
        nSegs = numel(groundTruth);
        if nSegs == 0,
            error('bad gtFile!');
        end

        seg = double(segs{1});
        N = size(seg, 1)*size(seg, 2);
        nLabels = max(max(seg));

        img = imread(imgFile);
        [height, width, channels] = size(img);

        X = 1:width;
        X = repmat(X, height, 1);
        
        Y = 1:height;
        Y = Y';
        Y = repmat(Y, 1, width);
        
        meanX = zeros(height, width);
        meanY = zeros(height, width);
        
        meansRGB = zeros(nLabels, 3);
        meansXY = zeros(nLabels, 2);
        
        if channels == 1
            meanImg = zeros(height, width);
        elseif channels == 3
            meanR = zeros(height, width);
            meanG = zeros(height, width);
            meanB = zeros(height, width);
        else
            error('Invalid number of channels.');
        end;
        
        for m = 1: nLabels
            mLabelSeg = seg == m;
            
            if channels == 1
                props = regionprops(mLabelSeg, img(:,:,1), 'MeanIntensity');
                meansRGB(m, 1) = props.MeanIntensity;
                meanImg(mLabelSeg) = props.MeanIntensity;
            elseif channels == 3
                props = regionprops(mLabelSeg, img(:,:,1), 'MeanIntensity');
                meansRGB(m, 1) = props.MeanIntensity;
                meanR(mLabelSeg) = props.MeanIntensity;
                
                props = regionprops(mLabelSeg, img(:,:,2), 'MeanIntensity');
                meansRGB(m, 2) = props.MeanIntensity;
                meanG(mLabelSeg) = props.MeanIntensity;
                
                props = regionprops(mLabelSeg, img(:,:,3), 'MeanIntensity');
                meansRGB(m, 3) = props.MeanIntensity;
                meanB(mLabelSeg) = props.MeanIntensity;
            end;
                
            props = regionprops(mLabelSeg, X, 'MeanIntensity');
            meansXY(m, 1) = props.MeanIntensity;
            meanX(mLabelSeg) = props.MeanIntensity;
            
            props = regionprops(mLabelSeg, Y, 'MeanIntensity');
            meansXY(m, 2) = props.MeanIntensity;
            meanY(mLabelSeg) = props.MeanIntensity;
        end;
        
        sumXYSSE = sum(sum(sqrt((meanX - X).^2 + (meanY - Y).^2)));
        
        if channels == 1
            sumRGBSSE = sum(sum(abs(meanImg - double(img(:,:,1)))));
        elseif channels == 3
            sumRGBSSE = sum(sum(sqrt((meanR - double(img(:,:,1))).^2 + (meanG - double(img(:,:,2))).^2 + (meanB - double(img(:,:,3))).^2)));
        end;

        fid = fopen(evFile9, 'w');
        if fid == -1, 
            error('Could not open file %s for writing.', evFile9);
        end
        fprintf(fid,'%10g %10g %10g %10g\n', sumXYSSE, sumRGBSSE, N);
        fclose(fid);
    end;
end