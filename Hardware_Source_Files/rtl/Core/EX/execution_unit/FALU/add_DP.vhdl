--------------------------------------------------------------------------------
--                           FPAdd_11_52_comb_uid2
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Pasca, Florent de Dinechin (2010)
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPAdd_11_52_comb_uid2 is
   port ( X : in  std_logic_vector(11+52+2 downto 0);
          Y : in  std_logic_vector(11+52+2 downto 0);
          RM : in std_logic_vector(2 downto 0);
          R : out  std_logic_vector(11+52+2 downto 0);
          INEXACT : out  std_logic   );
end entity;

architecture arch of FPAdd_11_52_comb_uid2 is
   component IntAdder_66_f400_uid4 is
      port ( X : in  std_logic_vector(65 downto 0);
             Y : in  std_logic_vector(65 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(65 downto 0)   );
   end component;

   component RightShifter_53_by_max_55_comb_uid12 is
      port ( X : in  std_logic_vector(52 downto 0);
             S : in  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(107 downto 0)   );
   end component;

   component IntAdder_56_f400_uid16 is
      port ( X : in  std_logic_vector(55 downto 0);
             Y : in  std_logic_vector(55 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(55 downto 0)   );
   end component;

   component LZCShifter_57_to_57_counting_64_comb_uid24 is
      port ( I : in  std_logic_vector(56 downto 0);
             Count : out  std_logic_vector(5 downto 0);
             O : out  std_logic_vector(56 downto 0)   );
   end component;

   component IntAdder_66_f400_uid28 is
      port ( X : in  std_logic_vector(65 downto 0);
             Y : in  std_logic_vector(65 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(65 downto 0)   );
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

signal excExpFracX :  std_logic_vector(64 downto 0);
signal excExpFracY :  std_logic_vector(64 downto 0);
signal eXmeY :  std_logic_vector(11 downto 0);
signal eYmeX :  std_logic_vector(11 downto 0);
signal addCmpOp1 :  std_logic_vector(65 downto 0);
signal addCmpOp2 :  std_logic_vector(65 downto 0);
signal cmpRes :  std_logic_vector(65 downto 0);
signal swap :  std_logic;
signal newX :  std_logic_vector(65 downto 0);
signal newY :  std_logic_vector(65 downto 0);
signal expX :  std_logic_vector(10 downto 0);
signal excX :  std_logic_vector(1 downto 0);
signal excY :  std_logic_vector(1 downto 0);
signal signX :  std_logic;
signal signY :  std_logic;
signal EffSub :  std_logic;
signal sXsYExnXY :  std_logic_vector(5 downto 0);
signal sdExnXY :  std_logic_vector(3 downto 0);
signal fracY :  std_logic_vector(52 downto 0);
signal excRt :  std_logic_vector(1 downto 0);
signal signR :  std_logic;
signal expDiff :  std_logic_vector(11 downto 0);
signal shiftedOut :  std_logic;
signal shiftVal :  std_logic_vector(5 downto 0);
signal shiftedFracY :  std_logic_vector(107 downto 0);
signal sticky :  std_logic;
signal fracYfar :  std_logic_vector(55 downto 0);
signal EffSubVector :  std_logic_vector(55 downto 0);
signal fracYfarXorOp :  std_logic_vector(55 downto 0);
signal fracXfar :  std_logic_vector(55 downto 0);
signal cInAddFar :  std_logic;
signal fracAddResult :  std_logic_vector(55 downto 0);
signal fracGRS :  std_logic_vector(56 downto 0);
signal extendedExpInc :  std_logic_vector(12 downto 0);
signal nZerosNew :  std_logic_vector(5 downto 0);
signal shiftedFrac :  std_logic_vector(56 downto 0);
signal updatedExp :  std_logic_vector(12 downto 0);
signal eqdiffsign :  std_logic;
signal expFrac :  std_logic_vector(65 downto 0);
signal stk :  std_logic;
signal rnd :  std_logic;
signal grd :  std_logic;
signal lsb :  std_logic;
signal addToRoundBit :  std_logic;
signal RoundedExpFrac :  std_logic_vector(65 downto 0);
signal upExc :  std_logic_vector(1 downto 0);
signal fracR :  std_logic_vector(51 downto 0);
signal expR :  std_logic_vector(10 downto 0);
signal exExpExc :  std_logic_vector(3 downto 0);
signal excRt2 :  std_logic_vector(1 downto 0);
signal excR :  std_logic_vector(1 downto 0);
signal signR2 :  std_logic;
signal computedR :  std_logic_vector(65 downto 0);
signal Guard_Bits :  std_logic_vector(2 downto 0);
begin
-- Exponent difference and swap  --
   excExpFracX <= X(65 downto 64) & X(62 downto 0);
   excExpFracY <= Y(65 downto 64) & Y(62 downto 0);
   eXmeY <= ("0" & X(62 downto 52)) - ("0" & Y(62 downto 52));
   eYmeX <= ("0" & Y(62 downto 52)) - ("0" & X(62 downto 52));
   addCmpOp1<= "0" & excExpFracX;
   addCmpOp2<= "1" & not(excExpFracY);
   cmpAdder: IntAdder_66_f400_uid4
      port map ( Cin => '1',
                 R => cmpRes,
                 X => addCmpOp1,
                 Y => addCmpOp2);
   swap <= cmpRes(65);
   newX <= X when swap = '0' else Y;
   newY <= Y when swap = '0' else X;
   expX<= newX(62 downto 52);
   excX<= newX(65 downto 64);
   excY<= newY(65 downto 64);
   signX<= newX(63);
   signY<= newY(63);
   EffSub <= signX xor signY;
   sXsYExnXY <= signX & signY & excX & excY;
   sdExnXY <= excX & excY;
   fracY <= "00000000000000000000000000000000000000000000000000000" when excY="00" else ('1' & newY(51 downto 0));
   with sXsYExnXY select
   excRt <= "00" when "000000"|"010000"|"100000"|"110000",
      "01" when "000101"|"010101"|"100101"|"110101"|"000100"|"010100"|"100100"|"110100"|"000001"|"010001"|"100001"|"110001",
      "10" when "111010"|"001010"|"001000"|"011000"|"101000"|"111000"|"000010"|"010010"|"100010"|"110010"|"001001"|"011001"|"101001"|"111001"|"000110"|"010110"|"100110"|"110110",
      "11" when others;
   signR<= '0' when (sXsYExnXY="100000" or sXsYExnXY="010000") else signX;
   expDiff <= eXmeY when swap = '0' else eYmeX;
   shiftedOut <= '1' when (expDiff >= 54) else '0';
   shiftVal <= expDiff(5 downto 0) when shiftedOut='0' else CONV_STD_LOGIC_VECTOR(55,6) ;
   RightShifterComponent: RightShifter_53_by_max_55_comb_uid12
      port map ( R => shiftedFracY,
                 S => shiftVal,
                 X => fracY);
   sticky <= '0' when (shiftedFracY(52 downto 0)=CONV_STD_LOGIC_VECTOR(0,53)) else '1';
   fracYfar <= "0" & shiftedFracY(107 downto 53);
   EffSubVector <= (55 downto 0 => EffSub);
   fracYfarXorOp <= fracYfar xor EffSubVector;
   fracXfar <= "01" & (newX(51 downto 0)) & "00";
   cInAddFar <= EffSub and not sticky;
   fracAdder: IntAdder_56_f400_uid16
      port map ( Cin => cInAddFar,
                 R => fracAddResult,
                 X => fracXfar,
                 Y => fracYfarXorOp);
   fracGRS<= fracAddResult & sticky;
   extendedExpInc<= ("00" & expX) + '1';
   LZC_component: LZCShifter_57_to_57_counting_64_comb_uid24
      port map ( Count => nZerosNew,
                 I => fracGRS,
                 O => shiftedFrac);
   updatedExp <= extendedExpInc - ("0000000" & nZerosNew);
   eqdiffsign <= '1' when nZerosNew="111111" else '0';
   expFrac<= updatedExp & shiftedFrac(55 downto 3);
   stk<= shiftedFrac(1) or shiftedFrac(0);
   rnd<= shiftedFrac(2);
   grd<= shiftedFrac(3);
   lsb<= shiftedFrac(4);
   Guard_Bits <= (grd & rnd & stk);
   rounding : Rounding_Mode_DP
   port map (  EXP_FRAC => expFrac(65 downto 1),
               Rounding_Mode => RM,
               Guard_Bits => Guard_Bits,
               Sign => signR2,
               OUT_EXP_FRAC => RoundedExpFrac(65 downto 1),
               INEXACT => INEXACT
               );
   --addToRoundBit<= '0' when (lsb='0' and grd='1' and rnd='0' and stk='0')  else '1';
   --roundingAdder: IntAdder_66_f400_uid28
      --port map ( Cin => addToRoundBit,
        --         R => RoundedExpFrac,
          --       X => expFrac,
            --     Y => "000000000000000000000000000000000000000000000000000000000000000000");
   upExc <= RoundedExpFrac(65 downto 64);
   fracR <= RoundedExpFrac(52 downto 1);
   expR <= RoundedExpFrac(63 downto 53);
   exExpExc <= upExc & excRt;
   with (exExpExc) select
   excRt2<= "00" when "0000"|"0100"|"1000"|"1100"|"1001"|"1101",
      "01" when "0001",
      "10" when "0010"|"0110"|"1010"|"1110"|"0101",
      "11" when others;
   excR <= "11" when (EffSub='1' and excX="10" and excY="10") else
           "00" when (eqdiffsign='1' and EffSub='1') else excRt2;
   signR2 <= '0' when (eqdiffsign='1' and EffSub='1') else signR;
   computedR <= excR & signR2 & expR & fracR;
   R <= computedR;
end architecture;

