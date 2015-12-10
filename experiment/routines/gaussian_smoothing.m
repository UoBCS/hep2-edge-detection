function [ img ] = gaussian_smoothing( image, sigma )
    halfw = 3 * sigma;
    [xx, yy] = meshgrid(-halfw:halfw, -halfw:halfw);
    gau = exp(-1/(2 * sigma) * (xx.^ 2+yy.^2));
    
    img = conv2(image, gau, 'same');
end