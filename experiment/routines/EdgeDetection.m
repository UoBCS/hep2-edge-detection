classdef EdgeDetection
    %EDGEDETECTION Defines methods for edge detection
    
    properties
        img
        imgA
        imgT
    end
    
    methods(Static)
        function [sens, spec] = roc_params_comparison(rocArr, thresholds, ttl, xl)
            sens = rocArr(:,1);
            spec = rocArr(:,2);
            
            figure
            plot(thresholds, sens, thresholds, spec);
            title(ttl)
            legend('Sensitivity', 'Specificity')
            xlabel(xl)
            ylabel('Sens/Spec')
        end
    end
    
    methods
        function obj = EdgeDetection(image, trueImage)
            obj.img = image;
            obj.imgA = imadjust(obj.img);
            obj.imgT = trueImage;
        end
        
        function [res, roc, threshold] = otsu(obj)
            global SOBEL;
            
            threshold = graythresh(obj.img);
            imgBW = single(im2bw(obj.img, threshold));
            res = detect_edges(imgBW, SOBEL.sobelX, SOBEL.sobelY) >= 1;
            roc = compute_roc(res, obj.imgT);
        end
        
        function [res, roc] = sobel(obj, adjust, threshold)
            global SOBEL;
            
            if adjust
                image = obj.imgA;
            else
                image = obj.img;
            end
            
            imgSobel = detect_edges(image, SOBEL.sobelX, SOBEL.sobelY);
            res = imgSobel > threshold;
            roc = compute_roc(res, obj.imgT);
        end
        
        function [imgArr, rocArr] = sobel_batch(obj, lth, uth, step, adjust, view)
            if adjust
                text = ' imadjust';
            else
                text = ' without imadjust';
            end
            
            %n = uth-lth;
            %imgArr = zeros(size(obj.img, 1),size(obj.img, 2),n);
            %rocArr = zeros(n,2);
            thresholds = (lth:step:uth);
            count = 1;

            for i = lth:step:uth
                [res, roc] = obj.sobel(adjust, i);
                rocArr(count,:) = roc;
                imgArr(:,:,count) = res;
                count = count + 1;
            end
            
            if view
                [sens, spec] = EdgeDetection.roc_params_comparison(rocArr, thresholds, strcat('Sobel batch - ', text), 'Threshold');
                roc_space(1 - spec, sens, strcat(['ROC space Sobel (thresholds ' num2str(lth) ' - ' num2str(uth) ' ' text, ' )']), 'red');
            end
        end
        
        function [res, roc] = roberts(obj, adjust, threshold)
            global ROBERTS;
            
            if adjust
                image = obj.imgA;
            else
                image = obj.img;
            end
            
            imgRoberts = detect_edges(image, ROBERTS.robertsA, ROBERTS.robertsB);
            res = imgRoberts > threshold;
            roc = compute_roc(res, obj.imgT);
        end
        
        function [imgArr, rocArr] = roberts_batch(obj, lth, uth, adjust, view)
            if adjust
                text = ' imadjust';
            else
                text = ' without imadjust';
            end
            
            n = uth-lth;
            imgArr = zeros(size(obj.img, 1),size(obj.img, 2),n);
            rocArr = zeros(n,2);
            thresholds = (lth:uth);

            for i = lth:uth
                [res, roc] = obj.roberts(adjust, i);
                rocArr(i-lth+1,:) = roc;
                imgArr(:,:,i-lth+1) = res;
            end
            
            if view
                [sens, spec] = EdgeDetection.roc_params_comparison(rocArr, thresholds, strcat(['Roberts batch - ' text]), 'Threshold');
                roc_space(1 - spec, sens, strcat(['ROC space Roberts (thresholds ' num2str(lth) ' - ' num2str(uth) ' ' text ' )']), 'blue');
            end
        end
        
        function [res, roc] = canny(obj, adjust, th1, th2, sigma)
            if adjust
                image = obj.imgA;
            else
                image = obj.img;
            end
            
            if th1 == 0 && th2 == 0
                th = [];
            else
                th = [th1 th2];
            end
            
            res = edge(image, 'Canny', th, sigma);
            roc = compute_roc(res, obj.imgT);
        end
        
        function [imgArr, rocArr] = canny_batch(obj, minSigma, maxSigma, step, adjust, view)
            if adjust
                text = ' imadjust';
            else
                text = ' without imadjust';
            end
            
            sigmas = (minSigma:step:maxSigma);
            count = 1;
            
            for i = sigmas
                [res, roc] = obj.canny(adjust, 0, 0, i);
                rocArr(count,:) = roc;
                imgArr(:,:,count) = res;
                count = count + 1;
            end
            
            if view
                [sens, spec] = EdgeDetection.roc_params_comparison(rocArr, sigmas, strcat(['Canny batch - ' text]), 'Sigma');
                roc_space(1 - spec, sens, strcat(['ROC space Canny (sigmas ' num2str(minSigma) ' - ' num2str(maxSigma) ' ' text ' )']), 'blue');
            end
        end
        
       function [imgArr, rocArr] = canny_anisodiff2_batch(obj, minParam, maxParam, param, option, view)
            n = maxParam-minParam;
            imgArr = zeros(size(obj.img, 1),size(obj.img, 2),n);
            rocArr = zeros(n,2);
            params = (minParam:maxParam);

            for i = minParam:maxParam
                if strcmp(param, 'iterations')
                    numIt = i;
                    kappa = 30;
                elseif strcmp(param, 'kappa')
                    kappa = i;
                    numIt = 15;
                end
                
                [res, roc] = obj.canny_anisodiff2(numIt, kappa, option);
                rocArr(i-minParam+1,:) = roc;
                imgArr(:,:,i-minParam+1) = res;
            end
            
            if view
                [sens, spec] = EdgeDetection.roc_params_comparison(rocArr, params, 'Canny with anisotropic diffusion (CAD) batch', param);
                roc_space(1 - spec, sens, 'ROC space CAD', 'blue');
            end
       end
        
       function [res, roc] = canny_anisodiff2(obj, numIt, kappa, option)
            res = anisodiff2D(obj.img, numIt, 1/7, kappa, option);
            
            res = edge(res, 'canny');
            
            se90 = strel('line', 3, 90);
            se0 = strel('line', 3, 0);
            res = imdilate(res, [se90 se0]);
            roc = compute_roc(res, obj.imgT); 
        end
        
        function [res, roc] = dilate_erode_method(obj, numErosions, threshold)
            global SOBEL;
            
            se90 = strel('line', 3, 90);
            se0 = strel('line', 3, 0);
            imgDilate = imdilate(obj.img, [se90, se0]);
            imgFilled = imfill(imgDilate, 'holes');
            seD = strel('diamond', 1);
            
            for i = 1:numErosions
                if i == 1
                    imgEroded = imerode(imgFilled, seD);
                else
                    imgEroded = imerode(imgEroded, seD);
                end
            end
            
            res = detect_edges(imgEroded, SOBEL.sobelX, SOBEL.sobelY) > threshold;
            roc = compute_roc(res, obj.imgT);
        end
        
        function [imgArr, rocArr] = dilate_erode_batch(obj, minParam, maxParam, param, view)
            n = maxParam-minParam;
            imgArr = zeros(size(obj.img, 1),size(obj.img, 2),n);
            rocArr = zeros(n,2);
            params = (minParam:maxParam);

            for i = params
                if strcmp(param, 'threshold')
                    [res, roc] = obj.dilate_erode_method(2, i);
                elseif strcmp(param, 'num_erosions')
                    [res, roc] = obj.dilate_erode_method(i, 60);
                end
                
                rocArr(i-minParam+1,:) = roc;
                imgArr(:,:,i-minParam+1) = res;
            end
            
            if view
                [sens, spec] = EdgeDetection.roc_params_comparison(rocArr, params, 'Dilate-Erode method batch', param);
                roc_space(1 - spec, sens, 'ROC space Dilate-Erode method', 'red');
            end
        end
        
        function [res, roc] = LoG(obj, sigma)
            global LAPLACE;
            
            % filter size = ceil(sigma*3)*2+1
            imgSmooth = gaussian_smoothing(obj.img, sigma);
            res = conv2(imgSmooth, LAPLACE.laplace);
            res = edge(res, 'zerocross');
            res = res(3:end, 3:end);
            roc = compute_roc(res, obj.imgT);
        end
        
        function [imgArr, rocArr] = LoG_batch(obj, minSigma, maxSigma, view)
            
            n = maxSigma-minSigma;
            imgArr = zeros(size(obj.img, 1),size(obj.img, 2),n);
            rocArr = zeros(n,2);
            sigmas = (minSigma:maxSigma);

            for i = minSigma:maxSigma
                [res, roc] = obj.LoG(i);
                rocArr(i-minSigma+1,:) = roc;
                imgArr(:,:,i-minSigma+1) = res;
            end
            
            if view
                [sens, spec] = EdgeDetection.roc_params_comparison(rocArr, sigmas, 'LoG batch', 'Sigma');
                roc_space(1 - spec, sens, strcat(['ROC space LoG (sigmas ' num2str(minSigma) ' - ' num2str(maxSigma) ' )']), 'blue');
            end
        end
        
        function [res, roc] = DoG(obj, sigma1, sigma2)
            imgSmooth1 = gaussian_smoothing(obj.img, sigma1); % 1
            imgSmooth2 = gaussian_smoothing(obj.img, sigma2); % 5
            res = imgSmooth2 - imgSmooth1;
            res = edge(res, 'zerocross');
            roc = compute_roc(res, obj.imgT);
        end
        
        function [imgArr, rocArr] = DoG_batch(obj, fixedParam, minParam, maxParam, variable, view)
            
            n = maxParam-minParam;
            imgArr = zeros(size(obj.img, 1),size(obj.img, 2),n);
            rocArr = zeros(n,2);
            params = (minParam:maxParam);

            for i = minParam:maxParam
                if strcmp(variable, 'min_sigma')
                    minSigma = i;
                    maxSigma = fixedParam;
                elseif strcmp(variable, 'max_sigma')
                    maxSigma = i;
                    minSigma = fixedParam;
                end
                
                [res, roc] = obj.DoG(minSigma, maxSigma);
                rocArr(i-minParam+1,:) = roc;
                imgArr(:,:,i-minParam+1) = res;
            end
            
            if view
                [sens, spec] = EdgeDetection.roc_params_comparison(rocArr, params, 'DoG batch', variable);
                roc_space(1 - spec, sens, 'ROC space DoG', 'blue');
            end
        end
        
        function [res, roc] = local_hed(obj, lt, ut, tolerance)
            res = histogram_edge_detection(obj.img, lt, ut, tolerance);
            roc = compute_roc(res, obj.imgT(2:end, 2:end));
        end
    end
    
end

