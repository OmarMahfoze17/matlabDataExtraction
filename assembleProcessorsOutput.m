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
nxProcSize=ones(noProcsZ,noProcsY)*nxBox;
nyProcSize=ones(noProcsZ,noProcsY)*floor(ny/noProcsY);
nzProcSize=ones(noProcsZ,noProcsY)*floor(nz/noProcsZ);
if (mod(ny,noProcsY)~=0)
    nyProcSize(:,end)=...
        nyProcSize(:,end)+1;
end
%--------------------------------------------
%= Define the processor containing the Box =
%------------ Processors Boundaries on the main grid
% test=zeros(noProcsZ,noProcsY)
% for i=1:noProcsZ
%     for j=1:noProcsY
%         if (nyProcSize(i,j)*j>=nyB1 && (nyProcSize(i,j)*(j-1)+1)<=nyB2 &&...
%                 nzProcSize(i,j)*i>=nzB1 && nzProcSize(i,j)*(i-1)+1<=nzB2)
%             test(i,j)=1;
% %             corners
%         else
%             test(i,j)=0;
%         end
%         [i j test(i,j)]
%
%     end
% end
IDP=0;
for i=1:noProcsZ
    for j=1:noProcsY
        IDP=IDP+1
        ProcID(i,j)=IDP;
        
        if (nyProcSize(i,j)*j>=nyB1 && (nyProcSize(i,j)*(j-1)+1)<=nyB1 &&...
                nzProcSize(i,j)*i>=nzB1 && nzProcSize(i,j)*(i-1)+1<=nzB1)
            C1=[i,j]; % coordinates of the first Processor in the box
        end
        if (nyProcSize(i,j)*j>=nyB2 && (nyProcSize(i,j)*(j-1)+1)<=nyB2 &&...
                nzProcSize(i,j)*i>=nzB2 && nzProcSize(i,j)*(i-1)+1<=nzB2)
            C4=[i,j]; % coordinates of the last Processor in the box
        end
        
    end
end


%--------------------------------------------
totalNoPointsPassed=0;
for time=1:1
    tic
    UX=zeros(nxBox,nyBox,nzBox);
    time
    nypSum=0;
    for j=C1(2):C4(2)
        nzpSum=0;
        for i=C1(1):C4(1)
            
            id=num2str(100000+ProcID(j,i));
            ID=id(2:end);
            fileName=[path,'/',fileNameIntial,ID]
            %             [nxProcSize(i,j),nyProcSize(i,j),nzProcSize(i,j)]
            if C1(1)==C4(1) 
                % if one processor has the full rang
                nzCommon=nzB2-nzB1+1;
            elseif i==C1(1)
                % this is the common points beteen the main grid and
                % the processor points
                nzCommon=(nzProcSize(i,j)*i-nzB1+1);
                
            elseif i==C4(1)
                
                nzCommon=(nzB2-nzProcSize(i-1,j)*(i-1)); 
            else
                nzCommon=nzProcSize(i,j);
            end
            if C1(2)==C4(2)
                % if one processor has the full rang
                nyCommon=nyB2-nyB1+1;
                if (nypSum==0)
                    nypSum=nyCommon;
                end
            elseif j==C1(2)
                nyCommon=(nyProcSize(i,j)*j-nyB1+1);
                if (nypSum==0)
                    nypSum=nyCommon;
                end
            elseif j==C4(2)
                nyCommon=(nyB2-nyProcSize(i,j-1)*(j-1));
            else
                nyCommon=nyProcSize(i,j);
            end
            noPoints=nxProcSize(i,j)*nyCommon*nzCommon;
            ux=readBinay(fileName,nxProcSize(i,j),nyCommon,nzCommon,...
                1,noPoints);
            nzpSum=nzpSum+nzCommon;
            UX(:,nypSum-nyCommon+1:nypSum,nzpSum-nzCommon+1:nzpSum)=ux;
            
            [ProcID(i,j),size(UX)]
        end
        nypSum=nypSum+nyCommon;
    end
    toc
end

ux2D(:,:)=UX(5,:,:);
contourf(ux2D)
