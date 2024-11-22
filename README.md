# ProjectSpyn

ProjectSpyn is a robotics control system implemented in MATLAB for interacting with LEGO Mindstorms EV3. Project Spyn is a inclusivity project designed to improve mobility for speacially-abled people by providing personalized autonomous transportation over the city.

## Features

- **Keyboard Control**: Use standard keys to move the robot forward, backward, and to turn left or right on pickup and drop-off zones.
- **Autonomous Navigation**: Automatically navigates a maze designed to mimick a road system for a city.
- **Lift Mechanism**: Control the robot's lift arm for raising and lowering objects.
- **Real-time Feedback**: Displays actions on the MATLAB console for better user interaction.

## Requirements

- MATLAB with LEGO Mindstorms EV3 Support Package
- LEGO Mindstorms EV3 Brick
- EV3 motors connected to specific ports:
  - Driving motors: Ports `A` and `D`
  - Lift motor: Port `B`
- EV3 sensors connected to the following ports:
  - Color sensor: 3
  - UltraSonic sensor: 2
  - Touch sensor: 1

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/RETR0-OS/ProjectSpyn.git
   ```
2. Open MATLAB and navigate to the project directory.
3. Ensure the EV3 brick is powered on and connected via Bluetooth or USB.

## Usage

1. Set the pickup and dropoff locations in ProjectSpyn.m.
2. Run `ProjetSpyn.m` in MATLAB.
3. The robot navigates the maze autonomously to go to the pickup location and dropoff locations.
4. At the pickup and dropoff locations, use the following keys for control:
   - `w`: Move forward
   - `s`: Move backward
   - `a`: Turn left
   - `d`: Turn right
   - `g`: Lower the lift
   - `t`: Raise the lift
   - `q`: Quit the keyboard control mode

## Contributing

Contributions are welcome! Please submit a pull request or open an issue for suggestions and bug reports.

## License

This project is open-source and published under the MIT license
