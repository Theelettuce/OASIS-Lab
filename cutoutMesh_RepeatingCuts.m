function [FEMesh, cutOutElements] = cutoutMesh_repeatingcircles(L, R, c, r, maxMeshSize, minMeshSize)

%Set up gd Matrix
gMatLength = 50;
gMatWidth = c*r + 1;
gd = zeros(gMatLength, gMatWidth);

%Square creation
HH=1 *(L/2);
gd(1:10, gMatWidth) = [2,4, HH, HH, -HH, -HH, HH, -HH, -HH, HH];

%Calculate spacing between each cut
xSpacing = L/(c + 1);
ySpacing = L/(r + 1);

%iterative to input of cuts 
for i = 1:c
    for j = 1:r
        col = (i-1)*r + j;
        xc = -HH + xSpacing * i;
        yc = -HH + ySpacing * j;
        gd(1:5, col) = [1; xc; yc; R; 0];
    end
end

%check to see geometry
disp (gd)
g = decsg(gd);
model = createpde;
geometryFromEdges(model,g);

figure(1)
pdegplot(g,'EdgeLabels','off',"FaceLabels","on")

FEMesh = generateMesh(model,'Hmax', maxMeshSize, 'Hmin',minMeshSize);

kirigami_cutout=1; %Select the faces which form the kirigiami elements

figure(2)
pdeplot(model);
hold on
cutOutElements = findElements(FEMesh,'region','Face',kirigami_cutout); % Define the kirigiami elements
pdemesh(FEMesh.Nodes, FEMesh.Elements(:,cutOutElements),'EdgeColor','green');
hold off
axis equal
pp=1.1;
xlim([-pp*(L/2),pp*(L/2)])
ylim([-pp*(L/2),pp*(L/2)])

end






