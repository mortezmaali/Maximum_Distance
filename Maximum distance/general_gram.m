% PARAMETERS: pixels(nbands,nPixels) - array of the pixels
% RETURNS: Gram - the Gram Matrix; [nPixels, nPixels]
% where nPixels is the number of pixels in the selected region

function Gram = general_gram(pixels)

n_pixels = size(pixels,2);
Gram = zeros(n_pixels,n_pixels);
%% calculate general gram matrix
for i = 1:(n_pixels-1)
    i_mag = norm(pixels(:,i));
    Gram(i,i) = i_mag * i_mag; % calculate the diagonal elements using that |i|^2 = i???i
   
    for j = (i+1):n_pixels
       Gram(i,j) = (pixels(:,i))' * pixels(:,j);
       Gram(j,i) = Gram(i,j);
    end 
end
% have to do the last diagonal element
last_mag = norm(pixels(:,n_pixels));
Gram(n_pixels,n_pixels) = last_mag * last_mag;
end