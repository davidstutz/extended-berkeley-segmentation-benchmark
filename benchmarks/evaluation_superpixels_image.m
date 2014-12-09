function [superpixels] = evaluation_superpixels_image(inFile, gtFile, evFile7)
% function [superpixels] = evaluation_superpixels_image(inFile, gtFile, evFile7)
%
% Simple benchmark module counting the number of superpixels. This is
% important as some algorithms offer direct control over the number of
% superpixels while the number of superpixels computed by others is
% depending on the image (not necessarily the image size!).
%
% INPUT
%	inFile:     a collection of segmentations in a cell 'segs' stored in a mat file
%               - note that using an ultrametric contour map is not possible
%               with this evaluation function.
%	gtFile:     file containing a cell of ground truth segmentations
%   evFile7:    temporary output for this image
%
% OUTPUT
%	superpixels: number of superpixels
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

        % estimate the number of labels
        seg = double(segs{1});
        nLabels = max(max(seg));
        foundLabels = zeros(nLabels, 1);

        for i = 1: size(seg, 1)
            for j = 1: size(seg, 2)
                if foundLabels(seg(i, j)) == 0 
                    foundLabels(seg(i,j)) = 1;
                end;
            end;
        end;

        labels = 0;
        for m = 1: nLabels
            labels = labels + foundLabels(m);
        end;

        fid = fopen(evFile7, 'w');
        if fid == -1, 
            error('Could not open file %s for writing.', evFile6);
        end
        fprintf(fid,'%10g\n', labels);
        fclose(fid);
    end;
end