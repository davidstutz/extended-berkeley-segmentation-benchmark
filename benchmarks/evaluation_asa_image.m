function [sumASA] = evaluation_asa_image(inFile, gtFile, evFile8)
% function [sumASA] = evaluation_asa_image(inFile, gtFile, evFile8)
%
% Calculate the Achievable Segmentation Accuracy as described in [1].
%
%   [1] M. Y. Lui, O. Tuzel, S. Ramalingam, R. Chellappa.
%       Entropy rate superpixel segmentation.
%       Proceedings of the Conference on Computer Vision and Pattern Recognition, pages 2097–2104, 2011.
%
% INPUT
%	inFile  : a collection of segmentations in a cell 'segs' stored in a mat file
%             - note that using an ultrametric contour map is not possible
%             with this evaluation function.
%
%	gtFile	:   file containing a cell of ground truth segmentations
%
%   evFile8 : temporary output for this image
%
% OUTPUT
%	sumASA     : array of achievable segmentation accuracy sums for each
%                ground truth segmentation; needs to be divided by
%                the total number of pixels in the image.
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

        thresh = 1:nSegs;
        thresh = thresh';

        seg = double(segs{1});
        N = ones(nSegs, 1)*size(seg, 1)*size(seg, 2);

        sumASA = zeros(nSegs, 1);
        % nSegs is the number of ground truth segmentations
        for t = 1: nSegs
            gt = double(groundTruth{t}.Segmentation);

            % number of ground truth labels and segmentation labels of "seg"
            num1 = max(gt(:)) + 1; 
            num2 = max(seg(:)) + 1;
            confcounts = zeros(num1, num2);

            % creates a matrix of labels as follows: for each label from 1 to num1
            % in gt there are num2 "sublabels"
            sumim = 1 + gt + seg*num1;

            % histc computes a simple histogram counting the number of values in
            % sumim to fall in the ranges given by 1:num1*num2
            hs = histc(sumim(:), 1:num1*num2);

            % confcounts is a mtrix of size num1 x num2 and in entry (i,j) it
            % stores the number of pixels belonging to both label i-1 in ground
            % truth and label j-1 in given segmentation
            confcounts(:) = confcounts(:) + hs(:);

            for j = 1: num2
                maxj = max(confcounts(:, j));
                sumASA(t) = sumASA(t) + maxj;
            end;
        end;

        fid = fopen(evFile8, 'w');
        if fid == -1, 
            error('Could not open file %s for writing.', evFile8);
        end
        fprintf(fid,'%10g %10g %10g\n',[thresh, sumASA, N]');
        fclose(fid);

    end;
end