motorPorts = 'AD';
rightMotor = 'A';
leftMotor = 'D';

brickName = 'gp123';
brick = ConnectBrick(brickName);

function main(brick)
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
            % Automated movement forward, check for sensors
            brick.MoveMotor(motorPorts, 90);
            if brick.TouchPressed(1)
                determine_turn(brick);
            elseif brick.ColorCode(3) == 5  % Assuming sensor port 3 for color
                brick.StopMotor(motorPorts, 'Coast');
                pause(2);
            end
        end
    end
end

function manual_control(brick, key)
    switch key
        case 'w'  % Move Forward
            disp('Moving Forward');
            brick.MoveMotor(motorPorts, 50);
        case 's'  % Move Backward
            disp('Moving Backward');
            brick.MoveMotor(motorPorts, -50);
        case 'a'  % Turn Left
            disp('Turning Left');
            turn_left(brick);
        case 'd'  % Turn Right
            disp('Turning Right');
            turn_right(brick);
        case ' '  % Space key to stop
            disp('Stopping Motors');
            brick.StopMotor(motorPorts, 'Brake');
        otherwise
            disp('Invalid key. Use W/A/S/D/SPACE/Q');
    end
end

function determine_turn(brick)
    distance = brick.UltrasonicDist(4);  % Assuming sensor port 4 for Ultrasonic
    if distance > 32
        turn_left(brick);
        return;
    else
        turn_around(brick);
        if distance > 32
           turn_right(brick);
           return;
        else
            return;
        end
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

main(brick);
