function OutputImage = StitchImages(StitchedImage, OnToImage)
 
% The function StitchImages(...) stitches the image 'StitchedImage' on to the image 'OnToImage', generating the stitched image 'OutputImage'.
% All pixels with value above 0.01 in one of the colors will be taken from 'StitchedImage', whereas the rest will be taken from 'OnToImage'.

OutputImage = OnToImage;
 
for x_ind = 1:size(OnToImage,2)
    for y_ind = 1:size(OnToImage,1)
        if any(StitchedImage(y_ind, x_ind,:)>0.01)
            OutputImage(y_ind, x_ind,:) = StitchedImage(y_ind, x_ind,:);
        end
    end
end
