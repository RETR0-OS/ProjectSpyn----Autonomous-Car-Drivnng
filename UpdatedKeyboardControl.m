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
        case 'w'  % Move Forward Continuously
            disp('Moving Forward...');
            while isKeyDown('w')  % Continue moving while 'W' is held down
                brick.MoveMotor(motorPorts, 50);
            end
            brick.StopMotor(motorPorts, 'Brake');  % Stop when 'W' is released
            
        case 's'  % Move Backward Continuously
            disp('Moving Backward...');
            while isKeyDown('s')  % Continue moving while 'S' is held down
                brick.MoveMotor(motorPorts, -50);
            end
            brick.StopMotor(motorPorts, 'Brake');  % Stop when 'S' is released
            
        case 'a'  % Turn Left Continuously
            disp('Turning Left...');
            while isKeyDown('a')  % Continue turning left while 'A' is held down
                brick.MoveMotor(leftMotor, -50);   % Left motor backward
                brick.MoveMotor(rightMotor, 50);   % Right motor forward
            end
            brick.StopMotor(motorPorts, 'Brake');  % Stop when 'A' is released
            
        case 'd'  % Turn Right Continuously
            disp('Turning Right...');
            while isKeyDown('d')  % Continue turning right while 'D' is held down
                brick.MoveMotor(leftMotor, 50);    % Left motor forward
                brick.MoveMotor(rightMotor, -50);  % Right motor backward
            end
            brick.StopMotor(motorPorts, 'Brake');  % Stop when 'D' is released
            
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

function keyHeld = isKeyDown(key)
    % Placeholder: Function to detect if a specific key is currently held down.
    keyHeld = false;
    % Actual implementation would require a method or tool capable of real-time key state detection.
    % Example solutions include custom scripts, Java integrations, or third-party tools.
end

main(brick);
