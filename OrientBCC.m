function [xxx] = OrientBCC(r,y,A)
%Finds BCC unit cell Orientation axis for current atom number, r - with nearest neighbor
%list, y.

%Calculate the 8 directional vectors
for i = 1:8
v(i,1:3) = A(y(i),1:3)-A(r,1:3);
end

%Pick two of these vectors that are not colinear
CPvectors=v(1:2,1:3);
if abs(acosd(dot(CPvectors(1,:),CPvectors(2,:))/(norm(CPvectors(1,:))*norm(CPvectors(2,:))))) < 15 || abs(acosd(dot(CPvectors(1,:),CPvectors(2,:))/(norm(CPvectors(1,:))*norm(CPvectors(2,:))))) > 165
    %need to pick another pair
    CPvectors(2,:) = v(3,:); %replace with new vector
end
    %Find inverse vectors (Resulting in 4 total)
    CPvectors=[CPvectors;-1.*CPvectors];
    
    %redefine vector list
    clear v
    v=CPvectors;
    clear CPvectors 
    % To find all anglular vector combinations
for i=1
    for j=1:4
angles(j,1)=acosd(dot(v(i,1:3),v(j,1:3))/(norm(v(i,1:3))*norm(v(j,1:3))));
    end
end

%Find the vector that makes 70.53 degree angle with chosen arbitrary vector
CP70 = find(angles(:,1) > 69.53 & angles(:,1) < 71.53); 
step=1;

while numel(CP70) <1 
    CP70 = find(angles(:,1) > 69.53-step & angles(:,1) < 71.53+step);
    step=step+1;
end

%Find the vector that lies 109.47 degrees away from arbitrary vector
CP109 = find(angles(:,1) > 108 & angles(:,1) < 110); 
step=1;
while numel(CP109) <1 
    CP109 = find(angles(:,1) > 108-step & angles(:,1) < 110+step);
    step=step+1;
end

%Reorder the three position vectors into the proper order and normalize
%original vector;70degreevector;109degree vector
v=[v(1,:)./norm(v(1,:));v(CP70,:)./norm(v(CP70,:));v(CP109,:)./norm(v(CP109,:))];

%Add the two pairs to get 100 and 010 directions
x1=v(1,:)+v(3,:); %100
x2=v(1,:)+v(2,:); %010

%Cross to find the third axis
x1=x1/norm(x1);  %Normalize 100
x2=x2/norm(x2);  %Normalize 010
x3=cross(x1,x2); %Cross
x3=x3/norm(x3);  %Normalize 001

%Need to rotate these axis by 45 degrees about 100 axis
xxx=[x1;x2;x3];
xxx=[1 0 0;0 cosd(45) -sind(45);0 sind(45) cosd(45)]*xxx;
xxx = [xxx; -xxx];
end