global rightMotor
global leftMotor
global motorPorts
global brick
global brickName
global wormMotorPort
motorPorts = 'AD';
rightMotor = 'A';
leftMotor = 'D';

brickName = 'gp123';
brick = ConnectBrick(brickName);
global key


% worm motor definitions % 
wormMotorPort = 'B';

%open keyboard%
InitKeyboard();

disp('Use W/A/S/D for movement, SPACE to stop, Q to quit.');
while true
    pause(0.1);
    switch key
        case 'w'  % Move Forward
            disp('Moving Forward');
            brick.MoveMotor(motorPorts, -70);

        case 's'  % Move Backward
            disp('Moving Backward');
            brick.MoveMotor(motorPorts, 40);
        case 'a'  % Turn Left
            disp('Turning Left');
            turn_left(brick, rightMotor, leftMotor);

        case 'd'  % Turn Right
            disp('Turning Right');
            turn_right(brick, rightMotor, leftMotor);

        case 'g' % Lower Lift
            disp('Lowering Lift');
            lower_lift(brick, wormMotorPort);

        case 't'
            disp('Raising Lift');
            raise_lift(brick, wormMotorPort);
        case 'q'
            disp('stop');
            brick.StopAllMotors('Coast');
            % switch to auto %
        otherwise
            brick.StopAllMotors('Coast');
    end

end
CloseKeyboard();


function turn_left(brick, rightMotor, leftMotor)
    brick.MoveMotor(rightMotor, 20);
    brick.MoveMotor(leftMotor, -20);
    return;
end

function turn_right(brick, rightMotor, leftMotor)
    brick.MoveMotor(rightMotor, -20);
    brick.MoveMotor(leftMotor, 20);
    return;
end

function lower_lift(brick, wormMotorPort)
    %FIXME: Verify worm motor orientation %
    brick.MoveMotor(wormMotorPort, -10);
    return;
end

function raise_lift(brick, wormMotorPort)
    %FIXME: Verify worm motor orientation %
    brick.MoveMotor(wormMotorPort, 10);
    return;
end
