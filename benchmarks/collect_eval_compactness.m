function [globalBestCO, averageCO, globalWorstCO] = collect_eval_compactness(outDir)
% function [globalBestCO, averageCO, globalWorstCO] = collect_eval_compactness(outDir)
% 
% Collects the Compactness benchmark for all images.
%
% Creates the following files: eval_compactness.txt, eval_compactness_img.txt.
% Details on these files can be found in README.md.
%
% INPUT
%   outDir:         the directory containing the temporary evaluation files
%
% OUTPUT:
%   globalBestCO:   best Compactness
%   averageCO:      average Compactness
%   globalWorstCO:  worst Compactness
%
% David Stutz <david.stutz@rwth-aachen.de>

    fname = fullfile(outDir, 'eval_compactness.txt');
    if length(dir(fname)) ~= 1,

        % *_ev6.txt files contain the compactness measure
        S = dir(fullfile(outDir, '*_ev6.txt'));

        CO = zeros(numel(S), 1);
        globalBestCO = 0;
        globalWorstCO = 1;
        averageSumCO = 0;
        indices = zeros(numel(S), 1);

        for i = 1: numel(S),

            indices(i) = i;

            evFile6 = fullfile(outDir, S(i).name);
            tmp  = dlmread(evFile6);
            sumCO = tmp(1,1);
            N = tmp(1,2);

            CO(i) = sumCO/N;

            if CO(i) > globalBestCO 
                globalBestCO = CO(i);
            end;

            if CO(i) < globalWorstCO
                globalWorstCO = CO(i);
            end;

            averageSumCO = averageSumCO + CO(i);
        end;

        averageCO = averageSumCO/numel(S);
        
        fname = fullfile(outDir, 'eval_compactness.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        fprintf(fid, '%10d %10g %10g\n', [globalBestCO, averageCO, globalWorstCO]);
        fclose(fid);

        fname = fullfile(outDir, 'eval_compactness_img.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        fprintf(fid, '%10d %10g\n', [indices, CO]');
        fclose(fid);
    end;
end

