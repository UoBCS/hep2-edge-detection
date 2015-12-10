function [ out ] = detect_edges( img, filterX, filterY )

    imgX = conv2(img, filterX, 'same');
    imgY = conv2(img, filterY, 'same');
    
    out = magnitude(imgX, imgY);

end