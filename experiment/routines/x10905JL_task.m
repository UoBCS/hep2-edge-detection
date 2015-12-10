global LAPLACE ROBERTS SOBEL;

LAPLACE = load('filters/laplace.mat');
ROBERTS = load('filters/roberts.mat');
SOBEL = load('filters/sobel.mat');

warning('off','all')

% Load true edge images
x10905JLtrue = read_image('images/10905 JL Edges.bmp', 0);

x10905JLg = read_image('images/10905 JL.bmp', 1);
e1 = EdgeDetection(x10905JLg, x10905JLtrue);
level = graythresh(x10905JLg);
x10905JLbw = single(im2bw(x10905JLg, level));

% Show background graph
% ---------------------

%show_background(x10905JLg);

% First order methods
% -------------------

% Otsu
%[x10905JLbwOtsu, x10905JLbwOtsuROC, x10905JLbwOtsuT] = e1.otsu();

% Sobel without imadjust
%[x10905JLSobelArr, x10905JLROCSobelArr] = e1.sobel_batch(20, 100, 0, 1);

% Sobel with imadjust
%[x10905JLaSobelArr, x10905JLaROCSobelArr] = e1.sobel_batch(20, 150, 1, 1);

% Roberts without imadjust
%[x10905JLRobertsArr, x10905JLROCRobertsArr] = e1.roberts_batch(1, 30, 0, 1);

% Roberts with imadjust
%[x10905JLaRobertsArr, x10905JLaROCRobertsArr] = e1.roberts_batch(1, 40, 1, 1);

% Canny without imadjust
%[x10905JLCannyArr, x10905JLROCCannyArr] = e1.canny_batch(1, 15, 1, 0, 1);

% Canny with imadjust
%[x10905JLaCannyArr, x10905JLaROCCannyArr] = e1.canny_batch(1, 15, 1, 1, 1);

% Canny with anisotropic diffusion
%[x10905JLCADArr, x10905JLROCCADArr] = e1.canny_anisodiff2_batch(1, 20, 'iterations', 1, 1);
%[x10905JLCADArr, x10905JLROCCADArr] = e1.canny_anisodiff2_batch(10, 40, 'kappa', 1, 1);

% Edge detection using dilate-erode method
%[x10905JLDEArr, x10905JLROCDEArr] = e1.dilate_erode_batch(1, 70, 'threshold', 1);
%[x10905JLDEArr, x10905JLROCDEArr] = e1.dilate_erode_batch(1, 5, 'num_erosions', 1);

% Histogram based edge detection
%[x10905JLHED, x10905JLHEDROC] = e1.local_hed(1, 10, 5);

% Second order methods
% --------------------

% LoG
%[x10905JLLoGArr, x10905JLROCLoGArr] = e1.LoG_batch(1, 3, 1);

% DoG
%[x10905JLDoGArr, x10905JLROCDoGArr] = e1.DoG_batch(1, 2, 10, 'max_sigma', 1);