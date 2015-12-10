function [] = roc_space( xs, ys, ttl, c )
    figure
    scatter(xs, ys, 20, c, 'filled')
    title(ttl) % ROC space for ...
    xlabel('FPR (False positive rate)')
    ylabel('TPR (True positive rate)')
    axis([0,1,0,1])
end

