function [] = compactnessBench(imgDir, gtDir, inDir, outDir)
% function [] = compactnessBench(imgDir, gtDir, inDir, outDir)
%
% Run compactness benchmark on dataset.
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
        evFile6 = fullfile(outDir, strcat(iids(i).name(1:end-4), '_ev6.txt'));
        if ~isempty(dir(evFile6))
            continue;
        end;

        inFile = fullfile(inDir, strcat(iids(i).name(1:end-4), '.mat'));
        gtFile = fullfile(gtDir, strcat(iids(i).name(1:end-4), '.mat'));

        evaluation_compactness_image(inFile, gtFile, evFile6);
    end;

    collect_eval_compactness(outDir);
    delete(sprintf('%s/*_ev6.txt', outDir));
end







