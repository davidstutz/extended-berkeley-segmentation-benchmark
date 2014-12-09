function [sumCO] = evaluation_compactness_image(inFile, gtFile, evFile6)
% function [sumCO] = evaluation_compactness_image(inFile, gtFile, evFile6)
%
% Calculate Compactness for superpixel segmentations as proposed in [2].
%
%   [5] A. Schick, M. Fischer, R. Stiefelhagen.
%       Measuring and evaluating the compactness of superpixels.
%       Proceedings of the International Conference on Pattern Recognition, pages 930–934, 2012.
%
% INPUT
%	inFile:     a collection of segmentations in a cell 'segs' stored in a mat file
%               - note that using an ultrametric contour map is not possible
%               with this evaluation function.
%	gtFile:     file containing a cell of ground truth segmentations
%   evFile6:    temporary output for this image
%
% OUTPUT
%	sumCO:      sum of compactness measure; needs to be divided by the
%                number of total pixels
%
% David Stutz <david.stutz@rwth-aachen.de>

    load(inFile); 

    % Only run if we have the correct format - does not work on ucm
    if exist('segs', 'var')

        load(gtFile);
        nSegs = numel(groundTruth);
        if nSegs == 0,
            error(' bad gtFile !');
        end

        seg = double(segs{1});
        nLabels = max(max(seg));
        N = size(seg, 1)*size(seg, 2);
        
        for m = 1: nLabels
            segLabelM = (seg == m);
            prop = bwconncomp(segLabelM, 4);
            
            for k = 1: prop.NumObjects
                if k > 1
                    nLabels = nLabels + 1;
                    for i = 1: size(prop.PixelIdxList{k}, 1)
                        seg(prop.PixelIdxList{k}(i)) = nLabels;
                    end;
                end;
            end;
        end;
        
        for m = 1: nLabels
            segLabelM = (seg == m);
            prop = bwconncomp(segLabelM, 4);
            
            if prop.NumObjects > 1
                error('Non-connected superpixel detected!');
            end;
        end;
        
        sumCO = 0;
        for m = 1: nLabels
            % segLabelM is zero everywhere except where it was labeled m.
            segLabelM = (seg == m);

            if sum(sum(segLabelM)) > 0
                properties = regionprops(segLabelM, 'Area', 'Perimeter');
                %imshow(segLabelM);
                
                if properties.Perimeter > 0
                    sumCO = sumCO + properties.Area*((4*pi*properties.Area)/(properties.Perimeter*properties.Perimeter));
                end;
            end;
        end;

%         X = 1:width;
%         X = repmat(X, height, 1);
%         
%         Y = 1:height;
%         Y = Y';
%         Y = repmat(Y, 1, width);
%         
%         meanX = zeros(height, width);
%         meanY = zeros(height, width);
%         meansXY = zeros(nLabels, 2);
%         
%         area = zeros(nLabels, 1);
%         for m = 1: nLabels
%             segLabelM = (seg == m);
%             
%             props = regionprops(segLabelM, X, 'MeanIntensity', 'Area');
%             meansXY(m, 1) = props.MeanIntensity;
%             area(m, 1) = props.Area;
%             meanX(segLabelM) = props.MeanIntensity;
%             
%             props = regionprops(segLabelM, Y, 'MeanIntensity');
%             meansXY(m, 2) = props.MeanIntensity;
%             meanY(segLabelM) = props.MeanIntensity;
%         end;
%         
%         distance = sqrt((meanX - X).^2 + (meanY - Y).^2);
%         
%         sumCO = 0;
%         for m = 1: nLabels
%             segLabelM = (seg == m);
%             radius = max(max(distance(segLabelM)));
%             
%             if area(m) > 1
%                 sumCO = sumCO + sqrt(area(m)/2)/radius;
%             else
%                 sumCO = sumCO + 1;
%             end;
%         end;
%         sumCO/nLabels
        
        fid = fopen(evFile6, 'w');
        if fid == -1, 
            error('Could not open file %s for writing.', evFile6);
        end
        fprintf(fid,'%10g %10g\n', sumCO, N);
        fclose(fid);
    end;
end