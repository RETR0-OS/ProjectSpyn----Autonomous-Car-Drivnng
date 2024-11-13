global rightMotor
global leftMotor
global motorPorts
global brick
global brickName
global SensorPort
global driveMode

% motor definitions %
motorPorts = 'AD'; % This will no longer be used for individual motor control
rightMotor = 'A';
leftMotor = 'D';
% end %

% brick settings %
brickName = 'gp123';
brick = ConnectBrick(brickName);
driveMode = true;
% end %

% colorSensor settings %
brick.SetColorMode('3', 2); % Ensure this is correct
%

% Ultra Sonic %
SensorPort = 3;
% end %

while true
    % move forward
    brick.MoveMotor(rightMotor, -90); % Use individual motors
    brick.MoveMotor(leftMotor, -90); % Use individual motors

    if (brick.TouchPressed(1))
        brick.StopMotor(rightMotor, 'Brake'); % Stop right motor
        brick.StopMotor(leftMotor, 'Brake');  % Stop left motor
        determine_turn(brick, SensorPort, rightMotor, leftMotor);
    elseif (brick.ColorCode('D') == 5)  % Red stop line detected
        brick.StopMotor(rightMotor, 'Coast');
        brick.StopMotor(leftMotor, 'Coast');
        pause(2);
    elseif (brick.ColorCode('3') == 2 || brick.ColorCode('3') == 3 || brick.ColorCode('3') == 4)
         driveMode = false;
         drop_off_zone(brick, rightMotor, leftMotor);
    end
end

function drop_off_zone(brick, rightMotor, leftMotor)
    brick.StopMotor(rightMotor, 'Coast');
    brick.StopMotor(leftMotor, 'Coast');
end

function determine_turn(brick, SensorPort, rightMotor, leftMotor)
    distance = brick.UltrasonicDist(SensorPort);
    if (distance > 32)
        turn_left(brick, rightMotor, leftMotor);
        return;
    else
        turn_around(brick, rightMotor, leftMotor);
        distance = brick.UltrasonicDist(SensorPort); % Recheck distance after turn
        if (distance > 32)
            turn_right(brick, rightMotor, leftMotor);
            return;
        else
            return;
        end
    end
end

function turn_around(brick, rightMotor, leftMotor)
    % FIXME: Verify turn rotations and speeds %
    brick.MoveMotorAngleRel(rightMotor, -50, 360, 'Coast');  % Turn 360 degrees right
    brick.MoveMotorAngleRel(leftMotor, -50, -360, 'Coast');  % Turn 360 degrees left
end

function turn_left(brick, rightMotor, leftMotor)
    % FIXME: Verify turn rotations and speeds %
    brick.MoveMotorAngleRel(rightMotor, -50, 90, 'Coast');   % Turn 90 degrees left
    brick.MoveMotorAngleRel(leftMotor, -50, -90, 'Coast');   % Turn 90 degrees right
end

function turn_right(brick, rightMotor, leftMotor)
    % FIXME: Verify turn rotations and speeds %
    brick.MoveMotorAngleRel(rightMotor, -50, -90, 'Coast');  % Turn 90 degrees right
    brick.MoveMotorAngleRel(leftMotor, -50, 90, 'Coast');    % Turn 90 degrees left
end
