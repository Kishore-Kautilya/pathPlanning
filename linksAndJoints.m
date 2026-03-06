clc;
clear;
close all;
a=0;
b=0;
c=0;

% Create rigid body tree
robot = rigidBodyTree('DataFormat','column','MaxNumBodies',9);

%---------movable base----

%------for x translation-------
bodyX = rigidBody('base_x');
jointX = rigidBodyJoint('joint_x','prismatic');

setFixedTransform(jointX, eye(4));
jointX.JointAxis = [1 0 0];

bodyX.Joint = jointX;
addBody(robot, bodyX, 'base');

%--------for y translation---------
bodyY = rigidBody('base_y');
jointY = rigidBodyJoint('joint_y','prismatic');

setFixedTransform(jointY, eye(4));
jointY.JointAxis = [0 1 0];

bodyY.Joint = jointY;
addBody(robot, bodyY, 'base_x');

%-------for rotation of the base-----------
bodyYaw = rigidBody('base_yaw');
jointYaw = rigidBodyJoint('joint_yaw','revolute');

setFixedTransform(jointYaw, eye(4));
jointYaw.JointAxis = [0 0 1];

bodyYaw.Joint = jointYaw;
addBody(robot, bodyYaw, 'base_y');

% -------- Link 1 --------
body1 = rigidBody('link1');
joint1 = rigidBodyJoint('joint1','prismatic');

setFixedTransform(joint1,[0 0 0 0],'dh'); % [a alpha d theta]
joint1.JointAxis = [0 0 1];
body1.Joint = joint1;
addBody(robot,body1,'base_yaw');

% -------- Link 2 --------
body2 = rigidBody('link2');
joint2 = rigidBodyJoint('joint2','revolute');

setFixedTransform(joint2,[0.5 0 0 0],'dh');
joint2.JointAxis = [0 0 1];%defining the axis along with either totation/translation happens in the body frame.

body2.Joint = joint2;
addBody(robot,body2,'link1');

%--------Link 3----------
body3 = rigidBody('link3');
joint3 = rigidBodyJoint('joint3','revolute');

setFixedTransform(joint3,[0.5 0 0 0],'dh');
joint3.JointAxis = [0 0 1];%defining the axis along with either totation/translation happens in the body frame.

body3.Joint = joint3;
addBody(robot,body3,'link2');


config = homeConfiguration(robot);

config(1) = 1;
config(2) = 0;
config(3) = c;
config(4) = 1;
config(5) = pi/4;
config(6) = pi/4;


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
slider = uicontrol('Style','slider',...
    'Min',0,'Max',4,...
    'Value',0,...
    'Position',[150 20 300 20],...
    'Callback',@(src,event) sliderCallback(src,robot,config));

function sliderCallback(src,robot,config)

    val = src.Value;
    config(1) = val;

    show(robot,config,'PreservePlot',true);

end
