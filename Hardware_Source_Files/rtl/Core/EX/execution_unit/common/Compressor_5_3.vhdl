--------------------------------------------------------------------------------
--                               Compressor_5_3
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

entity Compressor_5_3 is
   port ( X0 : in  std_logic_vector(4 downto 0);
          R : out  std_logic_vector(2 downto 0)   );
end entity;

architecture arch of Compressor_5_3 is
signal X :  std_logic_vector(4 downto 0);
begin
   X <=X0 ;
   with X select R <=
      "000" when "00000",
      "001" when "00001",
      "001" when "00010",
      "010" when "00011",
      "001" when "00100",
      "010" when "00101",
      "010" when "00110",
      "011" when "00111",
      "001" when "01000",
      "010" when "01001",
      "010" when "01010",
      "011" when "01011",
      "010" when "01100",
      "011" when "01101",
      "011" when "01110",
      "100" when "01111",
      "001" when "10000",
      "010" when "10001",
      "010" when "10010",
      "011" when "10011",
      "010" when "10100",
      "011" when "10101",
      "011" when "10110",
      "100" when "10111",
      "010" when "11000",
      "011" when "11001",
      "011" when "11010",
      "100" when "11011",
      "011" when "11100",
      "100" when "11101",
      "100" when "11110",
      "101" when "11111",
      "---" when others;

end architecture;

