function [averageEV] = collect_eval_ev(outDir)
% function [averageEV] = collect_eval_ev(outDir)
% 
% Collects the Explained Variation benchmark.
%
% Creates the following files: eval_ev.txt, eval_ev_img.txt.
% Details on these files can be found in README.md.
%
% INPUT
%   outDir:     the directory containing the temporary evaluation files
%
% OUTPUT
%   averageEV:  average Explained Variation
%
% David Stutz <david.stutz@rwth-aachen.de>

    fname = fullfile(outDir, 'eval_ev.txt');
    if length(dir(fname)) ~= 1,

        % *_ev9.txt files contain the SSE evaluation
        S = dir(fullfile(outDir, '*_ev10.txt'));

        EV = zeros(numel(S), 1);
        averageSUMEV = 0;
        indices = zeros(numel(S), 1);

        for i = 1: numel(S),

            indices(i) = i;

            evFile10 = fullfile(outDir, S(i).name);
            tmp  = dlmread(evFile10);
            nominator = tmp(1, 1);
            denominator = tmp(1, 2);

            EV(i) = nominator/denominator;

            averageSUMEV = averageSUMEV + EV(i);
        end;

        averageEV = averageSUMEV/numel(S);
        
        fname = fullfile(outDir, 'eval_ev.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        fprintf(fid, '%10d\n', [averageEV]);
        fclose(fid);

        fname = fullfile(outDir, 'eval_ev_img.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        fprintf(fid, '%10d %10g\n', [indices, EV]');
        fclose(fid);
    end;
end

