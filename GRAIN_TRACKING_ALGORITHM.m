function GRAIN_TRACKING_ALGORITHM(option)
%% Grain Tracking Algorithm
 %Devloped by Jason Panzarino
 %Version 2.7.3 7-27-2016
 %Any questions, comments, or additional help in using these codes please
 %contact me: jpanzari@uci.edu Thanks!


%Variables Used in the program
Crystal_Axis = 0;
rotmat = 0;
filenum = 0;
A_Matrix_New = 0;
Crystal_Axis_No_Mapping = 0;
Crystal_Axis001 = 0;
degreecutoff = 0;
A_Matrix = 0;
listnamefilenames = {''};
filenameslist = 0;
NumOfCores = '1';
FIRSTTIME = true;
Crystal_Axis110 = 0;
Crystal_Axis111 = 0;
Crystal_Axis_No_Mapping001 = 0;
numofgrains = 0;
Orientation_Matrix = 0;
numberoffiles=1;
if nargin<1, option = 1; end
switch option
  case 1
    style1 = 'popup';
    style2 = 'lefttop';
    style3 = 'rightbottom';
  case 2
    style1 = 'popup';
    style2 = 'righttop';
    style3 = 'leftbottom';
  otherwise
    style1 = 'popup';
    style2 = 'centertop';
    style3 = 'centerbottom';
end

width = 0;
hfig = figure(...
  'Name','Grain Tracking Algorithm',...
  'NumberTitle','off', ...
  'Menubar','none',...
  'Toolbar','none');

%--------------------------------------------------------------------------
% Creating the tabs
%--------------------------------------------------------------------------
htab(1) = uitabpanel(...
  'Parent',hfig,...
  'Style',style1,...
  'Units','normalized',...
  'Position',[0,0,0.3,1],...
  'FrameBackgroundColor',[0.4314,0.5882,0.8431],...
  'FrameBorderType','etchedin',...
  'Title',{'About'},...
  'PanelHeights',[8,35,10,10],...
  'HorizontalAlignment','left',...
  'FontWeight','bold',...
  'TitleBackgroundColor',[0.9255 0.9490 0.9765],...
  'TitleForegroundColor',[0.1294,0.3647,0.8510],...
  'PanelBackgroundColor',[0.7725,0.8431,0.9608],...
  'PanelBorderType','line',...
  'CreateFcn',@CreateTab1);

htab(2) = uitabpanel(...
  'Parent',hfig,...
  'TabPosition',style2,...
  'Position',[0.3,0,0.7,1],...
  'Margins',{[0,-1,1,0],'pixels'},...
  'PanelBorderType','line',...
  'Title',{'Introduction','Identifier','Tracking', 'Visualization','GB Network'},...
  'CreateFcn',@CreateTab2);


%--------------------------------------------------------------------------
  function CreateTab1(htab,evdt,hpanel,hstatus)
    uicontrol(...
      'Parent',hpanel(1),...
      'Units','normalized',...
      'Position',[.1,.1,.8,.92],...
      'BackgroundColor',get(hpanel(1),'BackgroundColor'),...
      'HorizontalAlignment','center',...
      'Style','text',...
      'String',[...
      ' Grain Tracking Algorithm '
      '                          ' 
      '        Version 2.7       '
      '                          '
      '        Created by:       '
      '      Jason Panzarino     '
      '      jpanzari@uci.edu    '
      '                          ']);

    uicontrol(...
      'Parent',hstatus,...
      'Units','normalized',...
      'Position',[0,0,1,.3],...
      'BackgroundColor',get(hstatus,'BackgroundColor'),...
      'ForegroundColor',[0.6,1,1],...
      'HitTest','off',...
      'Style','text',...
      'String',[...
            '']);

    set(htab,'ResizeFcn',@TabResize1);
    
    
   
%Website Button
labelStr = '<html><center><a href=""><br>Nanoscale Mechanics and Materials Lab<br><br>';
cbStr = 'web(''http://rupert.eng.uci.edu'');';
hButton = uicontrol('string',labelStr,'pos',[10,20,150,35],'callback',cbStr);
    
  end

