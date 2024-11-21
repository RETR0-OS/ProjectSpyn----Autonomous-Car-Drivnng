global rightMotor
global leftMotor
global motorPorts
global brick
global brickName
global SensorPort
global driveMode
global wormMotorPort
global key


% motor definitions %
motorPorts = 'AD';
rightMotor = 'A';
leftMotor = 'D';
wormMotorPort = 'B';
% end %


% brick settings %
brickName = 'gp123';
brick = ConnectBrick(brickName);
driveMode = true;
% end %

% colorSensor settings %
brick.SetColorMode(3, 2);
disp(brick.ColorCode(3));
%

%Ultra Sonic%
SensorPort = 2;
% end %

% driveMode definition %
driveMode = true;
% end %

% colors %
blue = 2;
green = 3;
yellow = 4;

% dropoff %
%change on every run%
dropoff = 2;
pickup = 3;
picked_up = false;
% end %

% 

while true
  while driveMode
    % move forward
    brick.MoveMotor(motorPorts, -50);
    brick.ResetMotorAngle(rightMotor);
    brick.ResetMotorAngle(leftMotor);
    if (brick.TouchPressed(1))
          brick.StopMotor(motorPorts, 'Brake');
          brick.MoveMotor(motorPorts, 30);
          pause(1);
          brick.StopMotor(motorPorts, 'Brake');
          determine_turn(brick, SensorPort, rightMotor, leftMotor);
          brick.StopMotor(motorPorts, 'Brake');
    elseif (brick.ColorCode(3) == 5)
          % red stop line %
          brick.StopMotor(motorPorts, 'Coast');
          pause(2);
          brick.MoveMotor(motorPorts, -50);
          pause(3.8);
          brick.StopMotor(motorPorts, 'Brake');
          % check right and left %
          distance = brick.UltrasonicDist(SensorPort);
          if distance > 57
              % turn right % 
              brick.ResetMotorAngle(rightMotor);
              brick.ResetMotorAngle(leftMotor);
              turn_right(brick, rightMotor, leftMotor);
          else
              % turn left %
              turn_around(brick, rightMotor, leftMotor);
              brick.ResetMotorAngle(rightMotor);
              brick.ResetMotorAngle(leftMotor);
              turn_right(brick, rightMotor, leftMotor);
          end
    elseif (brick.ColorCode(3) == 2) % Handles the blue color zone %
        if (or(dropoff == 2, pickup == 2))
            pause(0.5);
            drop_off_zone(brick, motorPorts);
            driveMode = false;
        else
            turn_around(brick, rightMotor, leftMotor);
        end
        brick.MoveMotor(motorPorts, -50)
        in_blue = true;
        brick.StopMotor(motorPorts, 'Brake');
        brick.MoveMotor(motorPorts, 30);
        pause(1);
        brick.StopMotor(motorPorts, 'Brake');
        turn_left(brick, rightMotor, leftMotor)
        while (in_blue)
            brick.MoveMotor(motorPorts, -50);
            if (brick.TouchPressed(1))
                brick.StopMotor(motorPorts, 'Brake');
                brick.MoveMotor(motorPorts, 30);
                pause(1);
                brick.StopMotor(motorPorts, 'Brake');
                if (and(pickup == 3, not(picked_up)))
                    % turn left %
                    turn_left(brick, rightMotor, leftMotor);
                elseif (and(dropoff == 3, picked_up))
                    turn_left(brick, rightMotor, leftMotor);
                end
                if (brick.ColorCode(3) == 5)
                    in_blue = false;
                    brick.StopMotor(motorPorts, 'Brake');
                    break
                end
            end
        end  
    elseif (brick.ColorCode(3) == pickup) % pickup point %
        pause(0.5);
        drop_off_zone(brick, motorPorts);
        driveMode = false;
    elseif (brick.ColorCode(3) == dropoff) % end point unless blue%
        pause(0.5);
        drop_off_zone(brick, motorPorts);
        driveMode = false;
    end
  end
  
  if not(driveMode)
    disp('Use W/A/S/D for movement, SPACE to stop, Q to quit.');
    InitKeyboard();
  end
  
  while not(driveMode)
      pause(0.1);
      switch key
          case 'w'  % Move Forward
              disp('Moving Forward');
              brick.MoveMotor(motorPorts, -70);
  
          case 's'  % Move Backward
              disp('Moving Backward');
              brick.MoveMotor(motorPorts, 40);
          case 'd'  % Turn Left
              disp('Turning Left');
              turn_left_keyboard(brick, rightMotor, leftMotor);
  
          case 'a'  % Turn Right
              disp('Turning Right');
              turn_right_keyboard(brick, rightMotor, leftMotor);
  
          case 'g' % Lower Lift
              disp('Lowering Lift');
              lower_lift(brick, wormMotorPort);
  
          case 't'
              disp('Raising Lift');
              raise_lift(brick, wormMotorPort);
          case 'q'
              disp('stop');
              brick.StopAllMotors('Coast');
              %CloseKeyboard();
              driveMode = true;
              % switch to auto %
          otherwise
              brick.StopAllMotors('Coast');
      end
  end
end



function drop_off_zone(brick, motorPorts)
    brick.StopMotor(motorPorts, 'Coast');
    return;
end


function determine_turn(brick, SensorPort, rightMotor, leftMotor)
    brick.ResetMotorAngle(rightMotor);
    brick.ResetMotorAngle(leftMotor);
    disp("turning");
    distance = brick.UltrasonicDist(SensorPort);
    disp(distance);
    if (distance > 57)
        disp(distance);
        disp("right");
        turn_right(brick, rightMotor, leftMotor)
        brick.ResetMotorAngle(rightMotor);
        brick.ResetMotorAngle(leftMotor);
        return;
    else
        turn_around(brick, rightMotor, leftMotor);
        brick.ResetMotorAngle(rightMotor);
        brick.ResetMotorAngle(leftMotor);
        distance = brick.UltrasonicDist(SensorPort);
        if (distance > 36)
            disp("left");
            turn_right(brick, rightMotor, leftMotor)
            brick.ResetMotorAngle(rightMotor);
            brick.ResetMotorAngle(leftMotor);
            return;
        end
    end
end

function turn_around(brick, rightMotor, leftMotor)
    % FIXME: Verify turn roations %
    brick.MoveMotor(rightMotor, 90);
    brick.MoveMotor(leftMotor, -90);
    pause(0.9);
    brick.StopAllMotors('Brake');
    pause(3);
end

function turn_right(brick, rightMotor, leftMotor)
    % FIXME: Verify turn roations %
    brick.MoveMotorAngleRel(rightMotor, 50, 270, 'Coast');
    brick.MoveMotorAngleRel(leftMotor, -50, 270, 'Coast');
    brick.WaitForMotor(rightMotor);
    brick.WaitForMotor(leftMotor);
end

function turn_left(brick, rightMotor, leftMotor)
    % FIXME: Verify turn roations %
    brick.MoveMotorAngleRel(rightMotor, -50, 270, 'Coast');
    brick.MoveMotorAngleRel(leftMotor, 50, 270, 'Coast');
    brick.WaitForMotor(rightMotor);
    brick.WaitForMotor(leftMotor);
end

function turn_left_keyboard(brick, rightMotor, leftMotor)
    brick.MoveMotor(rightMotor, 40);
    brick.MoveMotor(leftMotor, -40);
    return;
end

function turn_right_keyboard(brick, rightMotor, leftMotor)
    brick.MoveMotor(rightMotor, -40);
    brick.MoveMotor(leftMotor, 40);
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
