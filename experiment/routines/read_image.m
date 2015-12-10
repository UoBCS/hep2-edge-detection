function [ out_img ] = read_image( path, togray )
    out_img = imread(path);
    if togray
        out_img = rgb2gray(out_img);
    end
end

