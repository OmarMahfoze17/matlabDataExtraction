function FX=readBinay(dire,nx,ny,nz,Start,End)
fileID=fopen(dire,'rb');
% h = fread(fileID,1,'*uint32');
A = fread(fileID,[Start,End],'float64');
% B=A(1:)
% size(A)
% nx*ny*nz
% if (Flixable=='flixable')
 FX=reshape(A,nx,ny,nz);
% FX=A;
% else
%     FX=reshape(A,nx,ny,nz);
% end
fclose(fileID);
