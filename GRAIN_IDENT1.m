 function [A] = GRAIN_IDENT1(FILENAME,PATH,TEMP,GRAINSIZE,gsize,deg,run,crystaltype,cspcutoff,periodicbounds,minGsize) %#ok<INUSL>
 %% Grain Identification Code
 %Devloped by Jason Panzarino
 %Version 2.5.4 4/08/2015
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
%% Input File Format
% FILENAME - Filenames to be processed
% Temps - String naming designator defining the temperature of files
% GRAINSIZE - String Naming designator describing avg grain size
% deg - degree cutoff for allowable misorientation between grains
% crystaltype 1 - FCC, 2 - BCC
% cspcutoff - value deciding crystallinity
% periodic bounds [x y z] 1 X 3 vector, value of 1 adds periodic bounds in
% that direction, 0 does not.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Data Output FORMAT: A =  [x y z cna centro ID A# G# Chk? edge n1  n2  n3  NaN  axis]
%                     A =  [1 2 3  4    5    6  7  8   9    10  11  12  13  14  15-23]
% *************************************************************************
tic
%% Preliminaries
save('deg','deg'); %Save Most recent degree-cutoff (needed for running only 2nd half of GTA)
FILENAMEBASIS = FILENAME(1:end-4); %Remove the .cfg For String Naming Purposes
%     minGsize=200;    %minimum number of atoms to be considered a grain
if run == 0 || run == 1  %To Read from Oriented Atoms Files (Select 1)
    warning off MATLAB:MKDIR:DirectoryExists
    format short g
%     FILENAMEBASIS = FILENAME(1:end-4); %Remove the .cfg For String Naming Purposes
    fprintf('Analyzing: %s\n',FILENAME)
    %% Read in Data
    %Read from cfg file
%     location='\InputSamples\';%changed from / to \ for windows
%     location=sprintf('%s%s%s',pwd,location,FILENAME);
    location=[PATH,FILENAME];
    [A, xsize, ysize, zsize, xlo, ylo, zlo, xhi, yhi, zhi]=CFGOpenerV2(location);
    %% Preparing Columns for Code Execution 
    [n,f] = size(A);  %#ok<NASGU>
    B=zeros(n,18);   %Adding 18 Columns of zeros to the A matrix
    A=[A,B]; %23 columns
    clear B     
    %% Calculate Box size 
    xrange=xsize;
    yrange=ysize;
    zrange=zsize;
    [n,f] = size(A); 
    %% Initial A matrix calculations:
     for i=1:n                      %use Centro-sym parameter to identify grain vs GB atoms (crystallinity) Alternatively, could use CNA           
        if A(i,5) < cspcutoff       %2.14 NI && %2.83 for AL (FCC) | CNA could also be used here for initial identification of crystallinity
            A(i,6) = 1;             %Bulk Lattice        
        else
        A(i,6)=2;                   %GB
        end
        A(i,7)= i;                  %Assign atom number
     end
    %% Add Periodic Boundaries 
    disp('...Building Periodic Boundaries')
    [A] = periodic_boundaries(A,xrange,yrange,zrange,periodicbounds(1),periodicbounds(2),periodicbounds(3)); %Find new matrix of points with boundaries attached
    %% Remove "peppered" atoms (grain interior atoms with csp >= cutoff) (good for removal of thermal noise) (Testing Purposes)
%   [ A ] = removepeppered( A,n,f,xrange,yrange,zrange );    
%% Find edge atoms within entire sample and identify orientation normals
%Specify Crystal Type:
    if crystaltype == 1
        num=12;
    elseif crystaltype == 2
        num=8;
    else
        errordlg('incorrect crystal type designator')
        error('incorrect crystal type designator')
    end
disp('...Finding Edge Atoms and Building NN List')     
%% Set up For NN List Build    
B=A(1:n,6) == 1; %only Test Crystalline Atoms
kk=num2cell(A(B,7)); %List of all Crystalline Atoms Numbers
nnList{size(kk,1),1}=[];
edge{size(kk,1),1}=[];
nnList_simbox{size(kk,1),1}=[];

        %Find Best Nearest Neighbor Radius  
        rad=[];
        i=1;
            while isempty(rad)==1;
                rad=find_nnlist_search_radius(kk{i},A,num); %Find efficient search radius for NN searches
                i=i+1;
            end
            rad=2*rad;
        clear i; %Clean up variables
%% Nearest Neighbor List parfor loop
%     parfor_progress(size(kk,1));  %Track Progress of parfor loop (Testing)
    parfor i=1:size(kk,1)
%         parfor_progress;          %Loop Progress Tracking
         [nnList{i,1},~,~,~,edge{i,1},nnList_simbox{i,1}] = nearest_neighbors_improved_orient(kk{i},A,num,rad);
    end 
%     parfor_progress(0);             %Loop Progress Tracking

% Update A Matrix to include edge designator
edge=cell2mat(edge);
kk=cell2mat(kk);
A(kk(logical(edge)),10) = 1; %Label all Edge atoms within A Matrix

% atoms2orient = kk(edge == 0); %only crystalline atoms of k list
non_edge_nnList = nnList(logical(edge==0),:);  %#ok<NASGU>
non_edge_nnList_simbox = nnList_simbox(logical(edge==0),:);
%% Calculate Orientation List
disp('...Calculating Orientation Distribution')
rall=num2cell(kk);
    if crystaltype == 1 % FCC
        parfor i=1:size(nnList,1)
        Orientations{i,1} = OrientFCC(rall{i},nnList{i},A);
        end
    elseif crystaltype ==2 % BCC
        parfor i=1:size(nnList,1)
        Orientations{i,1} = OrientBCC(rall{i},nnList{i},A);
        end
    end

%Incorporate orientation data into A Matrix
A(kk,15:17)=cell2mat(cellfun(@(c) c(1,:), Orientations,'uniformoutput',false));  %save axis1
A(kk,18:20)=cell2mat(cellfun(@(c) c(2,:), Orientations,'uniformoutput',false));  %save axis2
A(kk,21:23)=cell2mat(cellfun(@(c) c(3,:), Orientations,'uniformoutput',false));  %save axis3
            
%% Build Disorientation List
disp('...Building Disorientation Neighbor List')
rnonedge=num2cell(kk(edge==0));
Disorientation{size(rnonedge,1),1}=[];
% parfor_progress(size(rnonedge,1));    %Loop Progress Tracking

    parfor i=1:size(rnonedge,1)
        Disorientation{i}=disorientationlist(non_edge_nnList_simbox{i},rnonedge{i},A); 
%     parfor_progress;                  %Loop Progress Tracking
    end
%     parfor_progress(0);               %Loop Progress Tracking
    clear rall rnonedge
 
%Save all variables once sample is oriented.
A=A(1:n,:);
mkdir(sprintf('%s/Outputfiles/OrientedSamples',pwd));
save(sprintf('%s/Outputfiles/OrientedSamples/Oriented_%s',pwd, FILENAMEBASIS));

disp('Grain Edges & Atomic Orientations Calculated and Saved Successfully')  
toc
elseif run==2  %************************* Begin Serial Portion of Grain Ident Script ************************
%% To Run from Oriented File (troubleshooting)
sprintf('loading Oriented File');
load(sprintf('%s/Outputfiles/OrientedSamples/Oriented_%s',pwd,FILENAMEBASIS));  %load oriented data
load('deg','deg') %ensure use of the newly entered degree cutoff
run=2;
end
%% Run from serial Portion
if run==1 || run == 2 
%% Begin Identifying Grains
 G=1;                 % Starting with Grain Number 1
 disp(sprintf('Current Filename: %s\nCurrent Grain: %s',FILENAMEBASIS,num2str(G)))     %#ok<DSPS> %Print GTA Status    %#ok<DSPS>      
 D=find(A(1:n,9) == 0 & A(1:n,6) == 1 & A(1:n,10) ~= 1);  %not checked, edge, or boundary
 E=D; %Save Original List for use with nnList reference (line 143)
 while isempty(D) ~= 1  %Run until there are no more unchecked lattice atoms
%% Select First Grain Interior Atom & its orientation
r=D(1,:);         %Row number 1
    current_disorientations=Disorientation{E==r};
%% Nearest Neighbor list for the current atom
    y=non_edge_nnList_simbox{E==r};
    
%% Begin Identifying grain Around First Point
    belowcutoff=y(current_disorientations' < deg & A(y,10)==0 & A(y,9)==0 & A(y,8)==0);  %Find logical nns that meet degree cutoff criteria and set equal to current G num
  %Only add those atoms which arent already long listed. 
    A(belowcutoff,8)=G; %Set these atoms to current Grain number
    A(r,8)=G;  %assign gnum to current atom
    
%% Identify grain atoms around surrounding points
%Begin Building Checklist of atoms: Add unchecked grain atoms to list
LL=zeros(100000,1);         %Space Allocation for Long List
LL(1,1)=r;                  %First Atom added to list
LL(2:numel(belowcutoff)+1,1)=A(belowcutoff,7);  %Add first round of unchecked atoms to LList
p=1;    %Initiate Counter
%Choose one of these atoms, continue & add grain interior atoms to LL
while p <= numel(LL(LL ~= 0)) %Allows list to simultaneously build during loop
    if A(LL(p),9) == 0 && A(LL(p),6) == 1 && A(LL(p),10) == 0             %Checked? Crystalline? Not Edge? If True:
        A(LL(p),9)=1;  %Check mark the current atom
        current_disorientations=Disorientation{E==LL(p)};                 %Collect current orientation
        yn=non_edge_nnList_simbox{E==LL(p)};                              %Collect the atoms neighbor list
        belowcutoff=yn(current_disorientations' < deg & A(yn,10)==0 & A(yn,9)==0 & A(yn,8)==0);  %Find logical nns that meet degree cutoff criteria and set equal to current G num
        A(belowcutoff,8)=G; %Set these atoms to current Grain number
        LLn=belowcutoff;
	    sizeLLn=numel(LLn);
            
        if sizeLLn > 0  %Add the new atoms to list
            sizeLL=numel(LL(LL~= 0));
            LL(sizeLL+1:sizeLLn+sizeLL)=LLn(:,1);
        end
        
        p=p+1;       
      
    else
        A(LL(p),9)=1;                   %Else Mark as checked and iterate to next listed Atom
        p=p+1;       
    end        
%     sprintf('Grainfinder_Progress:\n Number of Atoms: %d \n Grain Number: %d',p, G)   %(Troubleshooting)   
end

%% Grain "keep" criteria:
grainatoms=find(A(:,8)==G);
%% Grain is way too small
    if numel(grainatoms) < minGsize  %toosmall
        A(grainatoms,8)=0;      %Undefine grain number
        A(grainatoms,6)=2;      %Redefine as boundary atoms (They will still stay checked, as well)
    else        %Grain is of sufficient size
        G=G+1;  %Iterate to next grain number
        disp(sprintf('Current Filename: %s\nCurrent Grain: %s',FILENAMEBASIS,num2str(G)))     %#ok<DSPS> %Print GTA Status    %#ok<DSPS>      
    end

%% Rebuild New List of Atoms still be segmented
D=find(A(1:n,9) == 0 & A(1:n,6) == 1 & A(1:n,10) ~= 1);  %not checked, edge, or boundary
if numel(D) < minGsize   %clean up last remaining atoms (
    A(D,6)=2;       %define as boundary atoms
    D=find(A(1:n,9) == 0 & A(1:n,6) == 1 & A(1:n,10) ~= 1); %D will be empty causing exit while loop
end
end
%% Save intermediate variables before edge redef
% disp('...Saving Variables Before Allocating Edge Atoms'); 
% mkdir(sprintf('%s/Outputfiles/VariablesBeforeEdgeRedef',pwd));
% save(sprintf('%s/Outputfiles/VariablesBeforeEdgeRedef/VarsBeforeEdge_%s',pwd,FILENAMEBASIS));
% % load(sprintf('%s/Outputfiles/VariablesBeforeEdgeRedef/VarsBeforeEdge_%s',pwd,FILENAMEBASIS));
% % %load edge vars data (Testing Purposes)

%% redefine all atoms which were not added to to large misorientation differences
disp('...Allocating Misoriented Atoms');
misoriented_anums = A((A(1:n,6) == 2 | A(1:n,6) == 3 | A(1:n,6) == 4)  & A(1:n,5) < cspcutoff & A(1:n,8) == 0,7);    %Anums of atoms which were converted to Ident=2 due to misorientation cutoff
A(misoriented_anums,6)=3; %Give a new identifier, labeling these atoms as 'reallocted'
% nnList_misoriented=nnList_simbox(edge==1); %nnList of only edge atoms
misoriented_redefine=zeros(numel(misoriented_anums),2); %Preallocate memory
for i=1:numel(misoriented_anums)
            y=non_edge_nnList_simbox{E==misoriented_anums(i)};
            grainnumber=mode(A(y(A(y,8)>0),8));   %find the mode of the grainnumbers of all neighbors
            if isnan(grainnumber)==1  %if all surrounding atoms do not belong to a grain convert NaN to 0
                grainnumber=0;
            end
            misoriented_redefine(i,:)=[misoriented_anums(i) grainnumber];  %store the new grain number        
end

%redefine all misoriented atoms using new data
misoriented_redefine(misoriented_redefine(:,2)==0,:)=[]; %remove rows equal to zero gnum (maybe remove)
A(misoriented_redefine(:,1),8)=misoriented_redefine(:,2);

%Repeat the process successively **************** Reallocating atoms
%outward from grain

loopbreak = 1;
while loopbreak>0
        deep_misoriented_anums=misoriented_anums(A(misoriented_anums,8)==0);  %those atoms which have still not be allocated to a grain
        misoriented_redefine=zeros(numel(deep_misoriented_anums),2);
        loopbreak=numel(deep_misoriented_anums);
        
    for i=1:numel(deep_misoriented_anums)
            y=non_edge_nnList_simbox{E==deep_misoriented_anums(i)};
            grainnumber=mode(A(y(A(y,8)>0),8));   %find the mode of the grainnumbers of all neighbors
            if isnan(grainnumber)==1  %if all surrounding atoms do not belong to a grain convert NaN to 0
                grainnumber=0;
            end
            misoriented_redefine(i,:)=[deep_misoriented_anums(i) grainnumber];  %store the new grain number  %redefine to the new grain number                 
    end
    
    %redefine all edge atoms using new data
    misoriented_redefine(misoriented_redefine(:,2)==0,:)=[]; %remove rows equal to zero gnum (maybe remove)
    A(misoriented_redefine(:,1),8)=misoriented_redefine(:,2);
    %Repeat
            deep_misoriented_anums=misoriented_anums(A(misoriented_anums,8)==0); %Recalculate new number of misoriented atoms to be reallocated

            if loopbreak==numel(deep_misoriented_anums) || numel(deep_misoriented_anums)==0 %No longer allocating (all remaining atoms are buried in boundaries or clusters of noncrystalline atoms)
               
                loopbreak=0;
               A(deep_misoriented_anums,6)=4;  %Convert remaining misoriented atoms to ID =4
            end
                clear misoriented_redefine
end
%% redefine all edge atoms to their respective grains
disp('...Allocating Edge Atoms');
edge_anums = kk(edge==1);    %For all crystalline atoms (kk list), find the rows that are edge
nnList_edge=nnList_simbox(edge==1); %nnList of only edge atoms
edgeredefine=zeros(numel(edge_anums),2); %Preallocate memory
for i=1:numel(edge_anums)
            y=nnList_edge{i}(:,:);
            grainnumber=mode(A(y(A(y,8)>0),8));   %find the mode of the grainnumbers of all neighbors
            if isnan(grainnumber)==1  %if all surrounding atoms do not belong to a grain convert NaN to 0
                grainnumber=0;
            end
            edgeredefine(i,:)=[edge_anums(i) grainnumber];  %store the new grain number
end

%redefine all edge atoms using new data
A(edgeredefine(:,1),8)=edgeredefine(:,2);

%Repeat the process successively **************** Reallocating atoms
%outward from grain

loopbreak = 1;
while loopbreak>0
    deep_edge_anums=edge_anums(A(edge_anums,8)==0);
    edgeredefine=zeros(numel(deep_edge_anums),2);
    loopbreak=numel(deep_edge_anums);
    for i=1:numel(deep_edge_anums)
            y=nnList_edge{edge_anums==deep_edge_anums(i)};
            grainnumber=mode(A(y(A(y,8)>0),8));   %find the mode of the grainnumbers of all neighbors
            if isnan(grainnumber)==1  %if all surrounding atoms do not belong to a grain convert NaN to 0
                grainnumber=0;
            end
            edgeredefine(i,:)=[deep_edge_anums(i) grainnumber];  %store the new grain number  %redefine to the new grain number                
    end
    
    %redefine all edge atoms using new data
     A(edgeredefine(:,1),8)=edgeredefine(:,2);
     clear edgeredefine   
    %Repeat
    deep_edge_anums=edge_anums(A(edge_anums,8)==0);

            if loopbreak==numel(deep_edge_anums) || numel(deep_edge_anums)==0 %No longer allocating (all remaining edge atoms are buried in boundaries)
               loopbreak=0;
               A(deep_edge_anums,6)=5;  %Convert remaining edge atoms to ID =5
            end
end

%% Clean up any remaining misoriented atoms
disp('...Allocating Misoriented Atoms');
misoriented_anums = A((A(1:n,6) == 2 | A(1:n,6) == 3 | A(1:n,6) == 4)  & A(1:n,5) < cspcutoff & A(1:n,8) == 0,7);    %Anums of atoms which were converted to Ident=2 due to misorientation cutoff
A(misoriented_anums,6)=3; %Give a new identifier, labeling these atoms as 'reallocted'
% nnList_misoriented=nnList_simbox(edge==1); %nnList of only edge atoms
misoriented_redefine=zeros(numel(misoriented_anums),2); %Preallocate memory
for i=1:numel(misoriented_anums)
            y=non_edge_nnList_simbox{E==misoriented_anums(i)};
            grainnumber=mode(A(y(A(y,8)>0),8));   %find the mode of the grainnumbers of all neighbors
            if isnan(grainnumber)==1  %if all surrounding atoms do not belong to a grain convert NaN to 0
                grainnumber=0;
            end
            misoriented_redefine(i,:)=[misoriented_anums(i) grainnumber];  %store the new grain number        
end

%redefine all misoriented atoms using new data
misoriented_redefine(misoriented_redefine(:,2)==0,:)=[]; %remove rows equal to zero gnum (maybe remove)
A(misoriented_redefine(:,1),8)=misoriented_redefine(:,2);

%Repeat the process successively **************** Reallocating atoms
%outward from grain

loopbreak = 1;
while loopbreak>0
        deep_misoriented_anums=misoriented_anums(A(misoriented_anums,8)==0);  %those atoms which have still not be allocated to a grain
        misoriented_redefine=zeros(numel(deep_misoriented_anums),2);
        loopbreak=numel(deep_misoriented_anums);
        
    for i=1:numel(deep_misoriented_anums)
            y=non_edge_nnList_simbox{E==deep_misoriented_anums(i)};
            grainnumber=mode(A(y(A(y,8)>0),8));   %find the mode of the grainnumbers of all neighbors
            if isnan(grainnumber)==1  %if all surrounding atoms do not belong to a grain convert NaN to 0
                grainnumber=0;
            end
            misoriented_redefine(i,:)=[deep_misoriented_anums(i) grainnumber];  %store the new grain number  %redefine to the new grain number                 
    end
    
    %redefine all edge atoms using new data
    misoriented_redefine(misoriented_redefine(:,2)==0,:)=[]; %remove rows equal to zero gnum (maybe remove)
    A(misoriented_redefine(:,1),8)=misoriented_redefine(:,2);
    %Repeat
            deep_misoriented_anums=misoriented_anums(A(misoriented_anums,8)==0); %Recalculate new number of misoriented atoms to be reallocated

            if loopbreak==numel(deep_misoriented_anums) || numel(deep_misoriented_anums)==0 %No longer allocating (all remaining atoms are buried in boundaries or clusters of noncrystalline atoms)
               
                loopbreak=0;
               A(deep_misoriented_anums,6)=4;  %Convert remaining misoriented atoms to ID =4
            end
                clear misoriented_redefine
end
%%
disp('...Saving Final Variables and CFG Files');
%% Output final variables
mkdir(sprintf('%s/Outputfiles/GrainSegmentationFinalVariables',pwd));
save(sprintf('%s/Outputfiles/GrainSegmentationFinalVariables/FinalVariables_%s_%s_%3.0fDeg_%s',pwd,GRAINSIZE,TEMP,deg*100, FILENAMEBASIS));            
%% Output Final Ovito File 
mkdir(sprintf('%s/Outputfiles/GrainSegmentedOvitoCFGFiles',pwd));
location=sprintf('%s/Outputfiles/GrainSegmentedOvitoCFGFiles/Ovito_%s_%s_%3.2fDeg',pwd,GRAINSIZE,TEMP,deg);
write_ovito_file(location, xlo, ylo, zlo, xhi, yhi, zhi, A, n, FILENAME)
%% End of Script Indicator
disp(sprintf('Grain Identification Complete'))     %#ok<DSPS> %Print GTA Status    %#ok<DSPS>
toc
end
 end