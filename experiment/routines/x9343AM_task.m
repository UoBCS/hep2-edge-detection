global LAPLACE ROBERTS SOBEL;

LAPLACE = load('filters/laplace.mat');
ROBERTS = load('filters/roberts.mat');
SOBEL = load('filters/sobel.mat');

warning('off','all')

% Load true edge images
x9343AMtrue = read_image('images/9343 AM Edges.bmp', 0);

x9343AMg = read_image('images/9343 AM.bmp', 1);
e1 = EdgeDetection(x9343AMg, x9343AMtrue);
level = graythresh(x9343AMg);
x9343AMbw = single(im2bw(x9343AMg, level));

% Show background graph
% ---------------------

%show_background(x9343AMg);

% First order methods
% -------------------

% Otsu
%[x9343AMbwOtsu, x9343AMbwOtsuROC, x9343AMbwOtsuT] = e1.otsu();

% Sobel without imadjust
%[x9343AMSobelArr, x9343AMROCSobelArr] = e1.sobel_batch(20, 100, 0, 1);

% Sobel with imadjust
%[x9343AMaSobelArr, x9343AMaROCSobelArr] = e1.sobel_batch(20, 150, 1, 1);

% Roberts without imadjust
%[x9343AMRobertsArr, x9343AMROCRobertsArr] = e1.roberts_batch(20, 100, 0, 1);

% Roberts with imadjust
%[x9343AMaRobertsArr, x9343AMaROCRobertsArr] = e1.roberts_batch(1, 40, 1, 1);

% Canny without imadjust
%[x9343AMCannyArr, x9343AMROCCannyArr] = e1.canny_batch(1, 15, 1, 0, 1);

% Canny with imadjust
%[x9343AMaCannyArr, x9343AMaROCCannyArr] = e1.canny_batch(1, 15, 1, 1, 1);

% Canny with anisotropic diffusion
%[x9343AMCADArr, x9343AMROCCADArr] = e1.canny_anisodiff2_batch(1, 20, 'iterations', 1, 1);
%[x9343AMCADArr, x9343AMROCCADArr] = e1.canny_anisodiff2_batch(10, 40, 'kappa', 1, 1);

% Edge detection using dilate-erode method
%[x9343AMDEArr, x9343AMROCDEArr] = e1.dilate_erode_batch(1, 70, 'threshold', 1);
%[x9343AMDEArr, x9343AMROCDEArr] = e1.dilate_erode_batch(1, 5, 'num_erosions', 1);

% Histogram based edge detection
%[x9343AMHED, x9343AMHEDROC] = e1.local_hed(10, 20, 20);

% Second order methods
% --------------------

% LoG
%[x9343AMLoGArr, x9343AMROCLoGArr] = e1.LoG_batch(1, 3, 1);

% DoG
[x9343AMDoGArr, x9343AMROCDoGArr] = e1.DoG_batch(1, 2, 10, 'min_sigma', 1);
