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
  
      end
      switch brick.ColorCode(3)
          case 2
              %blue
              brick.playTone(100, 800, 500);
              pause(1);
              brick.playTone(100, 800, 500);
              driveMode = false;
              drop_off_zone(brick, motorPorts)
          case 3      
              %green
              drop_off_zone(brick, motorPorts);
              brick.playTone(100, 800, 500);
              pause(1);
              brick.playTone(100, 800, 500);
              pause(1);
              brick.playTone(100, 800, 500);
              driveMode = false;
              
          case 4
              %yellow
              driveMode = false;
              drop_off_zone(brick, motorPorts)
      end
  end
  
  if not(driveMode)
    disp('Use W/A/S/D for movement, SPACE to stop, Q to quit.');
  end
  
  while not(driveMode)
      InitKeyboard();
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
              CloseKeyboard();
              driveMode = false;
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
    if (distance > 30)
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
        if (distance > 30)
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
    %brick.WaitForMotor(rightMotor);
    %brick.WaitForMotor(leftMotor);
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

