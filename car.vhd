LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY car is 
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        car_x_pos : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current car x position
        start : IN STD_LOGIC; -- initiates start
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC;
        brake : IN STD_LOGIC
    );
END car;

ARCHITECTURE behavioral of car is
    CONSTANT car_body_width : INTEGER := 50;
    CONSTANT car_body_height : INTEGER := 18;
    CONSTANT car_top_width : INTEGER := 23;
    CONSTANT car_top_height : INTEGER := 27;
    CONSTANT inactive_street_width : INTEGER := 200; -- width of street will be approximately 2/3 of 800px
    CONSTANT inactive_street_height, active_street_height : INTEGER := 100;
    CONSTANT active_street_width : INTEGER := 125;
    SIGNAL car_on : STD_LOGIC;
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL car_speed, car_brake : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(0, 11);
    SIGNAL inactive_street_on, active_street_on, win_street_on : STD_LOGIC;
    SIGNAL vx, vy, vx1, vy1 : STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL car_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
    SIGNAL car_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    
    
   
    
BEGIN
    red <= NOT car_on; -- color setup for blue car on green background
	green <= NOT inactive_street_on AND NOT active_street_on AND NOT win_street_on AND NOT car_on;
	blue  <= car_on;
	cdraw : PROCESS (car_x, car_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= car_x - car_body_width) AND
		 (pixel_col <= car_x + car_body_width) AND
			 (pixel_row >= car_y - car_body_height) AND
			 (pixel_row <= car_y + car_body_height) THEN
				car_on <= '1';
	    ELSIF (pixel_col >= car_x - car_top_width) AND
		       (pixel_col <= car_x + car_top_width) AND
			     (pixel_row >= (car_y - 19) - car_top_height) AND
		  	        (pixel_row <= (car_y - 19) + car_top_height) THEN
				car_on <= '1';
		ELSIF((vx * vx) + (vy * vy)) < (144) THEN -- test if radial distance < bsize
            car_on <= '1';
        ELSIF((vx1 * vx1) + (vy1 * vy1)) < (144) THEN -- test if radial distance < bsize
            car_on <= '1';
		ELSE
			car_on <= '0';
		END IF;
            
	END PROCESS cdraw;
	
	wheel : PROCESS (car_x, car_y, pixel_row, pixel_col) IS 
	BEGIN
	   IF pixel_col <= car_x - 25 THEN -- vx = |ball_x - pixel_col|
            vx <= (car_x - 25) - pixel_col;
        ELSE
            vx <= pixel_col - (car_x - 25);
        END IF;
        IF pixel_row <= car_y + 20 THEN -- vy = |ball_y - pixel_row|
            vy <= (car_y + 20) - pixel_row;
        ELSE
            vy <= pixel_row - (car_y +20);
        END IF;
        
        
        
        IF pixel_col <= car_x + 25 THEN -- vx = |ball_x - pixel_col|
            vx1 <= (car_x + 25) - pixel_col;
        ELSE
            vx1 <= pixel_col - (car_x + 25);
        END IF;
        IF pixel_row <= car_y + 20 THEN -- vy = |ball_y - pixel_row|
            vy1 <= (car_y + 20) - pixel_row;
        ELSE
            vy1 <= pixel_row - (car_y +20);
        END IF;
	END PROCESS wheel;
	
	inactive_street_draw : PROCESS IS
	BEGIN
	   IF (pixel_col >= 200 - inactive_street_width) AND
		 (pixel_col <= 200 + inactive_street_width) AND
			 (pixel_row >= 300 - inactive_street_height) AND
			 (pixel_row <= 300 + inactive_street_height) THEN
				inactive_street_on <= '1';
		ELSE
			inactive_street_on <= '0';
		END IF;
	END PROCESS inactive_street_draw;
	
	active_street_draw : PROCESS IS
	BEGIN
	   IF (pixel_col >= 525 - active_street_width) AND
		 (pixel_col <= 525 + active_street_width) AND
			 (pixel_row >= 300 - active_street_height) AND
			 (pixel_row <= 300 + active_street_height) THEN
				active_street_on <= '1';
		ELSE
			active_street_on <= '0';
		END IF;
	END PROCESS active_street_draw;
	
	win_street : PROCESS IS
	BEGIN
	   IF (pixel_col >= 700) AND
		 (pixel_col <= 800) AND
			 (pixel_row >= 200) AND
			 (pixel_row <= 400) THEN
				win_street_on <= '1';
		ELSE
			win_street_on <= '0';
		END IF;
	END PROCESS win_street;
	
	update_speed : PROCESS(car_x_pos) IS 
	BEGIN
	
	   IF car_x_pos > car_speed THEN
	       car_speed <= car_x_pos;
	   END IF;
	   
	END PROCESS update_speed;
	
	update_brake : PROCESS IS
	BEGIN
	   IF brake = '1' THEN
            car_brake <= "00000000001";
       ELSIF brake = '0' THEN
            car_brake <= "00000000000";
       END IF;
	END PROCESS update_brake;
	
	mcar : PROCESS IS
	BEGIN
	   WAIT UNTIL rising_edge(v_sync);
	  
	   IF (car_x + car_body_width) >= (800) THEN
            car_x <= CONV_STD_LOGIC_VECTOR(50, 11); -- reset to starting position
            
       ELSE
            IF car_brake > car_speed THEN
                car_x <= car_x;
            ELSE 
             car_x <= car_x + car_speed - car_brake;
            END IF;
	   END IF;
	   
	END PROCESS mcar;
	
    
END behavioral;
