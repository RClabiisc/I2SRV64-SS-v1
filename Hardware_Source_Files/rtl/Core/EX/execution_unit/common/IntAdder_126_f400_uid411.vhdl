--------------------------------------------------------------------------------
--                          IntAdder_126_f400_uid411
--                   (IntAdderAlternative_126_comb_uid415)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_126_f400_uid411 is
   port ( X : in  std_logic_vector(125 downto 0);
          Y : in  std_logic_vector(125 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(125 downto 0)   );
end entity;

architecture arch of IntAdder_126_f400_uid411 is
begin
   --Alternative
    R <= X + Y + Cin;
end architecture;

