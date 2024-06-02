close all;clear all;clc
datafile = 'C:\Users\Morteza\OneDrive\Desktop\PhD\New_Data\8cal_Seurat_AFTER';
hdrfile = 'C:\Users\Morteza\OneDrive\Desktop\PhD\New_Data\8cal_Seurat_AFTER.hdr';

hcube = hypercube(datafile,hdrfile);
img = im2double(hcube.DataCube);
img = img(:,:,1:151);
num_endmember = 9;
I_sphere_bin=reshape(img,[670*1062 151]);
MNFD = hypermnf(img,151);
MNFD=reshape(MNFD,[670*1062 151]);
fcn_array = cal_vol_func(I_sphere_bin,MNFD,num_endmember);
%% compute ratio of general gram matrix
gen_gram_matrix = fcn_array(2,:);
gen_gram_matrix = gen_gram_matrix./sum(gen_gram_matrix);
%% plot the volume estimation figure
endmem = 3:1:num_endmember;
figure,
plot(endmem,gen_gram_matrix(3:num_endmember),'LineWidth',1.8);
xlabel('number of endmembers');ylabel('estimated volume');xlim([3 num_endmember]);
set(gca, 'FontSize', 18);
%% compute endmembers (let's say 6)
[Endmembers, endmember_index] = MaxD_Endmembers(I_sphere_bin,I_sphere_bin,9);