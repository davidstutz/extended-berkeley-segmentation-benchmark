function [] = superpixelsBench(imgDir, gtDir, inDir, outDir)
% superpixelsBench(imgDir, gtDir, inDir, outDir)
%
% Count the number of superpixels for all superpixel segmentations.
%
% INPUT
%   imgDir  : folder containing original images
%   gtDir   : folder containing ground truth data.
%   inDir   : a collection of segmentations in a cell 'segs' stored in a mat file
%             - note that using an ultrametric contour map is not possible
%             with this evaluation function.
%   outDir  : folder where evaluation results will be stored
%
% David Stutz <david.stutz@rwth-aachen.de>

    iids = dir(fullfile(imgDir,'*.jpg'));
    for i = 1:numel(iids)
        evFile7 = fullfile(outDir, strcat(iids(i).name(1:end-4), '_ev7.txt'));
        if ~isempty(dir(evFile7))
            continue;
        end;

        inFile = fullfile(inDir, strcat(iids(i).name(1:end-4), '.mat'));
        gtFile = fullfile(gtDir, strcat(iids(i).name(1:end-4), '.mat'));

        evaluation_superpixels_image(inFile, gtFile, evFile7);
    end;

    collect_eval_superpixels(outDir);
    delete(sprintf('%s/*_ev7.txt', outDir));
end
