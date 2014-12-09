function [bestAverageT, bestAverageASA, averageBestASA] = collect_eval_asa(outDir)
% function [bestAverageT, bestAverageASA, averageBestASA] = collect_eval_asa(outDir)
% 
% Collects the Achievable Segmentation Accuracy (ASA) results for all
% images.
%
% Creates mainly three files: eval_asa.txt, eval_asa_thr.txt, eval_asa_img.txt.
% Details on these files can be found in README.md.
%
% INPUT
%   outDir:         the directory containing the temporary evaluation files
%
% OUTPUT
%   bestAverageT:   index of ground truth segmentation corresponding
%                   to bestAverageASA
%   bestAverageASA: best Achievable Segmentation Accuracy over all
%                   ground truth segmentations after averaging over all images
%   averageBestASA: Achievable Segmentation Accuracy averaged over all images
%                   after choosing the best Achievable Segmentation Accuracy
%                   over the ground truth segmentations per image
% David Stutz <david.stutz@rwth-aachen.de>

    fname = fullfile(outDir, 'eval_asa.txt');
    if length(dir(fname)) ~= 1,

        % *_ev8.txt files contain the achievable segmentation accuracy
        S = dir(fullfile(outDir, '*_ev8.txt'));

        % determine nthresh from first file
        tmp = dlmread(fullfile(outDir, S(1).name));
        nthresh = size(tmp, 1);
        
        for i = 2: numel(S)
            tmp = dlmread(fullfile(outDir, S(i).name));
            if size(tmp, 1) < nthresh
                nthresh = size(tmp, 1);
            end;
        end;

       	thresh = 1:nthresh;
        thresh = thresh';
        
        % determine number of pixels from first file
        tmp = dlmread(fullfile(outDir, S(1).name));
        N = tmp(1:nthresh, 3);

        bestASA = zeros(numel(S), 1);
        bestASAIndex = zeros(numel(S), 1);
        indices = zeros(numel(S), 1);

        globalSumASA = zeros(nthresh, 1);
        bestSumASA = 0;

        for i = 1: numel(S),
            indices(i) = i;

            evFile8 = fullfile(outDir, S(i).name);
            tmp  = dlmread(evFile8);
            sumASA = tmp(1:nthresh, 2);

            ASA = sumASA./N;

            globalSumASA = globalSumASA + sumASA;
            [bestASA(i), bestASAIndex(i)] = min(ASA);
            bestSumASA = bestSumASA + min(sumASA);
        end;

        threshASA = globalSumASA./(N*numel(S));
        [bestAverageASA, bestAverageT] = min(threshASA);
        averageBestASA = bestSumASA/(N(1)*numel(S));

        fname = fullfile(outDir, 'eval_asa.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        % bestAverageASA is the best ASA over all ground truth segmentations
        % after averaging over all segmentations S
        % averageBestASA is the average ASA after maximizing over all ground
        % truth segmentations
        fprintf(fid, '%10d %10g %10g\n', [bestAverageT, bestAverageASA, averageBestASA]);
        fclose(fid);

        fname = fullfile(outDir, 'eval_asa_thr.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        % averaged ASA for each ground truth
        fprintf(fid, '%10d %10g\n', [thresh, threshASA]');
        fclose(fid);

        fname = fullfile(outDir, 'eval_asa_img.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        fprintf(fid, '%10d %10g %10g\n', [indices, bestASAIndex, bestASA]');
        fclose(fid);
    end;
end

