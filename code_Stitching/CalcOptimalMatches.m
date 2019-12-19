function [RANSAC_Matches, OptimalAffineMatchingTrans] = CalcOptimalMatches(Frames1,Frames2,Matches)
 
% The function CalcOptimalMatches(...) calculates the optimal transformation in the RANSAC sense.
% This is done by using the CalculateAffineMatching(...) function multiple times (to be exact - NumOfIterations times),
% and finds the transformation with maximum inlayer supporters.

% Inputs:

% Frames1                - First output of the sift.m function for the first image to be transformed (origin). 
% Frames2                - First output of the sift.m function for the second destination image. 
% Matches                - Output of the siftmatch.m function, contaning the SIFT matches between the descriptors of both images.

% Outputs:

% RANSAC_Matches             - A diluted Matches vector containing only the inlayer matches.
% OptimalAffineMatchingTrans - The optimal affine transformation between the two images in the RANSAC sence.

% Use 1000 RANSAC iterations:
NumOfIterations = 1000;

OptimalNumOfInlayers = 0;
Matches_vec_length = size(Matches,2);
 
% Do the RANSAC process:
for iter = 1:NumOfIterations
 
% Randomly choose 6 pairs of matching key-points  (p, p_gal) and calculate the affine transformation
% according to them, such that for each i = 1,...,6 , p = H * p_gal:    
    IsUseMatchForTransCalc = zeros(Matches_vec_length,1);
    point_indexed_for_trans_calc = randperm(Matches_vec_length,6);    
    IsUseMatchForTransCalc(point_indexed_for_trans_calc) = 1;     
    
    [~, IsMatchAnInLayer]  =... 
        CalculateAffineMatching(Frames1,Frames2,Matches,IsUseMatchForTransCalc);
    
    NumOfInlayers = sum(IsMatchAnInLayer);
    if (NumOfInlayers > OptimalNumOfInlayers) && (NumOfInlayers >= 6)
        OptimalNumOfInlayers = NumOfInlayers;
        Optimal_IsMatchAnInLayer = IsMatchAnInLayer;
    end
end
 
% An optimal set of 6 matchs was found, now use all the inlayers to calculate the mid affine transformation:
IsUseMatchForMidTransCalc = Optimal_IsMatchAnInLayer;       
[~, IsMatchAnInLayerMid] =.... 
    CalculateAffineMatching(Frames1,Frames2,Matches,IsUseMatchForMidTransCalc);

% Calculate the final transformation using all mid inlayers:
IsUseMatchForFinalTransCalc = IsMatchAnInLayerMid;       
[OptimalAffineMatchingTrans, IsMatchAnInLayerFinal] =.... 
    CalculateAffineMatching(Frames1,Frames2,Matches,IsUseMatchForFinalTransCalc);

% Combine for output only inlayer matches:
RANSAC_Matches = [];
for MachesInd = 1:Matches_vec_length
    if IsMatchAnInLayerFinal(MachesInd)
        temp_RANSAC = zeros(2,size(RANSAC_Matches,2)+1);
        if ~isempty(RANSAC_Matches)
            temp_RANSAC(:,1:size(RANSAC_Matches,2)) = RANSAC_Matches;
        end
        temp_RANSAC(:,size(RANSAC_Matches,2)+1) = Matches(:,MachesInd);
        RANSAC_Matches = temp_RANSAC;
    end
end
