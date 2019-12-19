function WarpedImage = WarpImage(InputImage, AffTrans, xGrid, yGrid)
 
% The function WarpImage(...) warps an input image using a linear transformation and resampling.

% Inputs:

% InputImage - The image to be transformed
% AffTrans   - The linear transformation
% xGrid      - Horizontal grid of the output image
% yGrid      - Vertical grid of the output image

% Outputs:

% WarpedImage - The warped and resampled output image.


% Calculate the interpolation grid on the input image, according to the transformation and the output grid:
InverseAffTrans = AffTrans^-1;
WarpedImage = zeros(length(yGrid),length(xGrid));
 
Xq = zeros(length(yGrid),length(xGrid));
Yq = zeros(length(yGrid),length(xGrid));
 
for x_ind = 1:length(xGrid)    
    for y_ind = 1:length(yGrid)
        originPoint = InverseAffTrans * [xGrid(x_ind); yGrid(y_ind); 1];        
        Xq(y_ind,x_ind) = originPoint(1);
        Yq(y_ind,x_ind) = originPoint(2);
    end
end
 
% Interpolate the input image using a bilinear transformation, each color separately:
for color_ind =  1:size(InputImage,3)    
    WarpedImage(:,:,color_ind) = interp2(double(InputImage(:,:,color_ind)),Xq,Yq,'Linear',0);
end
