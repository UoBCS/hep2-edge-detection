function [ sensitivity, specificity ] = compute_roc( ID, IT )

     TP = ID & IT;
     TP = sum(TP(TP == 1));
     
     FP = ID & ~IT;
     FP = sum(FP(FP == 1));
     
     FN = ~ID & IT;
     FN = sum(FN(FN == 1));
     
     TN = ~ID & ~IT;
     TN = sum(TN(TN == 1));
     
     sensitivity = TP / (TP + FN);
     specificity = TN / (TN + FP);
end

