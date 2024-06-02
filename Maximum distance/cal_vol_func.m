%% DESCRIPTION:
% First compute MaxD to get the endmembers, this program will increasingly iterate 
% through the endmembers and, during each iteration, calculate the general Gram 
% matrix and local Gram matrix for those endmembers.  The volume of the simplex
% with those endmembers as corners will be calculated based on its respective
% Gram matrices.  Then, those values will be stored in a local Gram volume 
% function and general Gram volume function.
%% USES: general_gram function and local_gram function
%% PARAMETERS: 
% Data: original image data [npixels,nbands],
% MNF_data: MNF of the image data [npixels,nbands],same size as image data
% num_endmembers:give how many endmembers you want to iterate, 15 or 20
%% RETURNS:
% fcn_array: the array of the volume fcns where 
% the first row is the local gram fcn 
% the second row is the general gram fcn
%% start the function
function fcn_array = cal_vol_func(Data,MNF_data,num_endmembers)
loc_gram_fcn = zeros(1,num_endmembers);
gen_gram_fcn = zeros(1,num_endmembers);
for i = 3:num_endmembers % start from 3 because MaxD starts from 3
    [Endmembers, ~] = MaxD_Endmembers(Data,MNF_data,i);

    % Iterate through the endmembers, increasing the number of endmembers
    % each time.  During this, we calculate the local gram matrix and
    % general gram matrix for each set of endmembers.  We then compute the 
    % volume of the simplex with 'i' corners via these matrices by using the
    % following property: the square root of the determinant of the gram 
    % matrix is equal to the volume of the parallelepiped spanned by those 
    % vectors.  Then, the volume is saved as a function of i.

    % LOCAL GRAM MATRIX
    loc_gram = local_gram(Endmembers);
    loc_gram_fcn(i) = sqrt(abs(det(loc_gram)));
    % GENERAL GRAM MATRIX
    gen_gram = general_gram(Endmembers);
    gen_gram_fcn(i) = sqrt(abs(det(gen_gram)));
end
fcn_array = cat(1,loc_gram_fcn,gen_gram_fcn);
end