%--------------------------------------------------------------------------
  function CreateTab2(htab,evdt,hpanel,hstatus)
    uicontrol(...
      'Parent',hpanel(1),...
      'Units','normalized',...
      'Position',[.1,.1,.8,.8],...
      'BackgroundColor',get(hpanel(1),'BackgroundColor'),...
      'ForegroundColor','w',...
      'HorizontalAlignment','left',...
      'FontSize',12,...
      'Style','text',...
      'String',[...
      '                                                                ']);
  



    uicontrol(...
      'Parent',hpanel(2),...
      'Units','normalized',...
      'Position',[.1,.1,.8,.8],...
      'BackgroundColor',get(hpanel(1),'BackgroundColor'),...
      'ForegroundColor','w',...
      'HorizontalAlignment','left',...
      'Style','text',...
      'String',[...
      '                                                                ']);
    
  
  
    uicontrol(...
      'Parent',hpanel(3),...
      'Units','normalized',...
      'Position',[.1,.1,.8,.8],...
      'BackgroundColor',get(hpanel(1),'BackgroundColor'),...
      'ForegroundColor','w',...
      'HorizontalAlignment','left',...
      'Style','text',...
      'String',[...
      '                                                                ']);

    uicontrol(...
      'Parent',hpanel(4),...
      'Units','normalized',...
      'Position',[.1,.1,.8,.8],...
      'BackgroundColor',get(hpanel(1),'BackgroundColor'),...
      'ForegroundColor','w',...
      'HorizontalAlignment','left',...
      'Style','text',...
      'String',[...
      '                                                                ']);
  
  uicontrol(...
      'Parent',hpanel(5),...
      'Units','normalized',...
      'Position',[.1,.1,.8,.8],...
      'BackgroundColor',get(hpanel(1),'BackgroundColor'),...
      'ForegroundColor','w',...
      'HorizontalAlignment','left',...
      'Style','text',...
      'String',[...
      '                                                                ']);

  
    uicontrol(...
      'Parent',hstatus,...
      'Units','normalized',...
      'Position',[0,0.1,1,.68],...
      'BackgroundColor',get(hstatus,'BackgroundColor'),...
      'ForegroundColor','k',...
      'HitTest','off',...
      'Style','text',...
      'String',['']);
    setappdata(htab,'SelectionChangeFcn',@TabStatus2);

    set(htab,'ResizeFcn',{@TabResize2,[0.5,0.5]});


    
    
%Insert Logo as a push Button on the Intro Tab
     [x,map]=imread('Logo.png');
     I2=imresize(x, [330 313]);
     h=uicontrol('parent',hpanel(1),'style','pushbutton',...
              'units','pixels',...
              'position',[20 20 333 350],...
              'cdata',I2)    ;
 
%% Buttons          

%Within Grain Visualization we have the following figures
%Button1 is for the reading of the data
button1 = uicontrol('Parent',hpanel(4),'Units','normalized',...
        'Style','pushbutton','String','Load Mapped Data',...
                      'Position',[.3,.85,.4,.08], 'Callback',{@pushbutton1_callback});


%Button2 is for the reading of the data
button2 = uicontrol('Parent',hpanel(4),'Units','normalized',...
        'Style','pushbutton','String','Interesting Grains',...
                      'Position',[.3,.75,.4,.08], 'Callback',{@pushbutton2_callback});

%Plotting Figures Buttons  
%3- Inverse Pole Figures (Stereographic Triangles)
%4 - Pole Figures (positive [001] simulation projection)
%5 - Avg Grain Sliding & Rotation
%6 - Orientation Map
button3 = uicontrol('Parent',hpanel(4),'Units','normalized',...
        'Style','pushbutton','String','Inverse Pole Figures (Stereographic Triangles)',...
                      'Position',[.15,.65,.7,.08], 'Callback',{@pushbutton3_callback});
button4 = uicontrol('Parent',hpanel(4),'Units','normalized',...
        'Style','pushbutton','String','Positive Pole Figures',...
                      'Position',[.15,.55,.7,.08], 'Callback',{@pushbutton4_callback});
button5 = uicontrol('Parent',hpanel(4),'Units','normalized',...
        'Style','pushbutton','String','Avg Grain Sliding & Rotation',...
                      'Position',[.15,.45,.7,.08], 'Callback',{@pushbutton5_callback});
button6 = uicontrol('Parent',hpanel(4),'Units','normalized',...
        'Style','pushbutton','String','Orientation Map',...
                      'Position',[.15,.35,.7,.08], 'Callback',{@pushbutton6_callback});

       
%%Grain History Button        
button7 = uicontrol('Parent',hpanel(3),'Units','normalized',...
        'Style','pushbutton','String','Run Grain Tracking Executable',...
                      'Position',[.15,.85,.7,.1], 'Callback',{@pushbutton7_callback});
       
%%Grain Indentifier Add Button        
button8 = uicontrol('Parent',hpanel(2),'Units','normalized',...
        'Style','pushbutton','String','Add File',...
                      'Position',[.15,.85,.2,.1], 'Callback',{@AddAnotherFile_Callback});
            
button9 = uicontrol('Parent',hpanel(2),'Units','normalized',...
        'Style','pushbutton','String','Run',...
                      'Position',[.75,.1,.2,.1], 'Callback',{@RunCallback});
                  
