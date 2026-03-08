function robo()
    clc; 
    close all;
    
    % rigid body tree created
    robot = rigidBodyTree('DataFormat','column');
    
    % main rod structure link
    mainrod = rigidBody('mainrodlink');
    mainrodjoint = rigidBodyJoint('mainrodjoint');
    setFixedTransform(mainrodjoint, [0 0 5 0],'dh'); 
    mainrodcoll = collisionCylinder(0.3,5);
    mainrodcoll.Pose = trvec2tform([0 0 -2.5]); 
    addCollision(mainrod, mainrodcoll, 'FaceColor', [0 1 1], 'FaceAlpha', 0.5)
    mainrod.Joint = mainrodjoint;
    addBody(robot,mainrod,'base');
    
    % platform link
    platformbody=rigidBody('platformlink');
    platformjoint=rigidBodyJoint('platformjoint','prismatic');
    platformbody.Joint=platformjoint;
    platformcoll = collisionBox(4, 4, 0.08);
    platformcoll.Pose = trvec2tform([1.5 0 0]);
    addCollision(platformbody, platformcoll,'FaceColor', [1 1 0], 'FaceAlpha', 0.5);
    setFixedTransform(platformjoint, [0 0 0 0],'dh');
    platformjoint.JointAxis=[0 0 1];
    addBody(robot,platformbody,'base');

    % arm translation link
    armtransbody=rigidBody('armtranslink');
    armtransjoint=rigidBodyJoint('armtransjoint','prismatic');
    armtransbody.Joint=armtransjoint;
    setFixedTransform(armtransjoint,[0 0 0 0],'dh');
    armtransjoint.JointAxis=[0 0 1];
    addBody(robot,armtransbody,'mainrodlink');
    
    % link for first joint of arm
    arm1body = rigidBody('arm1link');
    arm1joint = rigidBodyJoint('arm1joint','revolute');
    setFixedTransform(arm1joint,[2 0 0 0],'dh');
    arm1coll = collisionBox(2, 0.2, 0.2);
    arm1coll.Pose = trvec2tform([-1 0 0]);
    addCollision(arm1body, arm1coll,'FaceColor', [1 0 0], 'FaceAlpha', 0.5);
    arm1joint.JointAxis = [0 0 1];
    arm1body.Joint = arm1joint;
    addBody(robot,arm1body,'armtranslink');
    
    % link for second joint of arm
    arm2body = rigidBody('arm2link');
    arm2joint = rigidBodyJoint('arm2joint','revolute');
    arm2coll = collisionBox(2, 0.2, 0.2);
    arm2coll.Pose = trvec2tform([-1 0 0]);
    addCollision(arm2body, arm2coll, 'FaceColor', [0 0 1], 'FaceAlpha', 0.5);
    setFixedTransform(arm2joint,[2 0 0 0],'dh');
    arm2joint.JointAxis = [0 0 1];
    arm2body.Joint = arm2joint;
    addBody(robot,arm2body,'arm1link');

    fig = figure('Name', 'Continuous Robot Control');
    ax = axes('Parent', fig, 'Position', [0.1, 0.3, 0.8, 0.6]);
    
    % ui sliders and text label for these sliders

    platformSlider = uicontrol('Style','slider', 'Min',0, 'Max',4, 'Value',2, ...
        'Units','normalized', 'Position',[0.2 0.16 0.6 0.03], ...
        'Callback', @(src,event) updateRobot());
    uicontrol('Style','text', 'Units','normalized', 'Position',[0.05 0.16 0.12 0.03], 'String','Platform Prismatic');

    ArmTransSlider = uicontrol('Style','slider', 'Min',-4, 'Max',-0.2, 'Value',-0.2, ...
        'Units','normalized', 'Position',[0.2 0.01 0.6 0.03], ...
        'Callback', @(src,event) updateRobot());
    uicontrol('Style','text', 'Units','normalized', 'Position',[0.05 0.01 0.1 0.03], 'String','Arm1 Prismatic');

    Arm1Slider = uicontrol('Style','slider', 'Min',-pi/2, 'Max',pi/2, 'Value',0, ...
        'Units','normalized', 'Position',[0.2 0.11 0.6 0.03], ...
        'Callback', @(src,event) updateRobot());
    uicontrol('Style','text', 'Units','normalized', 'Position',[0.05 0.11 0.1 0.03], 'String','Arm1 Revolute');

    Arm2Slider = uicontrol('Style','slider', 'Min',-pi, 'Max', pi, 'Value',0.5, ...
        'Units','normalized', 'Position',[0.2 0.06 0.6 0.03], ...
        'Callback', @(src,event) updateRobot());
    uicontrol('Style','text', 'Units','normalized', 'Position',[0.05 0.06 0.1 0.03], 'String','Arm2 Revolute');

    % setting initial robot configuration and the viewing camera angles
    updateRobot();
    view(3);
    
    % callback function for the sliders
    function updateRobot()
        [az, el] = view(ax);
        current_config = [platformSlider.Value; ArmTransSlider.Value; Arm1Slider.Value; Arm2Slider.Value];
        show(robot, current_config, 'Parent', ax, 'PreservePlot', false, 'Collisions', 'on', 'Frames', 'on');
        axis(ax, 'manual');
        axis(ax, 'equal');
        xlim(ax, [-1 5]);
        ylim(ax, [-3 3]);
        zlim(ax, [0 5.5]);
        view(ax, az, el);
        rotate3d(ax,'on');
        grid(ax, 'on');
    end
end