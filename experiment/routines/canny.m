function [ mag ] = canny( image )
    load 'filters/sobel'

    % Smoothing
    smooth = gaussian_smoothing(image, 3);
    
    % Find gradients
    smoothSobelX = conv2(smooth, sobelX, 'same');
    smoothSobelY = conv2(smooth, sobelY, 'same');
    
    mag = magnitude(smoothSobelX, smoothSobelY);
    
    % Edge directions
    dir = atan(abs(smoothSobelY)./abs(smoothSobelX));
    
    % Non-maximum suppression
    R = max(size(dir));
    C = min(size(dir));

    for i=2:R-2,
        for j=2:C-2,
            rounded_angle = round(dir(i,j) / radians(45)) * radians(45);
            angle_dir = get_dir(rounded_angle);
            
            if strcmp(angle_dir, 'N') || strcmp(angle_dir, 'S')
                a = mag(i-1,j);
                b = mag(i+1,j);
            elseif strcmp(angle_dir, 'NE') || strcmp(angle_dir, 'SW')
                a = mag(i-1,j+1);
                b = mag(i+1,j-1);
            elseif strcmp(angle_dir, 'NW') || strcmp(angle_dir, 'SE')
                a = mag(i-1,j-1);
                b = mag(i+1,j+1);
            elseif strcmp(angle_dir, 'E') || strcmp(angle_dir, 'W')
                a = mag(i,j+1);
                b = mag(i,j-1);
            end
            
            if mag(i,j) < a || mag(i,j) < b
                mag(i,j) = 0;
            end
        end
    end
    
    % Edge hystheresis
end

function d = get_dir(angle)

    if angle == pi/4
        d = 'NE';
    elseif angle == pi/2
        d = 'N';
    elseif angle == (3/4)*pi
        d = 'NW';
    elseif angle == pi
        d = 'W';
    elseif angle == -(3/4)*pi
        d = 'SW';
    elseif angle == -pi/2
        d = 'S';
    elseif angle == -pi/4
        d = 'SE';
    else
        d = 'E';
    end
    
end

function r = radians(deg)
    r = deg * (pi / 180);
end