button10 = uicontrol('Parent',hpanel(2),'Units','normalized',...
        'Style','pushbutton','String','Settings',...
                      'Position',[.75,.85,.2,.1], 'Callback',{@SettingsCallback});
                  
%GB Mapping
 button11 = uicontrol('Parent',hpanel(5),'Units','normalized',...
         'Style','pushbutton','String','Analyze GB Network (Beta)',...
                       'Position',[.1,.85,.8,.1], 'Callback',{@RunCallbackGBMAP});
                   
%                    %Delete File button (will add later)
%  button11 = uicontrol('Parent',hpanel(2),'Units','normalized',...
%          'Style','pushbutton','String','Delete Input',...
%                        'Position',[.35,.85,.2,.1], 'Callback',{@DeleteFile_Callback});

filenameslist = uicontrol('Parent',hpanel(2),'Units','normalized',...
                'Style','listbox',...
                'String',listnamefilenames,...
                'Value',1,'Position',[.15,.25,.7,.5]);                 
                  
end

%--------------------------------------------------------------------------
  function TabResize1(hobj,evdt)
    figpos = get(hfig,'Position');
    tabpos = get(hobj,'Position');
    tabpos(4) = figpos(4);
    set(hobj,'Position',tabpos);

    width = tabpos(3)/figpos(3);
  end

%--------------------------------------------------------------------------
  function TabResize2(hobj,evdt,ysiz)
    figpos = get(hfig,'Position');
    tabpos = get(hobj,'Position');
    tabpos([1,3]) = [width,1-width]*figpos(3)+[1,0];
    tabpos([2,4]) = ysiz*figpos(4)+[1,0];
    set(hobj,'Position',tabpos);
  end

%--------------------------------------------------------------------------
  function TabStatus2(hobj,evdt)
    set(get(evdt.Status,'Children'),'String',['page ',num2str(evdt.NewValue)]);
  end

function pushbutton1_callback(hObject,eventdata)
    h1 = msgbox('Loading New Mapped Samples Variables...');
    infile = exist(sprintf('%s/Outputfiles/MappedVariables/Mapped_Variables.mat',pwd),'file');
    if (infile == 0)
        errordlg('Cannot find file "Mapped_Variables" Must First Run "GrainHistoryExecutable"');
        delete(h1);
    end
    MappedVariable = load(sprintf('%s/Outputfiles/MappedVariables/Mapped_Variables.mat',pwd));
    delete(h1);
    
    %Store these values into the main workspace
%     rotmat = MappedVariable.rotmat;
    Crystal_Axis = MappedVariable.Crystal_Axis;
    filenum = MappedVariable.filenum;
    A_Matrix_New = MappedVariable.A_Matrix_New;
    Crystal_Axis_No_Mapping = MappedVariable.Crystal_Axis_No_Mapping;
    degreecutoff = 0.5;%MappedVariable.degreecutoff;
    Crystal_Axis001 = MappedVariable.Crystal_Axis001;
    A_Matrix = MappedVariable.A_Matrix;
    numofgrains = MappedVariable.mostgrains;
end


function pushbutton2_callback(hObject,eventdata)
    EXECUTE = true;
   %% Find Interesting Grains & Pre-Processing Before Plotting
   interesting_grain_rotationcutoff=4; %cutoff for an interesting grain
h3 = msgbox('Finding notable grains with significant rotation greater than 4 degrees between timesteps and/or untrackable grains:');

try
    [Interesting_Grains, rotmat]=Grains_of_Interest_v2(Crystal_Axis,4,1); %%#ok<ASGLU>
    delete(h3);
catch
    delete(h3);
    msgbox('Mapped Variables was not loaded. Missing Crystal Axis OR file only contains one file to map from (should have at least 2)');
    EXECUTE = false;    
end

