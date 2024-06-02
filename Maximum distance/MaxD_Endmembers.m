% Background Endmembers for Target Detection based on TAD
% MaxD Function:
% Parameters: 
%       MData = [npixels, nbands], matrix of pixel-vectors where MaxD
%                                 is applied
%       N = number of endmembers that should be calculated.
% Outputs:
%       Endmembers = [nbands, nEnds], matrix of endmembers
%       idxEndmembers = [1,N], vector with the idx of pixel-vector that
%       were chosen as endmembers

% Leidy Dorado
% Fall 2012 - October

%% MaxD Method 
function [Endmembers idxEndmembers] = MaxD_Endmembers(MData,MData2,N)

Data       = MData';
Data1      = MData2';
[nb pix]   = size(Data);
[npc pix1]  = size(Data1);
magnitude  = sum(Data.^2,1);
[Max1 idx1]= max(magnitude);
[Min1 idx2]= min(magnitude);
Endmembers = zeros(npc,N);
idxEndmembers = zeros(1,N);

Endmembers(:,1) = Data(:,idx1);
Endmembers(:,2) = Data(:,idx2);
idxEndmembers(1,1) = idx1;
idxEndmembers(1,2) = idx2;
Data_proj = Data1;
Id        = eye(npc);
for k=3:N
    difference1= Data_proj(:,idx2)-Data_proj(:,idx1);
    Dps        = pinv(difference1);
 %   I          = eye(nb);
    ProjD      = Id-difference1*Dps;
    Data_proj  = ProjD*Data_proj;
    idx1       = idx2;
    Res = sum(((Data_proj(:,idx2)*ones(1,pix))-Data_proj).^2,1);
  
    [mx3 idx2]  = max(Res);

    Endmembers(:,k) = Data(:,idx2);
    idxEndmembers(1,k)= idx2;
end
