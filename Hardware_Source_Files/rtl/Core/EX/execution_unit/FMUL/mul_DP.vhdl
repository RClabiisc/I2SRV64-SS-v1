--------------------------------------------------------------------------------
--                     FPMult_11_52_11_52_11_52_comb_uid2
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

entity FPMult_11_52_11_52_11_52_comb_uid2 is
   port ( X : in  std_logic_vector(11+52+2 downto 0);
          Y : in  std_logic_vector(11+52+2 downto 0);
          RM : in std_logic_vector(2 downto 0);
          R : out  std_logic_vector(11+52+2 downto 0);
          INEXACT : out  std_logic   );
end entity;

architecture arch of FPMult_11_52_11_52_11_52_comb_uid2 is
   component IntMultiplier_UsingDSP_53_53_106_unsigned_comb_uid4 is
      port ( X : in  std_logic_vector(52 downto 0);
             Y : in  std_logic_vector(52 downto 0);
             R : out  std_logic_vector(105 downto 0)   );
   end component;

   component IntAdder_65_f400_uid559 is
      port ( X : in  std_logic_vector(64 downto 0);
             Y : in  std_logic_vector(64 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(64 downto 0)   );
   end component;

   component Rounding_Mode_DP is
    port (
          EXP_FRAC : in std_logic_vector(64 downto 0);
          Rounding_Mode : in std_logic_vector(2 downto 0);
          Guard_Bits : in std_logic_vector(2 downto 0);
          Sign : in  std_logic;
          OUT_EXP_FRAC : out  std_logic_vector(64 downto 0);
          INEXACT : out  std_logic
          );
  end component;
signal Guard_Bits :  std_logic_vector(2 downto 0);
signal sign :  std_logic;
signal expX :  std_logic_vector(10 downto 0);
signal expY :  std_logic_vector(10 downto 0);
signal expSumPreSub :  std_logic_vector(12 downto 0);
signal bias :  std_logic_vector(12 downto 0);
signal expSum :  std_logic_vector(12 downto 0);
signal sigX :  std_logic_vector(52 downto 0);
signal sigY :  std_logic_vector(52 downto 0);
signal sigProd :  std_logic_vector(105 downto 0);
signal excSel :  std_logic_vector(3 downto 0);
signal exc :  std_logic_vector(1 downto 0);
signal norm :  std_logic;
signal expPostNorm :  std_logic_vector(12 downto 0);
signal sigProdExt :  std_logic_vector(105 downto 0);
signal expSig :  std_logic_vector(64 downto 0);
signal sticky :  std_logic;
signal guard :  std_logic;
signal round :  std_logic;
signal expSigPostRound :  std_logic_vector(64 downto 0);
signal excPostNorm :  std_logic_vector(1 downto 0);
signal finalExc :  std_logic_vector(1 downto 0);
begin
   sign <= X(63) xor Y(63);
   expX <= X(62 downto 52);
   expY <= Y(62 downto 52);
   expSumPreSub <= ("00" & expX) + ("00" & expY);
   bias <= CONV_STD_LOGIC_VECTOR(1023,13);
   expSum <= expSumPreSub - bias;
   sigX <= "1" & X(51 downto 0);
   sigY <= "1" & Y(51 downto 0);
   SignificandMultiplication: IntMultiplier_UsingDSP_53_53_106_unsigned_comb_uid4
      port map ( R => sigProd,
                 X => sigX,
                 Y => sigY);
   excSel <= X(65 downto 64) & Y(65 downto 64);
   with excSel select
   exc <= "00" when  "0000" | "0001" | "0100",
          "01" when "0101",
          "10" when "0110" | "1001" | "1010" ,
          "11" when others;
   norm <= sigProd(105);
   -- exponent update
   expPostNorm <= expSum + ("000000000000" & norm);
   -- significand normalization shift
   sigProdExt <= sigProd(104 downto 0) & "0" when norm='1' else
                         sigProd(103 downto 0) & "00";
   expSig <= expPostNorm & sigProdExt(105 downto 54);

    sticky<= '0' when sigProdExt(51 downto 0)="00000000000000000000000000000000000000000000000000000" else '1';
    round<= sigProdExt(52);
    guard<= sigProdExt(53);

    Guard_Bits <= (guard & round & sticky);
    rounding : Rounding_Mode_DP
    port map (  EXP_FRAC => expSig,
              Rounding_Mode => RM,
              Guard_Bits => Guard_Bits,
              Sign => sign,
              OUT_EXP_FRAC => expSigPostRound,
              INEXACT => INEXACT
              );
   --sticky <= sigProdExt(53);
   --guard <= '0' when sigProdExt(52 downto 0)="00000000000000000000000000000000000000000000000000000" else '1';
   --round <= sticky and ( (guard and not(sigProdExt(54))) or (sigProdExt(54) ))  ;
     -- RoundingAdder: IntAdder_65_f400_uid559
     -- port map ( Cin => round,
       --          R => expSigPostRound,
         --        X => expSig,
           --      Y => "00000000000000000000000000000000000000000000000000000000000000000");
   with expSigPostRound(64 downto 63) select
   excPostNorm <=  "01"  when  "00",
                               "10"             when "01",
                               "00"             when "11"|"10",
                               "11"             when others;
   with exc select
   finalExc <= exc when  "11"|"10"|"00",
                       excPostNorm when others;
   R <= finalExc & sign & expSigPostRound(62 downto 0);
end architecture;

