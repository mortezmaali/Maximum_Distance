% USES: calc_gram_matrix
% PARAMETERS: roidata- [nbands, npixels]
% RETURNS: local Gram matrix for the given data, [nPixels, nPixels]

function Gram_local = local_gram(roidata)
% Select the point about which to calculate the local Gram Matrix.
% Point nearest the MEAN
nbands = size(roidata,1);
nroipts = size(roidata,2);
%% Initiate the mean vector. 
% Then, for each band, calculate the mean
% of all the values corresponding to that band.
mean_spec = zeros(nbands,1);
for i = 1:nbands
   mean_spec(i) = mean(roidata(i,:)); 
end

diffdist = zeros(nroipts,1);
for i = 1:nroipts
   diffdist(i) = norm(mean_spec - roidata(:,i));
end
[mindist,minloc] = min(diffdist);
%% Get the other pixels into nearpix.
nearpix = zeros(nbands,nroipts); % define the new array size
index = ones(1,nroipts); % will become index of rows to keep
index(minloc) = 0;  % keep them all but this one
keeprow = index == 1; % figure out which rows to keep
nearpix = roidata(:,keeprow); % make the new array
%% compute the cal_gram_matrix function
Gram_local = cal_gram_matrix(mean_spec,nearpix);
end