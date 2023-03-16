library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pixeldata is generic(
    NOTE_CIRCEL_HIGHT : integer := 96;
    NOTE_WIDTH :        integer := 110;
    NOTE_HIGHT :        integer := 345;
    ROM_OFFSET :        integer := 2;
    VGA_OFFSET :        integer := 2;
    STAVE_START:        integer := 50;
    STAVE_END:          integer := 500;
    STAVE_BOTTOM_START: integer := 400;
    NOTE_START:         integer := 100
    -- SPACING IS DETERMENT BY NOTE_CIRCEL_HIGHT
 ); 
 port(
	CLK: in std_logic; -- system clock
	RESET: in std_logic; -- async reset
	X, Y: in std_logic_vector(9 downto 0); -- pixel x/y
	NOTE_IDX: in std_logic_vector(3 downto 0);
	NOTE_WRONG: in std_logic;
	RGB: out std_logic_vector(11 downto 0)); -- RGB output color
end pixeldata;

architecture Behavioral of pixeldata is
    component half_Note_ROM is
      Port ( 
        clka : in STD_LOGIC;
        addra : in STD_LOGIC_VECTOR ( 15 downto 0 );
        douta : out STD_LOGIC_VECTOR ( 0 to 0 )
      );
    
    end component;

	signal iX, iY: UNSIGNED (9 downto 0); -- pixel x/y
    signal address : UNSIGNED ( 15 downto 0 );
    signal data : STD_LOGIC_VECTOR ( 0 to 0 );
	signal NOTE_INDEX: UNSIGNED(3 downto 0);
begin
    
    iX <= UNSIGNED(X) + VGA_OFFSET;
    iY <= UNSIGNED(Y); 
    NOTE_INDEX <= UNSIGNED(NOTE_IDX);
    
    half_Note_ROM_0: component half_Note_ROM port map ( 
        clka => CLK,
        addra => std_logic_vector (address),
        douta => data
    );
    
    process (CLK)
    begin
        if RESET = '1' then
            RGB <= (others => '0');
            address <= (others => '0');
            
        elsif rising_edge(CLK) then
            RGB <= (others => '1'); -- white background
            address <= (others => '0'); -- transparent pixel
            
            case NOTE_INDEX is
                -- f,g,a upricht note
                when "000" | "001" | "010" =>
                    -- set address to read if it's an valit address it wil be placed on output in swichts case statment. Circel botom side
                    address <= resize(((iX + ROM_OFFSET) - NOTE_START -- GET x component
                             + (iY - STAVE_BOTTOM_START+NOTE_HIGHT-(NOTE_CIRCEL_HIGHT/2)*NOTE_INDEX) * NOTE_WIDTH), address'length);  -- GET y component

                -- b,c,d,e,f hanging note
                when others =>
                    -- set address to read if it's an valit address it wil be placed on output in swichts case statment. Circel top side
                    address <= resize(((iX + ROM_OFFSET) - NOTE_START -- GET x component
                             - (iY - STAVE_BOTTOM_START+NOTE_HIGHT-(NOTE_CIRCEL_HIGHT/2)*NOTE_INDEX) * NOTE_WIDTH), address'length);  -- GET y component inverted
                    
            end case;
            
            -- DISPLAY Note if in correct opsition
            if ((iX >= NOTE_START) and
               (iX < (NOTE_START+NOTE_WIDTH)) and
               -- +(NOTE_CIRCEL_HIGHT/2)*NOTE_INDEX, is the offest between the difrent notes in highed --todo: updown
               (iY >= STAVE_BOTTOM_START+NOTE_HIGHT-(NOTE_CIRCEL_HIGHT/2)*NOTE_INDEX) and
               (iY < (STAVE_BOTTOM_START-(NOTE_CIRCEL_HIGHT/2)*NOTE_INDEX))) then
                
                -- ROM out is RGN out
                if (data = 0) then
                    -- set data black on white background
                    RGB <= (others => '0');
                end if;
            END IF;
            
            -- DISPLAY Stave balk lines
            if ((iX >= STAVE_START) and
			   (iX < STAVE_end) and
			   ((iY = STAVE_BOTTOM_START) OR
			   (iY = (STAVE_BOTTOM_START-NOTE_CIRCEL_HIGHT)) OR
			   (iY = (STAVE_BOTTOM_START-NOTE_CIRCEL_HIGHT*2)) OR
			   (iY = (STAVE_BOTTOM_START-NOTE_CIRCEL_HIGHT*3)) OR
			   (iY = (STAVE_BOTTOM_START-NOTE_CIRCEL_HIGHT*4)))) then
			    -- set data black on white background
                RGB <= (others => '0');
			END IF;
        end if;
    end process;
end Behavioral;
