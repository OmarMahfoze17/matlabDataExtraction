clc
clear all
close all
path='/home/omar/PhD/Runs/dataExtraction/uncontroledChannel';
fileNameIntial='uxBox';
nTime=100;
% ========== Main Grid Size =================
nx=128;
ny=129;
nz=84;
%--------------------------------------------
%========== Saving Box Size =================
nxB1=1;
nxB2=128;
nyB1=1;
nyB2=129;
nzB1=1;
nzB2=84;
nxBox=nxB2-nxB1+1;
nyBox=nyB2-nyB1+1;
nzBox=nzB2-nzB1+1;
%--------------------------------------------
%======= Processores Size ===================
noProcsY=2;
noProcsZ=2;
totalNoProcs=noProcsY*noProcsZ;
nxProcSize=ones(totalNoProcs,1)*nxBox;
nyProcSize=ones(totalNoProcs,1)*floor(ny/noProcsY);
nzProcSize=ones(totalNoProcs,1)*floor(nz/noProcsZ);
if (mod(ny,noProcsY)~=0)
    nyProcSize(end-noProcsZ+1:end)=...
        nyProcSize(end-noProcsZ+1:end)+1;
end
%--------------------------------------------
totalNoPointsPassed=0;
for time=1:1
    tic
    ProcID=0;
    UX=zeros(nxBox,nyBox,nzBox);
    time
    nypSum=nyProcSize(1);
    for i=1:noProcsY
        nzpSum=0;
        for j=1:noProcsZ
            ProcID=ProcID+1;
            id=num2str(100000+ProcID);
            ID=id(2:end);
            fileName=[path,'/',fileNameIntial,ID]
            [nxProcSize(ProcID),nyProcSize(ProcID),nzProcSize(ProcID)]
            noPoints=nxProcSize(ProcID)*nyProcSize(ProcID)*nzProcSize(ProcID);
            ux=readBinay(fileName,nxProcSize(ProcID),nyProcSize(ProcID),nzProcSize(ProcID),...
                1,noPoints);
            nzpSum=nzpSum+nzProcSize(ProcID);
            UX(:,nypSum-nyProcSize(ProcID)+1:nypSum,nzpSum-nzProcSize(ProcID)+1:nzpSum)=ux;         
            [ProcID,size(UX)]
        end
        nypSum=nypSum+nyProcSize(ProcID);
    end
    toc
end

ux2D(:,:)=UX(5,:,:);
contourf(ux2D)
