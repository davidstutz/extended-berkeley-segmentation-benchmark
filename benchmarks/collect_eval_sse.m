function [averageXYSSE, averageRGBSSE] = collect_eval_sse(outDir)
% function [averageXYSSE, averageRGBSSE] = collect_eval_sse(outDir)
% 
% Collects the Sum-Of-Squared Error benchmark.
%
% Creates the following files: eval_sse.txt, eval_sse_img.txt.
% Details on these files can be found in README.md.
%
% INPUT
%   outDir:         the directory containing the temporary evaluation files
%
% OUTPUT
%   averageXYSSE:   average Sum-Of-Squared Error for x,y coordinates
%   averageRGBSSE:  average Sum-Of-Squared Error for r,g,b color
%
% David Stutz <david.stutz@rwth-aachen.de>

    fname = fullfile(outDir, 'eval_sse.txt');
    if length(dir(fname)) ~= 1,

        % *_ev9.txt files contain the SSE evaluation
        S = dir(fullfile(outDir, '*_ev9.txt'));

        XYSSE = zeros(numel(S), 1);
        RGBSSE = zeros(numel(S), 1);
        averageSumXYSSE = 0;
        averageSumRGBSSE = 0;
        indices = zeros(numel(S), 1);

        for i = 1: numel(S),

            indices(i) = i;

            evFile9 = fullfile(outDir, S(i).name);
            tmp  = dlmread(evFile9);
            sumXYSSE = tmp(1, 1);
            sumRGBSSE = tmp(1, 2);
            N = tmp(1, 3);

            XYSSE(i) = sumXYSSE/N;
            RGBSSE(i) = sumRGBSSE/N;

            averageSumXYSSE = averageSumXYSSE + XYSSE(i);
            averageSumRGBSSE = averageSumRGBSSE + RGBSSE(i);
        end;

        averageXYSSE = averageSumXYSSE/numel(S);
        averageRGBSSE = averageSumRGBSSE/numel(S);
        
        fname = fullfile(outDir, 'eval_sse.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        fprintf(fid, '%10d %10g\n', [averageXYSSE, averageRGBSSE]);
        fclose(fid);

        fname = fullfile(outDir, 'eval_sse_img.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        fprintf(fid, '%10d %10g %10g\n', [indices, XYSSE, RGBSSE]');
        fclose(fid);
    end;
end

