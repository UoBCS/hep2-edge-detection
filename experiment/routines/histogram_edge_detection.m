function [ out_img ] = histogram_edge_detection( img, lt, ut, tolerance )

    out_img = zeros(size(img, 1) - 1, size(img, 2) - 1);

    for i = 2:size(img, 1)-1
        for j = 2:size(img, 2)-1
            mask = [img(i-1,j-1) img(i-1,j) img(i-1,j+1); img(i, j-1) img(i, j) img(i, j+1); img(i+1, j-1) img(i+1, j) img(i+1,j+1)];
            uv = unique(mask);
            freq = [uv, histc(mask(:),uv)];
            n = mean(freq(uv <= lt, 2));
            m = mean(freq(uv >= ut, 2));
            diff = abs(m - n);
            
            if diff >= 0 && diff <= tolerance
               out_img(i, j) = 1;
            else
                out_img(i, j) = 0;
            end
        end
    end

end