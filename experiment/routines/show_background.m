function [] = show_background( img )

    background = imopen(img, strel('disk', 15));
    figure
    surf(double(background(1:8:end, 1:8:end))),zlim([0 255]);
    set(gca, 'ydir', 'reverse')

end

