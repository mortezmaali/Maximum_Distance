function [A,p,t]=freadenvi2(fname);
% freadenvi     - read envi image (V. Guissard, Apr 29 2004)
% 				Reads an image of ENVI standard type 
%				to a [col x line x band] MATLAB array
%
% SYNTAX
% A=freadenvi(fname)
% [A,p]=freadenvi(fname)
% [A,p,t]=freadenvi(fname)
%
% INPUT :
%
% fname	string	giving the full pathname of the ENVI image to read.
%
% OUTPUT :
%
% image	c by l by b array containing the ENVI image values organised in
%				c : cols, l : lines and b : bands.
% p		1 by 3	vector that contains (1) the nb of cols, (2) the number.
%				of lines and (3) the number of bands of the opened image.
%
% t		string	describing the image data type string in MATLAB conventions.
%
% NOTE : 			freadenvi needs the corresponding image header file generated
%				automatically by ENVI. The ENVI header file must have the same name
%				as the ENVI image file + the '.hdf' exention.
%
%   Revisions:  1 September 2008 - Matt Montanaro (RIT)
%                   -modified code to read interleave info from header file.
%                   -reshape the matrix depending on interleave.
%                   -replaced datatype switch structure with find command.
%                   -added tic/toc.
%%%%%%%%%%%%%
tic

% Parameters initialization
elements={'samples ' 'lines   ' 'bands   ' 'interleave ' 'data type '};
d={'bit8' 'int16' 'int32' 'float32' 'float64' 'uint16' 'uint32' 'int64' 'uint64'};
di=[1 2 3 4 5 12 13 14 15];

% Check user input
if ~ischar(fname)
    error('fname should be a char string');
end

% Open ENVI header file to retreive s, l, b & d variables
rfid = fopen(strcat(fname,'.hdr'),'r');

% Check if the header file is correctely open
if rfid == -1
    error('Input header file does not exist');
end;

% Read ENVI image header file and get p(1) : nb samples,
% p(2) : nb lines, p(3) : nb bands and t : data type
while 1
    tline = fgetl(rfid);
    if ~ischar(tline), break, end
    [first,second]=strtok(tline,'=');
    
    switch first
        case elements(1)        % samples
            [f,s]=strtok(second);
            p(1)=str2num(s);
        case elements(2)        % lines
            [f,s]=strtok(second);
            p(2)=str2num(s);
        case elements(3)        % bands
            [f,s]=strtok(second);
            p(3)=str2num(s);
        case elements(4)        % interleave
            [f,s]=strtok(second);
            inter=strtrim(s);
        case elements(5)        % data type
            [f,s]=strtok(second);
            t=str2num(s);
            g = find(di == t);
            if g ~= g
                error('Unknown image data type');
            else
                t = d(g);
            end
    end
end
fclose(rfid);
t=t{1,1};

% Open the ENVI image and store it in the 'A' MATLAB array
disp([('Opening '),(num2str(p(1))),('cols x '),(num2str(p(2))),('lines x '),(num2str(p(3))),('bands')]);
disp([('of type '), (t), (' and interleave '), inter]);

fid=fopen(fname);
A=(fread(fid,t));
fclose(fid);

% reshape A based on interleave
switch inter
    case 'bip'
        %% BIP %%
        A=reshape(A,p(3),p(1)*p(2))';
        A=reshape(A,p(1),p(2),p(3));
        A = permute(A,[2,1,3]);     %% need to transpose
    case 'bil'
        %% BIL %%
        A=reshape(A,p(1)*p(3),p(2))';
        A=reshape(A,p(2),p(1),p(3));
    case 'bsq'
        %% BSQ %%
        A=reshape(A,p(1)*p(3),p(2));
        A=reshape(A,p(1),p(2),p(3));
        A = permute(A,[2,1,3]);     %% need to transpose
    otherwise
        error('Unknown interleave');
end

toc
