% brick vars definitions %
global brickName;
global brick;
global driveMode;

brickName = 'gp123';
brick = ConnectBrick(brickName);
driveMode = true;
% end %

function main()
    global driveMode;
    if driveMode == true
        % run autonomous %
        disp("auto")
    else
        % run keyboard control %
        disp("manual")
    end
end

main();
