function [angle] = misorientationv9f(axis1, axis2)
% misorientation
format long

ref1 = [1 0 0; 0 1 0; 0 0 1];

    x = axis1(1,:);
    y = axis1(2,:);
    z = axis1(3,:);
    x2 = axis2(1,:);
    y2 = axis2(2,:);
    z2 = axis2(3,:);

%Test Case
%     x=[-.001 -.3152 .949];
%     y=[-1 .0002 -.0015];
%     z=cross(x,y);
%     
%     x2=[.0013 -.3158 -.9488];
%     y2=[0.0003 -.9486 .3165];
%     z2=cross(x2,y2);

    axis1=[x;y;z];
    axis2=[x2;y2;z2];

    gb = Kabsch(axis2', ref1');

    ga = Kabsch(axis1', ref1');
    
    %%Minimum angle for the next 48 sets
%     min_deg_inside = zeros(48,1);
    
    %%Find OjGbGainv
        OjGbGainv_0 = CubicSym_j(gb/(ga), inv(gb/(ga)));
        
        %%Set 1 to 48
        
        min_deg_inside = cell2mat(cellfun(@misorientationv9f_sub, OjGbGainv_0,'uniformoutput',false));
        
%         min_deg_inside(1) = misorientationv9f_sub(OjGbGainv_0{1});
%         min_deg_inside(2) = misorientationv9f_sub(OjGbGainv_0{2});
%         min_deg_inside(3) = misorientationv9f_sub(OjGbGainv_0{3});
%         min_deg_inside(4) = misorientationv9f_sub(OjGbGainv_0{4});
%         min_deg_inside(5) = misorientationv9f_sub(OjGbGainv_0{5});
%         min_deg_inside(6) = misorientationv9f_sub(OjGbGainv_0{6});
%         min_deg_inside(7) = misorientationv9f_sub(OjGbGainv_0{7});
%         min_deg_inside(8) = misorientationv9f_sub(OjGbGainv_0{8});
%         min_deg_inside(9) = misorientationv9f_sub(OjGbGainv_0{9});
%         min_deg_inside(10) = misorientationv9f_sub(OjGbGainv_0{10});
%         min_deg_inside(11) = misorientationv9f_sub(OjGbGainv_0{11});
%         min_deg_inside(12) = misorientationv9f_sub(OjGbGainv_0{12});
%         min_deg_inside(13) = misorientationv9f_sub(OjGbGainv_0{13});
%         min_deg_inside(14) = misorientationv9f_sub(OjGbGainv_0{14});
%         min_deg_inside(15) = misorientationv9f_sub(OjGbGainv_0{15});
%         min_deg_inside(16) = misorientationv9f_sub(OjGbGainv_0{16});
%         min_deg_inside(17) = misorientationv9f_sub(OjGbGainv_0{17});
%         min_deg_inside(18) = misorientationv9f_sub(OjGbGainv_0{18});
%         min_deg_inside(19) = misorientationv9f_sub(OjGbGainv_0{19});
%         min_deg_inside(20) = misorientationv9f_sub(OjGbGainv_0{20});
%         min_deg_inside(21) = misorientationv9f_sub(OjGbGainv_0{21});
%         min_deg_inside(22) = misorientationv9f_sub(OjGbGainv_0{22});
%         min_deg_inside(23) = misorientationv9f_sub(OjGbGainv_0{23});
%         min_deg_inside(24) = misorientationv9f_sub(OjGbGainv_0{24});
%         min_deg_inside(25) = misorientationv9f_sub(OjGbGainv_0{25});
%         min_deg_inside(26) = misorientationv9f_sub(OjGbGainv_0{26});
%         min_deg_inside(27) = misorientationv9f_sub(OjGbGainv_0{27});
%         min_deg_inside(28) = misorientationv9f_sub(OjGbGainv_0{28});
%         min_deg_inside(29) = misorientationv9f_sub(OjGbGainv_0{29});
%         min_deg_inside(30) = misorientationv9f_sub(OjGbGainv_0{30});
%         min_deg_inside(31) = misorientationv9f_sub(OjGbGainv_0{31});
%         min_deg_inside(32) = misorientationv9f_sub(OjGbGainv_0{32});
%         min_deg_inside(33) = misorientationv9f_sub(OjGbGainv_0{33});
%         min_deg_inside(34) = misorientationv9f_sub(OjGbGainv_0{34});
%         min_deg_inside(35) = misorientationv9f_sub(OjGbGainv_0{35});
%         min_deg_inside(36) = misorientationv9f_sub(OjGbGainv_0{36});
%         min_deg_inside(37) = misorientationv9f_sub(OjGbGainv_0{37});
%         min_deg_inside(38) = misorientationv9f_sub(OjGbGainv_0{38});
%         min_deg_inside(39) = misorientationv9f_sub(OjGbGainv_0{39});
%         min_deg_inside(40) = misorientationv9f_sub(OjGbGainv_0{40});
%         min_deg_inside(41) = misorientationv9f_sub(OjGbGainv_0{41});
%         min_deg_inside(42) = misorientationv9f_sub(OjGbGainv_0{42});
%         min_deg_inside(43) = misorientationv9f_sub(OjGbGainv_0{43});
%         min_deg_inside(44) = misorientationv9f_sub(OjGbGainv_0{44});
%         min_deg_inside(45) = misorientationv9f_sub(OjGbGainv_0{45});
%         min_deg_inside(46) = misorientationv9f_sub(OjGbGainv_0{46});
%         min_deg_inside(47) = misorientationv9f_sub(OjGbGainv_0{47});
%         min_deg_inside(48) = misorientationv9f_sub(OjGbGainv_0{48});
        
%%Find the lowest angle        
    angle = min(min_deg_inside);
end