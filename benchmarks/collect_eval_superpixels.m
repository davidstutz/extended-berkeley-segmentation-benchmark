function [minSuperpixels, averageSuperpixels, maxSuperpixels] = collect_eval_superpixels(outDir)
% function [minSuperpixels, averageSuperpixels, maxSuperpixels] = collect_eval_superpixels(outDir)
% 
% Collects the superpixel number of all images.
%
% Creates the following files: eval_superpixels.txt, eval_superpixels_img.txt.
% Details on these files can be found in README.md.
%
% INPUT
%   outDir:             the directory containing the temporary
%                       evaluation files
%
% OUTPUT
%   minSuperpixels:     minimum number of superpixels
%   averageSuperpixels: average number of superpixels
%   maxSuperpixels:     maximum number of superpixels
%
% David Stutz <david.stutz@rwth-aachen.de>

    fname = fullfile(outDir, 'eval_superpixels.txt');
    if length(dir(fname)) ~= 1,

        % *_ev7.txt files contain the number of superpixels
        S = dir(fullfile(outDir, '*_ev7.txt'));

        superpixels = zeros(numel(S), 1);
        minSuperpixels = -1;
        maxSuperpixels = 0;
        averageSuperpixelsSum = 0;
        indices = zeros(numel(S), 1);

        for i = 1: numel(S),

            indices(i) = i;

            % read evaluation file containung undersegmentation error
            evFile7 = fullfile(outDir, S(i).name);
            tmp  = dlmread(evFile7);
            superpixels(i) = tmp(1, 1);

            if superpixels(i) > maxSuperpixels 
                maxSuperpixels = superpixels(i);
            end;

            if superpixels(i) < minSuperpixels || minSuperpixels < 0
                minSuperpixels = superpixels(i);
            end;

            averageSuperpixelsSum = averageSuperpixelsSum + superpixels(i);
        end;

        averageSuperpixels = averageSuperpixelsSum/numel(S);
        
        fname = fullfile(outDir, 'eval_superpixels.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        fprintf(fid, '%10d %10g %10g\n', [minSuperpixels, averageSuperpixels, maxSuperpixels]);
        fclose(fid);

        fname = fullfile(outDir, 'eval_superpixels_img.txt');
        fid = fopen(fname, 'w');
        if fid == -1
            error('Could not open file %s for writing.', fname);
        end
        fprintf(fid, '%10d %10g\n', [indices, superpixels]');
        fclose(fid);
    end;
end

