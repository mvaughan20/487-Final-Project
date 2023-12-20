# CPE487 Final Project: Traffic Light Simulation
## Group 4- Shady Kamel, Anthony Guadagno, Matthew Vaughan
* Our project consists of a traffic light simulation game using our FPGA's VGA output. The game will be controlled by the same potentiometer and Pmod AD1 used in lab 6. 
* The goal of the game is to have the car make it to the end of a road, but the game will end if the car runs the red light. When the car reaches the intersection, a timer will trigger that will eventually change the light from green to red. The car is then free to drive to the end of the road and "win" the game. 
* Our codebase is built upon pieces of labs 3 and 6 respectively, as we were able to use some of the VGA and movement components from each lab. 
### The game in action:
> SCREENSHOT WILL GO HERE
### 1. Car Model and Movement
>  CAR SCREENSHOT 
* The car is generated in car.vhd, where the wheels and body of the car are drawn separately. The left wheel and right wheel are drawn with the same algorithm, but are placed 50 pixels apart. The rest of the car is drawn in cdraw, which creates 2 rectangles to form the body of the car.
* The car moves based speed set by the controller, where the velocity of the car gets incrementally faster by turning the knob up. The car is only able to slow down via the break button on the FPGA, which slowly decrements the car speed until it comes to a full stop. 
### 2. Traffic Light Model and Counter
* When the car reaches the intersection, a timer is triggered which will count down the traffic light changing from red to green.
> LIGHT SCREENSHOT 
* Once the timer is completed and the light changes to green, the car will be able to pass the intersection.
* The remaining time will be displayed on the FPGA's built in display using the leddec function.
> TIMER SCREENSHOT 
### 3. Loss Conditions
* If the player fails the game, the loss indicator will be displayed 	<sup> EITHER ON VGA SCREEN OR BOARD DISPLAY </sup>
* There is a separate button on the FPGA used to reset the game in the case the player gets a game over. It will reset the car to its original position and set the timer back to zero.
> GAME OVER SCREENSHOT 
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
