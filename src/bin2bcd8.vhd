library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity bin2bcd8 is port(
	A: in std_logic_vector(7 downto 0); -- binary input (unsigned 8-bit)
	X: out std_logic_vector(3 downto 0); -- bcd output
	R: out std_logic_vector(7 downto 0)); -- remainder after operation
end bin2bcd8;

architecture Behavioral of bin2bcd8 is
begin
	X <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) mod 10, 4));
	R <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) / 10, 8));
end Behavioral;
