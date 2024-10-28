
% motor definitions %
motorPorts = 'AD';
rightMotor = 'A';
leftMotor = 'D';
% end %


% brick settings %
brickName = 'gp123';
brick = ConnectBrick(brickName);
driveMode = true;
% end %

% colorSensor settings %
brick.SetColorMode('3', 2);
%

function autonomousMovement()
    global motorPorts
    global brick 
    while true
        % move forward
        brick.MoveMotor(motorPorts, -90);
        disp("loop")
        if (brick.TouchPressed(1))
            determine_turn(brick);
        elseif (brick.ColorCode('D') == 5)
            % red stop line %
            brick.StopMotor(motorPorts, 'Coast');
            pause(2);
        elseif (brick.ColorCode('3') == 2 || brick.ColorCode('3') == 3 || brick.ColorCode('3') == 4)
            drop_off_zone(brick)
        end
    end
end


function drop_off_zone(brick)
    global motorPorts
    global driveMode
    brick.StopMotor(motorPorts, 'Coast');
    driveMode = false;
end


function determine_turn(brick)
    global SensorPort
    distance = brick.UltrasonicDist(SensorPort); %FIXME: enter US port %
    if (distance > 32)
        turn_left(brick)
        return;
    else
        turn_around(brick);
        if (distance > 32)
           turn_right(brick)
           return;
        else
            return;
        end
    end
end

function turn_around(brick)
    % FIXME: Verify turn roations %
    brick.MoveMotorAngleRel(rightMotor, -50, 360, 'Coast');
    brick.MoveMotorAngleRel(leftMotor, -50, -360, 'Coast');
    return;
end

function turn_left(brick)
    % FIXME: Verify turn roations %
    brick.MoveMotorAngleRel(rightMotor, -50, 90, 'Coast');
    brick.MoveMotorAngleRel(leftMotor, -50, -90, 'Coast');
    return;
end

function turn_right(brick)
    % FIXME: Verify turn roations %
    brick.MoveMotorAngleRel(rightMotor, -50, -90, 'Coast');
    brick.MoveMotorAngleRel(leftMotor, -50, 90, 'Coast');
    return
end

autonomousMovement();

