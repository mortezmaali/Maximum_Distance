% ref_pixel and neighbors should have same bands
% ref_pixel(nbands) - pixel about which to calculate the Gram Matrix
% neighbors(nbands,nPixels) - array of the nearest neighbor pixels
% Gram - the Gram Matrix; [nPixels, nPixels], 
% where nPixels is the number of pixels in the neighborhood array
function Gram = cal_gram_matrix(ref_pixel,neighbors)
%% initialize the matrix
% n_neighbors_bands = size(neighbors,1);
n_neighbors = size(neighbors,2);
% diff_vec = zeros(n_neighbors_bands,1);
% diff_vec_j = zeros(n_neighbors_bands,1);
Gram = zeros(n_neighbors,n_neighbors);
%% calculate Gram matrix
for i = 1:(n_neighbors-1)
   diff_vec = neighbors(:,i) - ref_pixel;
   Gram(i,i) = (diff_vec') * diff_vec;
   
   for j = (i+1):n_neighbors
      diff_vec_j = neighbors(:,j) - ref_pixel;
      Gram(i,j) = (diff_vec') * diff_vec_j;
      Gram(j,i) = Gram(i,j);
   end 
end
diff_vec = neighbors(:,n_neighbors) - ref_pixel;
Gram(n_neighbors,n_neighbors) = (diff_vec') * diff_vec;
end