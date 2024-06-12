--------------------------------------------------------------------------------
--                              Compressor_13_3
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Popa, Illyes Kinga, 2012
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Compressor_13_3 is
   port ( X0 : in  std_logic_vector(2 downto 0);
          X1 : in  std_logic_vector(0 downto 0);
          R : out  std_logic_vector(2 downto 0)   );
end entity;

architecture arch of Compressor_13_3 is
signal X :  std_logic_vector(3 downto 0);
begin
   X <=X1 & X0 ;
   with X select R <=
      "000" when "0000",
      "001" when "0001",
      "001" when "0010",
      "010" when "0011",
      "001" when "0100",
      "010" when "0101",
      "010" when "0110",
      "011" when "0111",
      "010" when "1000",
      "011" when "1001",
      "011" when "1010",
      "100" when "1011",
      "011" when "1100",
      "100" when "1101",
      "100" when "1110",
      "101" when "1111",
      "---" when others;

end architecture;

