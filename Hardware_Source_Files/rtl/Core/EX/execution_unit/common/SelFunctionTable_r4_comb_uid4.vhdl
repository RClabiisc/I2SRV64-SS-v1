--------------------------------------------------------------------------------
--                       SelFunctionTable_r4_comb_uid4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Maxime Christ, Florent de Dinechin (2015)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library work;
entity SelFunctionTable_r4_comb_uid4 is
   port ( X : in  std_logic_vector(4 downto 0);
          Y : out  std_logic_vector(2 downto 0)   );
end entity;

architecture arch of SelFunctionTable_r4_comb_uid4 is
signal TableOut :  std_logic_vector(2 downto 0);
begin
  with X select TableOut <=
   "000" when "00000",
   "000" when "00001",
   "001" when "00010",
   "001" when "00011",
   "010" when "00100",
   "001" when "00101",
   "011" when "00110",
   "010" when "00111",
   "011" when "01000",
   "011" when "01001",
   "011" when "01010",
   "011" when "01011",
   "011" when "01100",
   "011" when "01101",
   "011" when "01110",
   "011" when "01111",
   "101" when "10000",
   "101" when "10001",
   "101" when "10010",
   "101" when "10011",
   "101" when "10100",
   "101" when "10101",
   "101" when "10110",
   "101" when "10111",
   "101" when "11000",
   "110" when "11001",
   "110" when "11010",
   "110" when "11011",
   "111" when "11100",
   "111" when "11101",
   "111" when "11110",
   "111" when "11111",
   "---" when others;
    Y <= TableOut;
end architecture;

