--------------------------------------------------------------------------------
--                      FPMult_8_23_8_23_8_23_comb_uid2
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Bogdan Pasca, Florent de Dinechin 2008-2011
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPMult_8_23_8_23_8_23_comb_uid2 is
   port ( X : in  std_logic_vector(8+23+2 downto 0);
          Y : in  std_logic_vector(8+23+2 downto 0);
          RM : in std_logic_vector(2 downto 0);
          R : out  std_logic_vector(8+23+2 downto 0);
          INEXACT : out  std_logic  );
end entity;

architecture arch of FPMult_8_23_8_23_8_23_comb_uid2 is
   component IntMultiplier_UsingDSP_24_24_48_unsigned_comb_uid4 is
      port ( X : in  std_logic_vector(23 downto 0);
             Y : in  std_logic_vector(23 downto 0);
             R : out  std_logic_vector(47 downto 0)   );
   end component;

   component IntAdder_33_f400_uid25 is
      port ( X : in  std_logic_vector(32 downto 0);
             Y : in  std_logic_vector(32 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(32 downto 0)   );
   end component;
   
   component Rounding_Mode_SP is
     port (
           EXP_FRAC : in std_logic_vector(32 downto 0);
           Rounding_Mode : in std_logic_vector(2 downto 0);
           Guard_Bits : in std_logic_vector(2 downto 0);
           Sign : in  std_logic;
           OUT_EXP_FRAC : out  std_logic_vector(32 downto 0);
           INEXACT : out  std_logic
           );
   end component;
signal Guard_Bits :  std_logic_vector(2 downto 0);   

signal sign :  std_logic;
signal expX :  std_logic_vector(7 downto 0);
signal expY :  std_logic_vector(7 downto 0);
signal expSumPreSub :  std_logic_vector(9 downto 0);
signal bias :  std_logic_vector(9 downto 0);
signal expSum :  std_logic_vector(9 downto 0);
signal sigX :  std_logic_vector(23 downto 0);
signal sigY :  std_logic_vector(23 downto 0);
signal sigProd :  std_logic_vector(47 downto 0);
signal excSel :  std_logic_vector(3 downto 0);
signal exc :  std_logic_vector(1 downto 0);
signal norm :  std_logic;
signal expPostNorm :  std_logic_vector(9 downto 0);
signal sigProdExt :  std_logic_vector(47 downto 0);
signal expSig :  std_logic_vector(32 downto 0);
signal sticky :  std_logic;
signal guard :  std_logic;
signal round :  std_logic;
signal expSigPostRound :  std_logic_vector(32 downto 0);
signal excPostNorm :  std_logic_vector(1 downto 0);
signal finalExc :  std_logic_vector(1 downto 0);
begin
   sign <= X(31) xor Y(31);
   expX <= X(30 downto 23);
   expY <= Y(30 downto 23);
   expSumPreSub <= ("00" & expX) + ("00" & expY);
   bias <= CONV_STD_LOGIC_VECTOR(127,10);
   expSum <= expSumPreSub - bias;
   sigX <= "1" & X(22 downto 0);
   sigY <= "1" & Y(22 downto 0);
--   sigX <= (X(22 downto 0) & "0") when (expX = "00000000") else ("1" & X(22 downto 0));
--   sigY <= (Y(22 downto 0) & "0") when (expY = "00000000") else ("1" & Y(22 downto 0));
   SignificandMultiplication: IntMultiplier_UsingDSP_24_24_48_unsigned_comb_uid4
      port map ( R => sigProd,
                 X => sigX,
                 Y => sigY);
   excSel <= X(33 downto 32) & Y(33 downto 32);
   with excSel select 
   exc <= "00" when  "0000" | "0001" | "0100", 
          "01" when "0101",
          "10" when "0110" | "1001" | "1010" ,
          "11" when others;
   norm <= sigProd(47);
   -- exponent update
   expPostNorm <= expSum + ("000000000" & norm);
   -- significand normalization shift
   sigProdExt <= sigProd(46 downto 0) & "0" when norm='1' else
                         sigProd(45 downto 0) & "00";
   expSig <= expPostNorm & sigProdExt(47 downto 25);
   
   sticky<= '0' when sigProdExt(22 downto 0)="000000000000000000000000" else '1';
   round<= sigProdExt(23);
   guard<= sigProdExt(24);

   Guard_Bits <= (guard & round & sticky);
   rounding : Rounding_Mode_SP
   port map (  EXP_FRAC => expSig,
               Rounding_Mode => RM,
               Guard_Bits => Guard_Bits,
               Sign => sign,
               OUT_EXP_FRAC => expSigPostRound,
               INEXACT => INEXACT
               );
   --sticky <= sigProdExt(24);
   --guard <= '0' when sigProdExt(23 downto 0)="000000000000000000000000" else '1';
   --round <= sticky and ( (guard and not(sigProdExt(25))) or (sigProdExt(25) ))  ;
   --  RoundingAdder: IntAdder_33_f400_uid25
   --   port map ( Cin => round,
   --              R => expSigPostRound,
   --              X => expSig,
   --              Y => "000000000000000000000000000000000");
   with expSigPostRound(32 downto 31) select
   excPostNorm <=  "01"  when  "00",
                               "10"             when "01", 
                               "00"             when "11"|"10",
                               "11"             when others;
   with exc select 
   finalExc <= exc when  "11"|"10"|"00",
                       excPostNorm when others; 
   R <= finalExc & sign & expSigPostRound(30 downto 0);
end architecture;

