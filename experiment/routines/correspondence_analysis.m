function [] = correspondence_analysis( IDs, subdir, name )

    N = size(IDs, 3);
    K = size(IDs, 2);
    L = size(IDs, 1);
    RES = zeros(L, K);
    
    for i = 1:N
        ID = IDs(:,:,i);
        RES = RES + ID;
        
    end
    
    correspondence_lvls = unique(RES);
    
    f = figure();
    bar(correspondence_lvls, histc(RES(:), correspondence_lvls));
    xlabel('Correspondence level');
    ylabel('Number of pixels');
    title('Correspondence analysis');
    saveas(f, strcat('data/', subdir, '/', name, '_correspondence_analysis.png'));
end