if EXECUTE 
    columnname = [];
    columneditable = [];
    numberoftimesteps = size(rotmat,2) - 1;
    for i = 1:numberoftimesteps
        columnname = [columnname sprintf('TimeStep %d, ', i)];
        columneditable = [columneditable 0]; 
        columnformat{i} = 'numeric';
    end
    columnname = [columnname sprintf('Grain #')];
    columnname = strsplit(columnname, ',');

    rowname = [];
    numberofgrains = size(rotmat,1);
    for i = 1:numberofgrains
        rowname = [rowname sprintf('Grain %d, ', i)];
    end
    rowname = strsplit(rowname, ',');

    % rotmat(:, size(rotmat,2) + 1) = 0;
    columneditable = logical(columneditable);

    figure
    t = uitable; 
    set(t, 'RowName',rowname, 'ColumnName', columnname,...
                'Units','normalized','Position',...
                [0 0 1 1], 'Data', rotmat,... 
                'ColumnName', columnname,...
                'ColumnFormat', columnformat,...
                'ColumnEditable', columneditable);

    %dialog box input for removal of grains
    Interesting_Grains_string = sprintf('%.0f, ' ,Interesting_Grains);
    Interesting_Grains_string = sprintf('\n Grains that may be of interest (Significant Rotation) are listed HERE --> %s \n', Interesting_Grains_string);
    h4 = msgbox('Resize table to see all the values and press okay');
    waitfor(h4);
    Interesting_Grains_string = sprintf('The table shows rotation of grains tracked between timesteps (Table columns list the disorientation theta values with respect to the initial configuration of grains). Would you like to remove any erroneous grains from the qualitative analysis? If so, separate grain numbers with commas, If not, enter nothing. \n %s', Interesting_Grains_string);
    prompt = Interesting_Grains_string;
    dlg_title = 'Interesting Grains';
    num_lines = 1;
    def = {''};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    answer1 = strsplit(answer{1}, ',');
    Removed_Grains = str2double(answer1);

    for i = 1:numel(Removed_Grains);
        for j=1:filenum
            Crystal_Axis{j,1}.crystal_axis(Crystal_Axis{j,1}.crystal_axis(:,4)==Removed_Grains(i),:)=NaN; %Ignore this data 
        end
    end

end

end

%% Find Orientation Matrix and Plot Inverse Pole Figures (Stereographic Triangles)
% Plot Inv pole plots with corresponding grain numbers
%%TypeofPlots == 1 from Main Original Code
function pushbutton3_callback(hObject,eventdata)
 	Numbers = questdlg('Label grain numbers on the plots? (Usually "No" when plotting all files on 1 plot) Numbers may not show until image is saved as a .TIF',...
        'Inverse Pole Figure Plot');

            
    if strcmp (Numbers, 'Yes')
        startfile='For StereoPlotting: What file number would you like to start plotting qualitative tracking data from?';
        Axis ='Choose a simulation direction from which you would like to inversely project grain orientation normals stereographically: Use the format: [a b c]';
        StereoPlotParameters1= 'For StereoPlotting: Would you like to track a select grain number or all grains at once? 1-Select 0-All';
        
        prompt = {startfile Axis StereoPlotParameters1};
        dlg_title = 'Stereoplotting';
        num_lines = 3;
        def = {'', '', ''};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        startfile = str2num(answer{1});
        Axis = str2num(answer{2});
        StereoPlotParameters1 = str2num(answer{3});
        if StereoPlotParameters1== 1
            prompt = 'If you would like to track specific grains on one plot please enter grain numbers as a vector. Use the following format [1 2 3 4] If you would like plots generated for all grains do not enter anything and press ENTER now';
            dlg_title = 'Stereoplotting';
            num_lines = 1;
            def = {''};
            answer = inputdlg(prompt,dlg_title,num_lines,def);
            StereoPlotParameters2= str2num(answer{1});

            if isempty(StereoPlotParameters2)==1
            h5 = msgbox('Running!');   
            
            [Orientation_Matrix] = InversePole(Axis,Crystal_Axis,filenum);
            figure
            InvPoleStereoPlot(Orientation_Matrix,filenum,Axis,startfile,StereoPlotParameters1)
            delete(h5);
            
            else
            h5 = msgbox('Running!'); 
            [Orientation_Matrix] = InversePole(Axis,Crystal_Axis,filenum);
            figure
            InvPoleStereoPlot(Orientation_Matrix,filenum,Axis,startfile,StereoPlotParameters1,StereoPlotParameters2)
           delete(h5);
            end
        else
            prompt = 'Plot All FileSteps on one single plot?';
            dlg_title = 'Stereoplotting';
            prompt1 = questdlg(prompt,dlg_title); 
            if strcmp (prompt1, 'Yes')
                StereoPlotParameters2 = 1;
            elseif strcmp (prompt1, 'No')
                StereoPlotParameters2 = 0;
            else
            end

            if StereoPlotParameters2==1
                h5 = msgbox('Running!'); 
                [Orientation_Matrix] = InversePole(Axis,Crystal_Axis,filenum);
                figure
                InvPoleStereoPlot(Orientation_Matrix,filenum,Axis,startfile,StereoPlotParameters1,StereoPlotParameters2)
                delete(h5);
            else
                h5 = msgbox('Running!'); 
                [Orientation_Matrix] = InversePole(Axis,Crystal_Axis,filenum);
                figure      
                InvPoleStereoPlot(Orientation_Matrix,filenum,Axis,startfile,StereoPlotParameters1)  
                delete(h5);
            end
        end
        %Plot inv pole plots with no grain numbers
    elseif strcmp (Numbers, 'No')
        startfile='For StereoPlotting: What file number would you like to start plotting qualitative tracking data from?';
        Axis ='Choose a simulation direction from which you would like to inversely project grain orientation normals stereographically: Use the format: [a b c]';
        StereoPlotParameters1= 'For StereoPlotting: Would you like to track a select grain number or all grains at once? 1-Select 0-All';
        
        prompt = {startfile Axis StereoPlotParameters1};
        dlg_title = 'Stereoplotting';
        num_lines = 3;
        def = {'', '', ''};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        startfile = str2num(answer{1});
        Axis = str2num(answer{2});
        StereoPlotParameters1 = str2num(answer{3});
        
        if StereoPlotParameters1== 1
            prompt = 'If you would like to track specific grains on one plot please enter grain numbers as a vector. Use the following format [1 2 3 4] If you would like plots generated for all grains do not enter anything and press ENTER now';
            dlg_title = 'Stereoplotting';
            num_lines = 1;
            def = {''};
            answer = inputdlg(prompt,dlg_title,num_lines,def);
            StereoPlotParameters2= str2num(answer{1});
            
            
            if isempty(StereoPlotParameters2)==1
            h5 = msgbox('Running!'); 
            [Orientation_Matrix] = InversePole(Axis,Crystal_Axis,filenum);
            figure
            InvPoleStereoPlotNoNumbers(Orientation_Matrix,filenum,Axis,startfile,StereoPlotParameters1)
            delete(h5);
            else
            h5 = msgbox('Running!'); 
            [Orientation_Matrix] = InversePole(Axis,Crystal_Axis,filenum);
            figure
            InvPoleStereoPlotNoNumbers(Orientation_Matrix,filenum,Axis,startfile,StereoPlotParameters1,StereoPlotParameters2)
            delete(h5);
            end
        else
            prompt = 'Plot All FileSteps on one single plot?';
            dlg_title = 'Stereoplotting';
            prompt1 = questdlg(prompt,dlg_title); 
            if strcmp (prompt1, 'Yes')
                StereoPlotParameters2 = 1;
            elseif strcmp (prompt1, 'No')
                StereoPlotParameters2 = 0;
            else
            end
            if StereoPlotParameters2==1
                h5 = msgbox('Running!'); 
                [Orientation_Matrix] = InversePole(Axis,Crystal_Axis,filenum);
                figure
                InvPoleStereoPlotNoNumbers(Orientation_Matrix,filenum,Axis,startfile,StereoPlotParameters1,StereoPlotParameters2)
                delete(h5);
            else
                h5 = msgbox('Running!'); 
                [Orientation_Matrix] = InversePole(Axis,Crystal_Axis,filenum);
                figure    
                InvPoleStereoPlotNoNumbers(Orientation_Matrix,filenum,Axis,startfile,StereoPlotParameters1)  
                delete(h5);
            end
        end
    end   
        

