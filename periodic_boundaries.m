function [O] = periodic_boundaries(A,xrange,yrange,zrange,xboundaries,yboundaries,zboundaries)
%Builds PBs in the directions specified. Obtains the box sizes from the
%cfg file. 
%xboundaries,yboundaries,zboundaries are input designators where a 1 adds 
%boundaries in the specified direction and a 0 does not
xmax=max(A(:,1));
xmin=min(A(:,1));
ymax=max(A(:,2));
ymin=min(A(:,2));
zmax=max(A(:,3));
zmin=min(A(:,3));
progress=[];
B=[];
%% Find Boundary Extensions (10%)
perc=.1;  %extend boundary 10 percent;    
       
%  Pieces to be duplicated
    
if xboundaries ==1 
    xlow = logical(A(:,1) < (xmin + xrange*perc));
    xhi  = logical(A(:,1) > (xmax - xrange*perc));
end

if yboundaries ==1 
    ylow = logical(A(:,2) < (ymin + yrange*perc));
    yhi  = logical(A(:,2) > (ymax - yrange*perc));
end

if zboundaries ==1
    zlow = logical(A(:,3) < (zmin + zrange*perc));
    zhi  = logical(A(:,3) > (zmax - zrange*perc));
end
    
 %% Build new A matrix  
 
 %   Original Points
        O=A(:,:);
 
    if xboundaries ==1 
    
        % plus x dir
        O=[O;A(xlow,1) + xrange,A(xlow,2:end)];
    
        % minus x dir
        O=[O;A(xhi,1) - xrange,A(xhi,2:end)];
    end 

    if yboundaries ==1 
        
        % plus y dir
        O=[O;A(ylow,1),A(ylow,2) + yrange,A(ylow,3:end)];

        % minus y dir
        O=[O;A(yhi,1),A(yhi,2) - yrange,A(yhi,3:end)];
    end

    if xboundaries ==1 && yboundaries ==1 
        
        % plus x dir plus y dir
        O=[O;A(xlow==1 & ylow==1,1) + xrange,A(xlow==1 & ylow==1,2) + yrange,A(xlow==1 & ylow==1,3:end)];

        % minus x dir plus y dir
        O=[O;A(xhi==1 & ylow==1,1) - xrange,A(xhi==1 & ylow==1,2) + yrange,A(xhi==1 & ylow==1,3:end)];

        % plus x dir minus y dir
        O=[O;A(xlow==1 & yhi==1,1) + xrange,A(xlow==1 & yhi==1,2) - yrange,A(xlow==1 & yhi==1,3:end)];

        % minus x dir minus y dir
        O=[O;A(xhi==1 & yhi==1,1) - xrange,A(xhi==1 & yhi==1,2) - yrange,A(xhi==1 & yhi==1,3:end)];
    end
    
    if zboundaries ==1 
        % plus z dir
        O=[O;A(zlow==1,1:2),A(zlow==1,3) + zrange,A(zlow==1,4:end)];
    end
    
    if xboundaries ==1 && zboundaries ==1 
        % plus x dir plus z dir
        O=[O;A(xlow==1 & zlow==1,1) + xrange,A(xlow==1 & zlow==1,2),A(xlow==1 & zlow==1,3) + zrange, A(xlow==1 & zlow==1,4:end)];

        % minus x dir plus z dir
        O=[O;A(xhi==1 & zlow==1,1) - xrange,A(xhi==1 & zlow==1,2),A(xhi==1 & zlow==1,3) + zrange, A(xhi==1 & zlow==1,4:end)];
    end
    
    if yboundaries ==1  && zboundaries ==1 
        % plus y dir plus z dir
        O=[O;A(ylow==1 & zlow==1,1),A(ylow==1 & zlow==1,2) + yrange,A(ylow==1 & zlow==1,3) + zrange, A(ylow==1 & zlow==1,4:end)];

        % minus y dir plus z dir
        O=[O;A(yhi==1 & zlow==1,1),A(yhi==1 & zlow==1,2) - yrange,A(yhi==1 & zlow==1,3) + zrange, A(yhi==1 & zlow==1,4:end)];
    end
    
    if xboundaries ==1  && yboundaries ==1  && zboundaries ==1 
        % plus x dir plus y dir plus z dir
        O=[O;A(xlow==1 & ylow==1 & zlow==1,1) + xrange,A(xlow==1 & ylow==1 & zlow==1,2) + yrange,A(xlow==1 & ylow==1 & zlow==1,3) + zrange, A(xlow==1 & ylow==1 & zlow==1,4:end)];

        % minus x dir plus y dir plus z dir
        O=[O;A(xhi==1 & ylow==1 & zlow==1,1) - xrange,A(xhi==1 & ylow==1 & zlow==1,2) + yrange,A(xhi==1 & ylow==1 & zlow==1,3) + zrange, A(xhi==1 & ylow==1 & zlow==1,4:end)];

        % plus x dir minus y dir plus z dir
        O=[O;A(xlow==1 & yhi==1 & zlow==1,1) + xrange,A(xlow==1 & yhi==1 & zlow==1,2) - yrange,A(xlow==1 & yhi==1 & zlow==1,3) + zrange, A(xlow==1 & yhi==1 & zlow==1,4:end)];

        % minus x dir minus y dir plus z dir
        O=[O;A(xhi==1 & yhi==1 & zlow==1,1) - xrange,A(xhi==1 & yhi==1 & zlow==1,2) - yrange,A(xhi==1 & yhi==1 & zlow==1,3) + zrange, A(xhi==1 & yhi==1 & zlow==1,4:end)];
    end
    
    if zboundaries ==1 
        % minus z dir
        O=[O;A(zhi,1:2),A(zhi,3) - zrange,A(zhi,4:end)];
    end
    
    if xboundaries ==1 && zboundaries ==1
        % plus x dir minus z dir
        O=[O;A(xlow==1 & zhi==1,1) + xrange,A(xlow==1 & zhi==1,2),A(xlow==1 & zhi==1,3) - zrange, A(xlow==1 & zhi==1,4:end)];

        % minus x dir minus z dir
        O=[O;A(xhi==1 & zhi==1,1) - xrange,A(xhi==1 & zhi==1,2),A(xhi==1 & zhi==1,3) - zrange, A(xhi==1 & zhi==1,4:end)];
    end
    
    if yboundaries==1 && zboundaries==1
        % plus y dir minus z dir
        O=[O;A(ylow==1 & zhi==1,1),A(ylow==1 & zhi==1,2) + yrange,A(ylow==1 & zhi==1,3) - zrange, A(ylow==1 & zhi==1,4:end)];
    
        % minus y dir minus z dir
        O=[O;A(yhi==1 & zhi==1,1),A(yhi==1 & zhi==1,2) - yrange,A(yhi==1 & zhi==1,3) - zrange, A(yhi==1 & zhi==1,4:end)];
    end
    
    if xboundaries==1 && yboundaries ==1 && zboundaries ==1 
        % plus x dir plus y dir minus z dir
        O=[O;A(xlow==1 & ylow==1 & zhi==1,1) + xrange,A(xlow==1 & ylow==1 & zhi==1,2) + yrange,A(xlow==1 & ylow==1 & zhi==1,3) - zrange, A(xlow==1 & ylow==1 & zhi==1,4:end)];

        % minus x dir plus y dir minus z dir
        O=[O;A(xhi==1 & ylow==1 & zhi==1,1) - xrange,A(xhi==1 & ylow==1 & zhi==1,2) + yrange,A(xhi==1 & ylow==1 & zhi==1,3) - zrange, A(xhi==1 & ylow==1 & zhi==1,4:end)];

        % plus x dir minus y dir minus z dir
        O=[O;A(xlow==1 & yhi==1 & zhi==1,1) + xrange,A(xlow==1 & yhi==1 & zhi==1,2) - yrange,A(xlow==1 & yhi==1 & zhi==1,3) - zrange, A(xlow==1 & yhi==1 & zhi==1,4:end)];

        % minus x dir minus y dir minus z dir
        O=[O;A(xhi==1 & yhi==1 & zhi==1,1) - xrange,A(xhi==1 & yhi==1 & zhi==1,2) - yrange,A(xhi==1 & yhi==1 & zhi==1,3) - zrange, A(xhi==1 & yhi==1 & zhi==1,4:end)];
    end

    end