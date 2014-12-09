function [] = asaBench(imgDir, gtDir, inDir, outDir)
% function [] = asaBench(imgDir, gtDir, inDir, outDir)
%
% Calculate the Achievable Segmentation Accuracy.
%
% INPUT
%   imgDir  : folder containing original images
%   gtDir   : folder containing ground truth data
%   inDir   : a collection of segmentations in a cell 'segs' stored in a mat file
%             - note that using an ultrametric contour map is not possible
%             with this evaluation function
%   outDir  : folder where evaluation results will be stored
%
% David Stutz <david.stutz@rwth-aachen.de>

    iids = dir(fullfile(imgDir,'*.jpg'));
    for i = 1:numel(iids)
        evFile8 = fullfile(outDir, strcat(iids(i).name(1:end-4), '_ev8.txt'));
        if ~isempty(dir(evFile8))
            continue;
        end;

        inFile = fullfile(inDir, strcat(iids(i).name(1:end-4), '.mat'));
        gtFile = fullfile(gtDir, strcat(iids(i).name(1:end-4), '.mat'));

        evaluation_asa_image(inFile, gtFile, evFile8);
    end;

    collect_eval_asa(outDir);
    delete(sprintf('%s/*_ev8.txt', outDir));
end








