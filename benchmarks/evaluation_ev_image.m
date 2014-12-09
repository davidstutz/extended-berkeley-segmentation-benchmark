function [sumSuperpixelVariation, sumOverallVariation] = evaluation_ev_image(inFile, gtFile, imgFile, evFile10)
% function [sumSuperpixelVariation, sumOverallVariation] = evaluation_ev_image(inFile, gtFile, imgFile, evFile10)
%
% Calculates Explained Variation as described in [1]:
%
%   [1] D. Tang, H. Fu, and X. Cao.
%       Topology preserved regular superpixel.
%       In Multimedia and Expo, International Conference on, pages 765–768, Melbourne, Australia, July 2012
%
% INPUT
%	inFile:     a collection of segmentations in a cell 'segs' stored in a mat file
%               - note that using an ultrametric contour map is not possible
%               with this evaluation function.
%	gtFile:     file containing a cell of ground truth segmentations
%   imgFIle:    correpsonding image
%   evFile10:   temporary output for this image
%
% OUTPUT
%	sumSuperpixelVariation: nominator of explained variation
%   sumOverallVariation:    denominator of explained variation
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
                meanImg(mLabelSeg) = props.MeanIntensity;
            elseif channels == 3
                props = regionprops(mLabelSeg, img(:,:,1), 'MeanIntensity');
                meanR(mLabelSeg) = props.MeanIntensity;
                
                props = regionprops(mLabelSeg, img(:,:,2), 'MeanIntensity');
                meanG(mLabelSeg) = props.MeanIntensity;
                
                props = regionprops(mLabelSeg, img(:,:,3), 'MeanIntensity');
                meanB(mLabelSeg) = props.MeanIntensity;
            end;
        end;

        if channels == 1
            meanOverall = ones(height, width)*mean2(img);
            sumOverallVariation = sum(sum((meanOverall - double(img)).^2));
            
            sumSuperpixelVariation = sum(sum((meanOverall - meanImg).^2));
        elseif channels == 3
            meanROverall = ones(height, width)*mean2(img(:,:,1));
            meanGOverall = ones(height, width)*mean2(img(:,:,2));
            meanBOverall = ones(height, width)*mean2(img(:,:,3));
            sumOverallVariation = sum(sum((meanROverall - double(img(:,:,1))).^2 + (meanBOverall - double(img(:,:,2))).^2 + (meanGOverall - double(img(:,:,3))).^2));
            
            sumSuperpixelVariation = sum(sum((meanROverall - meanR).^2 + (meanBOverall - meanB).^2 + (meanGOverall - meanG).^2));
        end;
        
        fid = fopen(evFile10, 'w');
        if fid == -1, 
            error('Could not open file %s for writing.', evFile10);
        end
        fprintf(fid,'%10g %10g\n', sumSuperpixelVariation, sumOverallVariation);
        fclose(fid);
    end;
end