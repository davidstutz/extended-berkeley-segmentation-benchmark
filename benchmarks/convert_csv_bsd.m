function [] = convert_csv_bsd(inputDir, outputDir)
% function [] = convert_csv_bsd(inputDir, outputDir)
%
% Converts segmentations given as CSV files in inputDir to .mat files with
% a cell 'segs' containing one or more segmentations (usually just one).
%
% INPUT:
%   inputDir:   input directory containing the segmentation files
%   outputDir:  output directory
%
% David Stutz <david.stutz@rwth-aachen.de>

    if ~isdir(inputDir)
        fprintf('Input folder does not exist: %s\n', inputDir);
        return;
    end;

    if ~isdir(outputDir)
        mkdir(outputDir);
        fprintf('Output folder created: %s\n', outputDir);
    end;

    csvPattern = fullfile(inputDir, '*.csv');
    csvFiles = dir(csvPattern);

    for i = 1: length(csvFiles)
        inputFilename = csvFiles(i).name;
        inputFilepath = fullfile(inputDir, inputFilename);

        % fprintf('Processing %s\n', inputFilepath);

        labels = csvread(inputFilepath);
        
        % in the case there are segmentations containing negative labels
        minLabel = min(min(labels));
        
        % bsd assumes the labels start with one
        labels = labels + (1 - minLabel)*ones(size(labels));
        segs = cell(1, 1);
        segs(1, 1) = {labels};

        outputFilename = strrep(inputFilename, '.csv', '.mat');
        outputFilepath = fullfile(outputDir, outputFilename);

        save(outputFilepath, 'segs');
    end;

end