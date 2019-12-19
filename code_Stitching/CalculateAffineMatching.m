function [AffineMatchingTrans, IsMatchAnInLayer] = ...
        CalculateAffineMatching(Frames1,Frames2,Matches,IsUseMatchForTransCalc)
 
%   The function CalculateAffineMatching(...) gets a set of matching points between two images and calculates the affine
%   transformation between them. The transformation AffineMatchingTrans is 3x3 H homogenous matrix such that
%   each key-point in the first image, p , will map to its corresponding key-points in the second image, p_gal, 
%   according to p = H * p_gal

% Inputs:

% Frames1                - First output of the sift.m function for the first image to be transformed (origin). 
% Frames2                - First output of the sift.m function for the second destination image. 
% Matches                - Output of the siftmatch.m function, contaning the SIFT matches between the descriptors of both images.
% IsUseMatchForTransCalc - A boolean indicator vector with the length of 'Matches', telling the function if to use 
%                          each match when calculating the affine transformation

% Outputs:

% AffineMatchingTrans - The estimated affine trnsformation from the first image to the second one.
% IsMatchAnInLayer    - A boolean indicator vector with the length of 'Matches', telling if a match is an inlayer (true) or an outlayer (false)

NumOfMatchsForTransCalc = sum(IsUseMatchForTransCalc);
 
EnpPointsVec = zeros(NumOfMatchsForTransCalc,1);
OriginPointsMat = zeros(NumOfMatchsForTransCalc,6);
 
PointsVecInd = 0;
 
% Prepare data for least-squares calculation:
for MatchInd = 1:size(Matches,2)
    if IsUseMatchForTransCalc(MatchInd)
        Frame1Ind = Matches(1,MatchInd);
        Frame2Ind = Matches(2,MatchInd);
                
        EnpPointsVec(2*PointsVecInd+1) = Frames2(1,Frame2Ind);
        EnpPointsVec(2*PointsVecInd+2) = Frames2(2,Frame2Ind);
        
        OriginPointsMat(2*PointsVecInd+1,1) = Frames1(1,Frame1Ind);
        OriginPointsMat(2*PointsVecInd+1,2) = Frames1(2,Frame1Ind);
        OriginPointsMat(2*PointsVecInd+1,3) = 1;
        OriginPointsMat(2*PointsVecInd+2,4) = Frames1(1,Frame1Ind);
        OriginPointsMat(2*PointsVecInd+2,5) = Frames1(2,Frame1Ind);
        OriginPointsMat(2*PointsVecInd+2,6) = 1;
        
        PointsVecInd = PointsVecInd + 1;
    end
end

% Calculate least-squares solution:
AffineMatchingTransVec = ((OriginPointsMat')*OriginPointsMat)^-1 * (OriginPointsMat') * EnpPointsVec;

% Reshape to a 3X3 matrix:
AffineMatchingTrans = eye(3,3);
AffineMatchingTrans(1,1:3) = AffineMatchingTransVec(1:3);
AffineMatchingTrans(2,1:3) = AffineMatchingTransVec(4:6);
 
MappingErr = 0;

% Set mapping error threshold to determine if each match is an inlayer or an outlayer:
MappingErrTh = 5;

IsMatchAnInLayer = zeros(size(Matches,2),1);
 
for MatchInd = 1:size(Matches,2)   
  
    Frame1Ind = Matches(1,MatchInd);
    Frame2Ind = Matches(2,MatchInd);
 
    p1 = AffineMatchingTrans *[Frames1(1,Frame1Ind); Frames1(2,Frame1Ind); 1];    
    p2 = [Frames2(1,Frame2Ind); Frames2(2,Frame2Ind); 1];    
       
    dp = p2 - p1;
 
% Calculate mapping error The Euclidean mapping error (L2 distance) between all the features in the second image (destination), 
% and the affine-transformed features from the first image (origin), in units of pixels:    
    dp_sqr = dp(1)*dp(1) + dp(2)*dp(2);   
       
    if (sqrt(dp_sqr) <= MappingErrTh)
         IsMatchAnInLayer(MatchInd) = 1;
    end                   
end
 