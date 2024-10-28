motorPorts = 'AD';
rightMotor = 'A';
leftMotor = 'D';

brickName = 'gp123';
brick = ConnectBrick(brickName);


% worm motor definitions % 
wormMotorPort = 'B';

%open keyboard%
InitKeyboard()

function manualControlDriver(brick)
    disp('Use W/A/S/D for movement, SPACE to stop, Q to quit.');s
    while true
        switch key
            case 'w'  % Move Forward
                disp('Moving Forward');
                brick.MoveMotor(motorPorts, -70);
                break;
            case 's'  % Move Backward
                disp('Moving Backward');
                brick.MoveMotor(motorPorts, 40);
                break;
            case 'a'  % Turn Left
                disp('Turning Left');
                turn_left(brick);
                break;
            case 'd'  % Turn Right
                disp('Turning Right');
                turn_right(brick);
                break;
            case 'g' % Lower Lift
                disp('Lowering Lift');
                lower_lift(brick);
                break;
            case 't'
                disp('Raising Lift');
                raise_lift(brick);
                break;
            otherwise
                brick.StopAllMotors('brake');
        end

    end
end

function turn_left(brick)
    brick.MoveMotorAngleRel(rightMotor, -50, 180, 'Coast');
    brick.MoveMotorAngleRel(leftMotor, -50, -180, 'Coast');
    return;
end

function turn_right(brick)
    brick.MoveMotorAngleRel(rightMotor, -50, -360, 'Coast');
    brick.MoveMotorAngleRel(leftMotor, -50, 360, 'Coast');
    return;
end

function lower_lift(brick)
    %FIXME: Verify worm motor orientation %
    brick.MoveMotor(wormMotorPort, -10);
    return;
end

function raise_lift(brick)
    %FIXME: Verify worm motor orientation %
    brick.MoveMotor(wormMotorPort, 10);
    return;
end

manualControlDriver(brick);
