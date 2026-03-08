function [FEMesh, cutOutElements] = cutoutMesh_repeatingcircles(L, l, h, c, r, maxMeshSize, minMeshSize)
L = 4;
l = 0.2;
c = 3;
r = 3;
maxMeshSize = 0.1;
minMeshSize = 0.01;

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

        % Triangle vertices
        x1 = xc - l/2;  y1 = yc - l/2;
        x2 = xc + l/2;  y2 = yc - l/2;
        x3 = xc;        y3 = yc + l/2;

        gd(1:8, col) = [2;          % polygon code
                      3;          % number of vertices
                      x1; x2; x3; % x-coordinates
                      y1; y2; y3];% y-coordinates
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





