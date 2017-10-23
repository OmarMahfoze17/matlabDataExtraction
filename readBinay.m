function FX=readBinay(dire,nx,ny,nz,Start,End)
fileID=fopen(dire,'rb');
% h = fread(fileID,1,'*uint32');
[nx,ny,nz,Start,End]
A = fread(fileID,'float64');
% B=A(1:)
size(A)

% nx*ny*nz
% if (Flixable=='flixable')
FX=reshape(A,nx,ny,nz);
if (length(A)~=nx*ny*nz)
    error('OMAR ==> Dimension miss match of length(A)~=nx,ny,nz in reading binary')
    pause
end
% FX=A;
% else
%     FX=reshape(A,nx,ny,nz);
% end
fclose(fileID);