end

%% Pole Figures (3 positive crystal axis) Pole Figures (positive [001] simulation projection
%%TypeofPlots == 2 from Main Original Code
function pushbutton4_callback(hObject,eventdata)
        prompt='What file number would you like to start plotting qualitative tracking data from?';
        answer = inputdlg(prompt,'Pole Figures',1,{''});
        startfile = str2num(answer{1});
        prompt = 'Would you like to plot all files on one plot, or have individual plots for each file? 1=All On One,   0=Individual Plots';
        dlg_title = 'Pole Figures';
        prompt2 = questdlg(prompt,dlg_title, 'All','Individual Plots','Cancel'); 
        if strcmp (prompt2, 'All')
            singleormultiple = 1;
        elseif strcmp (prompt2, 'Individual Plots')
            singleormultiple = 0;
        else
        end
       
        OPTION = questdlg('Which pole figure would you like to generate?', 'Pole Figure','[1 1 1]', '[1 1 0]','[0 0 1]','4');
    
        plotnegative = 0;
        
    try
        h5 = msgbox('Running!'); 
        figure
        if strcmp (OPTION, '[1 1 1]')
            Crystal_Axis111 = ConvertAxisTo111([1 1 1],Crystal_Axis001, filenum, numofgrains);
            PlotPoleFigurePositiveAxis(singleormultiple,filenum,Crystal_Axis111,startfile, '[1 1 1]', plotnegative);
            
        elseif strcmp (OPTION, '[1 1 0]')
            Crystal_Axis110 = ConvertAxisTo110([1 1 0],Crystal_Axis001, filenum, numofgrains);
            PlotPoleFigurePositiveAxis(singleormultiple,filenum,Crystal_Axis110,startfile, '[1 1 0]', plotnegative);
        elseif strcmp (OPTION, '[0 0 1]')
            PlotPoleFigurePositiveAxis(singleormultiple,filenum,Crystal_Axis001,startfile, '[0 0 1]', plotnegative);
        else
            msgbox('Incorrect Input?');
        end
        delete(h5);
    catch
        errordlg('Missing Data.');
        delete(h5);
    end
end

%%TypeofPlots == 3 from Main Original Code
function pushbutton5_callback(hObject,eventdata)
%% Grain Sliding
    startfile = 'What file number would you like to initiate tracking from?';
    temp = 'Optional Descriptive Text';
    prompt={startfile temp};
    answer = inputdlg(prompt,'Grain Sliding & Rotation',2,{'',''});
    startfile = str2num(answer{1});
    temp = answer{2};
    [sliding_motion Com_Matrix]=cmass_tracking(A_Matrix_New,filenum,startfile,temp,Crystal_Axis);

%% Grain Rotation
[~, rotmat] = Grains_of_Interest_v2( Crystal_Axis,degreecutoff,startfile );

%% Save rotation and sliding matrices
save('rotmat','rotmat')
save('sliding_motion','sliding_motion')
msgbox('Visualization Complete!');
%% Plot Sliding and Rotation Data
%Sliding motion   
figure
    hold on
    avg_sliding_motion=nanmean(sliding_motion)./10;
    x=0:filenum-startfile;
    plot(x,avg_sliding_motion(:,1:numel(avg_sliding_motion)-1))   %Last column is just grain numbers
    xlabel('File Number')
    ylabel('Avg Center of Mass Displacement (Nanometers)')
    title(sprintf('Average Grain Sliding %s',temp))

%Rotation
    figure
    hold on
    xlabel('Cycle Number')
    ylabel(sprintf('Delta Theta (deg) vs. Initial Configuration'))
    title(sprintf('Average Grain Rotation %s',temp))
    x=0:filenum-startfile;
    avg_rotmat=nanmean(rotmat);
    plot(x,avg_rotmat(:,1:numel(avg_rotmat)-1))

    
end

%%TypeofPlots == 4 from Main Original Code
function pushbutton6_callback(hObject,eventdata)
    prompt ='Choose a simulation direction to inversely project orientation normals stereographically: Use the format: [a b c]';
    dlg_title = 'Orientation Mapping';
    num_lines = 1;
    def = {''};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    Axis = str2num(answer{1});
    
    try
        h5 = msgbox('Running!'); 
        [Orientation_Matrix] = InversePole(Axis,Crystal_Axis_No_Mapping,filenum);
        delete(h5);
        
    catch
        delete(h5);
        errordlg('Please Load Data from Grain Visualization');
    end
    [Orientation_Matrix] = Crystal_Symmetry_For_Orientation_Map(Orientation_Matrix,filenum);

    for k = 1:filenum %added the plus 10 for figure printing. conflicted with main figure GUI
        OrientationMap(A_Matrix,Orientation_Matrix,k) %added +10 to this function
    end
    
    figure(gcf+1) %Generate new figure
    image(imread('Key.png')) %Plot The Key on this Figure
%     GenerateOrientationKey(k + 11)  %Manual Generation of Key Triangle
%     (higher Quality, longer run time)

    msgbox('Visualization Complete!');        
end


%%GRAIN HISTORY BUTTON CALLBACK
function pushbutton7_callback(hObject,eventdata)

        %Collect Filenames
        files = dir(sprintf('%s/Outputfiles/GrainSegmentedOvitoCFGFiles/*.cfg',pwd)); 
        for i=1:size(files,1)
            if i == 1
                filenames=files(i,:).name;  %#ok<*SAGROW>
            else
                filenames=[filenames,sprintf('%s',','),files(i,:).name];
            end
        end
    
    
        String1 = ['Filenames: Input files are read alphabetically from the folder: /Outputfiles/GrainSegmentedOvitoCFGFiles/.'...
            '   (Make sure the files listed below are in simlation order and separated by commas)'];
        String2 =  ['Type a Number: How many crystalline nearest neighbors' ...
            ' to use for finding deep grain interior points between time steps.' ... 
            'A lower value means faster computation '...
            'time, but may induce mapping errors depending on the magnitude of '...
            'grain motion in between time steps. This code maps grains in '...
            'order from file 1 through till the end. This means that the '...
            'overall grain number will equal the number of grains at the '...
            'beginning file. Shrinking grains will be carried through untill '...
            'they disappear, but appearing grains may be incorrectly mapped.'];
%         String3 = 'Optional Descriptive Text';
        
        String4 = 'Periodic Boundaries. Provide as a vector [x y z]';
%         prompt = {String1 String2 String3 String4};
          prompt = {String1 String2 String4};
        dlg_title = 'Grain Tracking';
        num_lines = 3;
        def = {sprintf('%s',char(filenames)),'50','[1 1 1]'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        
      
        filenames =  char( strsplit(answer{1}, ','));
        num = str2num(answer{2});
        degreecutoff = str2num(answer{1});
        periodicboundaries = str2num(answer{3});
        h5 = msgbox('Running!'); 
        Done = 1;
        try
        [filenum Crystal_Axis A_Matrix_New Crystal_Axis_No_Mapping Crystal_Axis001 Crystal_Axis_No_Mapping001] = GRAINHISTORYEXECUTABLE(filenames,num,degreecutoff, periodicboundaries);
        catch
            errordlg('Error Mapping Files! Check validity of input parameters');
            Done = 0;
        end
        if Done == 1
            msgbox('Done! CHECK COMMAND WINDOW FOR WARNINGS!');
        end
%         delete(h5);
end
    
%%GRAIN IDENTIFIER ADD FILE CALLBACK
function AddAnotherFile_Callback(hObject, eventdata)
    
%%Create a storage textfile for the input parameters. 
if FIRSTTIME 
    Openfile = fopen('inputlines.txt', 'w');
    FIRSTTIME = false;
else
    Openfile = fopen('inputlines.txt', 'a');
    numberoffiles=numberoffiles+1;
end

if (Openfile < 0)
    error('could not open file');
end;

prompt = {'Filename:', 'Degree Cutoff: ','Crystal Type: 1 - FCC, 2 - BCC','CSP Cutoff','Minimum Distinguishable Grain size (# of atoms)','Periodic Boundaries [1 x 3 vector]', 'Optional: Temperature: ', 'Optional: Grain Size Name: ', 'Run full script? (0-Orientation/Disorientation Lists, 1-Full script, 2-Segmentation)'};
dlg_title = 'Add Another File';
num_lines = 1;
[fname,fpath] = uigetfile('*.cfg');
def = {fname, '', '', '','', '', '', '', '1'};
answer = inputdlg(prompt,dlg_title,num_lines, def);



%Rename the variables to make it easier to read
input.filename = num2str(cell2mat(answer(1)));
input.deg = num2str(cell2mat(answer(2)));
input.crystaltype = num2str(cell2mat(answer(3)));
input.cspcutoff = num2str(cell2mat(answer(4)));
input.minGsize = num2str(cell2mat(answer(5)));
input.periodicbounds = (cell2mat(answer(6)));
input.temp = num2str(cell2mat(answer(7)));
input.grainsize = num2str(cell2mat(answer(8)));
input.gsize = '';
input.startfrombeginning = num2str(cell2mat(answer(9)));
print_to_list = sprintf('File: %s, Crystaltype: %d, CSP: %d, Boundaries %s, Temp: %s, GSize:%s, GSize: %s, Deg: %d, OrientedFile: %d',input.filename,  str2double(input.crystaltype), str2double(input.cspcutoff),(input.periodicbounds), input.temp, input.grainsize, input.gsize, str2double(input.deg),str2double(input.startfrombeginning));

fprintf(Openfile, '%s,%s,%s,%s,%s,%d,%d,%d,%d,%s,%d\n',input.filename,fpath,input.temp, input.grainsize, input.gsize, str2double(input.deg), str2double(input.startfrombeginning),  str2double(input.crystaltype), str2double(input.cspcutoff),(input.periodicbounds),str2double(input.minGsize));

prev_list = get(filenameslist,'string');
new_list = [prev_list; print_to_list];
set(filenameslist,'string',new_list);
fclose(Openfile);
end


% function DeleteFile_Callback(hObject, eventdata)
%     %%Will be added later
% end
    
%%GRAIN IDENTIFIER SETTINGS. MULTICORE SETTINGS
function SettingsCallback(hObject, eventdata)
    prompt1 = {'Number of Cores to Use:'};
    dlg_title1 = 'Settings';
    num_lines1 = 1;
    def1 = {'1'};
    answer1 = inputdlg(prompt1,dlg_title1,num_lines1, def1);

    if size(answer1) == 0
        answer1(1) = {'1'};
    end

    NumOfCores = cell2mat(answer1(1)); %Create variable for number of cores to use

end
    
%% GRAIN BOUNDARY MAPPING RUN BUTTON
function RunCallbackGBMAP(hObject, eventdata)
    
        String1 = 'What file number would you like to analyze? To analyze all files leave blank';
        String2 = ['Box Side Length (angstroms) for NN Search for defect type identification. '...
                  'How big of a box to search for neigboring grains providing data for TJ ,'...
                  'Vertex Point,GB Plane atoms. Might need to iterativly adjust depending'...
                  'on average grain size.'];
        String3 = 'Number of atoms which are averaged to define a GB plane normal at a given point';
        String4 = 'CSP cutoff for crystallinity.';
        String5 = ['Number of GB nearest neighbors for sectioning GB Sections. NN search '...
                   'compares a central atoms normal with its neighbors normals during segmentation'];
        String6 = 'Normal Degree Cutoff for segmenting GB sections (Similar to Grain Segmentation Method)';
        String7 = 'Minimum Section Size (atoms)';

        prompt = {String1 String2 String3 String4 String5 String6 String7};
        dlg_title = 'GB Network Analysis';
        num_lines = 1;
        def = {'', '8', '50','2.83','10', '8', '15',};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        
%Load Variables From User Inputs
GB_Filenumber=str2num(answer{1});
GB_r=str2num(answer{2});
GB_Avg_Num_Plane_Atoms=str2num(answer{3});
GB_cspcutoff=str2num(answer{4});
GB_sectionnns=str2num(answer{5});
GB_normcutoff=str2num(answer{6});
GB_minsectionsize=str2num(answer{7});
        

disp('...Analyzing the Grain Boundary network')
    if isempty(GB_Filenumber)==1 %Run for all files
        try
            load('Outputfiles\MappedVariables\Mapped_Variables.mat','filenames');
            GB_Filenumber=size(filenames,1); %Total number of files
            for k=1:GB_Filenumber  %Analyze all files
                    running = msgbox('Analyzing GB Network');
                    EXECUTE_GB_Mapping(k,GB_r,GB_Avg_Num_Plane_Atoms,GB_cspcutoff,GB_sectionnns,GB_normcutoff,GB_minsectionsize)
                    %Run TJ TYPE ANALYSIS,SPECIAL FRACTION ANALYSIS, and
                    %MISORIENTATION ANALYSIS
                    %Collect Filenames
                        files = dir(sprintf('%s/Outputfiles/GBMappedFinalVariables/*.mat',pwd)); 
                        for i=1:size(files,1)
                                gbmapped_filenames(i,:)=files(i,:).name;  %#ok<*SAGROW>
                        end
                        
                            try
                                EXECUTE_TJTypeAnalysis(k,gbmapped_filenames)
                            catch
                                disp('No Triple Junctions Found - Skipping TJTypeAnalysis')
                            end
            end
            clear gbmapped_filenames
        catch
            error('Error loading/running GB Network Analysis. Did you run grain Tracking Executable?  Needed to produce necessary variables regardless of history tracking.')
        end
        
        
    else   %Run for specified file
                    running = msgbox('Analyzing GB Network');
                    EXECUTE_GB_Mapping(GB_Filenumber,GB_r,GB_Avg_Num_Plane_Atoms,GB_cspcutoff,GB_sectionnns,GB_normcutoff,GB_minsectionsize)
                        %Run TJ TYPE ANALYSIS,SPECIAL FRACTION ANALYSIS, and
                    %MISORIENTATION ANALYSIS
                    %Collect Filenames
                        files = dir(sprintf('%s/Outputfiles/GBMappedGrainSegmentationFinalVariables/*.mat',pwd)); 
                        for i=1:size(files,1)
                                gbmapped_filenames(i,:)=files(i,:).name;  %#ok<*AGROW,*SAGROW>
                        end
                    EXECUTE_TJTypeAnalysis(GB_Filenumber,gbmapped_filenames)
    
    end
    delete(running);
    msgbox('Done Analyzing GB Network!'); 
    
end

%% GRAIN IDENTIFIER RUN BUTTON
function RunCallback(hObject, eventdata)
%Open the file that has the saved commands
running = msgbox('Running...');

% Check if matlabpool is open or not
if isempty(gcp('nocreate'))==0
    delete(gcp);
end

% Test for Multiple cores
if str2num(NumOfCores)>1
parpool(str2num(NumOfCores));% Call to open the distributed processing
end
% delete(g1);

    %Check if the inputline.txt is valid or not
    Openfile = fopen('inputlines.txt', 'r');
    if (Openfile < 0)
        delete(running);
        errordlg('could not open file.');
    end

    %Allocate user inputs for grain ident serial execution
    try
        for i = 1:numberoffiles
    C1{i,:} = strsplit(fgets(Openfile),','); %#ok<AGROW> %save line
        end       
    catch 
    end
    fclose(Openfile);
    %Execute the GRAIN_IDENT1 Script on each .cfg file
    for i = 1:numberoffiles
        C=C1{i};
        feval(@GRAIN_IDENT1,C{1}, C{2}, C{3}, C{4}, C{5}, str2double(C{6}), str2double(C{7}), str2double(C{8}), str2num(C{9}), str2num(C{10}), str2double(C{11})); 
    end
    
%If Parpool was opened, close it.    
if isempty(gcp('nocreate'))==0
    delete(gcp);
end


%  delete(running);
g3 = msgbox('Done!');   
end



end
