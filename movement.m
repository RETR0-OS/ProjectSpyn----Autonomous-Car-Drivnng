motorPorts = 'AB';
rightMotor = 'A';
leftMotor = 'B';

brickName = 'gp123';

brick = ConnectBrick(brickName);

function main(brick)
    while true
        % move forward
        brick.MoveMotor(motorPorts, 90);
        if (brick.TouchPressed(1))
            determine_turn(brick);
        elseif (brick.ColorCode(SensorPort) == 5)
            brick.StopMotor(motorPorts, 'Coast');
            pause(2);
        end
    end

end

function determine_turn(brick)
    distance = brick.UltrasonicDist(SensorPort);
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
    return
end

main(brick);