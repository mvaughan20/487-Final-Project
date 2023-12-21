LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY car is 
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        car_x_pos : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
        start : IN STD_LOGIC; -- initiates start
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC;
        brake : IN STD_LOGIC;
        reset : IN STD_LOGIC
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
    SIGNAL car_speed, car_brake : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(0, 11);
    SIGNAL inactive_street_on, active_street_on, win_street_on : STD_LOGIC;
    SIGNAL vx, vy, vx1, vy1 : STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL car_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(50, 11);
    SIGNAL car_x_stop : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(0, 11);
    
    SIGNAL car_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
    SIGNAL red_on : STD_LOGIC;
    SIGNAL yellow_on : STD_LOGIC;
    SIGNAL green_on : STD_LOGIC;
    SIGNAL red_turn_on, yellow_turn_on, green_turn_on : STD_LOGIC := '0';
        SIGNAL lx, ly, lx1, ly1, lx2, ly2 : STD_LOGIC_VECTOR (10 DOWNTO 0);
    
    SIGNAL counter_start : STD_LOGIC := '0';
    SIGNAL car_safe : STD_LOGIC := '0';
    SIGNAL counter : STD_LOGIC_VECTOR(10 downto 0) := "00000000000";
    
   
    
BEGIN
    red <=  '0' WHEN car_on = '1' ELSE
    '1' WHEN inactive_street_on = '1' ELSE
	          '1' WHEN active_street_on = '1' ELSE
	          '1' WHEN win_street_on = '1' ELSE
            '1' WHEN red_on = '1' ELSE
            '1' WHEN yellow_on = '1' ELSE
            '0';
	green <= 
	          '1' WHEN green_on = '1' ELSE
	          '1' WHEN yellow_on = '1' ELSE
	          '0';
	blue  <= '1' WHEN car_on = '1' ELSE
	           '0' WHEN red_on = '1' ELSE
	          '0';
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
	
	update_speed : PROCESS(car_x_pos, reset) IS 
	BEGIN
	
	   IF reset = '1' THEN
	       car_speed <= CONV_STD_LOGIC_VECTOR(0, 11);
	   ELSIF car_x_pos > car_speed THEN
	       car_speed <= car_x_pos;
	   END IF;
	   
	END PROCESS update_speed;
	
	update_brake : PROCESS IS
	BEGIN
	   IF brake = '1' THEN
            car_brake <= "00000000100";
       ELSIF brake = '0' THEN
            car_brake <= "00000000000";
       END IF;
	END PROCESS update_brake;
	
	mcar : PROCESS IS
	BEGIN
	       IF reset = '1' THEN
               car_x <= "00000110010"; -- reset to starting location
          END IF;
	   WAIT UNTIL rising_edge(v_sync);
          
	   IF car_safe = '0' AND (car_x+car_body_width >= 525 + active_street_width) THEN
            car_x <= car_x; -- freeze car
       ELSIF car_safe = '1' AND (car_x-car_body_width >= 800) THEN
            car_x <= car_x; -- freeze car
         
       ELSE
            
            IF car_brake > car_speed THEN
                car_x <= car_x;   
            ELSE 
             car_x <= car_x + car_speed - car_brake;
            END IF;
	   END IF;
	   
	END PROCESS mcar;
	
	lightdraw : PROCESS (pixel_row, pixel_col) IS
	BEGIN
	    
		IF((lx * lx) + (ly * ly)) < (225) AND red_turn_on = '1' THEN -- test if radial distance < bsize
            red_on <= '1';
        ELSIF((lx1 * lx1) + (ly1 * ly1)) < (225) AND yellow_turn_on = '1' THEN -- test if radial distance < bsize
            yellow_on <= '1';
        ELSIF((lx2 * lx2) + (ly2 * ly2)) < (225) AND green_turn_on = '1' THEN -- test if radial distance < bsize
            green_on <= '1';
		ELSE
			red_on <= '0';
			yellow_on <= '0';
			green_on <= '0';
		END IF;
            
	END PROCESS lightdraw;
	
	circle : PROCESS (pixel_row, pixel_col) IS 
	BEGIN
	   IF pixel_col <= 675 THEN -- vx = |ball_x - pixel_col|
            lx <= (675) - pixel_col;
        ELSE
            lx <= pixel_col - (675);
        END IF;
        IF pixel_row <= 225 THEN -- vy = |ball_y - pixel_row|
            ly <= (225) - pixel_row;
        ELSE
            ly <= pixel_row - (225);
        END IF;
        
        
        
        IF pixel_col <= 675 THEN -- vx = |ball_x - pixel_col|
            lx1 <= (675) - pixel_col;
        ELSE
            lx1 <= pixel_col - (675);
        END IF;
        IF pixel_row <= 300 THEN -- vy = |ball_y - pixel_row|
            ly1 <= (300) - pixel_row;
        ELSE
            ly1 <= pixel_row - (300);
        END IF;
        
        
         IF pixel_col <= 675 THEN -- vx = |ball_x - pixel_col|
            lx2 <= (675) - pixel_col;
        ELSE
            lx2 <= pixel_col - (675);
        END IF;
        IF pixel_row <= 375 THEN -- vy = |ball_y - pixel_row|
            ly2 <= (375) - pixel_row;
        ELSE
            ly2 <= pixel_row - (375);
        END IF;
	END PROCESS circle;
    
    cnt_start : PROCESS (car_x) IS -- start counter if car passes a certain point
	BEGIN
	   IF car_x + car_body_width >= 525 - active_street_width THEN
	       counter_start <= '1';
	   END IF;
	END PROCESS cnt_start;   
	
	cnt : PROCESS (counter_start) IS -- counter
	BEGIN
	   IF counter_start = '1' AND rising_edge(v_sync) THEN
	       
	       IF counter = CONV_STD_LOGIC_VECTOR(1500, 11) THEN
	           car_safe <= '1';
	           red_turn_on <= '0';
	           green_turn_on <= '1';
	           counter <= counter + 1;
	       ELSIF counter >= CONV_STD_LOGIC_VECTOR(2000, 11) THEN
	           counter <= "00000000000";
	           green_turn_on <= '0';
	       ELSIF counter = CONV_STD_LOGIC_VECTOR(2, 11) THEN
	           yellow_turn_on <= '1';
	           car_safe <= '0';
	           counter <= counter + 1;
	           
	       ELSIF counter = CONV_STD_LOGIC_VECTOR(300, 11) THEN
	           yellow_turn_on <= '0';
	           red_turn_on <= '1';
	           counter <= counter + 1;

           ELSE 
               counter <= counter + 1;

	       END IF;
	       

	       
	   END IF;
	END PROCESS cnt;

	
END behavioral;
