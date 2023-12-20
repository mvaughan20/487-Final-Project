# CPE487 Final Project: Traffic Light Simulation
## Group 4- Shady Kamel, Anthony Guadagno, Matthew Vaughan
* Our project consists of a traffic light simulation game using our FPGA's VGA output. The game will be controlled by the same potentiometer and Pmod AD1 used in lab 6. 
* The goal of the game is to have the car make it to the end of a road, but the game will end if the car runs the red light. When the car reaches the intersection, a timer will trigger that will eventually change the light from green to red. The car is then free to drive to the end of the road and "win" the game. 
* Our codebase is built upon pieces of labs 3 and 6 respectively, as we were able to use some of the VGA and movement components from each lab. 
### The game in action:

![new_colors](https://github.com/mvaughan20/Group-4-Final-Project/assets/94701716/db0fb355-f5fb-45dc-87ea-6a36eb759e74)
### 1. Car Model and Movement


* The car is generated in car.vhd, where the wheels and body of the car are drawn separately. The left wheel and right wheel are drawn with the same algorithm, but are placed 50 pixels apart. The rest of the car is drawn in cdraw, which creates 2 rectangles to form the body of the car.
* The car moves based speed set by the controller, where the velocity of the car gets incrementally faster by turning the knob up. The car is only able to slow down via the break button on the FPGA, which slowly decrements the car speed until it comes to a full stop. 
### 2. Traffic Light Model and Counter
* When the car reaches the intersection, a timer is triggered which will count down the traffic light changing from red to green.
* Once the timer is completed and the light changes to green, the car will be able to pass the intersection.
* The remaining time will be displayed on the FPGA's built in display using the leddec function.
### 3. Loss Conditions
* If the player fails the game, the car will be reset at the starting position at zero velocity. 
* The car also resets to the beginning at zero velocity when the player wins the game. 

### Methodology & Modifications

### Components Used
Images below from Lab 6 README (link: https://github.com/byett/dsd/tree/CPE487-Fall2023/Nexys-A7/Lab-6)
* Pmod AD1 (12-bit analog-to-digital converter)


  ![ad1](https://github.com/mvaughan20/Group-4-Final-Project/assets/94701716/ad6d939a-e8d4-4003-9fb6-36759a0daedc)

* 5kΩ Potentiometer Controller



  ![knob](https://github.com/mvaughan20/Group-4-Final-Project/assets/94701716/a381e35d-e530-470f-b6da-dd89d7cf23c8)
  ![adc](https://github.com/mvaughan20/Group-4-Final-Project/assets/94701716/cc49d1a2-becf-453f-a4ea-2ca98453a661)


* VGA cable, and VGA Supporting Monitor

### FPGA Reference Manual
Link: https://reference.digilentinc.com/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf

### How to Duplicate The Project:
1. Create a new RTL project ***traffic*** in Vivado Quick Start
    * Create [] new source files of file type VHDL called []
      - clk_wiz_0.vhd, vga_sync.vhd, adc_if.vhd, and clk_wiz_0_clk_wiz.vhd are the same files as in Lab 6
    * Create a new constraint file of file type XDC called traffic
    * Choose Nexys A7-100T board for the project
    * Click 'Finish'
    * Click design sources and copy the VHDL code from []
    * Click constraints and copy the code from traffic.xdc
   
3. Run Synthesis
4. Run Implementation
5. Generate Bitstream
6. Open Hardware Manager & Program Device
   * Connect the potentiometer controller to the AD1 and connect both to the board using the top pins of the Pmod port JA (Section 10 of the Reference Manual linked above)
   * Click 'Open Hardware Manager' and click 'Open Target' then 'Auto Connect'
   * Click 'Program Device' then xc7a100t_0 to download traffic.bit to the Nexys A7-100T board
   * Turn the knob to start the game and increase the car's speed. Good Luck!
### Contributions:
* Anthony Guadagno:
  - 
* Matthew Vaughan:
  - 
* Shady Kamel:
  - 

Summary of the process:

Timeline of the Project:

Challenges and Solutions:
* "Multiple drivers" errors: In VHDL, signals are meant to be driven by a single source at any given time to avoid conflicts and ensure proper simulation and synthesis behavior
