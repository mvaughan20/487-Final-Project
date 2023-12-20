LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY light is 
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC
    );
END light;

ARCHITECTURE behavioral of light is
    SIGNAL red_on : STD_LOGIC;
    SIGNAL yellow_on : STD_LOGIC;
    SIGNAL green_on : STD_LOGIC;
    SIGNAL vx, vy, vx1, vy1, vx2, vy2 : STD_LOGIC_VECTOR (10 DOWNTO 0);

BEGIN
    red <= red_on AND yellow_on;
    green <= green_on AND yellow_on;
    blue <= '0';
    
    lightdraw : PROCESS (pixel_row, pixel_col) IS
	BEGIN
		IF((vx * vx) + (vy * vy)) < (225) THEN -- test if radial distance < bsize
            red_on <= '1';
        ELSIF((vx1 * vx1) + (vy1 * vy1)) < (225) THEN -- test if radial distance < bsize
            yellow_on <= '1';
        ELSIF((vx1 * vx1) + (vy1 * vy1)) < (225) THEN -- test if radial distance < bsize
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
            vx <= (675) - pixel_col;
        ELSE
            vx <= pixel_col - (675);
        END IF;
        IF pixel_row <= 225 THEN -- vy = |ball_y - pixel_row|
            vy <= (225) - pixel_row;
        ELSE
            vy <= pixel_row - (225);
        END IF;
        
        
        
        IF pixel_col <= 675 THEN -- vx = |ball_x - pixel_col|
            vx1 <= (675) - pixel_col;
        ELSE
            vx1 <= pixel_col - (675);
        END IF;
        IF pixel_row <= 300 THEN -- vy = |ball_y - pixel_row|
            vy1 <= (300) - pixel_row;
        ELSE
            vy1 <= pixel_row - (300);
        END IF;
        
         IF pixel_col <= 675 THEN -- vx = |ball_x - pixel_col|
            vx1 <= (675) - pixel_col;
        ELSE
            vx1 <= pixel_col - (675);
        END IF;
        IF pixel_row <= 375 THEN -- vy = |ball_y - pixel_row|
            vy1 <= (375) - pixel_row;
        ELSE
            vy1 <= pixel_row - (375);
        END IF;
	END PROCESS circle;
END behavioral;
