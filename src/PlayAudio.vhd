library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PlayAudio is
    generic(
        CLK_KHZ: integer := 100000
    );
    Port ( 	reset, clk100 : in STD_LOGIC;
			outMusic : out  STD_LOGIC);
end PlayAudio;

architecture Behavioral of PlayAudio is    
    component SampleOut is
        generic(
            INPUT_DEPTH: integer := 256;
            INPUT_SAMPLE_SIZE: integer := 36984;
            INPUT_AUDIO_KHZ: integer := 44;
            INPUT_CLK_KHZ: integer := 100000
        );
        Port ( 	reset, clk : in STD_LOGIC;
                inCOEData : in STD_LOGIC_VECTOR(7 downto 0);
			    outCOEData : out STD_LOGIC_VECTOR(7 downto 0);
                outCOEAddress : out STD_LOGIC_VECTOR(15 downto 0)
                );
    end component;
    
    component AudioOut is
        generic(
            INPUT_DEPTH: integer := 256;
            INPUT_SAMPLE_SIZE: integer := 36984;
            INPUT_AUDIO_KHZ: integer := 44;
            INPUT_CLK_KHZ: integer := 100000
        );
        Port ( 	reset, clk : in STD_LOGIC;
                inMusicData : in STD_LOGIC_VECTOR(7 downto 0);
                outMusic : out  STD_LOGIC);
    end component;

    component BertErnie44Audio IS
        PORT (
            clka : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END component;
    

signal COEAddress :STD_LOGIC_VECTOR(15 DOWNTO 0);
signal COEData :STD_LOGIC_VECTOR(7 DOWNTO 0);
signal MusicLevel:STD_LOGIC_VECTOR(7 DOWNTO 0);

begin
    -- map ports
    SampleOut0: SampleOut Port Map(
        reset           => reset,
        clk             => clk100,
        inCOEData       => COEData,
        outCOEData      => MusicLevel,
        outCOEAddress   => COEAddress
    );
    
    -- map ports
    AudioOut0: AudioOut Port Map(
        reset           => reset,
        clk             => clk100,
        inMusicData     => MusicLevel,
        outMusic        => outMusic
    );    
    
    -- map ports
    BertErnie44Audio0: BertErnie44Audio Port Map(
        clka        => clk100,
        addra       => COEAddress,
        douta       => COEData
    );

end Behavioral;
