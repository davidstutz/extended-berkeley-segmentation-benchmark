function [bestAverageT, bestAverageUE, averageBestUE] = collect_eval_undersegmentation(outDir)
% function [bestAverageT, bestAverageUE, averageBestUE] = collect_eval_undersegmentation(outDir)
% 
% Collects the Undersegmentation Error benchmark for all images.
%
% Creates the following files: eval_undersegmentation.txt,
% eval_undersegmentation_img.txt, eval_undersegmentation_thr.txt.
% Details on these files can be found in README.md.
%
% INPUT
%   outDir:         the directory containing the temporary
%                   evaluation files
%
% OUTPUT
%   bestAverageT:   index of the ground truth segmentation
%                   corresponding to bestAverage UE
%   bestAverageUE:  best Undersegmentation Error over all ground
%                   truth segmentations after averaging over all images
%   averageBestUE:  Undersegmentation Error averaged over all images
%                   after choosing the best Undersegmentation Error
%                   over the ground truth segmentations per image
%
% David Stutz <david.stutz@rwth-aachen.de>

    fname = fullfile(outDir, 'eval_undersegmentation.txt');
    if length(dir(fname)) ~= 1,

        % *_ev5.txt files contain the undersegmentation errors
        S = dir(fullfile(outDir, '*_ev5.txt'));

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
        
        bestUE = zeros(numel(S), 1);
        bestUEIndex = zeros(numel(S), 1);
        indices = zeros(numel(S), 1);

        % contains the sum of all sumUE for all thresh
        globalSumUE = zeros(nthresh, 1);
        % contains the sum of the best sumUE over all segmentations
        bestSumUE = 0;

        % for each image, find best segmentation for undersegmentation error
        for i = 1: numel(S),
            indices(i) = i;

            % read evaluation file containung undersegmentation error
            evFile5 = fullfile(outDir, S(i).name);
            tmp  = dlmread(evFile5);
            sumUE = tmp(1:nthresh, 2);
            
            UE = sumUE./N;

            globalSumUE = globalSumUE + sumUE;
            [bestUE(i), bestUEIndex(i)] = min(UE);
            bestSumUE = bestSumUE + min(sumUE);
        end;

        % minimize over all thresh
        threshUE = globalSumUE./(N*numel(S));
        [bestAverageUE, bestAverageT] = min(threshUE);
        averageBestUE = bestSumUE/(N(1)*numel(S));

        fname = fullfile(outDir, 'eval_undersegmentation.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        % bestAverageUE is the best UE over all ground truth segmentations
        % after averaging over all segmentations S
        % averageBestUE is the average UE after maximizing over all ground
        % truth segmentations
        fprintf(fid, '%10d %10g %10g\n', [bestAverageT, bestAverageUE, averageBestUE]);
        fclose(fid);

        fname = fullfile(outDir, 'eval_undersegmentation_thr.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        % best UE for each ground truth segmentation averaged over all
        % segmentations S
        fprintf(fid, '%10d %10g\n', [thresh, threshUE]');
        fclose(fid);

        fname = fullfile(outDir, 'eval_undersegmentation_img.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        fprintf(fid, '%10d %10g %10g\n', [indices, bestUEIndex, bestUE]');
        fclose(fid);
    end;
end

