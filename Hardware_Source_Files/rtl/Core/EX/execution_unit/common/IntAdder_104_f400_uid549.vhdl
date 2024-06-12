--------------------------------------------------------------------------------
--                          IntAdder_104_f400_uid549
--                   (IntAdderAlternative_104_comb_uid553)
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

entity IntAdder_104_f400_uid549 is
   port ( X : in  std_logic_vector(103 downto 0);
          Y : in  std_logic_vector(103 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(103 downto 0)   );
end entity;

architecture arch of IntAdder_104_f400_uid549 is
begin
   --Alternative
    R <= X + Y + Cin;
end architecture;

