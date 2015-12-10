global LAPLACE ROBERTS SOBEL;

LAPLACE = load('filters/laplace.mat');
ROBERTS = load('filters/roberts.mat');
SOBEL = load('filters/sobel.mat');

warning('off','all')

% Load true edge images
x43590AMtrue = read_image('images/43590 AM Edges.bmp', 0);

x43590AMg = read_image('images/43590 AM.bmp', 1);
e1 = EdgeDetection(x43590AMg, x43590AMtrue);
level = graythresh(x43590AMg);
x43590AMbw = single(im2bw(x43590AMg, level));

% Show background graph
% ---------------------

%show_background(x43590AMg);

% First order methods
% -------------------

% Otsu
%[x43590AMbwOtsu, x43590AMbwOtsuROC, x43590AMbwOtsuT] = e1.otsu();

% Sobel without imadjust
%[x43590AMSobelArr, x43590AMROCSobelArr] = e1.sobel_batch(1, 60, 1, 0, 1);

% Sobel with imadjust
%[x43590AMaSobelArr, x43590AMaROCSobelArr] = e1.sobel_batch(10, 100, 1, 1, 1);

% Roberts without imadjust
%[x43590AMRobertsArr, x43590AMROCRobertsArr] = e1.roberts_batch(1, 30, 0, 1);

% Roberts with imadjust
%[x43590AMaRobertsArr, x43590AMaROCRobertsArr] = e1.roberts_batch(1, 40, 1, 1);

% Canny without imadjust
%[x43590AMCannyArr, x43590AMROCCannyArr] = e1.canny_batch(1, 15, 1, 0, 1);

% Canny with imadjust
%[x43590AMaCannyArr, x43590AMaROCCannyArr] = e1.canny_batch(1, 15, 1, 1, 1);

% Canny with anisotropic diffusion
%[x43590AMCADArr, x43590AMROCCADArr] = e1.canny_anisodiff2_batch(1, 20, 'iterations', 1, 1);
%[x43590AMCADArr, x43590AMROCCADArr] = e1.canny_anisodiff2_batch(10, 40, 'kappa', 1, 1);

% Edge detection using dilate-erode method
%[x43590AMDEArr, x43590AMROCDEArr] = e1.dilate_erode_batch(1, 70, 'threshold', 1);
%[x43590AMDEArr, x43590AMROCDEArr] = e1.dilate_erode_batch(1, 5, 'num_erosions', 1);

% Histogram based edge detection
%[x43590AMHED, x43590AMHEDROC] = e1.local_hed(1, 10, 5);

% Second order methods
% --------------------

% LoG
%[x43590AMLoGArr, x43590AMROCLoGArr] = e1.LoG_batch(1, 3, 1);

% DoG
%[x43590AMDoGArr, x43590AMROCDoGArr] = e1.DoG_batch(1, 2, 10, 'max_sigma', 1);