--------------------------------------------------------------------------------
--             IntMultiplier_UsingDSP_24_24_48_unsigned_comb_uid4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Florent de Dinechin, Kinga Illyes, Bogdan Popa, Bogdan Pasca, 2012
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity IntMultiplier_UsingDSP_24_24_48_unsigned_comb_uid4 is
   port ( X : in  std_logic_vector(23 downto 0);
          Y : in  std_logic_vector(23 downto 0);
          R : out  std_logic_vector(47 downto 0)   );
end entity;

architecture arch of IntMultiplier_UsingDSP_24_24_48_unsigned_comb_uid4 is
   component IntAdder_42_f400_uid15 is
      port ( X : in  std_logic_vector(41 downto 0);
             Y : in  std_logic_vector(41 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(41 downto 0)   );
   end component;

signal XX_m5 :  std_logic_vector(23 downto 0);
signal YY_m5 :  std_logic_vector(23 downto 0);
signal DSP_bh6_ch0_0 :  std_logic_vector(40 downto 0);
signal heap_bh6_w47_0 :  std_logic;
signal heap_bh6_w46_0 :  std_logic;
signal heap_bh6_w45_0 :  std_logic;
signal heap_bh6_w44_0 :  std_logic;
signal heap_bh6_w43_0 :  std_logic;
signal heap_bh6_w42_0 :  std_logic;
signal heap_bh6_w41_0 :  std_logic;
signal heap_bh6_w40_0 :  std_logic;
signal heap_bh6_w39_0 :  std_logic;
signal heap_bh6_w38_0 :  std_logic;
signal heap_bh6_w37_0 :  std_logic;
signal heap_bh6_w36_0 :  std_logic;
signal heap_bh6_w35_0 :  std_logic;
signal heap_bh6_w34_0 :  std_logic;
signal heap_bh6_w33_0 :  std_logic;
signal heap_bh6_w32_0 :  std_logic;
signal heap_bh6_w31_0 :  std_logic;
signal heap_bh6_w30_0 :  std_logic;
signal heap_bh6_w29_0 :  std_logic;
signal heap_bh6_w28_0 :  std_logic;
signal heap_bh6_w27_0 :  std_logic;
signal heap_bh6_w26_0 :  std_logic;
signal heap_bh6_w25_0 :  std_logic;
signal heap_bh6_w24_0 :  std_logic;
signal heap_bh6_w23_0 :  std_logic;
signal heap_bh6_w22_0 :  std_logic;
signal heap_bh6_w21_0 :  std_logic;
signal heap_bh6_w20_0 :  std_logic;
signal heap_bh6_w19_0 :  std_logic;
signal heap_bh6_w18_0 :  std_logic;
signal heap_bh6_w17_0 :  std_logic;
signal heap_bh6_w16_0 :  std_logic;
signal heap_bh6_w15_0 :  std_logic;
signal heap_bh6_w14_0 :  std_logic;
signal heap_bh6_w13_0 :  std_logic;
signal heap_bh6_w12_0 :  std_logic;
signal heap_bh6_w11_0 :  std_logic;
signal heap_bh6_w10_0 :  std_logic;
signal heap_bh6_w9_0 :  std_logic;
signal heap_bh6_w8_0 :  std_logic;
signal heap_bh6_w7_0 :  std_logic;
signal DSP_bh6_ch1_0 :  std_logic_vector(40 downto 0);
signal heap_bh6_w30_1 :  std_logic;
signal heap_bh6_w29_1 :  std_logic;
signal heap_bh6_w28_1 :  std_logic;
signal heap_bh6_w27_1 :  std_logic;
signal heap_bh6_w26_1 :  std_logic;
signal heap_bh6_w25_1 :  std_logic;
signal heap_bh6_w24_1 :  std_logic;
signal heap_bh6_w23_1 :  std_logic;
signal heap_bh6_w22_1 :  std_logic;
signal heap_bh6_w21_1 :  std_logic;
signal heap_bh6_w20_1 :  std_logic;
signal heap_bh6_w19_1 :  std_logic;
signal heap_bh6_w18_1 :  std_logic;
signal heap_bh6_w17_1 :  std_logic;
signal heap_bh6_w16_1 :  std_logic;
signal heap_bh6_w15_1 :  std_logic;
signal heap_bh6_w14_1 :  std_logic;
signal heap_bh6_w13_1 :  std_logic;
signal heap_bh6_w12_1 :  std_logic;
signal heap_bh6_w11_1 :  std_logic;
signal heap_bh6_w10_1 :  std_logic;
signal heap_bh6_w9_1 :  std_logic;
signal heap_bh6_w8_1 :  std_logic;
signal heap_bh6_w7_1 :  std_logic;
signal heap_bh6_w6_0 :  std_logic;
signal heap_bh6_w5_0 :  std_logic;
signal heap_bh6_w4_0 :  std_logic;
signal heap_bh6_w3_0 :  std_logic;
signal heap_bh6_w2_0 :  std_logic;
signal heap_bh6_w1_0 :  std_logic;
signal heap_bh6_w0_0 :  std_logic;
signal finalAdderIn0_bh6 :  std_logic_vector(41 downto 0);
signal finalAdderIn1_bh6 :  std_logic_vector(41 downto 0);
signal finalAdderCin_bh6 :  std_logic;
signal finalAdderOut_bh6 :  std_logic_vector(41 downto 0);
signal tempR_bh6_0 :  std_logic_vector(6 downto 0);
signal CompressionResult6 :  std_logic_vector(48 downto 0);
begin
   XX_m5 <= X ;
   YY_m5 <= Y ;

   -- Beginning of code generated by BitHeap::generateCompressorVHDL
   -- code generated by BitHeap::generateSupertileVHDL()
   DSP_bh6_ch0_0 <= std_logic_vector(unsigned("" & XX_m5(23 downto 0) & "") * unsigned("" & YY_m5(23 downto 7) & ""));
   heap_bh6_w47_0 <= DSP_bh6_ch0_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w46_0 <= DSP_bh6_ch0_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w45_0 <= DSP_bh6_ch0_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w44_0 <= DSP_bh6_ch0_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w43_0 <= DSP_bh6_ch0_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w42_0 <= DSP_bh6_ch0_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w41_0 <= DSP_bh6_ch0_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w40_0 <= DSP_bh6_ch0_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w39_0 <= DSP_bh6_ch0_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w38_0 <= DSP_bh6_ch0_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w37_0 <= DSP_bh6_ch0_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w36_0 <= DSP_bh6_ch0_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w35_0 <= DSP_bh6_ch0_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w34_0 <= DSP_bh6_ch0_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w33_0 <= DSP_bh6_ch0_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w32_0 <= DSP_bh6_ch0_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w31_0 <= DSP_bh6_ch0_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w30_0 <= DSP_bh6_ch0_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w29_0 <= DSP_bh6_ch0_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w28_0 <= DSP_bh6_ch0_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w27_0 <= DSP_bh6_ch0_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w26_0 <= DSP_bh6_ch0_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w25_0 <= DSP_bh6_ch0_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w24_0 <= DSP_bh6_ch0_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w23_0 <= DSP_bh6_ch0_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w22_0 <= DSP_bh6_ch0_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w21_0 <= DSP_bh6_ch0_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w20_0 <= DSP_bh6_ch0_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w19_0 <= DSP_bh6_ch0_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w18_0 <= DSP_bh6_ch0_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w17_0 <= DSP_bh6_ch0_0(10); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w16_0 <= DSP_bh6_ch0_0(9); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w15_0 <= DSP_bh6_ch0_0(8); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w14_0 <= DSP_bh6_ch0_0(7); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w13_0 <= DSP_bh6_ch0_0(6); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w12_0 <= DSP_bh6_ch0_0(5); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w11_0 <= DSP_bh6_ch0_0(4); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w10_0 <= DSP_bh6_ch0_0(3); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w9_0 <= DSP_bh6_ch0_0(2); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w8_0 <= DSP_bh6_ch0_0(1); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w7_0 <= DSP_bh6_ch0_0(0); -- cycle= 0 cp= 2.387e-09
   DSP_bh6_ch1_0 <= std_logic_vector(unsigned("" & XX_m5(23 downto 0) & "") * unsigned("" & YY_m5(6 downto 0) & "0000000000"));
   heap_bh6_w30_1 <= DSP_bh6_ch1_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w29_1 <= DSP_bh6_ch1_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w28_1 <= DSP_bh6_ch1_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w27_1 <= DSP_bh6_ch1_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w26_1 <= DSP_bh6_ch1_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w25_1 <= DSP_bh6_ch1_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w24_1 <= DSP_bh6_ch1_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w23_1 <= DSP_bh6_ch1_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w22_1 <= DSP_bh6_ch1_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w21_1 <= DSP_bh6_ch1_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w20_1 <= DSP_bh6_ch1_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w19_1 <= DSP_bh6_ch1_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w18_1 <= DSP_bh6_ch1_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w17_1 <= DSP_bh6_ch1_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w16_1 <= DSP_bh6_ch1_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w15_1 <= DSP_bh6_ch1_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w14_1 <= DSP_bh6_ch1_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w13_1 <= DSP_bh6_ch1_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w12_1 <= DSP_bh6_ch1_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w11_1 <= DSP_bh6_ch1_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w10_1 <= DSP_bh6_ch1_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w9_1 <= DSP_bh6_ch1_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w8_1 <= DSP_bh6_ch1_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w7_1 <= DSP_bh6_ch1_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w6_0 <= DSP_bh6_ch1_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w5_0 <= DSP_bh6_ch1_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w4_0 <= DSP_bh6_ch1_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w3_0 <= DSP_bh6_ch1_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w2_0 <= DSP_bh6_ch1_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w1_0 <= DSP_bh6_ch1_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w0_0 <= DSP_bh6_ch1_0(10); -- cycle= 0 cp= 2.387e-09

   -- Adding the constant bits
      -- All the constant bits are zero, nothing to add

   finalAdderIn0_bh6 <= "0" & heap_bh6_w47_0 & heap_bh6_w46_0 & heap_bh6_w45_0 & heap_bh6_w44_0 & heap_bh6_w43_0 & heap_bh6_w42_0 & heap_bh6_w41_0 & heap_bh6_w40_0 & heap_bh6_w39_0 & heap_bh6_w38_0 & heap_bh6_w37_0 & heap_bh6_w36_0 & heap_bh6_w35_0 & heap_bh6_w34_0 & heap_bh6_w33_0 & heap_bh6_w32_0 & heap_bh6_w31_0 & heap_bh6_w30_1 & heap_bh6_w29_1 & heap_bh6_w28_1 & heap_bh6_w27_1 & heap_bh6_w26_1 & heap_bh6_w25_1 & heap_bh6_w24_1 & heap_bh6_w23_1 & heap_bh6_w22_1 & heap_bh6_w21_1 & heap_bh6_w20_1 & heap_bh6_w19_1 & heap_bh6_w18_1 & heap_bh6_w17_1 & heap_bh6_w16_1 & heap_bh6_w15_1 & heap_bh6_w14_1 & heap_bh6_w13_1 & heap_bh6_w12_1 & heap_bh6_w11_1 & heap_bh6_w10_1 & heap_bh6_w9_1 & heap_bh6_w8_1 & heap_bh6_w7_1;
   finalAdderIn1_bh6 <= "0" & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & heap_bh6_w30_0 & heap_bh6_w29_0 & heap_bh6_w28_0 & heap_bh6_w27_0 & heap_bh6_w26_0 & heap_bh6_w25_0 & heap_bh6_w24_0 & heap_bh6_w23_0 & heap_bh6_w22_0 & heap_bh6_w21_0 & heap_bh6_w20_0 & heap_bh6_w19_0 & heap_bh6_w18_0 & heap_bh6_w17_0 & heap_bh6_w16_0 & heap_bh6_w15_0 & heap_bh6_w14_0 & heap_bh6_w13_0 & heap_bh6_w12_0 & heap_bh6_w11_0 & heap_bh6_w10_0 & heap_bh6_w9_0 & heap_bh6_w8_0 & heap_bh6_w7_0;
   finalAdderCin_bh6 <= '0';
      Adder_final6_0: IntAdder_42_f400_uid15
      port map ( Cin => finalAdderCin_bh6,
                 R => finalAdderOut_bh6,
                 X => finalAdderIn0_bh6,
                 Y => finalAdderIn1_bh6);
   tempR_bh6_0 <= heap_bh6_w6_0 & heap_bh6_w5_0 & heap_bh6_w4_0 & heap_bh6_w3_0 & heap_bh6_w2_0 & heap_bh6_w1_0 & heap_bh6_w0_0; -- already compressed
   -- concatenate all the compressed chunks
   CompressionResult6 <= finalAdderOut_bh6 & tempR_bh6_0;
   -- End of code generated by BitHeap::generateCompressorVHDL
   R <= CompressionResult6(47 downto 0);
end architecture;

