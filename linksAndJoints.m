clc;
clear;
close all;
a=0;
b=0;
c=0;

% Create rigid body tree
robot = rigidBodyTree('DataFormat','column','MaxNumBodies',9);


% independent raising platform.
body1a=rigidBody('link1a');
joint1a=rigidBodyJoint('joint1a','prismatic');
body1a.Joint=joint1a;
setFixedTransform(joint1a,[0,0,0,0],'dh');
joint1a.JointAxis=[0 0 1];
addBody(robot,body1a,'base');

%
body1b=rigidBody('link1b');
joint1b=rigidBodyJoint('joint1b','prismatic');
body1b.Joint=joint1b;
setFixedTransform(joint1a,[0,0,0,0],'dh');
joint1b.JointAxis=[0 0 1];
addBody(robot,body1b,'base');



% -------- Link 2 --------
body2 = rigidBody('link2');
joint2 = rigidBodyJoint('joint2','revolute');

setFixedTransform(joint2,[0 0 0 0],'dh');
joint2.JointAxis = [0 0 1];%defining the axis along with either totation/translation happens in the body frame.

body2.Joint = joint2;
addBody(robot,body2,'link1b');

%--------Link 3----------
body3 = rigidBody('link3');
joint3 = rigidBodyJoint('joint3','revolute');

setFixedTransform(joint3,[4 0 0 0],'dh');
joint3.JointAxis = [0 0 1];%defining the axis along with either totation/translation happens in the body frame.

body3.Joint = joint3;
addBody(robot,body3,'link2');


config = homeConfiguration(robot);

config(1)=1;
config(2)=1;
config(3)=0;
config(4)=pi/3;


figure;
ax=axes;
show(robot,config)
axis manual;
axis equal;
xlim([-2.5 2.5]);
ylim([-2.5 2.5]);
zlim([0 2.5]);
view(3);
grid on;


%{
for q = linspace(0,2*pi,50)
    config(1) = 1;
    config(2) = 1;
    config(3) = q;
    config(4) = 1;
    config(5) = pi/4;
    config(6) = pi/4;
    show(robot,config,'PreservePlot',true);
    axis manual;
    axis equal;
    xlim([-2.5 2.5]);
    ylim([-2.5 2.5]);
    zlim([0 2.5]);
    drawnow;
    end
%}
%interactiveRigidBodyTree(robot)

% Slider 1
txt1=uicontrol('Style','text','String','platform','Position',[350,20,300,20],'FontSize',14);
slider = uicontrol('Style','slider',...
    'Min',0,'Max',4,...
    'Value',0,...
    'Position',[150 20 300 20],...
    'Callback',@(src,event) sliderCallback(src,robot,config));

function sliderCallback(src,robot,config)

    val = src.Value;
    config(1) = val;

    show(robot,config,'PreservePlot',false);

end


% Slider 2
txt2=uicontrol('Style','text','String','prismatic','Position',[350,40,300,20],'FontSize',14);
slider2 = uicontrol('Style','slider',...
    'Min',0,'Max',4,...
    'Value',0,...
    'Position',[150 40 300 20],...
    'Callback',@(src,event) sliderCallback2(src,robot,config));

function sliderCallback2(src,robot,config)

    val = src.Value;
    config(2) = val;

    show(robot,config,'PreservePlot',false);

end
showdetails(robot)

% Slider 3
txt3=uicontrol('Style','text','String','revolute1','Position',[350,60,300,20],'FontSize',14);
slider3 = uicontrol('Style','slider',...
    'Min',0,'Max',2*pi,...
    'Value',0,...
    'Position',[150 60 300 20],...
    'Callback',@(src,event) sliderCallback3(src,robot,config));

function sliderCallback3(src,robot,config)

    val = src.Value;
    config(3) = val;

    show(robot,config,'PreservePlot',false);

end


% Slider 4
txt4=uicontrol('Style','text','String','revolute2','Position',[350,80,300,20],'FontSize',14);
slider4 = uicontrol('Style','slider',...
    'Min',0,'Max',2*pi,...
    'Value',0,...
    'Position',[150 80 300 20],...
    'Callback',@(src,event) sliderCallback4(src,robot,config));

function sliderCallback4(src,robot,config)

    val = src.Value;
    config(4) = val;

    show(robot,config,'PreservePlot',false);

end
showdetails(robot)


