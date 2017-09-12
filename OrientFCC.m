function [avgXXX] = OrientFCC(r,y,A)
%Find FCC Unit Cell Orientation
%Orient_ALL_ATOMS: Find orientation at current atoms within grain
%   Uses closest packed directions to find reference orientation
%   Even if the atom is in a noncrystalline local environment an
%   orientation will be found and assigned. This orientation can be
%   meaningless and the atom will be converted to noncrystalline during
%   grain identification.


format short
%Avoid error due to bad initial orientation:
CPangles = [0;0;0;0];    %Initialize Variable    

CPvectors=0;                            %Initialize variable for while loop

%Calculate the 12 directional vectors
for i = 1:12
    v(i,1:3) = A(y(i),1:3)-A(r,1:3);
end

% %To find the two close packed planes passing through point r:
for i=1:12 %all vector combinations
    for j=1:12  %only compare with vector number 1
        angles(i,j)=acosd(dot(v(i,1:3),v(j,1:3))/(norm(v(i,1:3))*norm(v(j,1:3))));
    end
end
angles=abs(angles);
%% Find all 12 sets of axis
for k=1:12
    
    %Find all vectors that make 60 degree angles with chosen arbitrary vector
    CP = find(angles(:,k) > 59 & angles(:,k) < 61); %Find vectors that make 60 deg angles with chosen vector
    counter=1;
    CP=[];
    while numel(CP) <4
        CP = find(angles(:,k) > 59-counter & angles(:,k) < 61+counter);
        counter=counter+1;
    end
    CPvectors=v(CP(1:4),:);
    
    % end
    CPangles=[];
    %Find Combinations that make 90 degree angles
    for i =1:4
        CPangles(i,1)=dot(CPvectors(1,:),CPvectors(i,:))/(norm(CPvectors(1,:))*norm(CPvectors(i,:)));
    end
    CPangles=acosd(CPangles);
    %First Combo check for accuracy
    % CProws_check = find(CPangles(:,1) > -7 & CPangles(:,1) < 7 | CPangles(:,1) > 83 & CPangles(:,1) < 97);
    
    
    %% First Combo
    counter=0;
    n=0;
    CProws=[];
    while n <1
        n=numel(find(CPangles(:,1) > -1-counter & CPangles(:,1) < 1+counter));
        counter=counter+1;
        
    end
    counter=counter-1;
    CProws(1,:)=find(CPangles(:,1) > -1-counter & CPangles(:,1) < 1+counter,1);  %Only Keep 1
    
    counter=0;
    n=0;
    
    while n <1
        n=numel(find(CPangles(:,1) > 89-counter & CPangles(:,1) < 91+counter));
        counter=counter+1;
        
    end
    counter=counter-1;  %return to prev step size
    a =find(CPangles(:,1) > 89-counter & CPangles(:,1) < 91+counter,1);  %Only Keep 1
    CProws(2,:)=a(1,:);
    
    %% Second Combo
    a=[1;2;3;4];                %Find two remaining combinations
    a=[a;CProws];
    [~,e,~]=unique(a,'last');
    e=sort(e);
    CProws(3:4,:)=a(e(1:2,:));  %First two rows = combo1; last two rows=combo 2
    
    %% Add two combos of 90 degree vectors to get -100 0-10 001 plane then cross
    % vectors
    x1=CPvectors(CProws(1),:)+CPvectors(CProws(2),:);
    x2=CPvectors(CProws(3),:)+CPvectors(CProws(4),:);
    
    x1=x1/norm(x1);  %Normalize
    x2=x2/norm(x2);  %Normalize
    % x=[x1;x2];
    x3=cross(x1,x2);
    x3=x3/norm(x3);
    
    %% To store the average orientation
    xxx=[x1;x2;x3];
    XXX{k}=[xxx;-x2;-x1;-x3];  %all six possible 001 axis   %Set one 1:3 set two 4:6
end
%% Average All sets
xxx10=[];  %initialize variable
xxx20=[];
xxx30=[];
xxx40=[];
xxx50=[];
xxx60=[];

    for j=1:12 

            %dot products to find corres. axis
                for n=1:6
                    for p=1:6
                        axismap{j}(n,p)=acosd(dot(XXX{1}(n,1:3),XXX{j}(p,1:3)));
                    end 
                end
            [~, I]=min(axismap{j},[],2);
           
            %Store each axis respectively to the list
            xxx10=[xxx10;XXX{j}(I(1),:)];
            xxx20=[xxx20;XXX{j}(I(2),:)];
            xxx30=[xxx30;XXX{j}(I(3),:)];
            xxx40=[xxx40;XXX{j}(I(4),:)];
            xxx50=[xxx50;XXX{j}(I(5),:)];
            xxx60=[xxx60;XXX{j}(I(6),:)]; 
    
    end
            
        clear I axismap
        
        xxx10=mean(xxx10);
        xxx20=mean(xxx20);
        xxx30=mean(xxx30);
        xxx40=mean(xxx40);
        xxx50=mean(xxx50);
        xxx60=mean(xxx60);
        
        xxx10=xxx10/norm(xxx10);
        xxx20=xxx20/norm(xxx20);
        xxx30=xxx30/norm(xxx30);
        xxx40=xxx40/norm(xxx40);
        xxx50=xxx50/norm(xxx50);
        xxx60=xxx60/norm(xxx60);
        
        avgXXX=[xxx10;xxx20;xxx30;xxx40;xxx50;xxx60];

end

