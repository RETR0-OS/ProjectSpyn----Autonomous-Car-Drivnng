motorPorts = 'AD';
rightMotor = 'A';
leftMotor = 'D';

brickName = 'gp123';
brick = ConnectBrick(brickName);


% worm motor definitions % 
wormMotorPort = 'B';

function manualControlDriver(brick)
    disp('Use W/A/S/D for movement, SPACE to stop, Q to quit.');
    
    while true
        if kbhit()  % Check if a key is pressed
            key = getkey();  % Get the pressed key
            if key == 'q'  % Quit the loop on 'Q' press
                brick.StopMotor(motorPorts, 'Brake');
                disp('Exiting manual control...');
                break;
            else
                manual_control(brick, key);  % Handle manual movement
            end
        else
            
            brick.StopMotor(motorPorts, 'Coast');
            pause(2);
            % switch to Automated movement
        end
    end
end

function manual_control(brick, key)
    switch key
        case 'w'  % Move Forward
            disp('Moving Forward');
            brick.MoveMotor(motorPorts, 70);
        case 's'  % Move Backward
            disp('Moving Backward');
            brick.MoveMotor(motorPorts, -40);
        case 'a'  % Turn Left
            disp('Turning Left');
            turn_left(brick);
        case 'd'  % Turn Right
            disp('Turning Right');
            turn_right(brick);
        case 'g' % Lower Lift
            disp('Lowering Lift');
        case 't'
            disp('Raising Lift');
        case ' '  % Space key to stop
            disp('Stopping Motors');
            brick.StopMotor(motorPorts, 'Brake');
        otherwise
            disp('Invalid key. Use W/A/S/D/SPACE/Q');
    end
end

function turn_around(brick)
    brick.MoveMotorAngleRel(rightMotor, 50, 360, 'Coast');
    brick.MoveMotorAngleRel(leftMotor, 50, -360, 'Coast');
    return;
end

function turn_left(brick)
    brick.MoveMotorAngleRel(rightMotor, 50, 180, 'Coast');
    brick.MoveMotorAngleRel(leftMotor, 50, -180, 'Coast');
    return;
end

function turn_right(brick)
    brick.MoveMotorAngleRel(rightMotor, 50, -360, 'Coast');
    brick.MoveMotorAngleRel(leftMotor, 50, 360, 'Coast');
    return;
end

function lowerLift(brick)
    brick.MoveMotor(wormMotorPort, -10);
    return;
end

function raiseLift(brick)
    brick.MoveMotor(wormMotorPort, 10)
    return;
end

manualControlDriver(brick);
