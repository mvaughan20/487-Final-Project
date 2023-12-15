LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY car is 
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        car_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0); -- current car x position
        start : IN STD_LOGIC; -- initiates start
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC
    );
END car;

ARCHITECTURE behavioral of car is
    CONSTANT bsize : INTEGER := 8;
    CONSTANT inactive_street_width : INTEGER := 200; -- width of street will be approximately 2/3 of 800px
    CONSTANT inactive_street_height : INTEGER := 100;
    CONSTANT active_street_width : INTEGER := 100;
    CONSTANT active_street_height : INTEGER := 50;
    CONSTANT win_street_width : INTEGER := 50;
    CONSTANT win_street_height : INTEGER := 100;
    SIGNAL ball_on : STD_LOGIC;
    SIGNAL inactive_street_on : STD_LOGIC;
    SIGNAL active_street_on : STD_LOGIC;
    SIGNAL win_street_on : STD_LOGIC;
    
    SIGNAL ball_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
    SIGNAL ball_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
BEGIN
    red <= NOT ball_on; -- color setup for blue car on green background
	green <= NOT inactive_street_on AND NOT active_street_on AND NOT win_street_on AND NOT ball_on;
	blue  <= ball_on;
	-- process to draw ball current pixel address is covered by ball position
	bdraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
	BEGIN
	   IF start = '0' THEN
		IF (pixel_col >= ball_x - bsize) AND
		 (pixel_col <= ball_x + bsize) AND
			 (pixel_row >= ball_y - bsize) AND
			 (pixel_row <= ball_y + bsize) THEN
				ball_on <= '1';
		ELSE
			ball_on <= '0';
		END IF;
		
		END IF;
	END PROCESS bdraw;
	
	inactive_street_draw : PROCESS IS
	BEGIN
	   IF start = '1' THEN
	   IF (pixel_col >= 200 - inactive_street_width) AND
		 (pixel_col <= 200 + inactive_street_width) AND
			 (pixel_row >= 300 - inactive_street_height) AND
			 (pixel_row <= 300 + inactive_street_height) THEN
				inactive_street_on <= '1';
		ELSE
			inactive_street_on <= '0';
		END IF;
		END IF;
	END PROCESS inactive_street_draw;
	
	active_street_draw : PROCESS IS
	BEGIN
	   IF start = '1' THEN
	   IF (pixel_col >= 450 - inactive_street_width) AND
		 (pixel_col <= 450 + inactive_street_width) AND
			 (pixel_row >= 300 - inactive_street_height) AND
			 (pixel_row <= 300 + inactive_street_height) THEN
				active_street_on <= '1';
		ELSE
			active_street_on <= '0';
		END IF;
		END IF;
	END PROCESS active_street_draw;
	
	win_street : PROCESS IS
	BEGIN
	   IF start = '1' THEN
	   IF (pixel_col >= 750 - win_street_width) AND
		 (pixel_col <= 750 + win_street_width) AND
			 (pixel_row >= 300 - win_street_height) AND
			 (pixel_row <= 300 + win_street_height) THEN
				win_street_on <= '1';
		ELSE
			win_street_on <= '0';
		END IF;
		END IF;
	END PROCESS win_street;

END behavioral;
