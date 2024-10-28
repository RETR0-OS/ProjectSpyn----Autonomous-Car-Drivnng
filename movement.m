global rightMotor
global leftMotor
global motorPorts
global brick
global brickName
global SensorPort
global driveMode

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

%Ultra Sonic%
SensorPort = 3;
% end %


while true
    % move forward
    brick.MoveMotor(motorPorts, -90);
    if (brick.TouchPressed(1))
        brick.StopMotor(motorPorts, 'Brake');
        determine_turn(brick, SensorPort, rightMotor, leftMotor);
    elseif (brick.ColorCode('D') == 5)
        % red stop line %
        brick.StopMotor(motorPorts, 'Coast');
        pause(2);
    elseif (brick.ColorCode('3') == 2 || brick.ColorCode('3') == 3 || brick.ColorCode('3') == 4)
         driveMode = false;
        drop_off_zone(brick, motorPorts)
    end
end



function drop_off_zone(brick, motorPorts)
    brick.StopMotor(motorPorts, 'Coast');
end


function determine_turn(brick, SensorPort, rightMotor, leftMotor)
    distance = brick.UltrasonicDist(SensorPort);
    if (distance > 32)
        turn_left(brick, rightMotor, leftMotor)
        return;
    else
        turn_around(brick, rightMotor, leftMotor);
        if (distance > 32)
           turn_right(brick, rightMotor, leftMotor)
           return;
        else
            return;
        end
    end
end

function turn_around(brick, rightMotor, leftMotor)
    % FIXME: Verify turn roations %
    brick.MoveMotorAngleRel(rightMotor, -50, 360, 'Coast');
    brick.MoveMotorAngleRel(leftMotor, -50, -360, 'Coast');
    return;
end

function turn_left(brick, rightMotor, leftMotor)
    % FIXME: Verify turn roations %
    brick.MoveMotorAngleRel(rightMotor, -50, 90, 'Coast');
    brick.MoveMotorAngleRel(leftMotor, -50, -90, 'Coast');
    return;
end

function turn_right(brick, rightMotor, leftMotor)
    % FIXME: Verify turn roations %
    brick.MoveMotorAngleRel(rightMotor, -50, -90, 'Coast');
    brick.MoveMotorAngleRel(leftMotor, -50, 90, 'Coast');
    return
end


