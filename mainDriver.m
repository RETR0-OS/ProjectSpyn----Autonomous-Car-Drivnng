
% brick vars definitions %
brickName = 'gp123';
brick = ConnectBrick(brickName);
driveMode = true;
% end %


function main()
    if driveMode == true
        % run autonomous %
        disp("auto")
    else
        % run keyboard control %
        disp("manual")
    end
end

main()