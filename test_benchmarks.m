% Tests for all parts of the benchmark.
%
% Tests 1 - 5 are included in the original benchmark provided by [1]:
%
% [1] P. Arbeláez, M. Maire, C. Fowlkes, J. Malik.
%     Contour detection and hierarchical image segmentation.
%     Transactions on Pattern Analysis and Machine Intelligence, volume 33, number 5, pages 898–916, 2011.
%
% The remaining tests were added in the course of the bachelor thesise [2]:
%
% [2] D. Stutz, A. Hermans, B. Leibe.
%     Superpixel Segmentation using Depth Information.
%     Bachelor thesis, RWTH Aachen University, Aachen, Germany, 2014.
% 
% Test data is included in the data/ subfolder. Beneath the original data,
% test data from the NYU Depth V2 and BSDS500 for evaluating superpixel
% algorithms is included.
%
% Originally by Pablo Arbelaez <arbelaez@eecs.berkeley.edu>
% Updated by David Stutz <david.stutz@rwth-aachen.de>

addpath benchmarks
clear all;close all;clc;

%% 1. Test all the benchmarks for results stored in 'ucm2' format:

imgDir = 'data/BSDS500/images';
gtDir = 'data/BSDS500/groundTruth';
inDir = 'data/BSDS500/ucm2';
outDir = 'tests/test_1';
mkdir(outDir);
nthresh = 5;

tic;
allBench(imgDir, gtDir, inDir, outDir, nthresh);
toc;

plot_eval(outDir);

%% 2. Test boundary benchmark for results stored as contour images:

imgDir = 'data/BSDS500/images';
gtDir = 'data/BSDS500/groundTruth';
pbDir = 'data/BSDS500/png';
outDir = 'tests/test_2';
mkdir(outDir);
nthresh = 5;

tic;
boundaryBench(imgDir, gtDir, pbDir, outDir, nthresh);
toc;

%% 3. Test boundary benchmark for results stored as a cell of segmentations:

imgDir = 'data/BSDS500/images';
gtDir = 'data/BSDS500/groundTruth';
pbDir = 'data/BSDS500/segs';
outDir = 'tests/test_3';
mkdir(outDir);

nthresh = 99; % note: the code changes this to the actual number of segmentations
tic;
boundaryBench(imgDir, gtDir, pbDir, outDir, nthresh);
toc;

%% 4. Test all the benchmarks for results stored as a cell of segmentations:

imgDir = 'data/BSDS500/images';
gtDir = 'data/BSDS500/groundTruth';
inDir = 'data/BSDS500/segs';
outDir = 'tests/test_4';
mkdir(outDir);
nthresh = 5;

tic;
allBench(imgDir, gtDir, inDir, outDir, nthresh);
toc;

%% 5. Test region benchmarks for results stored as a cell of segmentations:

imgDir = 'data/BSDS500/images';
gtDir = 'data/BSDS500/groundTruth';
inDir = 'data/BSDS500/segs';
outDir = 'tests/test_5';
mkdir(outDir);
nthresh = 5;

tic;
regionBench(imgDir, gtDir, inDir, outDir, nthresh);
toc;

%% 6. Test all benchmarks for results stored as a cell of segmentations:

imgDir = 'data/BSDS500/images';
gtDir = 'data/BSDS500/groundTruth';
inDir = 'data/BSDS500/superpixel_segs';
outDir = 'tests/test_6';
mkdir(outDir);
nthresh = 5;

tic;
allBench(imgDir, gtDir, inDir, outDir, nthresh);
toc;

%% 7. Test Undersegmentation Error benchmark for results stored as a cell of segmentations:

imgDir = 'data/BSDS500/images';
gtDir = 'data/BSDS500/groundTruth';
inDir = 'data/BSDS500/superpixel_segs';
outDir = 'tests/test_7';
mkdir(outDir);

tic;
undersegmentationBench(imgDir, gtDir, inDir, outDir);
toc;

%% 8. Test Compactness benchmarks for superpixel results stored as a cell of segmentations:

imgDir = 'data/BSDS500/images';
gtDir = 'data/BSDS500/groundTruth';
inDir = 'data/BSDS500/grid_segs';
outDir = 'tests/test_8';
mkdir(outDir);

tic;
compactnessBench(imgDir, gtDir, inDir, outDir);
toc;

%% 9. Test supeprixel count benchmark for results stored as a cell of segmentations:

imgDir = 'data/BSDS500/images';
gtDir = 'data/BSDS500/groundTruth';
inDir = 'data/BSDS500/superpixel_segs';
outDir = 'tests/test_9';
mkdir(outDir);

tic;
superpixelsBench(imgDir, gtDir, inDir, outDir);
toc;

%% 10. Test Achievable Segmentation Accuracy benchmark for results stored as a cell of segmentations:

imgDir = 'data/BSDS500/images';
gtDir = 'data/BSDS500/groundTruth';
inDir = 'data/BSDS500/superpixel_segs';
outDir = 'tests/test_10';
mkdir(outDir);

tic;
asaBench(imgDir, gtDir, inDir, outDir);
toc;

%% 11. Test Sum-Of-Squared Error benchmark for results stored as a cell of segmentations:

imgDir = 'data/BSDS500/images';
gtDir = 'data/BSDS500/groundTruth';
inDir = 'data/BSDS500/superpixel_segs';
outDir = 'tests/test_11';
mkdir(outDir);

tic;
sseBench(imgDir, gtDir, inDir, outDir);
toc;

%% 12. Test Explained Variation benchmark for results stored as a cell of segmentations:

imgDir = 'data/BSDS500/images';
gtDir = 'data/BSDS500/groundTruth';
inDir = 'data/BSDS500/superpixel_segs';
outDir = 'tests/test_12';
mkdir(outDir);

tic;
evBench(imgDir, gtDir, inDir, outDir);
toc;