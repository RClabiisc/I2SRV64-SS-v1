--------------------------------------------------------------------------------
--             IntMultiplier_UsingDSP_65_65_130_signed_comb_uid2
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

entity IntMultiplier_UsingDSP_65_65_130_signed_comb_uid2 is
   port ( X : in  std_logic_vector(64 downto 0);
          Y : in  std_logic_vector(64 downto 0);
          R : out  std_logic_vector(129 downto 0)   );
end entity;

architecture arch of IntMultiplier_UsingDSP_65_65_130_signed_comb_uid2 is
   component IntAdder_126_f400_uid411 is
      port ( X : in  std_logic_vector(125 downto 0);
             Y : in  std_logic_vector(125 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(125 downto 0)   );
   end component;

   component Compressor_6_3 is
      port ( X0 : in  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

   component Compressor_14_3 is
      port ( X0 : in  std_logic_vector(3 downto 0);
             X1 : in  std_logic_vector(0 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

   component Compressor_4_3 is
      port ( X0 : in  std_logic_vector(3 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

   component Compressor_23_3 is
      port ( X0 : in  std_logic_vector(2 downto 0);
             X1 : in  std_logic_vector(1 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

   component Compressor_13_3 is
      port ( X0 : in  std_logic_vector(2 downto 0);
             X1 : in  std_logic_vector(0 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

   component Compressor_3_2 is
      port ( X0 : in  std_logic_vector(2 downto 0);
             R : out  std_logic_vector(1 downto 0)   );
   end component;

signal XX_m3 :  std_logic_vector(64 downto 0);
signal YY_m3 :  std_logic_vector(64 downto 0);
signal DSP_bh4_ch0_0 :  std_logic_vector(42 downto 0);
signal heap_bh4_w129_0 :  std_logic;
signal heap_bh4_w128_0 :  std_logic;
signal heap_bh4_w127_0 :  std_logic;
signal heap_bh4_w126_0 :  std_logic;
signal heap_bh4_w125_0 :  std_logic;
signal heap_bh4_w124_0 :  std_logic;
signal heap_bh4_w123_0 :  std_logic;
signal heap_bh4_w122_0 :  std_logic;
signal heap_bh4_w121_0 :  std_logic;
signal heap_bh4_w120_0 :  std_logic;
signal heap_bh4_w119_0 :  std_logic;
signal heap_bh4_w118_0 :  std_logic;
signal heap_bh4_w117_0 :  std_logic;
signal heap_bh4_w116_0 :  std_logic;
signal heap_bh4_w115_0 :  std_logic;
signal heap_bh4_w114_0 :  std_logic;
signal heap_bh4_w113_0 :  std_logic;
signal heap_bh4_w112_0 :  std_logic;
signal heap_bh4_w111_0 :  std_logic;
signal heap_bh4_w110_0 :  std_logic;
signal heap_bh4_w109_0 :  std_logic;
signal heap_bh4_w108_0 :  std_logic;
signal heap_bh4_w107_0 :  std_logic;
signal heap_bh4_w106_0 :  std_logic;
signal heap_bh4_w105_0 :  std_logic;
signal heap_bh4_w104_0 :  std_logic;
signal heap_bh4_w103_0 :  std_logic;
signal heap_bh4_w102_0 :  std_logic;
signal heap_bh4_w101_0 :  std_logic;
signal heap_bh4_w100_0 :  std_logic;
signal heap_bh4_w99_0 :  std_logic;
signal heap_bh4_w98_0 :  std_logic;
signal heap_bh4_w97_0 :  std_logic;
signal heap_bh4_w96_0 :  std_logic;
signal heap_bh4_w95_0 :  std_logic;
signal heap_bh4_w94_0 :  std_logic;
signal heap_bh4_w93_0 :  std_logic;
signal heap_bh4_w92_0 :  std_logic;
signal heap_bh4_w91_0 :  std_logic;
signal heap_bh4_w90_0 :  std_logic;
signal heap_bh4_w89_0 :  std_logic;
signal heap_bh4_w88_0 :  std_logic;
signal heap_bh4_w87_0 :  std_logic;
signal DSP_bh4_ch1_0 :  std_logic_vector(42 downto 0);
signal heap_bh4_w105_1 :  std_logic;
signal heap_bh4_w104_1 :  std_logic;
signal heap_bh4_w103_1 :  std_logic;
signal heap_bh4_w102_1 :  std_logic;
signal heap_bh4_w101_1 :  std_logic;
signal heap_bh4_w100_1 :  std_logic;
signal heap_bh4_w99_1 :  std_logic;
signal heap_bh4_w98_1 :  std_logic;
signal heap_bh4_w97_1 :  std_logic;
signal heap_bh4_w96_1 :  std_logic;
signal heap_bh4_w95_1 :  std_logic;
signal heap_bh4_w94_1 :  std_logic;
signal heap_bh4_w93_1 :  std_logic;
signal heap_bh4_w92_1 :  std_logic;
signal heap_bh4_w91_1 :  std_logic;
signal heap_bh4_w90_1 :  std_logic;
signal heap_bh4_w89_1 :  std_logic;
signal heap_bh4_w88_1 :  std_logic;
signal heap_bh4_w87_1 :  std_logic;
signal heap_bh4_w86_0 :  std_logic;
signal heap_bh4_w85_0 :  std_logic;
signal heap_bh4_w84_0 :  std_logic;
signal heap_bh4_w83_0 :  std_logic;
signal heap_bh4_w82_0 :  std_logic;
signal heap_bh4_w81_0 :  std_logic;
signal heap_bh4_w80_0 :  std_logic;
signal heap_bh4_w79_0 :  std_logic;
signal heap_bh4_w78_0 :  std_logic;
signal heap_bh4_w77_0 :  std_logic;
signal heap_bh4_w76_0 :  std_logic;
signal heap_bh4_w75_0 :  std_logic;
signal heap_bh4_w74_0 :  std_logic;
signal heap_bh4_w73_0 :  std_logic;
signal heap_bh4_w72_0 :  std_logic;
signal heap_bh4_w71_0 :  std_logic;
signal heap_bh4_w70_0 :  std_logic;
signal heap_bh4_w69_0 :  std_logic;
signal heap_bh4_w68_0 :  std_logic;
signal heap_bh4_w67_0 :  std_logic;
signal heap_bh4_w66_0 :  std_logic;
signal heap_bh4_w65_0 :  std_logic;
signal heap_bh4_w64_0 :  std_logic;
signal heap_bh4_w63_0 :  std_logic;
signal DSP_bh4_ch2_0 :  std_logic_vector(42 downto 0);
signal heap_bh4_w81_1 :  std_logic;
signal heap_bh4_w80_1 :  std_logic;
signal heap_bh4_w79_1 :  std_logic;
signal heap_bh4_w78_1 :  std_logic;
signal heap_bh4_w77_1 :  std_logic;
signal heap_bh4_w76_1 :  std_logic;
signal heap_bh4_w75_1 :  std_logic;
signal heap_bh4_w74_1 :  std_logic;
signal heap_bh4_w73_1 :  std_logic;
signal heap_bh4_w72_1 :  std_logic;
signal heap_bh4_w71_1 :  std_logic;
signal heap_bh4_w70_1 :  std_logic;
signal heap_bh4_w69_1 :  std_logic;
signal heap_bh4_w68_1 :  std_logic;
signal heap_bh4_w67_1 :  std_logic;
signal heap_bh4_w66_1 :  std_logic;
signal heap_bh4_w65_1 :  std_logic;
signal heap_bh4_w64_1 :  std_logic;
signal heap_bh4_w63_1 :  std_logic;
signal heap_bh4_w62_0 :  std_logic;
signal heap_bh4_w61_0 :  std_logic;
signal heap_bh4_w60_0 :  std_logic;
signal heap_bh4_w59_0 :  std_logic;
signal heap_bh4_w58_0 :  std_logic;
signal heap_bh4_w57_0 :  std_logic;
signal heap_bh4_w56_0 :  std_logic;
signal heap_bh4_w55_0 :  std_logic;
signal heap_bh4_w54_0 :  std_logic;
signal heap_bh4_w53_0 :  std_logic;
signal heap_bh4_w52_0 :  std_logic;
signal heap_bh4_w51_0 :  std_logic;
signal heap_bh4_w50_0 :  std_logic;
signal heap_bh4_w49_0 :  std_logic;
signal heap_bh4_w48_0 :  std_logic;
signal heap_bh4_w47_0 :  std_logic;
signal heap_bh4_w46_0 :  std_logic;
signal heap_bh4_w45_0 :  std_logic;
signal heap_bh4_w44_0 :  std_logic;
signal heap_bh4_w43_0 :  std_logic;
signal heap_bh4_w42_0 :  std_logic;
signal heap_bh4_w41_0 :  std_logic;
signal heap_bh4_w40_0 :  std_logic;
signal heap_bh4_w39_0 :  std_logic;
signal DSP_bh4_ch3_0 :  std_logic_vector(42 downto 0);
signal heap_bh4_w112_1 :  std_logic;
signal heap_bh4_w111_1 :  std_logic;
signal heap_bh4_w110_1 :  std_logic;
signal heap_bh4_w109_1 :  std_logic;
signal heap_bh4_w108_1 :  std_logic;
signal heap_bh4_w107_1 :  std_logic;
signal heap_bh4_w106_1 :  std_logic;
signal heap_bh4_w105_2 :  std_logic;
signal heap_bh4_w104_2 :  std_logic;
signal heap_bh4_w103_2 :  std_logic;
signal heap_bh4_w102_2 :  std_logic;
signal heap_bh4_w101_2 :  std_logic;
signal heap_bh4_w100_2 :  std_logic;
signal heap_bh4_w99_2 :  std_logic;
signal heap_bh4_w98_2 :  std_logic;
signal heap_bh4_w97_2 :  std_logic;
signal heap_bh4_w96_2 :  std_logic;
signal heap_bh4_w95_2 :  std_logic;
signal heap_bh4_w94_2 :  std_logic;
signal heap_bh4_w93_2 :  std_logic;
signal heap_bh4_w92_2 :  std_logic;
signal heap_bh4_w91_2 :  std_logic;
signal heap_bh4_w90_2 :  std_logic;
signal heap_bh4_w89_2 :  std_logic;
signal heap_bh4_w88_2 :  std_logic;
signal heap_bh4_w87_2 :  std_logic;
signal heap_bh4_w86_1 :  std_logic;
signal heap_bh4_w85_1 :  std_logic;
signal heap_bh4_w84_1 :  std_logic;
signal heap_bh4_w83_1 :  std_logic;
signal heap_bh4_w82_1 :  std_logic;
signal heap_bh4_w81_2 :  std_logic;
signal heap_bh4_w80_2 :  std_logic;
signal heap_bh4_w79_2 :  std_logic;
signal heap_bh4_w78_2 :  std_logic;
signal heap_bh4_w77_2 :  std_logic;
signal heap_bh4_w76_2 :  std_logic;
signal heap_bh4_w75_2 :  std_logic;
signal heap_bh4_w74_2 :  std_logic;
signal heap_bh4_w73_2 :  std_logic;
signal heap_bh4_w72_2 :  std_logic;
signal heap_bh4_w71_2 :  std_logic;
signal heap_bh4_w70_2 :  std_logic;
signal DSP_bh4_ch4_0 :  std_logic_vector(42 downto 0);
signal heap_bh4_w88_3 :  std_logic;
signal heap_bh4_w87_3 :  std_logic;
signal heap_bh4_w86_2 :  std_logic;
signal heap_bh4_w85_2 :  std_logic;
signal heap_bh4_w84_2 :  std_logic;
signal heap_bh4_w83_2 :  std_logic;
signal heap_bh4_w82_2 :  std_logic;
signal heap_bh4_w81_3 :  std_logic;
signal heap_bh4_w80_3 :  std_logic;
signal heap_bh4_w79_3 :  std_logic;
signal heap_bh4_w78_3 :  std_logic;
signal heap_bh4_w77_3 :  std_logic;
signal heap_bh4_w76_3 :  std_logic;
signal heap_bh4_w75_3 :  std_logic;
signal heap_bh4_w74_3 :  std_logic;
signal heap_bh4_w73_3 :  std_logic;
signal heap_bh4_w72_3 :  std_logic;
signal heap_bh4_w71_3 :  std_logic;
signal heap_bh4_w70_3 :  std_logic;
signal heap_bh4_w69_2 :  std_logic;
signal heap_bh4_w68_2 :  std_logic;
signal heap_bh4_w67_2 :  std_logic;
signal heap_bh4_w66_2 :  std_logic;
signal heap_bh4_w65_2 :  std_logic;
signal heap_bh4_w64_2 :  std_logic;
signal heap_bh4_w63_2 :  std_logic;
signal heap_bh4_w62_1 :  std_logic;
signal heap_bh4_w61_1 :  std_logic;
signal heap_bh4_w60_1 :  std_logic;
signal heap_bh4_w59_1 :  std_logic;
signal heap_bh4_w58_1 :  std_logic;
signal heap_bh4_w57_1 :  std_logic;
signal heap_bh4_w56_1 :  std_logic;
signal heap_bh4_w55_1 :  std_logic;
signal heap_bh4_w54_1 :  std_logic;
signal heap_bh4_w53_1 :  std_logic;
signal heap_bh4_w52_1 :  std_logic;
signal heap_bh4_w51_1 :  std_logic;
signal heap_bh4_w50_1 :  std_logic;
signal heap_bh4_w49_1 :  std_logic;
signal heap_bh4_w48_1 :  std_logic;
signal heap_bh4_w47_1 :  std_logic;
signal heap_bh4_w46_1 :  std_logic;
signal DSP_bh4_ch5_0 :  std_logic_vector(42 downto 0);
signal heap_bh4_w64_3 :  std_logic;
signal heap_bh4_w63_3 :  std_logic;
signal heap_bh4_w62_2 :  std_logic;
signal heap_bh4_w61_2 :  std_logic;
signal heap_bh4_w60_2 :  std_logic;
signal heap_bh4_w59_2 :  std_logic;
signal heap_bh4_w58_2 :  std_logic;
signal heap_bh4_w57_2 :  std_logic;
signal heap_bh4_w56_2 :  std_logic;
signal heap_bh4_w55_2 :  std_logic;
signal heap_bh4_w54_2 :  std_logic;
signal heap_bh4_w53_2 :  std_logic;
signal heap_bh4_w52_2 :  std_logic;
signal heap_bh4_w51_2 :  std_logic;
signal heap_bh4_w50_2 :  std_logic;
signal heap_bh4_w49_2 :  std_logic;
signal heap_bh4_w48_2 :  std_logic;
signal heap_bh4_w47_2 :  std_logic;
signal heap_bh4_w46_2 :  std_logic;
signal heap_bh4_w45_1 :  std_logic;
signal heap_bh4_w44_1 :  std_logic;
signal heap_bh4_w43_1 :  std_logic;
signal heap_bh4_w42_1 :  std_logic;
signal heap_bh4_w41_1 :  std_logic;
signal heap_bh4_w40_1 :  std_logic;
signal heap_bh4_w39_1 :  std_logic;
signal heap_bh4_w38_0 :  std_logic;
signal heap_bh4_w37_0 :  std_logic;
signal heap_bh4_w36_0 :  std_logic;
signal heap_bh4_w35_0 :  std_logic;
signal heap_bh4_w34_0 :  std_logic;
signal heap_bh4_w33_0 :  std_logic;
signal heap_bh4_w32_0 :  std_logic;
signal heap_bh4_w31_0 :  std_logic;
signal heap_bh4_w30_0 :  std_logic;
signal heap_bh4_w29_0 :  std_logic;
signal heap_bh4_w28_0 :  std_logic;
signal heap_bh4_w27_0 :  std_logic;
signal heap_bh4_w26_0 :  std_logic;
signal heap_bh4_w25_0 :  std_logic;
signal heap_bh4_w24_0 :  std_logic;
signal heap_bh4_w23_0 :  std_logic;
signal heap_bh4_w22_0 :  std_logic;
signal DSP_bh4_ch6_0 :  std_logic_vector(42 downto 0);
signal heap_bh4_w95_3 :  std_logic;
signal heap_bh4_w94_3 :  std_logic;
signal heap_bh4_w93_3 :  std_logic;
signal heap_bh4_w92_3 :  std_logic;
signal heap_bh4_w91_3 :  std_logic;
signal heap_bh4_w90_3 :  std_logic;
signal heap_bh4_w89_3 :  std_logic;
signal heap_bh4_w88_4 :  std_logic;
signal heap_bh4_w87_4 :  std_logic;
signal heap_bh4_w86_3 :  std_logic;
signal heap_bh4_w85_3 :  std_logic;
signal heap_bh4_w84_3 :  std_logic;
signal heap_bh4_w83_3 :  std_logic;
signal heap_bh4_w82_3 :  std_logic;
signal heap_bh4_w81_4 :  std_logic;
signal heap_bh4_w80_4 :  std_logic;
signal heap_bh4_w79_4 :  std_logic;
signal heap_bh4_w78_4 :  std_logic;
signal heap_bh4_w77_4 :  std_logic;
signal heap_bh4_w76_4 :  std_logic;
signal heap_bh4_w75_4 :  std_logic;
signal heap_bh4_w74_4 :  std_logic;
signal heap_bh4_w73_4 :  std_logic;
signal heap_bh4_w72_4 :  std_logic;
signal heap_bh4_w71_4 :  std_logic;
signal heap_bh4_w70_4 :  std_logic;
signal heap_bh4_w69_3 :  std_logic;
signal heap_bh4_w68_3 :  std_logic;
signal heap_bh4_w67_3 :  std_logic;
signal heap_bh4_w66_3 :  std_logic;
signal heap_bh4_w65_3 :  std_logic;
signal heap_bh4_w64_4 :  std_logic;
signal heap_bh4_w63_4 :  std_logic;
signal heap_bh4_w62_3 :  std_logic;
signal heap_bh4_w61_3 :  std_logic;
signal heap_bh4_w60_3 :  std_logic;
signal heap_bh4_w59_3 :  std_logic;
signal heap_bh4_w58_3 :  std_logic;
signal heap_bh4_w57_3 :  std_logic;
signal heap_bh4_w56_3 :  std_logic;
signal heap_bh4_w55_3 :  std_logic;
signal heap_bh4_w54_3 :  std_logic;
signal heap_bh4_w53_3 :  std_logic;
signal DSP_bh4_ch7_0 :  std_logic_vector(42 downto 0);
signal heap_bh4_w71_5 :  std_logic;
signal heap_bh4_w70_5 :  std_logic;
signal heap_bh4_w69_4 :  std_logic;
signal heap_bh4_w68_4 :  std_logic;
signal heap_bh4_w67_4 :  std_logic;
signal heap_bh4_w66_4 :  std_logic;
signal heap_bh4_w65_4 :  std_logic;
signal heap_bh4_w64_5 :  std_logic;
signal heap_bh4_w63_5 :  std_logic;
signal heap_bh4_w62_4 :  std_logic;
signal heap_bh4_w61_4 :  std_logic;
signal heap_bh4_w60_4 :  std_logic;
signal heap_bh4_w59_4 :  std_logic;
signal heap_bh4_w58_4 :  std_logic;
signal heap_bh4_w57_4 :  std_logic;
signal heap_bh4_w56_4 :  std_logic;
signal heap_bh4_w55_4 :  std_logic;
signal heap_bh4_w54_4 :  std_logic;
signal heap_bh4_w53_4 :  std_logic;
signal heap_bh4_w52_3 :  std_logic;
signal heap_bh4_w51_3 :  std_logic;
signal heap_bh4_w50_3 :  std_logic;
signal heap_bh4_w49_3 :  std_logic;
signal heap_bh4_w48_3 :  std_logic;
signal heap_bh4_w47_3 :  std_logic;
signal heap_bh4_w46_3 :  std_logic;
signal heap_bh4_w45_2 :  std_logic;
signal heap_bh4_w44_2 :  std_logic;
signal heap_bh4_w43_2 :  std_logic;
signal heap_bh4_w42_2 :  std_logic;
signal heap_bh4_w41_2 :  std_logic;
signal heap_bh4_w40_2 :  std_logic;
signal heap_bh4_w39_2 :  std_logic;
signal heap_bh4_w38_1 :  std_logic;
signal heap_bh4_w37_1 :  std_logic;
signal heap_bh4_w36_1 :  std_logic;
signal heap_bh4_w35_1 :  std_logic;
signal heap_bh4_w34_1 :  std_logic;
signal heap_bh4_w33_1 :  std_logic;
signal heap_bh4_w32_1 :  std_logic;
signal heap_bh4_w31_1 :  std_logic;
signal heap_bh4_w30_1 :  std_logic;
signal heap_bh4_w29_1 :  std_logic;
signal DSP_bh4_ch8_0 :  std_logic_vector(42 downto 0);
signal heap_bh4_w47_4 :  std_logic;
signal heap_bh4_w46_4 :  std_logic;
signal heap_bh4_w45_3 :  std_logic;
signal heap_bh4_w44_3 :  std_logic;
signal heap_bh4_w43_3 :  std_logic;
signal heap_bh4_w42_3 :  std_logic;
signal heap_bh4_w41_3 :  std_logic;
signal heap_bh4_w40_3 :  std_logic;
signal heap_bh4_w39_3 :  std_logic;
signal heap_bh4_w38_2 :  std_logic;
signal heap_bh4_w37_2 :  std_logic;
signal heap_bh4_w36_2 :  std_logic;
signal heap_bh4_w35_2 :  std_logic;
signal heap_bh4_w34_2 :  std_logic;
signal heap_bh4_w33_2 :  std_logic;
signal heap_bh4_w32_2 :  std_logic;
signal heap_bh4_w31_2 :  std_logic;
signal heap_bh4_w30_2 :  std_logic;
signal heap_bh4_w29_2 :  std_logic;
signal heap_bh4_w28_1 :  std_logic;
signal heap_bh4_w27_1 :  std_logic;
signal heap_bh4_w26_1 :  std_logic;
signal heap_bh4_w25_1 :  std_logic;
signal heap_bh4_w24_1 :  std_logic;
signal heap_bh4_w23_1 :  std_logic;
signal heap_bh4_w22_1 :  std_logic;
signal heap_bh4_w21_0 :  std_logic;
signal heap_bh4_w20_0 :  std_logic;
signal heap_bh4_w19_0 :  std_logic;
signal heap_bh4_w18_0 :  std_logic;
signal heap_bh4_w17_0 :  std_logic;
signal heap_bh4_w16_0 :  std_logic;
signal heap_bh4_w15_0 :  std_logic;
signal heap_bh4_w14_0 :  std_logic;
signal heap_bh4_w13_0 :  std_logic;
signal heap_bh4_w12_0 :  std_logic;
signal heap_bh4_w11_0 :  std_logic;
signal heap_bh4_w10_0 :  std_logic;
signal heap_bh4_w9_0 :  std_logic;
signal heap_bh4_w8_0 :  std_logic;
signal heap_bh4_w7_0 :  std_logic;
signal heap_bh4_w6_0 :  std_logic;
signal heap_bh4_w5_0 :  std_logic;
signal DSP_bh4_ch9_0 :  std_logic_vector(42 downto 0);
signal heap_bh4_w78_5 :  std_logic;
signal heap_bh4_w77_5 :  std_logic;
signal heap_bh4_w76_5 :  std_logic;
signal heap_bh4_w75_5 :  std_logic;
signal heap_bh4_w74_5 :  std_logic;
signal heap_bh4_w73_5 :  std_logic;
signal heap_bh4_w72_5 :  std_logic;
signal heap_bh4_w71_6 :  std_logic;
signal heap_bh4_w70_6 :  std_logic;
signal heap_bh4_w69_5 :  std_logic;
signal heap_bh4_w68_5 :  std_logic;
signal heap_bh4_w67_5 :  std_logic;
signal heap_bh4_w66_5 :  std_logic;
signal heap_bh4_w65_5 :  std_logic;
signal heap_bh4_w64_6 :  std_logic;
signal heap_bh4_w63_6 :  std_logic;
signal heap_bh4_w62_5 :  std_logic;
signal heap_bh4_w61_5 :  std_logic;
signal heap_bh4_w60_5 :  std_logic;
signal heap_bh4_w59_5 :  std_logic;
signal heap_bh4_w58_5 :  std_logic;
signal heap_bh4_w57_5 :  std_logic;
signal heap_bh4_w56_5 :  std_logic;
signal heap_bh4_w55_5 :  std_logic;
signal heap_bh4_w54_5 :  std_logic;
signal heap_bh4_w53_5 :  std_logic;
signal heap_bh4_w52_4 :  std_logic;
signal heap_bh4_w51_4 :  std_logic;
signal heap_bh4_w50_4 :  std_logic;
signal heap_bh4_w49_4 :  std_logic;
signal heap_bh4_w48_4 :  std_logic;
signal heap_bh4_w47_5 :  std_logic;
signal heap_bh4_w46_5 :  std_logic;
signal heap_bh4_w45_4 :  std_logic;
signal heap_bh4_w44_4 :  std_logic;
signal heap_bh4_w43_4 :  std_logic;
signal heap_bh4_w42_4 :  std_logic;
signal heap_bh4_w41_4 :  std_logic;
signal heap_bh4_w40_4 :  std_logic;
signal heap_bh4_w39_4 :  std_logic;
signal heap_bh4_w38_3 :  std_logic;
signal heap_bh4_w37_3 :  std_logic;
signal heap_bh4_w36_3 :  std_logic;
signal DSP_bh4_ch10_0 :  std_logic_vector(42 downto 0);
signal heap_bh4_w54_6 :  std_logic;
signal heap_bh4_w53_6 :  std_logic;
signal heap_bh4_w52_5 :  std_logic;
signal heap_bh4_w51_5 :  std_logic;
signal heap_bh4_w50_5 :  std_logic;
signal heap_bh4_w49_5 :  std_logic;
signal heap_bh4_w48_5 :  std_logic;
signal heap_bh4_w47_6 :  std_logic;
signal heap_bh4_w46_6 :  std_logic;
signal heap_bh4_w45_5 :  std_logic;
signal heap_bh4_w44_5 :  std_logic;
signal heap_bh4_w43_5 :  std_logic;
signal heap_bh4_w42_5 :  std_logic;
signal heap_bh4_w41_5 :  std_logic;
signal heap_bh4_w40_5 :  std_logic;
signal heap_bh4_w39_5 :  std_logic;
signal heap_bh4_w38_4 :  std_logic;
signal heap_bh4_w37_4 :  std_logic;
signal heap_bh4_w36_4 :  std_logic;
signal heap_bh4_w35_3 :  std_logic;
signal heap_bh4_w34_3 :  std_logic;
signal heap_bh4_w33_3 :  std_logic;
signal heap_bh4_w32_3 :  std_logic;
signal heap_bh4_w31_3 :  std_logic;
signal heap_bh4_w30_3 :  std_logic;
signal heap_bh4_w29_3 :  std_logic;
signal heap_bh4_w28_2 :  std_logic;
signal heap_bh4_w27_2 :  std_logic;
signal heap_bh4_w26_2 :  std_logic;
signal heap_bh4_w25_2 :  std_logic;
signal heap_bh4_w24_2 :  std_logic;
signal heap_bh4_w23_2 :  std_logic;
signal heap_bh4_w22_2 :  std_logic;
signal heap_bh4_w21_1 :  std_logic;
signal heap_bh4_w20_1 :  std_logic;
signal heap_bh4_w19_1 :  std_logic;
signal heap_bh4_w18_1 :  std_logic;
signal heap_bh4_w17_1 :  std_logic;
signal heap_bh4_w16_1 :  std_logic;
signal heap_bh4_w15_1 :  std_logic;
signal heap_bh4_w14_1 :  std_logic;
signal heap_bh4_w13_1 :  std_logic;
signal heap_bh4_w12_1 :  std_logic;
signal DSP_bh4_ch11_0 :  std_logic_vector(42 downto 0);
signal heap_bh4_w30_4 :  std_logic;
signal heap_bh4_w29_4 :  std_logic;
signal heap_bh4_w28_3 :  std_logic;
signal heap_bh4_w27_3 :  std_logic;
signal heap_bh4_w26_3 :  std_logic;
signal heap_bh4_w25_3 :  std_logic;
signal heap_bh4_w24_3 :  std_logic;
signal heap_bh4_w23_3 :  std_logic;
signal heap_bh4_w22_3 :  std_logic;
signal heap_bh4_w21_2 :  std_logic;
signal heap_bh4_w20_2 :  std_logic;
signal heap_bh4_w19_2 :  std_logic;
signal heap_bh4_w18_2 :  std_logic;
signal heap_bh4_w17_2 :  std_logic;
signal heap_bh4_w16_2 :  std_logic;
signal heap_bh4_w15_2 :  std_logic;
signal heap_bh4_w14_2 :  std_logic;
signal heap_bh4_w13_2 :  std_logic;
signal heap_bh4_w12_2 :  std_logic;
signal heap_bh4_w11_1 :  std_logic;
signal heap_bh4_w10_1 :  std_logic;
signal heap_bh4_w9_1 :  std_logic;
signal heap_bh4_w8_1 :  std_logic;
signal heap_bh4_w7_1 :  std_logic;
signal heap_bh4_w6_1 :  std_logic;
signal heap_bh4_w5_1 :  std_logic;
signal heap_bh4_w4_0 :  std_logic;
signal heap_bh4_w3_0 :  std_logic;
signal heap_bh4_w2_0 :  std_logic;
signal heap_bh4_w1_0 :  std_logic;
signal heap_bh4_w0_0 :  std_logic;
signal heap_bh4_w30_5 :  std_logic;
signal heap_bh4_w31_4 :  std_logic;
signal heap_bh4_w32_4 :  std_logic;
signal heap_bh4_w33_4 :  std_logic;
signal heap_bh4_w34_4 :  std_logic;
signal heap_bh4_w35_4 :  std_logic;
signal heap_bh4_w36_5 :  std_logic;
signal heap_bh4_w37_5 :  std_logic;
signal heap_bh4_w38_5 :  std_logic;
signal heap_bh4_w39_6 :  std_logic;
signal heap_bh4_w40_6 :  std_logic;
signal heap_bh4_w41_6 :  std_logic;
signal heap_bh4_w42_6 :  std_logic;
signal heap_bh4_w43_6 :  std_logic;
signal heap_bh4_w44_6 :  std_logic;
signal heap_bh4_w45_6 :  std_logic;
signal heap_bh4_w46_7 :  std_logic;
signal heap_bh4_w48_6 :  std_logic;
signal heap_bh4_w49_6 :  std_logic;
signal heap_bh4_w50_6 :  std_logic;
signal heap_bh4_w51_6 :  std_logic;
signal heap_bh4_w52_6 :  std_logic;
signal heap_bh4_w53_7 :  std_logic;
signal heap_bh4_w55_6 :  std_logic;
signal heap_bh4_w56_6 :  std_logic;
signal heap_bh4_w57_6 :  std_logic;
signal heap_bh4_w58_6 :  std_logic;
signal heap_bh4_w59_6 :  std_logic;
signal heap_bh4_w60_6 :  std_logic;
signal heap_bh4_w61_6 :  std_logic;
signal heap_bh4_w62_6 :  std_logic;
signal heap_bh4_w63_7 :  std_logic;
signal heap_bh4_w65_6 :  std_logic;
signal heap_bh4_w66_6 :  std_logic;
signal heap_bh4_w67_6 :  std_logic;
signal heap_bh4_w68_6 :  std_logic;
signal heap_bh4_w69_6 :  std_logic;
signal heap_bh4_w70_7 :  std_logic;
signal heap_bh4_w72_6 :  std_logic;
signal heap_bh4_w73_6 :  std_logic;
signal heap_bh4_w74_6 :  std_logic;
signal heap_bh4_w75_6 :  std_logic;
signal heap_bh4_w76_6 :  std_logic;
signal heap_bh4_w77_6 :  std_logic;
signal heap_bh4_w79_5 :  std_logic;
signal heap_bh4_w80_5 :  std_logic;
signal heap_bh4_w82_4 :  std_logic;
signal heap_bh4_w83_4 :  std_logic;
signal heap_bh4_w84_4 :  std_logic;
signal heap_bh4_w85_4 :  std_logic;
signal heap_bh4_w86_4 :  std_logic;
signal heap_bh4_w87_5 :  std_logic;
signal heap_bh4_w89_4 :  std_logic;
signal heap_bh4_w90_4 :  std_logic;
signal heap_bh4_w91_4 :  std_logic;
signal heap_bh4_w92_4 :  std_logic;
signal heap_bh4_w93_4 :  std_logic;
signal heap_bh4_w94_4 :  std_logic;
signal heap_bh4_w96_3 :  std_logic;
signal heap_bh4_w97_3 :  std_logic;
signal heap_bh4_w98_3 :  std_logic;
signal heap_bh4_w99_3 :  std_logic;
signal heap_bh4_w100_3 :  std_logic;
signal heap_bh4_w101_3 :  std_logic;
signal heap_bh4_w102_3 :  std_logic;
signal heap_bh4_w103_3 :  std_logic;
signal heap_bh4_w104_3 :  std_logic;
signal heap_bh4_w106_2 :  std_logic;
signal heap_bh4_w107_2 :  std_logic;
signal heap_bh4_w108_2 :  std_logic;
signal heap_bh4_w109_2 :  std_logic;
signal heap_bh4_w110_2 :  std_logic;
signal heap_bh4_w111_2 :  std_logic;
signal heap_bh4_w113_1 :  std_logic;
signal heap_bh4_w114_1 :  std_logic;
signal heap_bh4_w115_1 :  std_logic;
signal heap_bh4_w116_1 :  std_logic;
signal heap_bh4_w117_1 :  std_logic;
signal heap_bh4_w118_1 :  std_logic;
signal heap_bh4_w119_1 :  std_logic;
signal heap_bh4_w120_1 :  std_logic;
signal heap_bh4_w121_1 :  std_logic;
signal heap_bh4_w122_1 :  std_logic;
signal heap_bh4_w123_1 :  std_logic;
signal heap_bh4_w124_1 :  std_logic;
signal heap_bh4_w125_1 :  std_logic;
signal heap_bh4_w126_1 :  std_logic;
signal heap_bh4_w127_1 :  std_logic;
signal heap_bh4_w128_1 :  std_logic;
signal tempR_bh4_0 :  std_logic_vector(4 downto 0);
signal CompressorIn_bh4_0_0 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_0_0 :  std_logic_vector(2 downto 0);
signal heap_bh4_w30_6 :  std_logic;
signal heap_bh4_w31_5 :  std_logic;
signal heap_bh4_w32_5 :  std_logic;
signal CompressorIn_bh4_1_1 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_1_1 :  std_logic_vector(2 downto 0);
signal heap_bh4_w36_6 :  std_logic;
signal heap_bh4_w37_6 :  std_logic;
signal heap_bh4_w38_6 :  std_logic;
signal CompressorIn_bh4_2_2 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_2_2 :  std_logic_vector(2 downto 0);
signal heap_bh4_w37_7 :  std_logic;
signal heap_bh4_w38_7 :  std_logic;
signal heap_bh4_w39_7 :  std_logic;
signal CompressorIn_bh4_3_3 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_3_3 :  std_logic_vector(2 downto 0);
signal heap_bh4_w38_8 :  std_logic;
signal heap_bh4_w39_8 :  std_logic;
signal heap_bh4_w40_7 :  std_logic;
signal CompressorIn_bh4_4_4 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_4_4 :  std_logic_vector(2 downto 0);
signal heap_bh4_w39_9 :  std_logic;
signal heap_bh4_w40_8 :  std_logic;
signal heap_bh4_w41_7 :  std_logic;
signal CompressorIn_bh4_5_5 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_5_5 :  std_logic_vector(2 downto 0);
signal heap_bh4_w40_9 :  std_logic;
signal heap_bh4_w41_8 :  std_logic;
signal heap_bh4_w42_7 :  std_logic;
signal CompressorIn_bh4_6_6 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_6_6 :  std_logic_vector(2 downto 0);
signal heap_bh4_w41_9 :  std_logic;
signal heap_bh4_w42_8 :  std_logic;
signal heap_bh4_w43_7 :  std_logic;
signal CompressorIn_bh4_7_7 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_7_7 :  std_logic_vector(2 downto 0);
signal heap_bh4_w42_9 :  std_logic;
signal heap_bh4_w43_8 :  std_logic;
signal heap_bh4_w44_7 :  std_logic;
signal CompressorIn_bh4_8_8 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_8_8 :  std_logic_vector(2 downto 0);
signal heap_bh4_w43_9 :  std_logic;
signal heap_bh4_w44_8 :  std_logic;
signal heap_bh4_w45_7 :  std_logic;
signal CompressorIn_bh4_9_9 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_9_9 :  std_logic_vector(2 downto 0);
signal heap_bh4_w44_9 :  std_logic;
signal heap_bh4_w45_8 :  std_logic;
signal heap_bh4_w46_8 :  std_logic;
signal CompressorIn_bh4_10_10 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_10_10 :  std_logic_vector(2 downto 0);
signal heap_bh4_w45_9 :  std_logic;
signal heap_bh4_w46_9 :  std_logic;
signal heap_bh4_w47_7 :  std_logic;
signal CompressorIn_bh4_11_11 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_11_11 :  std_logic_vector(2 downto 0);
signal heap_bh4_w46_10 :  std_logic;
signal heap_bh4_w47_8 :  std_logic;
signal heap_bh4_w48_7 :  std_logic;
signal CompressorIn_bh4_12_12 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_12_12 :  std_logic_vector(2 downto 0);
signal heap_bh4_w47_9 :  std_logic;
signal heap_bh4_w48_8 :  std_logic;
signal heap_bh4_w49_7 :  std_logic;
signal CompressorIn_bh4_13_13 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_13_13 :  std_logic_vector(2 downto 0);
signal heap_bh4_w48_9 :  std_logic;
signal heap_bh4_w49_8 :  std_logic;
signal heap_bh4_w50_7 :  std_logic;
signal CompressorIn_bh4_14_14 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_14_14 :  std_logic_vector(2 downto 0);
signal heap_bh4_w49_9 :  std_logic;
signal heap_bh4_w50_8 :  std_logic;
signal heap_bh4_w51_7 :  std_logic;
signal CompressorIn_bh4_15_15 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_15_15 :  std_logic_vector(2 downto 0);
signal heap_bh4_w50_9 :  std_logic;
signal heap_bh4_w51_8 :  std_logic;
signal heap_bh4_w52_7 :  std_logic;
signal CompressorIn_bh4_16_16 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_16_16 :  std_logic_vector(2 downto 0);
signal heap_bh4_w51_9 :  std_logic;
signal heap_bh4_w52_8 :  std_logic;
signal heap_bh4_w53_8 :  std_logic;
signal CompressorIn_bh4_17_17 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_17_17 :  std_logic_vector(2 downto 0);
signal heap_bh4_w52_9 :  std_logic;
signal heap_bh4_w53_9 :  std_logic;
signal heap_bh4_w54_7 :  std_logic;
signal CompressorIn_bh4_18_18 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_18_18 :  std_logic_vector(2 downto 0);
signal heap_bh4_w53_10 :  std_logic;
signal heap_bh4_w54_8 :  std_logic;
signal heap_bh4_w55_7 :  std_logic;
signal CompressorIn_bh4_19_19 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_19_19 :  std_logic_vector(2 downto 0);
signal heap_bh4_w54_9 :  std_logic;
signal heap_bh4_w55_8 :  std_logic;
signal heap_bh4_w56_7 :  std_logic;
signal CompressorIn_bh4_20_20 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_20_20 :  std_logic_vector(2 downto 0);
signal heap_bh4_w55_9 :  std_logic;
signal heap_bh4_w56_8 :  std_logic;
signal heap_bh4_w57_7 :  std_logic;
signal CompressorIn_bh4_21_21 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_21_21 :  std_logic_vector(2 downto 0);
signal heap_bh4_w56_9 :  std_logic;
signal heap_bh4_w57_8 :  std_logic;
signal heap_bh4_w58_7 :  std_logic;
signal CompressorIn_bh4_22_22 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_22_22 :  std_logic_vector(2 downto 0);
signal heap_bh4_w57_9 :  std_logic;
signal heap_bh4_w58_8 :  std_logic;
signal heap_bh4_w59_7 :  std_logic;
signal CompressorIn_bh4_23_23 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_23_23 :  std_logic_vector(2 downto 0);
signal heap_bh4_w58_9 :  std_logic;
signal heap_bh4_w59_8 :  std_logic;
signal heap_bh4_w60_7 :  std_logic;
signal CompressorIn_bh4_24_24 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_24_24 :  std_logic_vector(2 downto 0);
signal heap_bh4_w59_9 :  std_logic;
signal heap_bh4_w60_8 :  std_logic;
signal heap_bh4_w61_7 :  std_logic;
signal CompressorIn_bh4_25_25 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_25_25 :  std_logic_vector(2 downto 0);
signal heap_bh4_w60_9 :  std_logic;
signal heap_bh4_w61_8 :  std_logic;
signal heap_bh4_w62_7 :  std_logic;
signal CompressorIn_bh4_26_26 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_26_26 :  std_logic_vector(2 downto 0);
signal heap_bh4_w61_9 :  std_logic;
signal heap_bh4_w62_8 :  std_logic;
signal heap_bh4_w63_8 :  std_logic;
signal CompressorIn_bh4_27_27 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_27_27 :  std_logic_vector(2 downto 0);
signal heap_bh4_w62_9 :  std_logic;
signal heap_bh4_w63_9 :  std_logic;
signal heap_bh4_w64_7 :  std_logic;
signal CompressorIn_bh4_28_28 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_28_28 :  std_logic_vector(2 downto 0);
signal heap_bh4_w63_10 :  std_logic;
signal heap_bh4_w64_8 :  std_logic;
signal heap_bh4_w65_7 :  std_logic;
signal CompressorIn_bh4_29_29 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_29_29 :  std_logic_vector(2 downto 0);
signal heap_bh4_w64_9 :  std_logic;
signal heap_bh4_w65_8 :  std_logic;
signal heap_bh4_w66_7 :  std_logic;
signal CompressorIn_bh4_30_30 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_30_30 :  std_logic_vector(2 downto 0);
signal heap_bh4_w65_9 :  std_logic;
signal heap_bh4_w66_8 :  std_logic;
signal heap_bh4_w67_7 :  std_logic;
signal CompressorIn_bh4_31_31 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_31_31 :  std_logic_vector(2 downto 0);
signal heap_bh4_w66_9 :  std_logic;
signal heap_bh4_w67_8 :  std_logic;
signal heap_bh4_w68_7 :  std_logic;
signal CompressorIn_bh4_32_32 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_32_32 :  std_logic_vector(2 downto 0);
signal heap_bh4_w67_9 :  std_logic;
signal heap_bh4_w68_8 :  std_logic;
signal heap_bh4_w69_7 :  std_logic;
signal CompressorIn_bh4_33_33 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_33_33 :  std_logic_vector(2 downto 0);
signal heap_bh4_w68_9 :  std_logic;
signal heap_bh4_w69_8 :  std_logic;
signal heap_bh4_w70_8 :  std_logic;
signal CompressorIn_bh4_34_34 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_34_34 :  std_logic_vector(2 downto 0);
signal heap_bh4_w69_9 :  std_logic;
signal heap_bh4_w70_9 :  std_logic;
signal heap_bh4_w71_7 :  std_logic;
signal CompressorIn_bh4_35_35 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_35_35 :  std_logic_vector(2 downto 0);
signal heap_bh4_w70_10 :  std_logic;
signal heap_bh4_w71_8 :  std_logic;
signal heap_bh4_w72_7 :  std_logic;
signal CompressorIn_bh4_36_36 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_36_36 :  std_logic_vector(2 downto 0);
signal heap_bh4_w71_9 :  std_logic;
signal heap_bh4_w72_8 :  std_logic;
signal heap_bh4_w73_7 :  std_logic;
signal CompressorIn_bh4_37_37 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_37_37 :  std_logic_vector(2 downto 0);
signal heap_bh4_w72_9 :  std_logic;
signal heap_bh4_w73_8 :  std_logic;
signal heap_bh4_w74_7 :  std_logic;
signal CompressorIn_bh4_38_38 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_38_38 :  std_logic_vector(2 downto 0);
signal heap_bh4_w73_9 :  std_logic;
signal heap_bh4_w74_8 :  std_logic;
signal heap_bh4_w75_7 :  std_logic;
signal CompressorIn_bh4_39_39 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_39_39 :  std_logic_vector(2 downto 0);
signal heap_bh4_w74_9 :  std_logic;
signal heap_bh4_w75_8 :  std_logic;
signal heap_bh4_w76_7 :  std_logic;
signal CompressorIn_bh4_40_40 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_40_40 :  std_logic_vector(2 downto 0);
signal heap_bh4_w75_9 :  std_logic;
signal heap_bh4_w76_8 :  std_logic;
signal heap_bh4_w77_7 :  std_logic;
signal CompressorIn_bh4_41_41 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_41_41 :  std_logic_vector(2 downto 0);
signal heap_bh4_w76_9 :  std_logic;
signal heap_bh4_w77_8 :  std_logic;
signal heap_bh4_w78_6 :  std_logic;
signal CompressorIn_bh4_42_42 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_42_42 :  std_logic_vector(2 downto 0);
signal heap_bh4_w77_9 :  std_logic;
signal heap_bh4_w78_7 :  std_logic;
signal heap_bh4_w79_6 :  std_logic;
signal CompressorIn_bh4_43_43 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_43_43 :  std_logic_vector(2 downto 0);
signal heap_bh4_w78_8 :  std_logic;
signal heap_bh4_w79_7 :  std_logic;
signal heap_bh4_w80_6 :  std_logic;
signal CompressorIn_bh4_44_44 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_44_44 :  std_logic_vector(2 downto 0);
signal heap_bh4_w79_8 :  std_logic;
signal heap_bh4_w80_7 :  std_logic;
signal heap_bh4_w81_5 :  std_logic;
signal CompressorIn_bh4_45_45 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_45_45 :  std_logic_vector(2 downto 0);
signal heap_bh4_w80_8 :  std_logic;
signal heap_bh4_w81_6 :  std_logic;
signal heap_bh4_w82_5 :  std_logic;
signal CompressorIn_bh4_46_46 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh4_46_46 :  std_logic_vector(2 downto 0);
signal heap_bh4_w87_6 :  std_logic;
signal heap_bh4_w88_5 :  std_logic;
signal heap_bh4_w89_5 :  std_logic;
signal CompressorIn_bh4_47_47 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_47_48 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_47_47 :  std_logic_vector(2 downto 0);
signal heap_bh4_w22_4 :  std_logic;
signal heap_bh4_w23_4 :  std_logic;
signal heap_bh4_w24_4 :  std_logic;
signal CompressorIn_bh4_48_49 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_48_50 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_48_48 :  std_logic_vector(2 downto 0);
signal heap_bh4_w24_5 :  std_logic;
signal heap_bh4_w25_4 :  std_logic;
signal heap_bh4_w26_4 :  std_logic;
signal CompressorIn_bh4_49_51 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_49_52 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_49_49 :  std_logic_vector(2 downto 0);
signal heap_bh4_w26_5 :  std_logic;
signal heap_bh4_w27_4 :  std_logic;
signal heap_bh4_w28_4 :  std_logic;
signal CompressorIn_bh4_50_53 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_50_54 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_50_50 :  std_logic_vector(2 downto 0);
signal heap_bh4_w28_5 :  std_logic;
signal heap_bh4_w29_5 :  std_logic;
signal heap_bh4_w30_7 :  std_logic;
signal CompressorIn_bh4_51_55 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_51_56 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_51_51 :  std_logic_vector(2 downto 0);
signal heap_bh4_w31_6 :  std_logic;
signal heap_bh4_w32_6 :  std_logic;
signal heap_bh4_w33_5 :  std_logic;
signal CompressorIn_bh4_52_57 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_52_58 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_52_52 :  std_logic_vector(2 downto 0);
signal heap_bh4_w32_7 :  std_logic;
signal heap_bh4_w33_6 :  std_logic;
signal heap_bh4_w34_5 :  std_logic;
signal CompressorIn_bh4_53_59 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_53_60 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_53_53 :  std_logic_vector(2 downto 0);
signal heap_bh4_w33_7 :  std_logic;
signal heap_bh4_w34_6 :  std_logic;
signal heap_bh4_w35_5 :  std_logic;
signal CompressorIn_bh4_54_61 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_54_62 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_54_54 :  std_logic_vector(2 downto 0);
signal heap_bh4_w34_7 :  std_logic;
signal heap_bh4_w35_6 :  std_logic;
signal heap_bh4_w36_7 :  std_logic;
signal CompressorIn_bh4_55_63 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_55_64 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_55_55 :  std_logic_vector(2 downto 0);
signal heap_bh4_w81_7 :  std_logic;
signal heap_bh4_w82_6 :  std_logic;
signal heap_bh4_w83_5 :  std_logic;
signal CompressorIn_bh4_56_65 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_56_66 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_56_56 :  std_logic_vector(2 downto 0);
signal heap_bh4_w82_7 :  std_logic;
signal heap_bh4_w83_6 :  std_logic;
signal heap_bh4_w84_5 :  std_logic;
signal CompressorIn_bh4_57_67 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_57_68 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_57_57 :  std_logic_vector(2 downto 0);
signal heap_bh4_w83_7 :  std_logic;
signal heap_bh4_w84_6 :  std_logic;
signal heap_bh4_w85_5 :  std_logic;
signal CompressorIn_bh4_58_69 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_58_70 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_58_58 :  std_logic_vector(2 downto 0);
signal heap_bh4_w84_7 :  std_logic;
signal heap_bh4_w85_6 :  std_logic;
signal heap_bh4_w86_5 :  std_logic;
signal CompressorIn_bh4_59_71 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_59_72 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_59_59 :  std_logic_vector(2 downto 0);
signal heap_bh4_w85_7 :  std_logic;
signal heap_bh4_w86_6 :  std_logic;
signal heap_bh4_w87_7 :  std_logic;
signal CompressorIn_bh4_60_73 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_60_74 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_60_60 :  std_logic_vector(2 downto 0);
signal heap_bh4_w88_6 :  std_logic;
signal heap_bh4_w89_6 :  std_logic;
signal heap_bh4_w90_5 :  std_logic;
signal CompressorIn_bh4_61_75 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_61_76 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_61_61 :  std_logic_vector(2 downto 0);
signal heap_bh4_w89_7 :  std_logic;
signal heap_bh4_w90_6 :  std_logic;
signal heap_bh4_w91_5 :  std_logic;
signal CompressorIn_bh4_62_77 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_62_78 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_62_62 :  std_logic_vector(2 downto 0);
signal heap_bh4_w90_7 :  std_logic;
signal heap_bh4_w91_6 :  std_logic;
signal heap_bh4_w92_5 :  std_logic;
signal CompressorIn_bh4_63_79 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_63_80 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_63_63 :  std_logic_vector(2 downto 0);
signal heap_bh4_w91_7 :  std_logic;
signal heap_bh4_w92_6 :  std_logic;
signal heap_bh4_w93_5 :  std_logic;
signal CompressorIn_bh4_64_81 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_64_82 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_64_64 :  std_logic_vector(2 downto 0);
signal heap_bh4_w92_7 :  std_logic;
signal heap_bh4_w93_6 :  std_logic;
signal heap_bh4_w94_5 :  std_logic;
signal CompressorIn_bh4_65_83 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_65_84 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_65_65 :  std_logic_vector(2 downto 0);
signal heap_bh4_w93_7 :  std_logic;
signal heap_bh4_w94_6 :  std_logic;
signal heap_bh4_w95_4 :  std_logic;
signal CompressorIn_bh4_66_85 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_66_86 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_66_66 :  std_logic_vector(2 downto 0);
signal heap_bh4_w94_7 :  std_logic;
signal heap_bh4_w95_5 :  std_logic;
signal heap_bh4_w96_4 :  std_logic;
signal CompressorIn_bh4_67_87 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_67_88 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_67_67 :  std_logic_vector(2 downto 0);
signal heap_bh4_w96_5 :  std_logic;
signal heap_bh4_w97_4 :  std_logic;
signal heap_bh4_w98_4 :  std_logic;
signal CompressorIn_bh4_68_89 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_68_90 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_68_68 :  std_logic_vector(2 downto 0);
signal heap_bh4_w98_5 :  std_logic;
signal heap_bh4_w99_4 :  std_logic;
signal heap_bh4_w100_4 :  std_logic;
signal CompressorIn_bh4_69_91 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_69_92 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_69_69 :  std_logic_vector(2 downto 0);
signal heap_bh4_w100_5 :  std_logic;
signal heap_bh4_w101_4 :  std_logic;
signal heap_bh4_w102_4 :  std_logic;
signal CompressorIn_bh4_70_93 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_70_94 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_70_70 :  std_logic_vector(2 downto 0);
signal heap_bh4_w102_5 :  std_logic;
signal heap_bh4_w103_4 :  std_logic;
signal heap_bh4_w104_4 :  std_logic;
signal CompressorIn_bh4_71_95 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_71_96 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_71_71 :  std_logic_vector(2 downto 0);
signal heap_bh4_w104_5 :  std_logic;
signal heap_bh4_w105_3 :  std_logic;
signal heap_bh4_w106_3 :  std_logic;
signal CompressorIn_bh4_72_97 :  std_logic_vector(3 downto 0);
signal CompressorOut_bh4_72_72 :  std_logic_vector(2 downto 0);
signal heap_bh4_w29_6 :  std_logic;
signal heap_bh4_w30_8 :  std_logic;
signal heap_bh4_w31_7 :  std_logic;
signal CompressorIn_bh4_73_98 :  std_logic_vector(3 downto 0);
signal CompressorOut_bh4_73_73 :  std_logic_vector(2 downto 0);
signal heap_bh4_w35_7 :  std_logic;
signal heap_bh4_w36_8 :  std_logic;
signal heap_bh4_w37_8 :  std_logic;
signal CompressorIn_bh4_74_99 :  std_logic_vector(3 downto 0);
signal CompressorOut_bh4_74_74 :  std_logic_vector(2 downto 0);
signal heap_bh4_w86_7 :  std_logic;
signal heap_bh4_w87_8 :  std_logic;
signal heap_bh4_w88_7 :  std_logic;
signal CompressorIn_bh4_75_100 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_75_101 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_75_75 :  std_logic_vector(2 downto 0);
signal heap_bh4_w12_3 :  std_logic;
signal heap_bh4_w13_3 :  std_logic;
signal heap_bh4_w14_3 :  std_logic;
signal CompressorIn_bh4_76_102 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_76_103 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_76_76 :  std_logic_vector(2 downto 0);
signal heap_bh4_w14_4 :  std_logic;
signal heap_bh4_w15_3 :  std_logic;
signal heap_bh4_w16_3 :  std_logic;
signal CompressorIn_bh4_77_104 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_77_105 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_77_77 :  std_logic_vector(2 downto 0);
signal heap_bh4_w16_4 :  std_logic;
signal heap_bh4_w17_3 :  std_logic;
signal heap_bh4_w18_3 :  std_logic;
signal CompressorIn_bh4_78_106 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_78_107 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_78_78 :  std_logic_vector(2 downto 0);
signal heap_bh4_w18_4 :  std_logic;
signal heap_bh4_w19_3 :  std_logic;
signal heap_bh4_w20_3 :  std_logic;
signal CompressorIn_bh4_79_108 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_79_109 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_79_79 :  std_logic_vector(2 downto 0);
signal heap_bh4_w20_4 :  std_logic;
signal heap_bh4_w21_3 :  std_logic;
signal heap_bh4_w22_5 :  std_logic;
signal CompressorIn_bh4_80_110 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_80_111 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_80_80 :  std_logic_vector(2 downto 0);
signal heap_bh4_w106_4 :  std_logic;
signal heap_bh4_w107_3 :  std_logic;
signal heap_bh4_w108_3 :  std_logic;
signal CompressorIn_bh4_81_112 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_81_113 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_81_81 :  std_logic_vector(2 downto 0);
signal heap_bh4_w108_4 :  std_logic;
signal heap_bh4_w109_3 :  std_logic;
signal heap_bh4_w110_3 :  std_logic;
signal CompressorIn_bh4_82_114 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_82_115 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_82_82 :  std_logic_vector(2 downto 0);
signal heap_bh4_w110_4 :  std_logic;
signal heap_bh4_w111_3 :  std_logic;
signal heap_bh4_w112_2 :  std_logic;
signal CompressorIn_bh4_83_116 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_83_83 :  std_logic_vector(1 downto 0);
signal heap_bh4_w23_5 :  std_logic;
signal heap_bh4_w24_6 :  std_logic;
signal CompressorIn_bh4_84_117 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_84_84 :  std_logic_vector(1 downto 0);
signal heap_bh4_w25_5 :  std_logic;
signal heap_bh4_w26_6 :  std_logic;
signal CompressorIn_bh4_85_118 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_85_85 :  std_logic_vector(1 downto 0);
signal heap_bh4_w27_5 :  std_logic;
signal heap_bh4_w28_6 :  std_logic;
signal CompressorIn_bh4_86_119 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_86_86 :  std_logic_vector(1 downto 0);
signal heap_bh4_w95_6 :  std_logic;
signal heap_bh4_w96_6 :  std_logic;
signal CompressorIn_bh4_87_120 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_87_87 :  std_logic_vector(1 downto 0);
signal heap_bh4_w97_5 :  std_logic;
signal heap_bh4_w98_6 :  std_logic;
signal CompressorIn_bh4_88_121 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_88_88 :  std_logic_vector(1 downto 0);
signal heap_bh4_w99_5 :  std_logic;
signal heap_bh4_w100_6 :  std_logic;
signal CompressorIn_bh4_89_122 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_89_89 :  std_logic_vector(1 downto 0);
signal heap_bh4_w101_5 :  std_logic;
signal heap_bh4_w102_6 :  std_logic;
signal CompressorIn_bh4_90_123 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_90_90 :  std_logic_vector(1 downto 0);
signal heap_bh4_w103_5 :  std_logic;
signal heap_bh4_w104_6 :  std_logic;
signal CompressorIn_bh4_91_124 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_91_125 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_91_91 :  std_logic_vector(2 downto 0);
signal heap_bh4_w31_8 :  std_logic;
signal heap_bh4_w32_8 :  std_logic;
signal heap_bh4_w33_8 :  std_logic;
signal CompressorIn_bh4_92_126 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_92_127 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_92_92 :  std_logic_vector(2 downto 0);
signal heap_bh4_w39_10 :  std_logic;
signal heap_bh4_w40_10 :  std_logic;
signal heap_bh4_w41_10 :  std_logic;
signal CompressorIn_bh4_93_128 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_93_129 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_93_93 :  std_logic_vector(2 downto 0);
signal heap_bh4_w41_11 :  std_logic;
signal heap_bh4_w42_10 :  std_logic;
signal heap_bh4_w43_10 :  std_logic;
signal CompressorIn_bh4_94_130 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_94_131 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_94_94 :  std_logic_vector(2 downto 0);
signal heap_bh4_w43_11 :  std_logic;
signal heap_bh4_w44_10 :  std_logic;
signal heap_bh4_w45_10 :  std_logic;
signal CompressorIn_bh4_95_132 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_95_133 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_95_95 :  std_logic_vector(2 downto 0);
signal heap_bh4_w45_11 :  std_logic;
signal heap_bh4_w46_11 :  std_logic;
signal heap_bh4_w47_10 :  std_logic;
signal CompressorIn_bh4_96_134 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_96_135 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_96_96 :  std_logic_vector(2 downto 0);
signal heap_bh4_w46_12 :  std_logic;
signal heap_bh4_w47_11 :  std_logic;
signal heap_bh4_w48_10 :  std_logic;
signal CompressorIn_bh4_97_136 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_97_137 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_97_97 :  std_logic_vector(2 downto 0);
signal heap_bh4_w48_11 :  std_logic;
signal heap_bh4_w49_10 :  std_logic;
signal heap_bh4_w50_10 :  std_logic;
signal CompressorIn_bh4_98_138 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_98_139 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_98_98 :  std_logic_vector(2 downto 0);
signal heap_bh4_w50_11 :  std_logic;
signal heap_bh4_w51_10 :  std_logic;
signal heap_bh4_w52_10 :  std_logic;
signal CompressorIn_bh4_99_140 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_99_141 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_99_99 :  std_logic_vector(2 downto 0);
signal heap_bh4_w52_11 :  std_logic;
signal heap_bh4_w53_11 :  std_logic;
signal heap_bh4_w54_10 :  std_logic;
signal CompressorIn_bh4_100_142 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_100_143 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_100_100 :  std_logic_vector(2 downto 0);
signal heap_bh4_w53_12 :  std_logic;
signal heap_bh4_w54_11 :  std_logic;
signal heap_bh4_w55_10 :  std_logic;
signal CompressorIn_bh4_101_144 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_101_145 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_101_101 :  std_logic_vector(2 downto 0);
signal heap_bh4_w55_11 :  std_logic;
signal heap_bh4_w56_10 :  std_logic;
signal heap_bh4_w57_10 :  std_logic;
signal CompressorIn_bh4_102_146 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_102_147 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_102_102 :  std_logic_vector(2 downto 0);
signal heap_bh4_w57_11 :  std_logic;
signal heap_bh4_w58_10 :  std_logic;
signal heap_bh4_w59_10 :  std_logic;
signal CompressorIn_bh4_103_148 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_103_149 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_103_103 :  std_logic_vector(2 downto 0);
signal heap_bh4_w59_11 :  std_logic;
signal heap_bh4_w60_10 :  std_logic;
signal heap_bh4_w61_10 :  std_logic;
signal CompressorIn_bh4_104_150 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_104_151 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_104_104 :  std_logic_vector(2 downto 0);
signal heap_bh4_w61_11 :  std_logic;
signal heap_bh4_w62_10 :  std_logic;
signal heap_bh4_w63_11 :  std_logic;
signal CompressorIn_bh4_105_152 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_105_153 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_105_105 :  std_logic_vector(2 downto 0);
signal heap_bh4_w63_12 :  std_logic;
signal heap_bh4_w64_10 :  std_logic;
signal heap_bh4_w65_10 :  std_logic;
signal CompressorIn_bh4_106_154 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_106_155 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_106_106 :  std_logic_vector(2 downto 0);
signal heap_bh4_w65_11 :  std_logic;
signal heap_bh4_w66_10 :  std_logic;
signal heap_bh4_w67_10 :  std_logic;
signal CompressorIn_bh4_107_156 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_107_157 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_107_107 :  std_logic_vector(2 downto 0);
signal heap_bh4_w67_11 :  std_logic;
signal heap_bh4_w68_10 :  std_logic;
signal heap_bh4_w69_10 :  std_logic;
signal CompressorIn_bh4_108_158 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_108_159 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_108_108 :  std_logic_vector(2 downto 0);
signal heap_bh4_w69_11 :  std_logic;
signal heap_bh4_w70_11 :  std_logic;
signal heap_bh4_w71_10 :  std_logic;
signal CompressorIn_bh4_109_160 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_109_161 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_109_109 :  std_logic_vector(2 downto 0);
signal heap_bh4_w70_12 :  std_logic;
signal heap_bh4_w71_11 :  std_logic;
signal heap_bh4_w72_10 :  std_logic;
signal CompressorIn_bh4_110_162 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_110_163 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_110_110 :  std_logic_vector(2 downto 0);
signal heap_bh4_w72_11 :  std_logic;
signal heap_bh4_w73_10 :  std_logic;
signal heap_bh4_w74_10 :  std_logic;
signal CompressorIn_bh4_111_164 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_111_165 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_111_111 :  std_logic_vector(2 downto 0);
signal heap_bh4_w74_11 :  std_logic;
signal heap_bh4_w75_10 :  std_logic;
signal heap_bh4_w76_10 :  std_logic;
signal CompressorIn_bh4_112_166 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_112_167 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_112_112 :  std_logic_vector(2 downto 0);
signal heap_bh4_w76_11 :  std_logic;
signal heap_bh4_w77_10 :  std_logic;
signal heap_bh4_w78_9 :  std_logic;
signal CompressorIn_bh4_113_168 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_113_169 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_113_113 :  std_logic_vector(2 downto 0);
signal heap_bh4_w81_8 :  std_logic;
signal heap_bh4_w82_8 :  std_logic;
signal heap_bh4_w83_8 :  std_logic;
signal CompressorIn_bh4_114_170 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh4_114_171 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_114_114 :  std_logic_vector(2 downto 0);
signal heap_bh4_w88_8 :  std_logic;
signal heap_bh4_w89_8 :  std_logic;
signal heap_bh4_w90_8 :  std_logic;
signal CompressorIn_bh4_115_172 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_115_173 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_115_115 :  std_logic_vector(2 downto 0);
signal heap_bh4_w24_7 :  std_logic;
signal heap_bh4_w25_6 :  std_logic;
signal heap_bh4_w26_7 :  std_logic;
signal CompressorIn_bh4_116_174 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_116_175 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_116_116 :  std_logic_vector(2 downto 0);
signal heap_bh4_w26_8 :  std_logic;
signal heap_bh4_w27_6 :  std_logic;
signal heap_bh4_w28_7 :  std_logic;
signal CompressorIn_bh4_117_176 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_117_177 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_117_117 :  std_logic_vector(2 downto 0);
signal heap_bh4_w28_8 :  std_logic;
signal heap_bh4_w29_7 :  std_logic;
signal heap_bh4_w30_9 :  std_logic;
signal CompressorIn_bh4_118_178 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_118_179 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_118_118 :  std_logic_vector(2 downto 0);
signal heap_bh4_w33_9 :  std_logic;
signal heap_bh4_w34_8 :  std_logic;
signal heap_bh4_w35_8 :  std_logic;
signal CompressorIn_bh4_119_180 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_119_181 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_119_119 :  std_logic_vector(2 downto 0);
signal heap_bh4_w35_9 :  std_logic;
signal heap_bh4_w36_9 :  std_logic;
signal heap_bh4_w37_9 :  std_logic;
signal CompressorIn_bh4_120_182 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_120_183 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_120_120 :  std_logic_vector(2 downto 0);
signal heap_bh4_w37_10 :  std_logic;
signal heap_bh4_w38_9 :  std_logic;
signal heap_bh4_w39_11 :  std_logic;
signal CompressorIn_bh4_121_184 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_121_185 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_121_121 :  std_logic_vector(2 downto 0);
signal heap_bh4_w77_11 :  std_logic;
signal heap_bh4_w78_10 :  std_logic;
signal heap_bh4_w79_9 :  std_logic;
signal CompressorIn_bh4_122_186 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_122_187 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_122_122 :  std_logic_vector(2 downto 0);
signal heap_bh4_w79_10 :  std_logic;
signal heap_bh4_w80_9 :  std_logic;
signal heap_bh4_w81_9 :  std_logic;
signal CompressorIn_bh4_123_188 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_123_189 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_123_123 :  std_logic_vector(2 downto 0);
signal heap_bh4_w83_9 :  std_logic;
signal heap_bh4_w84_8 :  std_logic;
signal heap_bh4_w85_8 :  std_logic;
signal CompressorIn_bh4_124_190 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_124_191 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_124_124 :  std_logic_vector(2 downto 0);
signal heap_bh4_w85_9 :  std_logic;
signal heap_bh4_w86_8 :  std_logic;
signal heap_bh4_w87_9 :  std_logic;
signal CompressorIn_bh4_125_192 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_125_193 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_125_125 :  std_logic_vector(2 downto 0);
signal heap_bh4_w90_9 :  std_logic;
signal heap_bh4_w91_8 :  std_logic;
signal heap_bh4_w92_8 :  std_logic;
signal CompressorIn_bh4_126_194 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_126_195 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_126_126 :  std_logic_vector(2 downto 0);
signal heap_bh4_w92_9 :  std_logic;
signal heap_bh4_w93_8 :  std_logic;
signal heap_bh4_w94_8 :  std_logic;
signal CompressorIn_bh4_127_196 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_127_197 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_127_127 :  std_logic_vector(2 downto 0);
signal heap_bh4_w94_9 :  std_logic;
signal heap_bh4_w95_7 :  std_logic;
signal heap_bh4_w96_7 :  std_logic;
signal CompressorIn_bh4_128_198 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_128_199 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_128_128 :  std_logic_vector(2 downto 0);
signal heap_bh4_w96_8 :  std_logic;
signal heap_bh4_w97_6 :  std_logic;
signal heap_bh4_w98_7 :  std_logic;
signal CompressorIn_bh4_129_200 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_129_201 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_129_129 :  std_logic_vector(2 downto 0);
signal heap_bh4_w98_8 :  std_logic;
signal heap_bh4_w99_6 :  std_logic;
signal heap_bh4_w100_7 :  std_logic;
signal CompressorIn_bh4_130_202 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_130_203 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_130_130 :  std_logic_vector(2 downto 0);
signal heap_bh4_w100_8 :  std_logic;
signal heap_bh4_w101_6 :  std_logic;
signal heap_bh4_w102_7 :  std_logic;
signal CompressorIn_bh4_131_204 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_131_205 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_131_131 :  std_logic_vector(2 downto 0);
signal heap_bh4_w102_8 :  std_logic;
signal heap_bh4_w103_6 :  std_logic;
signal heap_bh4_w104_7 :  std_logic;
signal CompressorIn_bh4_132_206 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_132_207 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_132_132 :  std_logic_vector(2 downto 0);
signal heap_bh4_w104_8 :  std_logic;
signal heap_bh4_w105_4 :  std_logic;
signal heap_bh4_w106_5 :  std_logic;
signal CompressorIn_bh4_133_208 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_133_209 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_133_133 :  std_logic_vector(2 downto 0);
signal heap_bh4_w112_3 :  std_logic;
signal heap_bh4_w113_2 :  std_logic;
signal heap_bh4_w114_2 :  std_logic;
signal CompressorIn_bh4_134_210 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_134_211 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_134_134 :  std_logic_vector(2 downto 0);
signal heap_bh4_w62_11 :  std_logic;
signal heap_bh4_w63_13 :  std_logic;
signal heap_bh4_w64_11 :  std_logic;
signal CompressorIn_bh4_135_212 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_135_135 :  std_logic_vector(1 downto 0);
signal heap_bh4_w30_10 :  std_logic;
signal heap_bh4_w31_9 :  std_logic;
signal CompressorIn_bh4_136_213 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_136_136 :  std_logic_vector(1 downto 0);
signal heap_bh4_w40_11 :  std_logic;
signal heap_bh4_w41_12 :  std_logic;
signal CompressorIn_bh4_137_214 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_137_137 :  std_logic_vector(1 downto 0);
signal heap_bh4_w42_11 :  std_logic;
signal heap_bh4_w43_12 :  std_logic;
signal CompressorIn_bh4_138_215 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_138_138 :  std_logic_vector(1 downto 0);
signal heap_bh4_w44_11 :  std_logic;
signal heap_bh4_w45_12 :  std_logic;
signal CompressorIn_bh4_139_216 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_139_139 :  std_logic_vector(1 downto 0);
signal heap_bh4_w47_12 :  std_logic;
signal heap_bh4_w48_12 :  std_logic;
signal CompressorIn_bh4_140_217 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_140_140 :  std_logic_vector(1 downto 0);
signal heap_bh4_w49_11 :  std_logic;
signal heap_bh4_w50_12 :  std_logic;
signal CompressorIn_bh4_141_218 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_141_141 :  std_logic_vector(1 downto 0);
signal heap_bh4_w51_11 :  std_logic;
signal heap_bh4_w52_12 :  std_logic;
signal CompressorIn_bh4_142_219 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_142_142 :  std_logic_vector(1 downto 0);
signal heap_bh4_w54_12 :  std_logic;
signal heap_bh4_w55_12 :  std_logic;
signal CompressorIn_bh4_143_220 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_143_143 :  std_logic_vector(1 downto 0);
signal heap_bh4_w56_11 :  std_logic;
signal heap_bh4_w57_12 :  std_logic;
signal CompressorIn_bh4_144_221 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_144_144 :  std_logic_vector(1 downto 0);
signal heap_bh4_w58_11 :  std_logic;
signal heap_bh4_w59_12 :  std_logic;
signal CompressorIn_bh4_145_222 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_145_145 :  std_logic_vector(1 downto 0);
signal heap_bh4_w60_11 :  std_logic;
signal heap_bh4_w61_12 :  std_logic;
signal CompressorIn_bh4_146_223 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_146_146 :  std_logic_vector(1 downto 0);
signal heap_bh4_w64_12 :  std_logic;
signal heap_bh4_w65_12 :  std_logic;
signal CompressorIn_bh4_147_224 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_147_147 :  std_logic_vector(1 downto 0);
signal heap_bh4_w66_11 :  std_logic;
signal heap_bh4_w67_12 :  std_logic;
signal CompressorIn_bh4_148_225 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_148_148 :  std_logic_vector(1 downto 0);
signal heap_bh4_w68_11 :  std_logic;
signal heap_bh4_w69_12 :  std_logic;
signal CompressorIn_bh4_149_226 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_149_149 :  std_logic_vector(1 downto 0);
signal heap_bh4_w71_12 :  std_logic;
signal heap_bh4_w72_12 :  std_logic;
signal CompressorIn_bh4_150_227 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_150_150 :  std_logic_vector(1 downto 0);
signal heap_bh4_w73_11 :  std_logic;
signal heap_bh4_w74_12 :  std_logic;
signal CompressorIn_bh4_151_228 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_151_151 :  std_logic_vector(1 downto 0);
signal heap_bh4_w75_11 :  std_logic;
signal heap_bh4_w76_12 :  std_logic;
signal CompressorIn_bh4_152_229 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh4_152_152 :  std_logic_vector(1 downto 0);
signal heap_bh4_w87_10 :  std_logic;
signal heap_bh4_w88_9 :  std_logic;
signal CompressorIn_bh4_153_230 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_153_231 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_153_153 :  std_logic_vector(2 downto 0);
signal heap_bh4_w32_9 :  std_logic;
signal heap_bh4_w33_10 :  std_logic;
signal heap_bh4_w34_9 :  std_logic;
signal CompressorIn_bh4_154_232 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_154_233 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_154_154 :  std_logic_vector(2 downto 0);
signal heap_bh4_w41_13 :  std_logic;
signal heap_bh4_w42_12 :  std_logic;
signal heap_bh4_w43_13 :  std_logic;
signal CompressorIn_bh4_155_234 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_155_235 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_155_155 :  std_logic_vector(2 downto 0);
signal heap_bh4_w43_14 :  std_logic;
signal heap_bh4_w44_12 :  std_logic;
signal heap_bh4_w45_13 :  std_logic;
signal CompressorIn_bh4_156_236 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_156_237 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_156_156 :  std_logic_vector(2 downto 0);
signal heap_bh4_w45_14 :  std_logic;
signal heap_bh4_w46_13 :  std_logic;
signal heap_bh4_w47_13 :  std_logic;
signal CompressorIn_bh4_157_238 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_157_239 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_157_157 :  std_logic_vector(2 downto 0);
signal heap_bh4_w47_14 :  std_logic;
signal heap_bh4_w48_13 :  std_logic;
signal heap_bh4_w49_12 :  std_logic;
signal CompressorIn_bh4_158_240 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_158_241 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_158_158 :  std_logic_vector(2 downto 0);
signal heap_bh4_w50_13 :  std_logic;
signal heap_bh4_w51_12 :  std_logic;
signal heap_bh4_w52_13 :  std_logic;
signal CompressorIn_bh4_159_242 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_159_243 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_159_159 :  std_logic_vector(2 downto 0);
signal heap_bh4_w52_14 :  std_logic;
signal heap_bh4_w53_13 :  std_logic;
signal heap_bh4_w54_13 :  std_logic;
signal CompressorIn_bh4_160_244 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_160_245 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_160_160 :  std_logic_vector(2 downto 0);
signal heap_bh4_w54_14 :  std_logic;
signal heap_bh4_w55_13 :  std_logic;
signal heap_bh4_w56_12 :  std_logic;
signal CompressorIn_bh4_161_246 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_161_247 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_161_161 :  std_logic_vector(2 downto 0);
signal heap_bh4_w57_13 :  std_logic;
signal heap_bh4_w58_12 :  std_logic;
signal heap_bh4_w59_13 :  std_logic;
signal CompressorIn_bh4_162_248 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_162_249 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_162_162 :  std_logic_vector(2 downto 0);
signal heap_bh4_w59_14 :  std_logic;
signal heap_bh4_w60_12 :  std_logic;
signal heap_bh4_w61_13 :  std_logic;
signal CompressorIn_bh4_163_250 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_163_251 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_163_163 :  std_logic_vector(2 downto 0);
signal heap_bh4_w61_14 :  std_logic;
signal heap_bh4_w62_12 :  std_logic;
signal heap_bh4_w63_14 :  std_logic;
signal CompressorIn_bh4_164_252 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_164_253 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_164_164 :  std_logic_vector(2 downto 0);
signal heap_bh4_w63_15 :  std_logic;
signal heap_bh4_w64_13 :  std_logic;
signal heap_bh4_w65_13 :  std_logic;
signal CompressorIn_bh4_165_254 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_165_255 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_165_165 :  std_logic_vector(2 downto 0);
signal heap_bh4_w65_14 :  std_logic;
signal heap_bh4_w66_12 :  std_logic;
signal heap_bh4_w67_13 :  std_logic;
signal CompressorIn_bh4_166_256 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_166_257 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_166_166 :  std_logic_vector(2 downto 0);
signal heap_bh4_w67_14 :  std_logic;
signal heap_bh4_w68_12 :  std_logic;
signal heap_bh4_w69_13 :  std_logic;
signal CompressorIn_bh4_167_258 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_167_259 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_167_167 :  std_logic_vector(2 downto 0);
signal heap_bh4_w69_14 :  std_logic;
signal heap_bh4_w70_13 :  std_logic;
signal heap_bh4_w71_13 :  std_logic;
signal CompressorIn_bh4_168_260 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_168_261 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_168_168 :  std_logic_vector(2 downto 0);
signal heap_bh4_w71_14 :  std_logic;
signal heap_bh4_w72_13 :  std_logic;
signal heap_bh4_w73_12 :  std_logic;
signal CompressorIn_bh4_169_262 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_169_263 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_169_169 :  std_logic_vector(2 downto 0);
signal heap_bh4_w74_13 :  std_logic;
signal heap_bh4_w75_12 :  std_logic;
signal heap_bh4_w76_13 :  std_logic;
signal CompressorIn_bh4_170_264 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_170_265 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_170_170 :  std_logic_vector(2 downto 0);
signal heap_bh4_w76_14 :  std_logic;
signal heap_bh4_w77_12 :  std_logic;
signal heap_bh4_w78_11 :  std_logic;
signal CompressorIn_bh4_171_266 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_171_267 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_171_171 :  std_logic_vector(2 downto 0);
signal heap_bh4_w78_12 :  std_logic;
signal heap_bh4_w79_11 :  std_logic;
signal heap_bh4_w80_10 :  std_logic;
signal CompressorIn_bh4_172_268 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_172_269 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_172_172 :  std_logic_vector(2 downto 0);
signal heap_bh4_w82_9 :  std_logic;
signal heap_bh4_w83_10 :  std_logic;
signal heap_bh4_w84_9 :  std_logic;
signal CompressorIn_bh4_173_270 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_173_271 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_173_173 :  std_logic_vector(2 downto 0);
signal heap_bh4_w89_9 :  std_logic;
signal heap_bh4_w90_10 :  std_logic;
signal heap_bh4_w91_9 :  std_logic;
signal CompressorIn_bh4_174_272 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_174_273 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_174_174 :  std_logic_vector(2 downto 0);
signal heap_bh4_w106_6 :  std_logic;
signal heap_bh4_w107_4 :  std_logic;
signal heap_bh4_w108_5 :  std_logic;
signal CompressorIn_bh4_175_274 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_175_275 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_175_175 :  std_logic_vector(2 downto 0);
signal heap_bh4_w114_3 :  std_logic;
signal heap_bh4_w115_2 :  std_logic;
signal heap_bh4_w116_2 :  std_logic;
signal CompressorIn_bh4_176_276 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_176_277 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_176_176 :  std_logic_vector(2 downto 0);
signal heap_bh4_w34_10 :  std_logic;
signal heap_bh4_w35_10 :  std_logic;
signal heap_bh4_w36_10 :  std_logic;
signal CompressorIn_bh4_177_278 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_177_279 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_177_177 :  std_logic_vector(2 downto 0);
signal heap_bh4_w80_11 :  std_logic;
signal heap_bh4_w81_10 :  std_logic;
signal heap_bh4_w82_10 :  std_logic;
signal CompressorIn_bh4_178_280 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_178_281 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_178_178 :  std_logic_vector(2 downto 0);
signal heap_bh4_w84_10 :  std_logic;
signal heap_bh4_w85_10 :  std_logic;
signal heap_bh4_w86_9 :  std_logic;
signal CompressorIn_bh4_179_282 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_179_283 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_179_179 :  std_logic_vector(2 downto 0);
signal heap_bh4_w91_10 :  std_logic;
signal heap_bh4_w92_10 :  std_logic;
signal heap_bh4_w93_9 :  std_logic;
signal CompressorIn_bh4_180_284 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_180_285 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_180_180 :  std_logic_vector(2 downto 0);
signal heap_bh4_w108_6 :  std_logic;
signal heap_bh4_w109_4 :  std_logic;
signal heap_bh4_w110_5 :  std_logic;
signal CompressorIn_bh4_181_286 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_181_287 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_181_181 :  std_logic_vector(2 downto 0);
signal heap_bh4_w116_3 :  std_logic;
signal heap_bh4_w117_2 :  std_logic;
signal heap_bh4_w118_2 :  std_logic;
signal CompressorIn_bh4_182_288 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_182_289 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_182_182 :  std_logic_vector(2 downto 0);
signal heap_bh4_w49_13 :  std_logic;
signal heap_bh4_w50_14 :  std_logic;
signal heap_bh4_w51_13 :  std_logic;
signal CompressorIn_bh4_183_290 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_183_291 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_183_183 :  std_logic_vector(2 downto 0);
signal heap_bh4_w56_13 :  std_logic;
signal heap_bh4_w57_14 :  std_logic;
signal heap_bh4_w58_13 :  std_logic;
signal CompressorIn_bh4_184_292 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_184_293 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_184_184 :  std_logic_vector(2 downto 0);
signal heap_bh4_w73_13 :  std_logic;
signal heap_bh4_w74_14 :  std_logic;
signal heap_bh4_w75_13 :  std_logic;
signal CompressorIn_bh4_185_294 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_185_295 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_185_185 :  std_logic_vector(2 downto 0);
signal heap_bh4_w36_11 :  std_logic;
signal heap_bh4_w37_11 :  std_logic;
signal heap_bh4_w38_10 :  std_logic;
signal CompressorIn_bh4_186_296 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_186_297 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_186_186 :  std_logic_vector(2 downto 0);
signal heap_bh4_w86_10 :  std_logic;
signal heap_bh4_w87_11 :  std_logic;
signal heap_bh4_w88_10 :  std_logic;
signal CompressorIn_bh4_187_298 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_187_299 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_187_187 :  std_logic_vector(2 downto 0);
signal heap_bh4_w93_10 :  std_logic;
signal heap_bh4_w94_10 :  std_logic;
signal heap_bh4_w95_8 :  std_logic;
signal CompressorIn_bh4_188_300 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_188_301 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_188_188 :  std_logic_vector(2 downto 0);
signal heap_bh4_w110_6 :  std_logic;
signal heap_bh4_w111_4 :  std_logic;
signal heap_bh4_w112_4 :  std_logic;
signal CompressorIn_bh4_189_302 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_189_303 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_189_189 :  std_logic_vector(2 downto 0);
signal heap_bh4_w118_3 :  std_logic;
signal heap_bh4_w119_2 :  std_logic;
signal heap_bh4_w120_2 :  std_logic;
signal CompressorIn_bh4_190_304 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_190_305 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_190_190 :  std_logic_vector(2 downto 0);
signal heap_bh4_w38_11 :  std_logic;
signal heap_bh4_w39_12 :  std_logic;
signal heap_bh4_w40_12 :  std_logic;
signal CompressorIn_bh4_191_306 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_191_307 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_191_191 :  std_logic_vector(2 downto 0);
signal heap_bh4_w95_9 :  std_logic;
signal heap_bh4_w96_9 :  std_logic;
signal heap_bh4_w97_7 :  std_logic;
signal CompressorIn_bh4_192_308 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_192_309 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_192_192 :  std_logic_vector(2 downto 0);
signal heap_bh4_w120_3 :  std_logic;
signal heap_bh4_w121_2 :  std_logic;
signal heap_bh4_w122_2 :  std_logic;
signal CompressorIn_bh4_193_310 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_193_311 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_193_193 :  std_logic_vector(2 downto 0);
signal heap_bh4_w88_11 :  std_logic;
signal heap_bh4_w89_10 :  std_logic;
signal heap_bh4_w90_11 :  std_logic;
signal CompressorIn_bh4_194_312 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_194_313 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_194_194 :  std_logic_vector(2 downto 0);
signal heap_bh4_w122_3 :  std_logic;
signal heap_bh4_w123_2 :  std_logic;
signal heap_bh4_w124_2 :  std_logic;
signal CompressorIn_bh4_195_314 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_195_315 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_195_195 :  std_logic_vector(2 downto 0);
signal heap_bh4_w40_13 :  std_logic;
signal heap_bh4_w41_14 :  std_logic;
signal heap_bh4_w42_13 :  std_logic;
signal CompressorIn_bh4_196_316 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_196_317 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_196_196 :  std_logic_vector(2 downto 0);
signal heap_bh4_w124_3 :  std_logic;
signal heap_bh4_w125_2 :  std_logic;
signal heap_bh4_w126_2 :  std_logic;
signal CompressorIn_bh4_197_318 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_197_319 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh4_197_197 :  std_logic_vector(2 downto 0);
signal heap_bh4_w126_3 :  std_logic;
signal heap_bh4_w127_2 :  std_logic;
signal heap_bh4_w128_2 :  std_logic;
signal CompressorIn_bh4_198_320 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh4_198_321 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh4_198_198 :  std_logic_vector(2 downto 0);
signal heap_bh4_w128_3 :  std_logic;
signal heap_bh4_w129_1 :  std_logic;
signal finalAdderIn0_bh4 :  std_logic_vector(125 downto 0);
signal finalAdderIn1_bh4 :  std_logic_vector(125 downto 0);
signal finalAdderCin_bh4 :  std_logic;
signal finalAdderOut_bh4 :  std_logic_vector(125 downto 0);
signal CompressionResult4 :  std_logic_vector(130 downto 0);
begin
   XX_m3 <= X ;
   YY_m3 <= Y ;

   -- Beginning of code generated by BitHeap::generateCompressorVHDL
   -- code generated by BitHeap::generateSupertileVHDL()
   DSP_bh4_ch0_0 <= std_logic_vector(signed("" & XX_m3(64 downto 40) & "") * signed("" & YY_m3(64 downto 47) & ""));
   heap_bh4_w129_0 <= not( DSP_bh4_ch0_0(42) ); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w128_0 <= DSP_bh4_ch0_0(41); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w127_0 <= DSP_bh4_ch0_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w126_0 <= DSP_bh4_ch0_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w125_0 <= DSP_bh4_ch0_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w124_0 <= DSP_bh4_ch0_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w123_0 <= DSP_bh4_ch0_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w122_0 <= DSP_bh4_ch0_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w121_0 <= DSP_bh4_ch0_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w120_0 <= DSP_bh4_ch0_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w119_0 <= DSP_bh4_ch0_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w118_0 <= DSP_bh4_ch0_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w117_0 <= DSP_bh4_ch0_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w116_0 <= DSP_bh4_ch0_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w115_0 <= DSP_bh4_ch0_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w114_0 <= DSP_bh4_ch0_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w113_0 <= DSP_bh4_ch0_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w112_0 <= DSP_bh4_ch0_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w111_0 <= DSP_bh4_ch0_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w110_0 <= DSP_bh4_ch0_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w109_0 <= DSP_bh4_ch0_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w108_0 <= DSP_bh4_ch0_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w107_0 <= DSP_bh4_ch0_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w106_0 <= DSP_bh4_ch0_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w105_0 <= DSP_bh4_ch0_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w104_0 <= DSP_bh4_ch0_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w103_0 <= DSP_bh4_ch0_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w102_0 <= DSP_bh4_ch0_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w101_0 <= DSP_bh4_ch0_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w100_0 <= DSP_bh4_ch0_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w99_0 <= DSP_bh4_ch0_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w98_0 <= DSP_bh4_ch0_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w97_0 <= DSP_bh4_ch0_0(10); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w96_0 <= DSP_bh4_ch0_0(9); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w95_0 <= DSP_bh4_ch0_0(8); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w94_0 <= DSP_bh4_ch0_0(7); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w93_0 <= DSP_bh4_ch0_0(6); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w92_0 <= DSP_bh4_ch0_0(5); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w91_0 <= DSP_bh4_ch0_0(4); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w90_0 <= DSP_bh4_ch0_0(3); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w89_0 <= DSP_bh4_ch0_0(2); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w88_0 <= DSP_bh4_ch0_0(1); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w87_0 <= DSP_bh4_ch0_0(0); -- cycle= 0 cp= 2.387e-09
   DSP_bh4_ch1_0 <= std_logic_vector(signed("0" & XX_m3(39 downto 16) & "") * signed("" & YY_m3(64 downto 47) & ""));
   heap_bh4_w105_1 <= not( DSP_bh4_ch1_0(42) ); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w104_1 <= DSP_bh4_ch1_0(41); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w103_1 <= DSP_bh4_ch1_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w102_1 <= DSP_bh4_ch1_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w101_1 <= DSP_bh4_ch1_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w100_1 <= DSP_bh4_ch1_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w99_1 <= DSP_bh4_ch1_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w98_1 <= DSP_bh4_ch1_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w97_1 <= DSP_bh4_ch1_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w96_1 <= DSP_bh4_ch1_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w95_1 <= DSP_bh4_ch1_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w94_1 <= DSP_bh4_ch1_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w93_1 <= DSP_bh4_ch1_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w92_1 <= DSP_bh4_ch1_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w91_1 <= DSP_bh4_ch1_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w90_1 <= DSP_bh4_ch1_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w89_1 <= DSP_bh4_ch1_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w88_1 <= DSP_bh4_ch1_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w87_1 <= DSP_bh4_ch1_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w86_0 <= DSP_bh4_ch1_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w85_0 <= DSP_bh4_ch1_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w84_0 <= DSP_bh4_ch1_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w83_0 <= DSP_bh4_ch1_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w82_0 <= DSP_bh4_ch1_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w81_0 <= DSP_bh4_ch1_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w80_0 <= DSP_bh4_ch1_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w79_0 <= DSP_bh4_ch1_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w78_0 <= DSP_bh4_ch1_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w77_0 <= DSP_bh4_ch1_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w76_0 <= DSP_bh4_ch1_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w75_0 <= DSP_bh4_ch1_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w74_0 <= DSP_bh4_ch1_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w73_0 <= DSP_bh4_ch1_0(10); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w72_0 <= DSP_bh4_ch1_0(9); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w71_0 <= DSP_bh4_ch1_0(8); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w70_0 <= DSP_bh4_ch1_0(7); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w69_0 <= DSP_bh4_ch1_0(6); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w68_0 <= DSP_bh4_ch1_0(5); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w67_0 <= DSP_bh4_ch1_0(4); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w66_0 <= DSP_bh4_ch1_0(3); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w65_0 <= DSP_bh4_ch1_0(2); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w64_0 <= DSP_bh4_ch1_0(1); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w63_0 <= DSP_bh4_ch1_0(0); -- cycle= 0 cp= 2.387e-09
   DSP_bh4_ch2_0 <= std_logic_vector(signed("0" & XX_m3(15 downto 0) & "00000000") * signed("" & YY_m3(64 downto 47) & ""));
   heap_bh4_w81_1 <= not( DSP_bh4_ch2_0(42) ); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w80_1 <= DSP_bh4_ch2_0(41); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w79_1 <= DSP_bh4_ch2_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w78_1 <= DSP_bh4_ch2_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w77_1 <= DSP_bh4_ch2_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w76_1 <= DSP_bh4_ch2_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w75_1 <= DSP_bh4_ch2_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w74_1 <= DSP_bh4_ch2_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w73_1 <= DSP_bh4_ch2_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w72_1 <= DSP_bh4_ch2_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w71_1 <= DSP_bh4_ch2_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w70_1 <= DSP_bh4_ch2_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w69_1 <= DSP_bh4_ch2_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w68_1 <= DSP_bh4_ch2_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w67_1 <= DSP_bh4_ch2_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w66_1 <= DSP_bh4_ch2_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w65_1 <= DSP_bh4_ch2_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w64_1 <= DSP_bh4_ch2_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w63_1 <= DSP_bh4_ch2_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w62_0 <= DSP_bh4_ch2_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w61_0 <= DSP_bh4_ch2_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w60_0 <= DSP_bh4_ch2_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w59_0 <= DSP_bh4_ch2_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w58_0 <= DSP_bh4_ch2_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w57_0 <= DSP_bh4_ch2_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w56_0 <= DSP_bh4_ch2_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w55_0 <= DSP_bh4_ch2_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w54_0 <= DSP_bh4_ch2_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w53_0 <= DSP_bh4_ch2_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w52_0 <= DSP_bh4_ch2_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w51_0 <= DSP_bh4_ch2_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w50_0 <= DSP_bh4_ch2_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w49_0 <= DSP_bh4_ch2_0(10); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w48_0 <= DSP_bh4_ch2_0(9); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w47_0 <= DSP_bh4_ch2_0(8); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w46_0 <= DSP_bh4_ch2_0(7); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w45_0 <= DSP_bh4_ch2_0(6); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w44_0 <= DSP_bh4_ch2_0(5); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w43_0 <= DSP_bh4_ch2_0(4); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w42_0 <= DSP_bh4_ch2_0(3); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w41_0 <= DSP_bh4_ch2_0(2); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w40_0 <= DSP_bh4_ch2_0(1); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w39_0 <= DSP_bh4_ch2_0(0); -- cycle= 0 cp= 2.387e-09
   DSP_bh4_ch3_0 <= std_logic_vector(signed("" & XX_m3(64 downto 40) & "") * signed("0" & YY_m3(46 downto 30) & ""));
   heap_bh4_w112_1 <= not( DSP_bh4_ch3_0(42) ); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w111_1 <= DSP_bh4_ch3_0(41); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w110_1 <= DSP_bh4_ch3_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w109_1 <= DSP_bh4_ch3_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w108_1 <= DSP_bh4_ch3_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w107_1 <= DSP_bh4_ch3_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w106_1 <= DSP_bh4_ch3_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w105_2 <= DSP_bh4_ch3_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w104_2 <= DSP_bh4_ch3_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w103_2 <= DSP_bh4_ch3_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w102_2 <= DSP_bh4_ch3_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w101_2 <= DSP_bh4_ch3_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w100_2 <= DSP_bh4_ch3_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w99_2 <= DSP_bh4_ch3_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w98_2 <= DSP_bh4_ch3_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w97_2 <= DSP_bh4_ch3_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w96_2 <= DSP_bh4_ch3_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w95_2 <= DSP_bh4_ch3_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w94_2 <= DSP_bh4_ch3_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w93_2 <= DSP_bh4_ch3_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w92_2 <= DSP_bh4_ch3_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w91_2 <= DSP_bh4_ch3_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w90_2 <= DSP_bh4_ch3_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w89_2 <= DSP_bh4_ch3_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w88_2 <= DSP_bh4_ch3_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w87_2 <= DSP_bh4_ch3_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w86_1 <= DSP_bh4_ch3_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w85_1 <= DSP_bh4_ch3_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w84_1 <= DSP_bh4_ch3_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w83_1 <= DSP_bh4_ch3_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w82_1 <= DSP_bh4_ch3_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w81_2 <= DSP_bh4_ch3_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w80_2 <= DSP_bh4_ch3_0(10); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w79_2 <= DSP_bh4_ch3_0(9); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w78_2 <= DSP_bh4_ch3_0(8); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w77_2 <= DSP_bh4_ch3_0(7); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w76_2 <= DSP_bh4_ch3_0(6); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w75_2 <= DSP_bh4_ch3_0(5); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w74_2 <= DSP_bh4_ch3_0(4); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w73_2 <= DSP_bh4_ch3_0(3); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w72_2 <= DSP_bh4_ch3_0(2); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w71_2 <= DSP_bh4_ch3_0(1); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w70_2 <= DSP_bh4_ch3_0(0); -- cycle= 0 cp= 2.387e-09
   DSP_bh4_ch4_0 <= std_logic_vector(signed("0" & XX_m3(39 downto 16) & "") * signed("0" & YY_m3(46 downto 30) & ""));
   heap_bh4_w88_3 <= not( DSP_bh4_ch4_0(42) ); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w87_3 <= DSP_bh4_ch4_0(41); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w86_2 <= DSP_bh4_ch4_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w85_2 <= DSP_bh4_ch4_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w84_2 <= DSP_bh4_ch4_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w83_2 <= DSP_bh4_ch4_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w82_2 <= DSP_bh4_ch4_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w81_3 <= DSP_bh4_ch4_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w80_3 <= DSP_bh4_ch4_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w79_3 <= DSP_bh4_ch4_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w78_3 <= DSP_bh4_ch4_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w77_3 <= DSP_bh4_ch4_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w76_3 <= DSP_bh4_ch4_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w75_3 <= DSP_bh4_ch4_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w74_3 <= DSP_bh4_ch4_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w73_3 <= DSP_bh4_ch4_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w72_3 <= DSP_bh4_ch4_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w71_3 <= DSP_bh4_ch4_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w70_3 <= DSP_bh4_ch4_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w69_2 <= DSP_bh4_ch4_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w68_2 <= DSP_bh4_ch4_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w67_2 <= DSP_bh4_ch4_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w66_2 <= DSP_bh4_ch4_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w65_2 <= DSP_bh4_ch4_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w64_2 <= DSP_bh4_ch4_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w63_2 <= DSP_bh4_ch4_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w62_1 <= DSP_bh4_ch4_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w61_1 <= DSP_bh4_ch4_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w60_1 <= DSP_bh4_ch4_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w59_1 <= DSP_bh4_ch4_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w58_1 <= DSP_bh4_ch4_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w57_1 <= DSP_bh4_ch4_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w56_1 <= DSP_bh4_ch4_0(10); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w55_1 <= DSP_bh4_ch4_0(9); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w54_1 <= DSP_bh4_ch4_0(8); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w53_1 <= DSP_bh4_ch4_0(7); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w52_1 <= DSP_bh4_ch4_0(6); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w51_1 <= DSP_bh4_ch4_0(5); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w50_1 <= DSP_bh4_ch4_0(4); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w49_1 <= DSP_bh4_ch4_0(3); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w48_1 <= DSP_bh4_ch4_0(2); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w47_1 <= DSP_bh4_ch4_0(1); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w46_1 <= DSP_bh4_ch4_0(0); -- cycle= 0 cp= 2.387e-09
   DSP_bh4_ch5_0 <= std_logic_vector(signed("0" & XX_m3(15 downto 0) & "00000000") * signed("0" & YY_m3(46 downto 30) & ""));
   heap_bh4_w64_3 <= not( DSP_bh4_ch5_0(42) ); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w63_3 <= DSP_bh4_ch5_0(41); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w62_2 <= DSP_bh4_ch5_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w61_2 <= DSP_bh4_ch5_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w60_2 <= DSP_bh4_ch5_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w59_2 <= DSP_bh4_ch5_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w58_2 <= DSP_bh4_ch5_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w57_2 <= DSP_bh4_ch5_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w56_2 <= DSP_bh4_ch5_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w55_2 <= DSP_bh4_ch5_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w54_2 <= DSP_bh4_ch5_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w53_2 <= DSP_bh4_ch5_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w52_2 <= DSP_bh4_ch5_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w51_2 <= DSP_bh4_ch5_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w50_2 <= DSP_bh4_ch5_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w49_2 <= DSP_bh4_ch5_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w48_2 <= DSP_bh4_ch5_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w47_2 <= DSP_bh4_ch5_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w46_2 <= DSP_bh4_ch5_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w45_1 <= DSP_bh4_ch5_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w44_1 <= DSP_bh4_ch5_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w43_1 <= DSP_bh4_ch5_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w42_1 <= DSP_bh4_ch5_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w41_1 <= DSP_bh4_ch5_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w40_1 <= DSP_bh4_ch5_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w39_1 <= DSP_bh4_ch5_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w38_0 <= DSP_bh4_ch5_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w37_0 <= DSP_bh4_ch5_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w36_0 <= DSP_bh4_ch5_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w35_0 <= DSP_bh4_ch5_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w34_0 <= DSP_bh4_ch5_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w33_0 <= DSP_bh4_ch5_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w32_0 <= DSP_bh4_ch5_0(10); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w31_0 <= DSP_bh4_ch5_0(9); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w30_0 <= DSP_bh4_ch5_0(8); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w29_0 <= DSP_bh4_ch5_0(7); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w28_0 <= DSP_bh4_ch5_0(6); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w27_0 <= DSP_bh4_ch5_0(5); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w26_0 <= DSP_bh4_ch5_0(4); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w25_0 <= DSP_bh4_ch5_0(3); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w24_0 <= DSP_bh4_ch5_0(2); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w23_0 <= DSP_bh4_ch5_0(1); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w22_0 <= DSP_bh4_ch5_0(0); -- cycle= 0 cp= 2.387e-09
   DSP_bh4_ch6_0 <= std_logic_vector(signed("" & XX_m3(64 downto 40) & "") * signed("0" & YY_m3(29 downto 13) & ""));
   heap_bh4_w95_3 <= not( DSP_bh4_ch6_0(42) ); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w94_3 <= DSP_bh4_ch6_0(41); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w93_3 <= DSP_bh4_ch6_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w92_3 <= DSP_bh4_ch6_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w91_3 <= DSP_bh4_ch6_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w90_3 <= DSP_bh4_ch6_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w89_3 <= DSP_bh4_ch6_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w88_4 <= DSP_bh4_ch6_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w87_4 <= DSP_bh4_ch6_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w86_3 <= DSP_bh4_ch6_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w85_3 <= DSP_bh4_ch6_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w84_3 <= DSP_bh4_ch6_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w83_3 <= DSP_bh4_ch6_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w82_3 <= DSP_bh4_ch6_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w81_4 <= DSP_bh4_ch6_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w80_4 <= DSP_bh4_ch6_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w79_4 <= DSP_bh4_ch6_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w78_4 <= DSP_bh4_ch6_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w77_4 <= DSP_bh4_ch6_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w76_4 <= DSP_bh4_ch6_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w75_4 <= DSP_bh4_ch6_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w74_4 <= DSP_bh4_ch6_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w73_4 <= DSP_bh4_ch6_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w72_4 <= DSP_bh4_ch6_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w71_4 <= DSP_bh4_ch6_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w70_4 <= DSP_bh4_ch6_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w69_3 <= DSP_bh4_ch6_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w68_3 <= DSP_bh4_ch6_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w67_3 <= DSP_bh4_ch6_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w66_3 <= DSP_bh4_ch6_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w65_3 <= DSP_bh4_ch6_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w64_4 <= DSP_bh4_ch6_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w63_4 <= DSP_bh4_ch6_0(10); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w62_3 <= DSP_bh4_ch6_0(9); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w61_3 <= DSP_bh4_ch6_0(8); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w60_3 <= DSP_bh4_ch6_0(7); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w59_3 <= DSP_bh4_ch6_0(6); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w58_3 <= DSP_bh4_ch6_0(5); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w57_3 <= DSP_bh4_ch6_0(4); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w56_3 <= DSP_bh4_ch6_0(3); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w55_3 <= DSP_bh4_ch6_0(2); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w54_3 <= DSP_bh4_ch6_0(1); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w53_3 <= DSP_bh4_ch6_0(0); -- cycle= 0 cp= 2.387e-09
   DSP_bh4_ch7_0 <= std_logic_vector(signed("0" & XX_m3(39 downto 16) & "") * signed("0" & YY_m3(29 downto 13) & ""));
   heap_bh4_w71_5 <= not( DSP_bh4_ch7_0(42) ); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w70_5 <= DSP_bh4_ch7_0(41); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w69_4 <= DSP_bh4_ch7_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w68_4 <= DSP_bh4_ch7_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w67_4 <= DSP_bh4_ch7_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w66_4 <= DSP_bh4_ch7_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w65_4 <= DSP_bh4_ch7_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w64_5 <= DSP_bh4_ch7_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w63_5 <= DSP_bh4_ch7_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w62_4 <= DSP_bh4_ch7_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w61_4 <= DSP_bh4_ch7_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w60_4 <= DSP_bh4_ch7_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w59_4 <= DSP_bh4_ch7_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w58_4 <= DSP_bh4_ch7_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w57_4 <= DSP_bh4_ch7_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w56_4 <= DSP_bh4_ch7_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w55_4 <= DSP_bh4_ch7_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w54_4 <= DSP_bh4_ch7_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w53_4 <= DSP_bh4_ch7_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w52_3 <= DSP_bh4_ch7_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w51_3 <= DSP_bh4_ch7_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w50_3 <= DSP_bh4_ch7_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w49_3 <= DSP_bh4_ch7_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w48_3 <= DSP_bh4_ch7_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w47_3 <= DSP_bh4_ch7_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w46_3 <= DSP_bh4_ch7_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w45_2 <= DSP_bh4_ch7_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w44_2 <= DSP_bh4_ch7_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w43_2 <= DSP_bh4_ch7_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w42_2 <= DSP_bh4_ch7_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w41_2 <= DSP_bh4_ch7_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w40_2 <= DSP_bh4_ch7_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w39_2 <= DSP_bh4_ch7_0(10); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w38_1 <= DSP_bh4_ch7_0(9); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w37_1 <= DSP_bh4_ch7_0(8); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w36_1 <= DSP_bh4_ch7_0(7); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w35_1 <= DSP_bh4_ch7_0(6); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w34_1 <= DSP_bh4_ch7_0(5); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w33_1 <= DSP_bh4_ch7_0(4); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w32_1 <= DSP_bh4_ch7_0(3); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w31_1 <= DSP_bh4_ch7_0(2); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w30_1 <= DSP_bh4_ch7_0(1); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w29_1 <= DSP_bh4_ch7_0(0); -- cycle= 0 cp= 2.387e-09
   DSP_bh4_ch8_0 <= std_logic_vector(signed("0" & XX_m3(15 downto 0) & "00000000") * signed("0" & YY_m3(29 downto 13) & ""));
   heap_bh4_w47_4 <= not( DSP_bh4_ch8_0(42) ); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w46_4 <= DSP_bh4_ch8_0(41); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w45_3 <= DSP_bh4_ch8_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w44_3 <= DSP_bh4_ch8_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w43_3 <= DSP_bh4_ch8_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w42_3 <= DSP_bh4_ch8_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w41_3 <= DSP_bh4_ch8_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w40_3 <= DSP_bh4_ch8_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w39_3 <= DSP_bh4_ch8_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w38_2 <= DSP_bh4_ch8_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w37_2 <= DSP_bh4_ch8_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w36_2 <= DSP_bh4_ch8_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w35_2 <= DSP_bh4_ch8_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w34_2 <= DSP_bh4_ch8_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w33_2 <= DSP_bh4_ch8_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w32_2 <= DSP_bh4_ch8_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w31_2 <= DSP_bh4_ch8_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w30_2 <= DSP_bh4_ch8_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w29_2 <= DSP_bh4_ch8_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w28_1 <= DSP_bh4_ch8_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w27_1 <= DSP_bh4_ch8_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w26_1 <= DSP_bh4_ch8_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w25_1 <= DSP_bh4_ch8_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w24_1 <= DSP_bh4_ch8_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w23_1 <= DSP_bh4_ch8_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w22_1 <= DSP_bh4_ch8_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w21_0 <= DSP_bh4_ch8_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w20_0 <= DSP_bh4_ch8_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w19_0 <= DSP_bh4_ch8_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w18_0 <= DSP_bh4_ch8_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w17_0 <= DSP_bh4_ch8_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w16_0 <= DSP_bh4_ch8_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w15_0 <= DSP_bh4_ch8_0(10); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w14_0 <= DSP_bh4_ch8_0(9); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w13_0 <= DSP_bh4_ch8_0(8); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w12_0 <= DSP_bh4_ch8_0(7); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w11_0 <= DSP_bh4_ch8_0(6); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w10_0 <= DSP_bh4_ch8_0(5); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w9_0 <= DSP_bh4_ch8_0(4); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w8_0 <= DSP_bh4_ch8_0(3); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w7_0 <= DSP_bh4_ch8_0(2); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w6_0 <= DSP_bh4_ch8_0(1); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w5_0 <= DSP_bh4_ch8_0(0); -- cycle= 0 cp= 2.387e-09
   DSP_bh4_ch9_0 <= std_logic_vector(signed("" & XX_m3(64 downto 40) & "") * signed("0" & YY_m3(12 downto 0) & "0000"));
   heap_bh4_w78_5 <= not( DSP_bh4_ch9_0(42) ); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w77_5 <= DSP_bh4_ch9_0(41); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w76_5 <= DSP_bh4_ch9_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w75_5 <= DSP_bh4_ch9_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w74_5 <= DSP_bh4_ch9_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w73_5 <= DSP_bh4_ch9_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w72_5 <= DSP_bh4_ch9_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w71_6 <= DSP_bh4_ch9_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w70_6 <= DSP_bh4_ch9_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w69_5 <= DSP_bh4_ch9_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w68_5 <= DSP_bh4_ch9_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w67_5 <= DSP_bh4_ch9_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w66_5 <= DSP_bh4_ch9_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w65_5 <= DSP_bh4_ch9_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w64_6 <= DSP_bh4_ch9_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w63_6 <= DSP_bh4_ch9_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w62_5 <= DSP_bh4_ch9_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w61_5 <= DSP_bh4_ch9_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w60_5 <= DSP_bh4_ch9_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w59_5 <= DSP_bh4_ch9_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w58_5 <= DSP_bh4_ch9_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w57_5 <= DSP_bh4_ch9_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w56_5 <= DSP_bh4_ch9_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w55_5 <= DSP_bh4_ch9_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w54_5 <= DSP_bh4_ch9_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w53_5 <= DSP_bh4_ch9_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w52_4 <= DSP_bh4_ch9_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w51_4 <= DSP_bh4_ch9_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w50_4 <= DSP_bh4_ch9_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w49_4 <= DSP_bh4_ch9_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w48_4 <= DSP_bh4_ch9_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w47_5 <= DSP_bh4_ch9_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w46_5 <= DSP_bh4_ch9_0(10); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w45_4 <= DSP_bh4_ch9_0(9); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w44_4 <= DSP_bh4_ch9_0(8); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w43_4 <= DSP_bh4_ch9_0(7); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w42_4 <= DSP_bh4_ch9_0(6); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w41_4 <= DSP_bh4_ch9_0(5); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w40_4 <= DSP_bh4_ch9_0(4); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w39_4 <= DSP_bh4_ch9_0(3); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w38_3 <= DSP_bh4_ch9_0(2); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w37_3 <= DSP_bh4_ch9_0(1); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w36_3 <= DSP_bh4_ch9_0(0); -- cycle= 0 cp= 2.387e-09
   DSP_bh4_ch10_0 <= std_logic_vector(signed("0" & XX_m3(39 downto 16) & "") * signed("0" & YY_m3(12 downto 0) & "0000"));
   heap_bh4_w54_6 <= not( DSP_bh4_ch10_0(42) ); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w53_6 <= DSP_bh4_ch10_0(41); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w52_5 <= DSP_bh4_ch10_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w51_5 <= DSP_bh4_ch10_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w50_5 <= DSP_bh4_ch10_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w49_5 <= DSP_bh4_ch10_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w48_5 <= DSP_bh4_ch10_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w47_6 <= DSP_bh4_ch10_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w46_6 <= DSP_bh4_ch10_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w45_5 <= DSP_bh4_ch10_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w44_5 <= DSP_bh4_ch10_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w43_5 <= DSP_bh4_ch10_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w42_5 <= DSP_bh4_ch10_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w41_5 <= DSP_bh4_ch10_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w40_5 <= DSP_bh4_ch10_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w39_5 <= DSP_bh4_ch10_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w38_4 <= DSP_bh4_ch10_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w37_4 <= DSP_bh4_ch10_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w36_4 <= DSP_bh4_ch10_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w35_3 <= DSP_bh4_ch10_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w34_3 <= DSP_bh4_ch10_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w33_3 <= DSP_bh4_ch10_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w32_3 <= DSP_bh4_ch10_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w31_3 <= DSP_bh4_ch10_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w30_3 <= DSP_bh4_ch10_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w29_3 <= DSP_bh4_ch10_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w28_2 <= DSP_bh4_ch10_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w27_2 <= DSP_bh4_ch10_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w26_2 <= DSP_bh4_ch10_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w25_2 <= DSP_bh4_ch10_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w24_2 <= DSP_bh4_ch10_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w23_2 <= DSP_bh4_ch10_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w22_2 <= DSP_bh4_ch10_0(10); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w21_1 <= DSP_bh4_ch10_0(9); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w20_1 <= DSP_bh4_ch10_0(8); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w19_1 <= DSP_bh4_ch10_0(7); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w18_1 <= DSP_bh4_ch10_0(6); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w17_1 <= DSP_bh4_ch10_0(5); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w16_1 <= DSP_bh4_ch10_0(4); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w15_1 <= DSP_bh4_ch10_0(3); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w14_1 <= DSP_bh4_ch10_0(2); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w13_1 <= DSP_bh4_ch10_0(1); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w12_1 <= DSP_bh4_ch10_0(0); -- cycle= 0 cp= 2.387e-09
   DSP_bh4_ch11_0 <= std_logic_vector(signed("0" & XX_m3(15 downto 0) & "00000000") * signed("0" & YY_m3(12 downto 0) & "0000"));
   heap_bh4_w30_4 <= not( DSP_bh4_ch11_0(42) ); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w29_4 <= DSP_bh4_ch11_0(41); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w28_3 <= DSP_bh4_ch11_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w27_3 <= DSP_bh4_ch11_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w26_3 <= DSP_bh4_ch11_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w25_3 <= DSP_bh4_ch11_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w24_3 <= DSP_bh4_ch11_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w23_3 <= DSP_bh4_ch11_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w22_3 <= DSP_bh4_ch11_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w21_2 <= DSP_bh4_ch11_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w20_2 <= DSP_bh4_ch11_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w19_2 <= DSP_bh4_ch11_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w18_2 <= DSP_bh4_ch11_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w17_2 <= DSP_bh4_ch11_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w16_2 <= DSP_bh4_ch11_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w15_2 <= DSP_bh4_ch11_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w14_2 <= DSP_bh4_ch11_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w13_2 <= DSP_bh4_ch11_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w12_2 <= DSP_bh4_ch11_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w11_1 <= DSP_bh4_ch11_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w10_1 <= DSP_bh4_ch11_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w9_1 <= DSP_bh4_ch11_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w8_1 <= DSP_bh4_ch11_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w7_1 <= DSP_bh4_ch11_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w6_1 <= DSP_bh4_ch11_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w5_1 <= DSP_bh4_ch11_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w4_0 <= DSP_bh4_ch11_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w3_0 <= DSP_bh4_ch11_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w2_0 <= DSP_bh4_ch11_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w1_0 <= DSP_bh4_ch11_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh4_w0_0 <= DSP_bh4_ch11_0(12); -- cycle= 0 cp= 2.387e-09

   -- Adding the constant bits
   heap_bh4_w30_5 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w31_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w32_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w33_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w34_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w35_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w36_5 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w37_5 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w38_5 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w39_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w40_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w41_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w42_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w43_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w44_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w45_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w46_7 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w48_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w49_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w50_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w51_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w52_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w53_7 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w55_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w56_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w57_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w58_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w59_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w60_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w61_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w62_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w63_7 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w65_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w66_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w67_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w68_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w69_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w70_7 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w72_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w73_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w74_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w75_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w76_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w77_6 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w79_5 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w80_5 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w82_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w83_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w84_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w85_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w86_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w87_5 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w89_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w90_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w91_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w92_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w93_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w94_4 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w96_3 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w97_3 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w98_3 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w99_3 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w100_3 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w101_3 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w102_3 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w103_3 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w104_3 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w106_2 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w107_2 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w108_2 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w109_2 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w110_2 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w111_2 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w113_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w114_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w115_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w116_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w117_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w118_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w119_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w120_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w121_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w122_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w123_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w124_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w125_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w126_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w127_1 <= '1'; -- cycle= 0 cp= 0
   heap_bh4_w128_1 <= '1'; -- cycle= 0 cp= 0

   tempR_bh4_0 <= heap_bh4_w4_0 & heap_bh4_w3_0 & heap_bh4_w2_0 & heap_bh4_w1_0 & heap_bh4_w0_0; -- already compressed

   CompressorIn_bh4_0_0 <= heap_bh4_w30_5 & heap_bh4_w30_4 & heap_bh4_w30_3 & heap_bh4_w30_2 & heap_bh4_w30_1 & heap_bh4_w30_0;
      Compressor_bh4_0: Compressor_6_3
      port map ( R => CompressorOut_bh4_0_0,
                 X0 => CompressorIn_bh4_0_0);
   heap_bh4_w30_6 <= CompressorOut_bh4_0_0(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w31_5 <= CompressorOut_bh4_0_0(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w32_5 <= CompressorOut_bh4_0_0(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_1_1 <= heap_bh4_w36_5 & heap_bh4_w36_4 & heap_bh4_w36_3 & heap_bh4_w36_2 & heap_bh4_w36_1 & heap_bh4_w36_0;
      Compressor_bh4_1: Compressor_6_3
      port map ( R => CompressorOut_bh4_1_1,
                 X0 => CompressorIn_bh4_1_1);
   heap_bh4_w36_6 <= CompressorOut_bh4_1_1(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w37_6 <= CompressorOut_bh4_1_1(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w38_6 <= CompressorOut_bh4_1_1(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_2_2 <= heap_bh4_w37_5 & heap_bh4_w37_4 & heap_bh4_w37_3 & heap_bh4_w37_2 & heap_bh4_w37_1 & heap_bh4_w37_0;
      Compressor_bh4_2: Compressor_6_3
      port map ( R => CompressorOut_bh4_2_2,
                 X0 => CompressorIn_bh4_2_2);
   heap_bh4_w37_7 <= CompressorOut_bh4_2_2(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w38_7 <= CompressorOut_bh4_2_2(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w39_7 <= CompressorOut_bh4_2_2(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_3_3 <= heap_bh4_w38_5 & heap_bh4_w38_4 & heap_bh4_w38_3 & heap_bh4_w38_2 & heap_bh4_w38_1 & heap_bh4_w38_0;
      Compressor_bh4_3: Compressor_6_3
      port map ( R => CompressorOut_bh4_3_3,
                 X0 => CompressorIn_bh4_3_3);
   heap_bh4_w38_8 <= CompressorOut_bh4_3_3(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w39_8 <= CompressorOut_bh4_3_3(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w40_7 <= CompressorOut_bh4_3_3(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_4_4 <= heap_bh4_w39_6 & heap_bh4_w39_5 & heap_bh4_w39_4 & heap_bh4_w39_3 & heap_bh4_w39_2 & heap_bh4_w39_1;
      Compressor_bh4_4: Compressor_6_3
      port map ( R => CompressorOut_bh4_4_4,
                 X0 => CompressorIn_bh4_4_4);
   heap_bh4_w39_9 <= CompressorOut_bh4_4_4(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w40_8 <= CompressorOut_bh4_4_4(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w41_7 <= CompressorOut_bh4_4_4(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_5_5 <= heap_bh4_w40_6 & heap_bh4_w40_5 & heap_bh4_w40_4 & heap_bh4_w40_3 & heap_bh4_w40_2 & heap_bh4_w40_1;
      Compressor_bh4_5: Compressor_6_3
      port map ( R => CompressorOut_bh4_5_5,
                 X0 => CompressorIn_bh4_5_5);
   heap_bh4_w40_9 <= CompressorOut_bh4_5_5(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w41_8 <= CompressorOut_bh4_5_5(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w42_7 <= CompressorOut_bh4_5_5(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_6_6 <= heap_bh4_w41_6 & heap_bh4_w41_5 & heap_bh4_w41_4 & heap_bh4_w41_3 & heap_bh4_w41_2 & heap_bh4_w41_1;
      Compressor_bh4_6: Compressor_6_3
      port map ( R => CompressorOut_bh4_6_6,
                 X0 => CompressorIn_bh4_6_6);
   heap_bh4_w41_9 <= CompressorOut_bh4_6_6(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w42_8 <= CompressorOut_bh4_6_6(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w43_7 <= CompressorOut_bh4_6_6(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_7_7 <= heap_bh4_w42_6 & heap_bh4_w42_5 & heap_bh4_w42_4 & heap_bh4_w42_3 & heap_bh4_w42_2 & heap_bh4_w42_1;
      Compressor_bh4_7: Compressor_6_3
      port map ( R => CompressorOut_bh4_7_7,
                 X0 => CompressorIn_bh4_7_7);
   heap_bh4_w42_9 <= CompressorOut_bh4_7_7(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w43_8 <= CompressorOut_bh4_7_7(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w44_7 <= CompressorOut_bh4_7_7(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_8_8 <= heap_bh4_w43_6 & heap_bh4_w43_5 & heap_bh4_w43_4 & heap_bh4_w43_3 & heap_bh4_w43_2 & heap_bh4_w43_1;
      Compressor_bh4_8: Compressor_6_3
      port map ( R => CompressorOut_bh4_8_8,
                 X0 => CompressorIn_bh4_8_8);
   heap_bh4_w43_9 <= CompressorOut_bh4_8_8(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w44_8 <= CompressorOut_bh4_8_8(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w45_7 <= CompressorOut_bh4_8_8(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_9_9 <= heap_bh4_w44_6 & heap_bh4_w44_5 & heap_bh4_w44_4 & heap_bh4_w44_3 & heap_bh4_w44_2 & heap_bh4_w44_1;
      Compressor_bh4_9: Compressor_6_3
      port map ( R => CompressorOut_bh4_9_9,
                 X0 => CompressorIn_bh4_9_9);
   heap_bh4_w44_9 <= CompressorOut_bh4_9_9(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w45_8 <= CompressorOut_bh4_9_9(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w46_8 <= CompressorOut_bh4_9_9(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_10_10 <= heap_bh4_w45_6 & heap_bh4_w45_5 & heap_bh4_w45_4 & heap_bh4_w45_3 & heap_bh4_w45_2 & heap_bh4_w45_1;
      Compressor_bh4_10: Compressor_6_3
      port map ( R => CompressorOut_bh4_10_10,
                 X0 => CompressorIn_bh4_10_10);
   heap_bh4_w45_9 <= CompressorOut_bh4_10_10(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w46_9 <= CompressorOut_bh4_10_10(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w47_7 <= CompressorOut_bh4_10_10(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_11_11 <= heap_bh4_w46_7 & heap_bh4_w46_6 & heap_bh4_w46_5 & heap_bh4_w46_4 & heap_bh4_w46_3 & heap_bh4_w46_2;
      Compressor_bh4_11: Compressor_6_3
      port map ( R => CompressorOut_bh4_11_11,
                 X0 => CompressorIn_bh4_11_11);
   heap_bh4_w46_10 <= CompressorOut_bh4_11_11(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w47_8 <= CompressorOut_bh4_11_11(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w48_7 <= CompressorOut_bh4_11_11(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_12_12 <= heap_bh4_w47_6 & heap_bh4_w47_5 & heap_bh4_w47_4 & heap_bh4_w47_3 & heap_bh4_w47_2 & heap_bh4_w47_1;
      Compressor_bh4_12: Compressor_6_3
      port map ( R => CompressorOut_bh4_12_12,
                 X0 => CompressorIn_bh4_12_12);
   heap_bh4_w47_9 <= CompressorOut_bh4_12_12(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w48_8 <= CompressorOut_bh4_12_12(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w49_7 <= CompressorOut_bh4_12_12(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_13_13 <= heap_bh4_w48_6 & heap_bh4_w48_5 & heap_bh4_w48_4 & heap_bh4_w48_3 & heap_bh4_w48_2 & heap_bh4_w48_1;
      Compressor_bh4_13: Compressor_6_3
      port map ( R => CompressorOut_bh4_13_13,
                 X0 => CompressorIn_bh4_13_13);
   heap_bh4_w48_9 <= CompressorOut_bh4_13_13(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w49_8 <= CompressorOut_bh4_13_13(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w50_7 <= CompressorOut_bh4_13_13(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_14_14 <= heap_bh4_w49_6 & heap_bh4_w49_5 & heap_bh4_w49_4 & heap_bh4_w49_3 & heap_bh4_w49_2 & heap_bh4_w49_1;
      Compressor_bh4_14: Compressor_6_3
      port map ( R => CompressorOut_bh4_14_14,
                 X0 => CompressorIn_bh4_14_14);
   heap_bh4_w49_9 <= CompressorOut_bh4_14_14(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w50_8 <= CompressorOut_bh4_14_14(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w51_7 <= CompressorOut_bh4_14_14(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_15_15 <= heap_bh4_w50_6 & heap_bh4_w50_5 & heap_bh4_w50_4 & heap_bh4_w50_3 & heap_bh4_w50_2 & heap_bh4_w50_1;
      Compressor_bh4_15: Compressor_6_3
      port map ( R => CompressorOut_bh4_15_15,
                 X0 => CompressorIn_bh4_15_15);
   heap_bh4_w50_9 <= CompressorOut_bh4_15_15(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w51_8 <= CompressorOut_bh4_15_15(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w52_7 <= CompressorOut_bh4_15_15(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_16_16 <= heap_bh4_w51_6 & heap_bh4_w51_5 & heap_bh4_w51_4 & heap_bh4_w51_3 & heap_bh4_w51_2 & heap_bh4_w51_1;
      Compressor_bh4_16: Compressor_6_3
      port map ( R => CompressorOut_bh4_16_16,
                 X0 => CompressorIn_bh4_16_16);
   heap_bh4_w51_9 <= CompressorOut_bh4_16_16(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w52_8 <= CompressorOut_bh4_16_16(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w53_8 <= CompressorOut_bh4_16_16(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_17_17 <= heap_bh4_w52_6 & heap_bh4_w52_5 & heap_bh4_w52_4 & heap_bh4_w52_3 & heap_bh4_w52_2 & heap_bh4_w52_1;
      Compressor_bh4_17: Compressor_6_3
      port map ( R => CompressorOut_bh4_17_17,
                 X0 => CompressorIn_bh4_17_17);
   heap_bh4_w52_9 <= CompressorOut_bh4_17_17(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w53_9 <= CompressorOut_bh4_17_17(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w54_7 <= CompressorOut_bh4_17_17(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_18_18 <= heap_bh4_w53_7 & heap_bh4_w53_6 & heap_bh4_w53_5 & heap_bh4_w53_4 & heap_bh4_w53_3 & heap_bh4_w53_2;
      Compressor_bh4_18: Compressor_6_3
      port map ( R => CompressorOut_bh4_18_18,
                 X0 => CompressorIn_bh4_18_18);
   heap_bh4_w53_10 <= CompressorOut_bh4_18_18(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w54_8 <= CompressorOut_bh4_18_18(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w55_7 <= CompressorOut_bh4_18_18(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_19_19 <= heap_bh4_w54_6 & heap_bh4_w54_5 & heap_bh4_w54_4 & heap_bh4_w54_3 & heap_bh4_w54_2 & heap_bh4_w54_1;
      Compressor_bh4_19: Compressor_6_3
      port map ( R => CompressorOut_bh4_19_19,
                 X0 => CompressorIn_bh4_19_19);
   heap_bh4_w54_9 <= CompressorOut_bh4_19_19(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w55_8 <= CompressorOut_bh4_19_19(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w56_7 <= CompressorOut_bh4_19_19(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_20_20 <= heap_bh4_w55_6 & heap_bh4_w55_5 & heap_bh4_w55_4 & heap_bh4_w55_3 & heap_bh4_w55_2 & heap_bh4_w55_1;
      Compressor_bh4_20: Compressor_6_3
      port map ( R => CompressorOut_bh4_20_20,
                 X0 => CompressorIn_bh4_20_20);
   heap_bh4_w55_9 <= CompressorOut_bh4_20_20(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w56_8 <= CompressorOut_bh4_20_20(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w57_7 <= CompressorOut_bh4_20_20(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_21_21 <= heap_bh4_w56_6 & heap_bh4_w56_5 & heap_bh4_w56_4 & heap_bh4_w56_3 & heap_bh4_w56_2 & heap_bh4_w56_1;
      Compressor_bh4_21: Compressor_6_3
      port map ( R => CompressorOut_bh4_21_21,
                 X0 => CompressorIn_bh4_21_21);
   heap_bh4_w56_9 <= CompressorOut_bh4_21_21(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w57_8 <= CompressorOut_bh4_21_21(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w58_7 <= CompressorOut_bh4_21_21(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_22_22 <= heap_bh4_w57_6 & heap_bh4_w57_5 & heap_bh4_w57_4 & heap_bh4_w57_3 & heap_bh4_w57_2 & heap_bh4_w57_1;
      Compressor_bh4_22: Compressor_6_3
      port map ( R => CompressorOut_bh4_22_22,
                 X0 => CompressorIn_bh4_22_22);
   heap_bh4_w57_9 <= CompressorOut_bh4_22_22(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w58_8 <= CompressorOut_bh4_22_22(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w59_7 <= CompressorOut_bh4_22_22(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_23_23 <= heap_bh4_w58_6 & heap_bh4_w58_5 & heap_bh4_w58_4 & heap_bh4_w58_3 & heap_bh4_w58_2 & heap_bh4_w58_1;
      Compressor_bh4_23: Compressor_6_3
      port map ( R => CompressorOut_bh4_23_23,
                 X0 => CompressorIn_bh4_23_23);
   heap_bh4_w58_9 <= CompressorOut_bh4_23_23(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w59_8 <= CompressorOut_bh4_23_23(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w60_7 <= CompressorOut_bh4_23_23(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_24_24 <= heap_bh4_w59_6 & heap_bh4_w59_5 & heap_bh4_w59_4 & heap_bh4_w59_3 & heap_bh4_w59_2 & heap_bh4_w59_1;
      Compressor_bh4_24: Compressor_6_3
      port map ( R => CompressorOut_bh4_24_24,
                 X0 => CompressorIn_bh4_24_24);
   heap_bh4_w59_9 <= CompressorOut_bh4_24_24(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w60_8 <= CompressorOut_bh4_24_24(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w61_7 <= CompressorOut_bh4_24_24(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_25_25 <= heap_bh4_w60_6 & heap_bh4_w60_5 & heap_bh4_w60_4 & heap_bh4_w60_3 & heap_bh4_w60_2 & heap_bh4_w60_1;
      Compressor_bh4_25: Compressor_6_3
      port map ( R => CompressorOut_bh4_25_25,
                 X0 => CompressorIn_bh4_25_25);
   heap_bh4_w60_9 <= CompressorOut_bh4_25_25(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w61_8 <= CompressorOut_bh4_25_25(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w62_7 <= CompressorOut_bh4_25_25(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_26_26 <= heap_bh4_w61_6 & heap_bh4_w61_5 & heap_bh4_w61_4 & heap_bh4_w61_3 & heap_bh4_w61_2 & heap_bh4_w61_1;
      Compressor_bh4_26: Compressor_6_3
      port map ( R => CompressorOut_bh4_26_26,
                 X0 => CompressorIn_bh4_26_26);
   heap_bh4_w61_9 <= CompressorOut_bh4_26_26(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w62_8 <= CompressorOut_bh4_26_26(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w63_8 <= CompressorOut_bh4_26_26(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_27_27 <= heap_bh4_w62_6 & heap_bh4_w62_5 & heap_bh4_w62_4 & heap_bh4_w62_3 & heap_bh4_w62_2 & heap_bh4_w62_1;
      Compressor_bh4_27: Compressor_6_3
      port map ( R => CompressorOut_bh4_27_27,
                 X0 => CompressorIn_bh4_27_27);
   heap_bh4_w62_9 <= CompressorOut_bh4_27_27(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w63_9 <= CompressorOut_bh4_27_27(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w64_7 <= CompressorOut_bh4_27_27(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_28_28 <= heap_bh4_w63_7 & heap_bh4_w63_6 & heap_bh4_w63_5 & heap_bh4_w63_4 & heap_bh4_w63_3 & heap_bh4_w63_2;
      Compressor_bh4_28: Compressor_6_3
      port map ( R => CompressorOut_bh4_28_28,
                 X0 => CompressorIn_bh4_28_28);
   heap_bh4_w63_10 <= CompressorOut_bh4_28_28(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w64_8 <= CompressorOut_bh4_28_28(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w65_7 <= CompressorOut_bh4_28_28(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_29_29 <= heap_bh4_w64_6 & heap_bh4_w64_5 & heap_bh4_w64_4 & heap_bh4_w64_3 & heap_bh4_w64_2 & heap_bh4_w64_1;
      Compressor_bh4_29: Compressor_6_3
      port map ( R => CompressorOut_bh4_29_29,
                 X0 => CompressorIn_bh4_29_29);
   heap_bh4_w64_9 <= CompressorOut_bh4_29_29(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w65_8 <= CompressorOut_bh4_29_29(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w66_7 <= CompressorOut_bh4_29_29(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_30_30 <= heap_bh4_w65_6 & heap_bh4_w65_5 & heap_bh4_w65_4 & heap_bh4_w65_3 & heap_bh4_w65_2 & heap_bh4_w65_1;
      Compressor_bh4_30: Compressor_6_3
      port map ( R => CompressorOut_bh4_30_30,
                 X0 => CompressorIn_bh4_30_30);
   heap_bh4_w65_9 <= CompressorOut_bh4_30_30(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w66_8 <= CompressorOut_bh4_30_30(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w67_7 <= CompressorOut_bh4_30_30(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_31_31 <= heap_bh4_w66_6 & heap_bh4_w66_5 & heap_bh4_w66_4 & heap_bh4_w66_3 & heap_bh4_w66_2 & heap_bh4_w66_1;
      Compressor_bh4_31: Compressor_6_3
      port map ( R => CompressorOut_bh4_31_31,
                 X0 => CompressorIn_bh4_31_31);
   heap_bh4_w66_9 <= CompressorOut_bh4_31_31(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w67_8 <= CompressorOut_bh4_31_31(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w68_7 <= CompressorOut_bh4_31_31(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_32_32 <= heap_bh4_w67_6 & heap_bh4_w67_5 & heap_bh4_w67_4 & heap_bh4_w67_3 & heap_bh4_w67_2 & heap_bh4_w67_1;
      Compressor_bh4_32: Compressor_6_3
      port map ( R => CompressorOut_bh4_32_32,
                 X0 => CompressorIn_bh4_32_32);
   heap_bh4_w67_9 <= CompressorOut_bh4_32_32(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w68_8 <= CompressorOut_bh4_32_32(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w69_7 <= CompressorOut_bh4_32_32(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_33_33 <= heap_bh4_w68_6 & heap_bh4_w68_5 & heap_bh4_w68_4 & heap_bh4_w68_3 & heap_bh4_w68_2 & heap_bh4_w68_1;
      Compressor_bh4_33: Compressor_6_3
      port map ( R => CompressorOut_bh4_33_33,
                 X0 => CompressorIn_bh4_33_33);
   heap_bh4_w68_9 <= CompressorOut_bh4_33_33(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w69_8 <= CompressorOut_bh4_33_33(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w70_8 <= CompressorOut_bh4_33_33(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_34_34 <= heap_bh4_w69_6 & heap_bh4_w69_5 & heap_bh4_w69_4 & heap_bh4_w69_3 & heap_bh4_w69_2 & heap_bh4_w69_1;
      Compressor_bh4_34: Compressor_6_3
      port map ( R => CompressorOut_bh4_34_34,
                 X0 => CompressorIn_bh4_34_34);
   heap_bh4_w69_9 <= CompressorOut_bh4_34_34(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w70_9 <= CompressorOut_bh4_34_34(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w71_7 <= CompressorOut_bh4_34_34(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_35_35 <= heap_bh4_w70_7 & heap_bh4_w70_6 & heap_bh4_w70_5 & heap_bh4_w70_4 & heap_bh4_w70_3 & heap_bh4_w70_2;
      Compressor_bh4_35: Compressor_6_3
      port map ( R => CompressorOut_bh4_35_35,
                 X0 => CompressorIn_bh4_35_35);
   heap_bh4_w70_10 <= CompressorOut_bh4_35_35(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w71_8 <= CompressorOut_bh4_35_35(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w72_7 <= CompressorOut_bh4_35_35(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_36_36 <= heap_bh4_w71_6 & heap_bh4_w71_5 & heap_bh4_w71_4 & heap_bh4_w71_3 & heap_bh4_w71_2 & heap_bh4_w71_1;
      Compressor_bh4_36: Compressor_6_3
      port map ( R => CompressorOut_bh4_36_36,
                 X0 => CompressorIn_bh4_36_36);
   heap_bh4_w71_9 <= CompressorOut_bh4_36_36(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w72_8 <= CompressorOut_bh4_36_36(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w73_7 <= CompressorOut_bh4_36_36(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_37_37 <= heap_bh4_w72_6 & heap_bh4_w72_5 & heap_bh4_w72_4 & heap_bh4_w72_3 & heap_bh4_w72_2 & heap_bh4_w72_1;
      Compressor_bh4_37: Compressor_6_3
      port map ( R => CompressorOut_bh4_37_37,
                 X0 => CompressorIn_bh4_37_37);
   heap_bh4_w72_9 <= CompressorOut_bh4_37_37(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w73_8 <= CompressorOut_bh4_37_37(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w74_7 <= CompressorOut_bh4_37_37(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_38_38 <= heap_bh4_w73_6 & heap_bh4_w73_5 & heap_bh4_w73_4 & heap_bh4_w73_3 & heap_bh4_w73_2 & heap_bh4_w73_1;
      Compressor_bh4_38: Compressor_6_3
      port map ( R => CompressorOut_bh4_38_38,
                 X0 => CompressorIn_bh4_38_38);
   heap_bh4_w73_9 <= CompressorOut_bh4_38_38(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w74_8 <= CompressorOut_bh4_38_38(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w75_7 <= CompressorOut_bh4_38_38(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_39_39 <= heap_bh4_w74_6 & heap_bh4_w74_5 & heap_bh4_w74_4 & heap_bh4_w74_3 & heap_bh4_w74_2 & heap_bh4_w74_1;
      Compressor_bh4_39: Compressor_6_3
      port map ( R => CompressorOut_bh4_39_39,
                 X0 => CompressorIn_bh4_39_39);
   heap_bh4_w74_9 <= CompressorOut_bh4_39_39(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w75_8 <= CompressorOut_bh4_39_39(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w76_7 <= CompressorOut_bh4_39_39(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_40_40 <= heap_bh4_w75_6 & heap_bh4_w75_5 & heap_bh4_w75_4 & heap_bh4_w75_3 & heap_bh4_w75_2 & heap_bh4_w75_1;
      Compressor_bh4_40: Compressor_6_3
      port map ( R => CompressorOut_bh4_40_40,
                 X0 => CompressorIn_bh4_40_40);
   heap_bh4_w75_9 <= CompressorOut_bh4_40_40(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w76_8 <= CompressorOut_bh4_40_40(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w77_7 <= CompressorOut_bh4_40_40(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_41_41 <= heap_bh4_w76_6 & heap_bh4_w76_5 & heap_bh4_w76_4 & heap_bh4_w76_3 & heap_bh4_w76_2 & heap_bh4_w76_1;
      Compressor_bh4_41: Compressor_6_3
      port map ( R => CompressorOut_bh4_41_41,
                 X0 => CompressorIn_bh4_41_41);
   heap_bh4_w76_9 <= CompressorOut_bh4_41_41(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w77_8 <= CompressorOut_bh4_41_41(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w78_6 <= CompressorOut_bh4_41_41(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_42_42 <= heap_bh4_w77_6 & heap_bh4_w77_5 & heap_bh4_w77_4 & heap_bh4_w77_3 & heap_bh4_w77_2 & heap_bh4_w77_1;
      Compressor_bh4_42: Compressor_6_3
      port map ( R => CompressorOut_bh4_42_42,
                 X0 => CompressorIn_bh4_42_42);
   heap_bh4_w77_9 <= CompressorOut_bh4_42_42(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w78_7 <= CompressorOut_bh4_42_42(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w79_6 <= CompressorOut_bh4_42_42(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_43_43 <= heap_bh4_w78_5 & heap_bh4_w78_4 & heap_bh4_w78_3 & heap_bh4_w78_2 & heap_bh4_w78_1 & heap_bh4_w78_0;
      Compressor_bh4_43: Compressor_6_3
      port map ( R => CompressorOut_bh4_43_43,
                 X0 => CompressorIn_bh4_43_43);
   heap_bh4_w78_8 <= CompressorOut_bh4_43_43(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w79_7 <= CompressorOut_bh4_43_43(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w80_6 <= CompressorOut_bh4_43_43(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_44_44 <= heap_bh4_w79_5 & heap_bh4_w79_4 & heap_bh4_w79_3 & heap_bh4_w79_2 & heap_bh4_w79_1 & heap_bh4_w79_0;
      Compressor_bh4_44: Compressor_6_3
      port map ( R => CompressorOut_bh4_44_44,
                 X0 => CompressorIn_bh4_44_44);
   heap_bh4_w79_8 <= CompressorOut_bh4_44_44(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w80_7 <= CompressorOut_bh4_44_44(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w81_5 <= CompressorOut_bh4_44_44(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_45_45 <= heap_bh4_w80_5 & heap_bh4_w80_4 & heap_bh4_w80_3 & heap_bh4_w80_2 & heap_bh4_w80_1 & heap_bh4_w80_0;
      Compressor_bh4_45: Compressor_6_3
      port map ( R => CompressorOut_bh4_45_45,
                 X0 => CompressorIn_bh4_45_45);
   heap_bh4_w80_8 <= CompressorOut_bh4_45_45(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w81_6 <= CompressorOut_bh4_45_45(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w82_5 <= CompressorOut_bh4_45_45(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_46_46 <= heap_bh4_w87_5 & heap_bh4_w87_4 & heap_bh4_w87_3 & heap_bh4_w87_2 & heap_bh4_w87_1 & heap_bh4_w87_0;
      Compressor_bh4_46: Compressor_6_3
      port map ( R => CompressorOut_bh4_46_46,
                 X0 => CompressorIn_bh4_46_46);
   heap_bh4_w87_6 <= CompressorOut_bh4_46_46(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w88_5 <= CompressorOut_bh4_46_46(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w89_5 <= CompressorOut_bh4_46_46(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_47_47 <= heap_bh4_w22_3 & heap_bh4_w22_2 & heap_bh4_w22_1 & heap_bh4_w22_0;
   CompressorIn_bh4_47_48(0) <= heap_bh4_w23_3;
      Compressor_bh4_47: Compressor_14_3
      port map ( R => CompressorOut_bh4_47_47,
                 X0 => CompressorIn_bh4_47_47,
                 X1 => CompressorIn_bh4_47_48);
   heap_bh4_w22_4 <= CompressorOut_bh4_47_47(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w23_4 <= CompressorOut_bh4_47_47(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w24_4 <= CompressorOut_bh4_47_47(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_48_49 <= heap_bh4_w24_3 & heap_bh4_w24_2 & heap_bh4_w24_1 & heap_bh4_w24_0;
   CompressorIn_bh4_48_50(0) <= heap_bh4_w25_3;
      Compressor_bh4_48: Compressor_14_3
      port map ( R => CompressorOut_bh4_48_48,
                 X0 => CompressorIn_bh4_48_49,
                 X1 => CompressorIn_bh4_48_50);
   heap_bh4_w24_5 <= CompressorOut_bh4_48_48(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w25_4 <= CompressorOut_bh4_48_48(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w26_4 <= CompressorOut_bh4_48_48(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_49_51 <= heap_bh4_w26_3 & heap_bh4_w26_2 & heap_bh4_w26_1 & heap_bh4_w26_0;
   CompressorIn_bh4_49_52(0) <= heap_bh4_w27_3;
      Compressor_bh4_49: Compressor_14_3
      port map ( R => CompressorOut_bh4_49_49,
                 X0 => CompressorIn_bh4_49_51,
                 X1 => CompressorIn_bh4_49_52);
   heap_bh4_w26_5 <= CompressorOut_bh4_49_49(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w27_4 <= CompressorOut_bh4_49_49(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w28_4 <= CompressorOut_bh4_49_49(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_50_53 <= heap_bh4_w28_3 & heap_bh4_w28_2 & heap_bh4_w28_1 & heap_bh4_w28_0;
   CompressorIn_bh4_50_54(0) <= heap_bh4_w29_4;
      Compressor_bh4_50: Compressor_14_3
      port map ( R => CompressorOut_bh4_50_50,
                 X0 => CompressorIn_bh4_50_53,
                 X1 => CompressorIn_bh4_50_54);
   heap_bh4_w28_5 <= CompressorOut_bh4_50_50(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w29_5 <= CompressorOut_bh4_50_50(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w30_7 <= CompressorOut_bh4_50_50(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_51_55 <= heap_bh4_w31_4 & heap_bh4_w31_3 & heap_bh4_w31_2 & heap_bh4_w31_1;
   CompressorIn_bh4_51_56(0) <= heap_bh4_w32_4;
      Compressor_bh4_51: Compressor_14_3
      port map ( R => CompressorOut_bh4_51_51,
                 X0 => CompressorIn_bh4_51_55,
                 X1 => CompressorIn_bh4_51_56);
   heap_bh4_w31_6 <= CompressorOut_bh4_51_51(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w32_6 <= CompressorOut_bh4_51_51(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w33_5 <= CompressorOut_bh4_51_51(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_52_57 <= heap_bh4_w32_3 & heap_bh4_w32_2 & heap_bh4_w32_1 & heap_bh4_w32_0;
   CompressorIn_bh4_52_58(0) <= heap_bh4_w33_4;
      Compressor_bh4_52: Compressor_14_3
      port map ( R => CompressorOut_bh4_52_52,
                 X0 => CompressorIn_bh4_52_57,
                 X1 => CompressorIn_bh4_52_58);
   heap_bh4_w32_7 <= CompressorOut_bh4_52_52(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w33_6 <= CompressorOut_bh4_52_52(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w34_5 <= CompressorOut_bh4_52_52(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_53_59 <= heap_bh4_w33_3 & heap_bh4_w33_2 & heap_bh4_w33_1 & heap_bh4_w33_0;
   CompressorIn_bh4_53_60(0) <= heap_bh4_w34_4;
      Compressor_bh4_53: Compressor_14_3
      port map ( R => CompressorOut_bh4_53_53,
                 X0 => CompressorIn_bh4_53_59,
                 X1 => CompressorIn_bh4_53_60);
   heap_bh4_w33_7 <= CompressorOut_bh4_53_53(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w34_6 <= CompressorOut_bh4_53_53(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w35_5 <= CompressorOut_bh4_53_53(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_54_61 <= heap_bh4_w34_3 & heap_bh4_w34_2 & heap_bh4_w34_1 & heap_bh4_w34_0;
   CompressorIn_bh4_54_62(0) <= heap_bh4_w35_4;
      Compressor_bh4_54: Compressor_14_3
      port map ( R => CompressorOut_bh4_54_54,
                 X0 => CompressorIn_bh4_54_61,
                 X1 => CompressorIn_bh4_54_62);
   heap_bh4_w34_7 <= CompressorOut_bh4_54_54(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w35_6 <= CompressorOut_bh4_54_54(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w36_7 <= CompressorOut_bh4_54_54(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_55_63 <= heap_bh4_w81_4 & heap_bh4_w81_3 & heap_bh4_w81_2 & heap_bh4_w81_1;
   CompressorIn_bh4_55_64(0) <= heap_bh4_w82_4;
      Compressor_bh4_55: Compressor_14_3
      port map ( R => CompressorOut_bh4_55_55,
                 X0 => CompressorIn_bh4_55_63,
                 X1 => CompressorIn_bh4_55_64);
   heap_bh4_w81_7 <= CompressorOut_bh4_55_55(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w82_6 <= CompressorOut_bh4_55_55(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w83_5 <= CompressorOut_bh4_55_55(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_56_65 <= heap_bh4_w82_3 & heap_bh4_w82_2 & heap_bh4_w82_1 & heap_bh4_w82_0;
   CompressorIn_bh4_56_66(0) <= heap_bh4_w83_4;
      Compressor_bh4_56: Compressor_14_3
      port map ( R => CompressorOut_bh4_56_56,
                 X0 => CompressorIn_bh4_56_65,
                 X1 => CompressorIn_bh4_56_66);
   heap_bh4_w82_7 <= CompressorOut_bh4_56_56(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w83_6 <= CompressorOut_bh4_56_56(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w84_5 <= CompressorOut_bh4_56_56(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_57_67 <= heap_bh4_w83_3 & heap_bh4_w83_2 & heap_bh4_w83_1 & heap_bh4_w83_0;
   CompressorIn_bh4_57_68(0) <= heap_bh4_w84_4;
      Compressor_bh4_57: Compressor_14_3
      port map ( R => CompressorOut_bh4_57_57,
                 X0 => CompressorIn_bh4_57_67,
                 X1 => CompressorIn_bh4_57_68);
   heap_bh4_w83_7 <= CompressorOut_bh4_57_57(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w84_6 <= CompressorOut_bh4_57_57(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w85_5 <= CompressorOut_bh4_57_57(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_58_69 <= heap_bh4_w84_3 & heap_bh4_w84_2 & heap_bh4_w84_1 & heap_bh4_w84_0;
   CompressorIn_bh4_58_70(0) <= heap_bh4_w85_4;
      Compressor_bh4_58: Compressor_14_3
      port map ( R => CompressorOut_bh4_58_58,
                 X0 => CompressorIn_bh4_58_69,
                 X1 => CompressorIn_bh4_58_70);
   heap_bh4_w84_7 <= CompressorOut_bh4_58_58(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w85_6 <= CompressorOut_bh4_58_58(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w86_5 <= CompressorOut_bh4_58_58(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_59_71 <= heap_bh4_w85_3 & heap_bh4_w85_2 & heap_bh4_w85_1 & heap_bh4_w85_0;
   CompressorIn_bh4_59_72(0) <= heap_bh4_w86_4;
      Compressor_bh4_59: Compressor_14_3
      port map ( R => CompressorOut_bh4_59_59,
                 X0 => CompressorIn_bh4_59_71,
                 X1 => CompressorIn_bh4_59_72);
   heap_bh4_w85_7 <= CompressorOut_bh4_59_59(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w86_6 <= CompressorOut_bh4_59_59(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w87_7 <= CompressorOut_bh4_59_59(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_60_73 <= heap_bh4_w88_4 & heap_bh4_w88_3 & heap_bh4_w88_2 & heap_bh4_w88_1;
   CompressorIn_bh4_60_74(0) <= heap_bh4_w89_4;
      Compressor_bh4_60: Compressor_14_3
      port map ( R => CompressorOut_bh4_60_60,
                 X0 => CompressorIn_bh4_60_73,
                 X1 => CompressorIn_bh4_60_74);
   heap_bh4_w88_6 <= CompressorOut_bh4_60_60(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w89_6 <= CompressorOut_bh4_60_60(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w90_5 <= CompressorOut_bh4_60_60(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_61_75 <= heap_bh4_w89_3 & heap_bh4_w89_2 & heap_bh4_w89_1 & heap_bh4_w89_0;
   CompressorIn_bh4_61_76(0) <= heap_bh4_w90_4;
      Compressor_bh4_61: Compressor_14_3
      port map ( R => CompressorOut_bh4_61_61,
                 X0 => CompressorIn_bh4_61_75,
                 X1 => CompressorIn_bh4_61_76);
   heap_bh4_w89_7 <= CompressorOut_bh4_61_61(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w90_6 <= CompressorOut_bh4_61_61(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w91_5 <= CompressorOut_bh4_61_61(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_62_77 <= heap_bh4_w90_3 & heap_bh4_w90_2 & heap_bh4_w90_1 & heap_bh4_w90_0;
   CompressorIn_bh4_62_78(0) <= heap_bh4_w91_4;
      Compressor_bh4_62: Compressor_14_3
      port map ( R => CompressorOut_bh4_62_62,
                 X0 => CompressorIn_bh4_62_77,
                 X1 => CompressorIn_bh4_62_78);
   heap_bh4_w90_7 <= CompressorOut_bh4_62_62(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w91_6 <= CompressorOut_bh4_62_62(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w92_5 <= CompressorOut_bh4_62_62(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_63_79 <= heap_bh4_w91_3 & heap_bh4_w91_2 & heap_bh4_w91_1 & heap_bh4_w91_0;
   CompressorIn_bh4_63_80(0) <= heap_bh4_w92_4;
      Compressor_bh4_63: Compressor_14_3
      port map ( R => CompressorOut_bh4_63_63,
                 X0 => CompressorIn_bh4_63_79,
                 X1 => CompressorIn_bh4_63_80);
   heap_bh4_w91_7 <= CompressorOut_bh4_63_63(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w92_6 <= CompressorOut_bh4_63_63(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w93_5 <= CompressorOut_bh4_63_63(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_64_81 <= heap_bh4_w92_3 & heap_bh4_w92_2 & heap_bh4_w92_1 & heap_bh4_w92_0;
   CompressorIn_bh4_64_82(0) <= heap_bh4_w93_4;
      Compressor_bh4_64: Compressor_14_3
      port map ( R => CompressorOut_bh4_64_64,
                 X0 => CompressorIn_bh4_64_81,
                 X1 => CompressorIn_bh4_64_82);
   heap_bh4_w92_7 <= CompressorOut_bh4_64_64(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w93_6 <= CompressorOut_bh4_64_64(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w94_5 <= CompressorOut_bh4_64_64(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_65_83 <= heap_bh4_w93_3 & heap_bh4_w93_2 & heap_bh4_w93_1 & heap_bh4_w93_0;
   CompressorIn_bh4_65_84(0) <= heap_bh4_w94_4;
      Compressor_bh4_65: Compressor_14_3
      port map ( R => CompressorOut_bh4_65_65,
                 X0 => CompressorIn_bh4_65_83,
                 X1 => CompressorIn_bh4_65_84);
   heap_bh4_w93_7 <= CompressorOut_bh4_65_65(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w94_6 <= CompressorOut_bh4_65_65(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w95_4 <= CompressorOut_bh4_65_65(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_66_85 <= heap_bh4_w94_3 & heap_bh4_w94_2 & heap_bh4_w94_1 & heap_bh4_w94_0;
   CompressorIn_bh4_66_86(0) <= heap_bh4_w95_3;
      Compressor_bh4_66: Compressor_14_3
      port map ( R => CompressorOut_bh4_66_66,
                 X0 => CompressorIn_bh4_66_85,
                 X1 => CompressorIn_bh4_66_86);
   heap_bh4_w94_7 <= CompressorOut_bh4_66_66(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w95_5 <= CompressorOut_bh4_66_66(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w96_4 <= CompressorOut_bh4_66_66(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_67_87 <= heap_bh4_w96_3 & heap_bh4_w96_2 & heap_bh4_w96_1 & heap_bh4_w96_0;
   CompressorIn_bh4_67_88(0) <= heap_bh4_w97_3;
      Compressor_bh4_67: Compressor_14_3
      port map ( R => CompressorOut_bh4_67_67,
                 X0 => CompressorIn_bh4_67_87,
                 X1 => CompressorIn_bh4_67_88);
   heap_bh4_w96_5 <= CompressorOut_bh4_67_67(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w97_4 <= CompressorOut_bh4_67_67(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w98_4 <= CompressorOut_bh4_67_67(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_68_89 <= heap_bh4_w98_3 & heap_bh4_w98_2 & heap_bh4_w98_1 & heap_bh4_w98_0;
   CompressorIn_bh4_68_90(0) <= heap_bh4_w99_3;
      Compressor_bh4_68: Compressor_14_3
      port map ( R => CompressorOut_bh4_68_68,
                 X0 => CompressorIn_bh4_68_89,
                 X1 => CompressorIn_bh4_68_90);
   heap_bh4_w98_5 <= CompressorOut_bh4_68_68(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w99_4 <= CompressorOut_bh4_68_68(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w100_4 <= CompressorOut_bh4_68_68(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_69_91 <= heap_bh4_w100_3 & heap_bh4_w100_2 & heap_bh4_w100_1 & heap_bh4_w100_0;
   CompressorIn_bh4_69_92(0) <= heap_bh4_w101_3;
      Compressor_bh4_69: Compressor_14_3
      port map ( R => CompressorOut_bh4_69_69,
                 X0 => CompressorIn_bh4_69_91,
                 X1 => CompressorIn_bh4_69_92);
   heap_bh4_w100_5 <= CompressorOut_bh4_69_69(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w101_4 <= CompressorOut_bh4_69_69(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w102_4 <= CompressorOut_bh4_69_69(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_70_93 <= heap_bh4_w102_3 & heap_bh4_w102_2 & heap_bh4_w102_1 & heap_bh4_w102_0;
   CompressorIn_bh4_70_94(0) <= heap_bh4_w103_3;
      Compressor_bh4_70: Compressor_14_3
      port map ( R => CompressorOut_bh4_70_70,
                 X0 => CompressorIn_bh4_70_93,
                 X1 => CompressorIn_bh4_70_94);
   heap_bh4_w102_5 <= CompressorOut_bh4_70_70(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w103_4 <= CompressorOut_bh4_70_70(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w104_4 <= CompressorOut_bh4_70_70(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_71_95 <= heap_bh4_w104_3 & heap_bh4_w104_2 & heap_bh4_w104_1 & heap_bh4_w104_0;
   CompressorIn_bh4_71_96(0) <= heap_bh4_w105_2;
      Compressor_bh4_71: Compressor_14_3
      port map ( R => CompressorOut_bh4_71_71,
                 X0 => CompressorIn_bh4_71_95,
                 X1 => CompressorIn_bh4_71_96);
   heap_bh4_w104_5 <= CompressorOut_bh4_71_71(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w105_3 <= CompressorOut_bh4_71_71(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w106_3 <= CompressorOut_bh4_71_71(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_72_97 <= heap_bh4_w29_3 & heap_bh4_w29_2 & heap_bh4_w29_1 & heap_bh4_w29_0;
      Compressor_bh4_72: Compressor_4_3
      port map ( R => CompressorOut_bh4_72_72,
                 X0 => CompressorIn_bh4_72_97);
   heap_bh4_w29_6 <= CompressorOut_bh4_72_72(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w30_8 <= CompressorOut_bh4_72_72(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w31_7 <= CompressorOut_bh4_72_72(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_73_98 <= heap_bh4_w35_3 & heap_bh4_w35_2 & heap_bh4_w35_1 & heap_bh4_w35_0;
      Compressor_bh4_73: Compressor_4_3
      port map ( R => CompressorOut_bh4_73_73,
                 X0 => CompressorIn_bh4_73_98);
   heap_bh4_w35_7 <= CompressorOut_bh4_73_73(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w36_8 <= CompressorOut_bh4_73_73(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w37_8 <= CompressorOut_bh4_73_73(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_74_99 <= heap_bh4_w86_3 & heap_bh4_w86_2 & heap_bh4_w86_1 & heap_bh4_w86_0;
      Compressor_bh4_74: Compressor_4_3
      port map ( R => CompressorOut_bh4_74_74,
                 X0 => CompressorIn_bh4_74_99);
   heap_bh4_w86_7 <= CompressorOut_bh4_74_74(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w87_8 <= CompressorOut_bh4_74_74(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w88_7 <= CompressorOut_bh4_74_74(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_75_100 <= heap_bh4_w12_2 & heap_bh4_w12_1 & heap_bh4_w12_0;
   CompressorIn_bh4_75_101 <= heap_bh4_w13_2 & heap_bh4_w13_1;
      Compressor_bh4_75: Compressor_23_3
      port map ( R => CompressorOut_bh4_75_75,
                 X0 => CompressorIn_bh4_75_100,
                 X1 => CompressorIn_bh4_75_101);
   heap_bh4_w12_3 <= CompressorOut_bh4_75_75(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w13_3 <= CompressorOut_bh4_75_75(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w14_3 <= CompressorOut_bh4_75_75(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_76_102 <= heap_bh4_w14_2 & heap_bh4_w14_1 & heap_bh4_w14_0;
   CompressorIn_bh4_76_103 <= heap_bh4_w15_2 & heap_bh4_w15_1;
      Compressor_bh4_76: Compressor_23_3
      port map ( R => CompressorOut_bh4_76_76,
                 X0 => CompressorIn_bh4_76_102,
                 X1 => CompressorIn_bh4_76_103);
   heap_bh4_w14_4 <= CompressorOut_bh4_76_76(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w15_3 <= CompressorOut_bh4_76_76(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w16_3 <= CompressorOut_bh4_76_76(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_77_104 <= heap_bh4_w16_2 & heap_bh4_w16_1 & heap_bh4_w16_0;
   CompressorIn_bh4_77_105 <= heap_bh4_w17_2 & heap_bh4_w17_1;
      Compressor_bh4_77: Compressor_23_3
      port map ( R => CompressorOut_bh4_77_77,
                 X0 => CompressorIn_bh4_77_104,
                 X1 => CompressorIn_bh4_77_105);
   heap_bh4_w16_4 <= CompressorOut_bh4_77_77(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w17_3 <= CompressorOut_bh4_77_77(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w18_3 <= CompressorOut_bh4_77_77(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_78_106 <= heap_bh4_w18_2 & heap_bh4_w18_1 & heap_bh4_w18_0;
   CompressorIn_bh4_78_107 <= heap_bh4_w19_2 & heap_bh4_w19_1;
      Compressor_bh4_78: Compressor_23_3
      port map ( R => CompressorOut_bh4_78_78,
                 X0 => CompressorIn_bh4_78_106,
                 X1 => CompressorIn_bh4_78_107);
   heap_bh4_w18_4 <= CompressorOut_bh4_78_78(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w19_3 <= CompressorOut_bh4_78_78(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w20_3 <= CompressorOut_bh4_78_78(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_79_108 <= heap_bh4_w20_2 & heap_bh4_w20_1 & heap_bh4_w20_0;
   CompressorIn_bh4_79_109 <= heap_bh4_w21_2 & heap_bh4_w21_1;
      Compressor_bh4_79: Compressor_23_3
      port map ( R => CompressorOut_bh4_79_79,
                 X0 => CompressorIn_bh4_79_108,
                 X1 => CompressorIn_bh4_79_109);
   heap_bh4_w20_4 <= CompressorOut_bh4_79_79(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w21_3 <= CompressorOut_bh4_79_79(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w22_5 <= CompressorOut_bh4_79_79(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_80_110 <= heap_bh4_w106_2 & heap_bh4_w106_1 & heap_bh4_w106_0;
   CompressorIn_bh4_80_111 <= heap_bh4_w107_2 & heap_bh4_w107_1;
      Compressor_bh4_80: Compressor_23_3
      port map ( R => CompressorOut_bh4_80_80,
                 X0 => CompressorIn_bh4_80_110,
                 X1 => CompressorIn_bh4_80_111);
   heap_bh4_w106_4 <= CompressorOut_bh4_80_80(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w107_3 <= CompressorOut_bh4_80_80(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w108_3 <= CompressorOut_bh4_80_80(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_81_112 <= heap_bh4_w108_2 & heap_bh4_w108_1 & heap_bh4_w108_0;
   CompressorIn_bh4_81_113 <= heap_bh4_w109_2 & heap_bh4_w109_1;
      Compressor_bh4_81: Compressor_23_3
      port map ( R => CompressorOut_bh4_81_81,
                 X0 => CompressorIn_bh4_81_112,
                 X1 => CompressorIn_bh4_81_113);
   heap_bh4_w108_4 <= CompressorOut_bh4_81_81(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w109_3 <= CompressorOut_bh4_81_81(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w110_3 <= CompressorOut_bh4_81_81(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_82_114 <= heap_bh4_w110_2 & heap_bh4_w110_1 & heap_bh4_w110_0;
   CompressorIn_bh4_82_115 <= heap_bh4_w111_2 & heap_bh4_w111_1;
      Compressor_bh4_82: Compressor_23_3
      port map ( R => CompressorOut_bh4_82_82,
                 X0 => CompressorIn_bh4_82_114,
                 X1 => CompressorIn_bh4_82_115);
   heap_bh4_w110_4 <= CompressorOut_bh4_82_82(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w111_3 <= CompressorOut_bh4_82_82(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w112_2 <= CompressorOut_bh4_82_82(2); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_83_116 <= heap_bh4_w23_2 & heap_bh4_w23_1 & heap_bh4_w23_0;
      Compressor_bh4_83: Compressor_3_2
      port map ( R => CompressorOut_bh4_83_83,
                 X0 => CompressorIn_bh4_83_116);
   heap_bh4_w23_5 <= CompressorOut_bh4_83_83(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w24_6 <= CompressorOut_bh4_83_83(1); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_84_117 <= heap_bh4_w25_2 & heap_bh4_w25_1 & heap_bh4_w25_0;
      Compressor_bh4_84: Compressor_3_2
      port map ( R => CompressorOut_bh4_84_84,
                 X0 => CompressorIn_bh4_84_117);
   heap_bh4_w25_5 <= CompressorOut_bh4_84_84(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w26_6 <= CompressorOut_bh4_84_84(1); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_85_118 <= heap_bh4_w27_2 & heap_bh4_w27_1 & heap_bh4_w27_0;
      Compressor_bh4_85: Compressor_3_2
      port map ( R => CompressorOut_bh4_85_85,
                 X0 => CompressorIn_bh4_85_118);
   heap_bh4_w27_5 <= CompressorOut_bh4_85_85(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w28_6 <= CompressorOut_bh4_85_85(1); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_86_119 <= heap_bh4_w95_2 & heap_bh4_w95_1 & heap_bh4_w95_0;
      Compressor_bh4_86: Compressor_3_2
      port map ( R => CompressorOut_bh4_86_86,
                 X0 => CompressorIn_bh4_86_119);
   heap_bh4_w95_6 <= CompressorOut_bh4_86_86(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w96_6 <= CompressorOut_bh4_86_86(1); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_87_120 <= heap_bh4_w97_2 & heap_bh4_w97_1 & heap_bh4_w97_0;
      Compressor_bh4_87: Compressor_3_2
      port map ( R => CompressorOut_bh4_87_87,
                 X0 => CompressorIn_bh4_87_120);
   heap_bh4_w97_5 <= CompressorOut_bh4_87_87(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w98_6 <= CompressorOut_bh4_87_87(1); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_88_121 <= heap_bh4_w99_2 & heap_bh4_w99_1 & heap_bh4_w99_0;
      Compressor_bh4_88: Compressor_3_2
      port map ( R => CompressorOut_bh4_88_88,
                 X0 => CompressorIn_bh4_88_121);
   heap_bh4_w99_5 <= CompressorOut_bh4_88_88(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w100_6 <= CompressorOut_bh4_88_88(1); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_89_122 <= heap_bh4_w101_2 & heap_bh4_w101_1 & heap_bh4_w101_0;
      Compressor_bh4_89: Compressor_3_2
      port map ( R => CompressorOut_bh4_89_89,
                 X0 => CompressorIn_bh4_89_122);
   heap_bh4_w101_5 <= CompressorOut_bh4_89_89(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w102_6 <= CompressorOut_bh4_89_89(1); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_90_123 <= heap_bh4_w103_2 & heap_bh4_w103_1 & heap_bh4_w103_0;
      Compressor_bh4_90: Compressor_3_2
      port map ( R => CompressorOut_bh4_90_90,
                 X0 => CompressorIn_bh4_90_123);
   heap_bh4_w103_5 <= CompressorOut_bh4_90_90(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh4_w104_6 <= CompressorOut_bh4_90_90(1); -- cycle= 0 cp= 2.91772e-09

   CompressorIn_bh4_91_124 <= heap_bh4_w31_0 & heap_bh4_w31_7 & heap_bh4_w31_6 & heap_bh4_w31_5;
   CompressorIn_bh4_91_125(0) <= heap_bh4_w32_7;
      Compressor_bh4_91: Compressor_14_3
      port map ( R => CompressorOut_bh4_91_91,
                 X0 => CompressorIn_bh4_91_124,
                 X1 => CompressorIn_bh4_91_125);
   heap_bh4_w31_8 <= CompressorOut_bh4_91_91(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w32_8 <= CompressorOut_bh4_91_91(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w33_8 <= CompressorOut_bh4_91_91(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_92_126 <= heap_bh4_w39_0 & heap_bh4_w39_9 & heap_bh4_w39_8 & heap_bh4_w39_7;
   CompressorIn_bh4_92_127(0) <= heap_bh4_w40_0;
      Compressor_bh4_92: Compressor_14_3
      port map ( R => CompressorOut_bh4_92_92,
                 X0 => CompressorIn_bh4_92_126,
                 X1 => CompressorIn_bh4_92_127);
   heap_bh4_w39_10 <= CompressorOut_bh4_92_92(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w40_10 <= CompressorOut_bh4_92_92(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w41_10 <= CompressorOut_bh4_92_92(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_93_128 <= heap_bh4_w41_0 & heap_bh4_w41_9 & heap_bh4_w41_8 & heap_bh4_w41_7;
   CompressorIn_bh4_93_129(0) <= heap_bh4_w42_0;
      Compressor_bh4_93: Compressor_14_3
      port map ( R => CompressorOut_bh4_93_93,
                 X0 => CompressorIn_bh4_93_128,
                 X1 => CompressorIn_bh4_93_129);
   heap_bh4_w41_11 <= CompressorOut_bh4_93_93(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w42_10 <= CompressorOut_bh4_93_93(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w43_10 <= CompressorOut_bh4_93_93(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_94_130 <= heap_bh4_w43_0 & heap_bh4_w43_9 & heap_bh4_w43_8 & heap_bh4_w43_7;
   CompressorIn_bh4_94_131(0) <= heap_bh4_w44_0;
      Compressor_bh4_94: Compressor_14_3
      port map ( R => CompressorOut_bh4_94_94,
                 X0 => CompressorIn_bh4_94_130,
                 X1 => CompressorIn_bh4_94_131);
   heap_bh4_w43_11 <= CompressorOut_bh4_94_94(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w44_10 <= CompressorOut_bh4_94_94(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w45_10 <= CompressorOut_bh4_94_94(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_95_132 <= heap_bh4_w45_0 & heap_bh4_w45_9 & heap_bh4_w45_8 & heap_bh4_w45_7;
   CompressorIn_bh4_95_133(0) <= heap_bh4_w46_1;
      Compressor_bh4_95: Compressor_14_3
      port map ( R => CompressorOut_bh4_95_95,
                 X0 => CompressorIn_bh4_95_132,
                 X1 => CompressorIn_bh4_95_133);
   heap_bh4_w45_11 <= CompressorOut_bh4_95_95(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w46_11 <= CompressorOut_bh4_95_95(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w47_10 <= CompressorOut_bh4_95_95(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_96_134 <= heap_bh4_w46_0 & heap_bh4_w46_10 & heap_bh4_w46_9 & heap_bh4_w46_8;
   CompressorIn_bh4_96_135(0) <= heap_bh4_w47_0;
      Compressor_bh4_96: Compressor_14_3
      port map ( R => CompressorOut_bh4_96_96,
                 X0 => CompressorIn_bh4_96_134,
                 X1 => CompressorIn_bh4_96_135);
   heap_bh4_w46_12 <= CompressorOut_bh4_96_96(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w47_11 <= CompressorOut_bh4_96_96(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w48_10 <= CompressorOut_bh4_96_96(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_97_136 <= heap_bh4_w48_0 & heap_bh4_w48_9 & heap_bh4_w48_8 & heap_bh4_w48_7;
   CompressorIn_bh4_97_137(0) <= heap_bh4_w49_0;
      Compressor_bh4_97: Compressor_14_3
      port map ( R => CompressorOut_bh4_97_97,
                 X0 => CompressorIn_bh4_97_136,
                 X1 => CompressorIn_bh4_97_137);
   heap_bh4_w48_11 <= CompressorOut_bh4_97_97(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w49_10 <= CompressorOut_bh4_97_97(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w50_10 <= CompressorOut_bh4_97_97(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_98_138 <= heap_bh4_w50_0 & heap_bh4_w50_9 & heap_bh4_w50_8 & heap_bh4_w50_7;
   CompressorIn_bh4_98_139(0) <= heap_bh4_w51_0;
      Compressor_bh4_98: Compressor_14_3
      port map ( R => CompressorOut_bh4_98_98,
                 X0 => CompressorIn_bh4_98_138,
                 X1 => CompressorIn_bh4_98_139);
   heap_bh4_w50_11 <= CompressorOut_bh4_98_98(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w51_10 <= CompressorOut_bh4_98_98(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w52_10 <= CompressorOut_bh4_98_98(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_99_140 <= heap_bh4_w52_0 & heap_bh4_w52_9 & heap_bh4_w52_8 & heap_bh4_w52_7;
   CompressorIn_bh4_99_141(0) <= heap_bh4_w53_1;
      Compressor_bh4_99: Compressor_14_3
      port map ( R => CompressorOut_bh4_99_99,
                 X0 => CompressorIn_bh4_99_140,
                 X1 => CompressorIn_bh4_99_141);
   heap_bh4_w52_11 <= CompressorOut_bh4_99_99(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w53_11 <= CompressorOut_bh4_99_99(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w54_10 <= CompressorOut_bh4_99_99(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_100_142 <= heap_bh4_w53_0 & heap_bh4_w53_10 & heap_bh4_w53_9 & heap_bh4_w53_8;
   CompressorIn_bh4_100_143(0) <= heap_bh4_w54_0;
      Compressor_bh4_100: Compressor_14_3
      port map ( R => CompressorOut_bh4_100_100,
                 X0 => CompressorIn_bh4_100_142,
                 X1 => CompressorIn_bh4_100_143);
   heap_bh4_w53_12 <= CompressorOut_bh4_100_100(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w54_11 <= CompressorOut_bh4_100_100(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w55_10 <= CompressorOut_bh4_100_100(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_101_144 <= heap_bh4_w55_0 & heap_bh4_w55_9 & heap_bh4_w55_8 & heap_bh4_w55_7;
   CompressorIn_bh4_101_145(0) <= heap_bh4_w56_0;
      Compressor_bh4_101: Compressor_14_3
      port map ( R => CompressorOut_bh4_101_101,
                 X0 => CompressorIn_bh4_101_144,
                 X1 => CompressorIn_bh4_101_145);
   heap_bh4_w55_11 <= CompressorOut_bh4_101_101(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w56_10 <= CompressorOut_bh4_101_101(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w57_10 <= CompressorOut_bh4_101_101(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_102_146 <= heap_bh4_w57_0 & heap_bh4_w57_9 & heap_bh4_w57_8 & heap_bh4_w57_7;
   CompressorIn_bh4_102_147(0) <= heap_bh4_w58_0;
      Compressor_bh4_102: Compressor_14_3
      port map ( R => CompressorOut_bh4_102_102,
                 X0 => CompressorIn_bh4_102_146,
                 X1 => CompressorIn_bh4_102_147);
   heap_bh4_w57_11 <= CompressorOut_bh4_102_102(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w58_10 <= CompressorOut_bh4_102_102(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w59_10 <= CompressorOut_bh4_102_102(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_103_148 <= heap_bh4_w59_0 & heap_bh4_w59_9 & heap_bh4_w59_8 & heap_bh4_w59_7;
   CompressorIn_bh4_103_149(0) <= heap_bh4_w60_0;
      Compressor_bh4_103: Compressor_14_3
      port map ( R => CompressorOut_bh4_103_103,
                 X0 => CompressorIn_bh4_103_148,
                 X1 => CompressorIn_bh4_103_149);
   heap_bh4_w59_11 <= CompressorOut_bh4_103_103(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w60_10 <= CompressorOut_bh4_103_103(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w61_10 <= CompressorOut_bh4_103_103(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_104_150 <= heap_bh4_w61_0 & heap_bh4_w61_9 & heap_bh4_w61_8 & heap_bh4_w61_7;
   CompressorIn_bh4_104_151(0) <= heap_bh4_w62_0;
      Compressor_bh4_104: Compressor_14_3
      port map ( R => CompressorOut_bh4_104_104,
                 X0 => CompressorIn_bh4_104_150,
                 X1 => CompressorIn_bh4_104_151);
   heap_bh4_w61_11 <= CompressorOut_bh4_104_104(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w62_10 <= CompressorOut_bh4_104_104(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w63_11 <= CompressorOut_bh4_104_104(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_105_152 <= heap_bh4_w63_1 & heap_bh4_w63_0 & heap_bh4_w63_10 & heap_bh4_w63_9;
   CompressorIn_bh4_105_153(0) <= heap_bh4_w64_0;
      Compressor_bh4_105: Compressor_14_3
      port map ( R => CompressorOut_bh4_105_105,
                 X0 => CompressorIn_bh4_105_152,
                 X1 => CompressorIn_bh4_105_153);
   heap_bh4_w63_12 <= CompressorOut_bh4_105_105(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w64_10 <= CompressorOut_bh4_105_105(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w65_10 <= CompressorOut_bh4_105_105(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_106_154 <= heap_bh4_w65_0 & heap_bh4_w65_9 & heap_bh4_w65_8 & heap_bh4_w65_7;
   CompressorIn_bh4_106_155(0) <= heap_bh4_w66_0;
      Compressor_bh4_106: Compressor_14_3
      port map ( R => CompressorOut_bh4_106_106,
                 X0 => CompressorIn_bh4_106_154,
                 X1 => CompressorIn_bh4_106_155);
   heap_bh4_w65_11 <= CompressorOut_bh4_106_106(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w66_10 <= CompressorOut_bh4_106_106(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w67_10 <= CompressorOut_bh4_106_106(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_107_156 <= heap_bh4_w67_0 & heap_bh4_w67_9 & heap_bh4_w67_8 & heap_bh4_w67_7;
   CompressorIn_bh4_107_157(0) <= heap_bh4_w68_0;
      Compressor_bh4_107: Compressor_14_3
      port map ( R => CompressorOut_bh4_107_107,
                 X0 => CompressorIn_bh4_107_156,
                 X1 => CompressorIn_bh4_107_157);
   heap_bh4_w67_11 <= CompressorOut_bh4_107_107(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w68_10 <= CompressorOut_bh4_107_107(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w69_10 <= CompressorOut_bh4_107_107(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_108_158 <= heap_bh4_w69_0 & heap_bh4_w69_9 & heap_bh4_w69_8 & heap_bh4_w69_7;
   CompressorIn_bh4_108_159(0) <= heap_bh4_w70_1;
      Compressor_bh4_108: Compressor_14_3
      port map ( R => CompressorOut_bh4_108_108,
                 X0 => CompressorIn_bh4_108_158,
                 X1 => CompressorIn_bh4_108_159);
   heap_bh4_w69_11 <= CompressorOut_bh4_108_108(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w70_11 <= CompressorOut_bh4_108_108(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w71_10 <= CompressorOut_bh4_108_108(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_109_160 <= heap_bh4_w70_0 & heap_bh4_w70_10 & heap_bh4_w70_9 & heap_bh4_w70_8;
   CompressorIn_bh4_109_161(0) <= heap_bh4_w71_0;
      Compressor_bh4_109: Compressor_14_3
      port map ( R => CompressorOut_bh4_109_109,
                 X0 => CompressorIn_bh4_109_160,
                 X1 => CompressorIn_bh4_109_161);
   heap_bh4_w70_12 <= CompressorOut_bh4_109_109(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w71_11 <= CompressorOut_bh4_109_109(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w72_10 <= CompressorOut_bh4_109_109(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_110_162 <= heap_bh4_w72_0 & heap_bh4_w72_9 & heap_bh4_w72_8 & heap_bh4_w72_7;
   CompressorIn_bh4_110_163(0) <= heap_bh4_w73_0;
      Compressor_bh4_110: Compressor_14_3
      port map ( R => CompressorOut_bh4_110_110,
                 X0 => CompressorIn_bh4_110_162,
                 X1 => CompressorIn_bh4_110_163);
   heap_bh4_w72_11 <= CompressorOut_bh4_110_110(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w73_10 <= CompressorOut_bh4_110_110(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w74_10 <= CompressorOut_bh4_110_110(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_111_164 <= heap_bh4_w74_0 & heap_bh4_w74_9 & heap_bh4_w74_8 & heap_bh4_w74_7;
   CompressorIn_bh4_111_165(0) <= heap_bh4_w75_0;
      Compressor_bh4_111: Compressor_14_3
      port map ( R => CompressorOut_bh4_111_111,
                 X0 => CompressorIn_bh4_111_164,
                 X1 => CompressorIn_bh4_111_165);
   heap_bh4_w74_11 <= CompressorOut_bh4_111_111(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w75_10 <= CompressorOut_bh4_111_111(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w76_10 <= CompressorOut_bh4_111_111(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_112_166 <= heap_bh4_w76_0 & heap_bh4_w76_9 & heap_bh4_w76_8 & heap_bh4_w76_7;
   CompressorIn_bh4_112_167(0) <= heap_bh4_w77_0;
      Compressor_bh4_112: Compressor_14_3
      port map ( R => CompressorOut_bh4_112_112,
                 X0 => CompressorIn_bh4_112_166,
                 X1 => CompressorIn_bh4_112_167);
   heap_bh4_w76_11 <= CompressorOut_bh4_112_112(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w77_10 <= CompressorOut_bh4_112_112(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w78_9 <= CompressorOut_bh4_112_112(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_113_168 <= heap_bh4_w81_0 & heap_bh4_w81_7 & heap_bh4_w81_6 & heap_bh4_w81_5;
   CompressorIn_bh4_113_169(0) <= heap_bh4_w82_7;
      Compressor_bh4_113: Compressor_14_3
      port map ( R => CompressorOut_bh4_113_113,
                 X0 => CompressorIn_bh4_113_168,
                 X1 => CompressorIn_bh4_113_169);
   heap_bh4_w81_8 <= CompressorOut_bh4_113_113(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w82_8 <= CompressorOut_bh4_113_113(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w83_8 <= CompressorOut_bh4_113_113(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_114_170 <= heap_bh4_w88_0 & heap_bh4_w88_7 & heap_bh4_w88_6 & heap_bh4_w88_5;
   CompressorIn_bh4_114_171(0) <= heap_bh4_w89_7;
      Compressor_bh4_114: Compressor_14_3
      port map ( R => CompressorOut_bh4_114_114,
                 X0 => CompressorIn_bh4_114_170,
                 X1 => CompressorIn_bh4_114_171);
   heap_bh4_w88_8 <= CompressorOut_bh4_114_114(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w89_8 <= CompressorOut_bh4_114_114(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w90_8 <= CompressorOut_bh4_114_114(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_115_172 <= heap_bh4_w24_6 & heap_bh4_w24_5 & heap_bh4_w24_4;
   CompressorIn_bh4_115_173 <= heap_bh4_w25_5 & heap_bh4_w25_4;
      Compressor_bh4_115: Compressor_23_3
      port map ( R => CompressorOut_bh4_115_115,
                 X0 => CompressorIn_bh4_115_172,
                 X1 => CompressorIn_bh4_115_173);
   heap_bh4_w24_7 <= CompressorOut_bh4_115_115(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w25_6 <= CompressorOut_bh4_115_115(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w26_7 <= CompressorOut_bh4_115_115(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_116_174 <= heap_bh4_w26_6 & heap_bh4_w26_5 & heap_bh4_w26_4;
   CompressorIn_bh4_116_175 <= heap_bh4_w27_5 & heap_bh4_w27_4;
      Compressor_bh4_116: Compressor_23_3
      port map ( R => CompressorOut_bh4_116_116,
                 X0 => CompressorIn_bh4_116_174,
                 X1 => CompressorIn_bh4_116_175);
   heap_bh4_w26_8 <= CompressorOut_bh4_116_116(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w27_6 <= CompressorOut_bh4_116_116(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w28_7 <= CompressorOut_bh4_116_116(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_117_176 <= heap_bh4_w28_6 & heap_bh4_w28_5 & heap_bh4_w28_4;
   CompressorIn_bh4_117_177 <= heap_bh4_w29_6 & heap_bh4_w29_5;
      Compressor_bh4_117: Compressor_23_3
      port map ( R => CompressorOut_bh4_117_117,
                 X0 => CompressorIn_bh4_117_176,
                 X1 => CompressorIn_bh4_117_177);
   heap_bh4_w28_8 <= CompressorOut_bh4_117_117(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w29_7 <= CompressorOut_bh4_117_117(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w30_9 <= CompressorOut_bh4_117_117(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_118_178 <= heap_bh4_w33_7 & heap_bh4_w33_6 & heap_bh4_w33_5;
   CompressorIn_bh4_118_179 <= heap_bh4_w34_7 & heap_bh4_w34_6;
      Compressor_bh4_118: Compressor_23_3
      port map ( R => CompressorOut_bh4_118_118,
                 X0 => CompressorIn_bh4_118_178,
                 X1 => CompressorIn_bh4_118_179);
   heap_bh4_w33_9 <= CompressorOut_bh4_118_118(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w34_8 <= CompressorOut_bh4_118_118(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w35_8 <= CompressorOut_bh4_118_118(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_119_180 <= heap_bh4_w35_7 & heap_bh4_w35_6 & heap_bh4_w35_5;
   CompressorIn_bh4_119_181 <= heap_bh4_w36_8 & heap_bh4_w36_7;
      Compressor_bh4_119: Compressor_23_3
      port map ( R => CompressorOut_bh4_119_119,
                 X0 => CompressorIn_bh4_119_180,
                 X1 => CompressorIn_bh4_119_181);
   heap_bh4_w35_9 <= CompressorOut_bh4_119_119(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w36_9 <= CompressorOut_bh4_119_119(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w37_9 <= CompressorOut_bh4_119_119(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_120_182 <= heap_bh4_w37_8 & heap_bh4_w37_7 & heap_bh4_w37_6;
   CompressorIn_bh4_120_183 <= heap_bh4_w38_8 & heap_bh4_w38_7;
      Compressor_bh4_120: Compressor_23_3
      port map ( R => CompressorOut_bh4_120_120,
                 X0 => CompressorIn_bh4_120_182,
                 X1 => CompressorIn_bh4_120_183);
   heap_bh4_w37_10 <= CompressorOut_bh4_120_120(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w38_9 <= CompressorOut_bh4_120_120(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w39_11 <= CompressorOut_bh4_120_120(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_121_184 <= heap_bh4_w77_9 & heap_bh4_w77_8 & heap_bh4_w77_7;
   CompressorIn_bh4_121_185 <= heap_bh4_w78_8 & heap_bh4_w78_7;
      Compressor_bh4_121: Compressor_23_3
      port map ( R => CompressorOut_bh4_121_121,
                 X0 => CompressorIn_bh4_121_184,
                 X1 => CompressorIn_bh4_121_185);
   heap_bh4_w77_11 <= CompressorOut_bh4_121_121(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w78_10 <= CompressorOut_bh4_121_121(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w79_9 <= CompressorOut_bh4_121_121(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_122_186 <= heap_bh4_w79_8 & heap_bh4_w79_7 & heap_bh4_w79_6;
   CompressorIn_bh4_122_187 <= heap_bh4_w80_8 & heap_bh4_w80_7;
      Compressor_bh4_122: Compressor_23_3
      port map ( R => CompressorOut_bh4_122_122,
                 X0 => CompressorIn_bh4_122_186,
                 X1 => CompressorIn_bh4_122_187);
   heap_bh4_w79_10 <= CompressorOut_bh4_122_122(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w80_9 <= CompressorOut_bh4_122_122(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w81_9 <= CompressorOut_bh4_122_122(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_123_188 <= heap_bh4_w83_7 & heap_bh4_w83_6 & heap_bh4_w83_5;
   CompressorIn_bh4_123_189 <= heap_bh4_w84_7 & heap_bh4_w84_6;
      Compressor_bh4_123: Compressor_23_3
      port map ( R => CompressorOut_bh4_123_123,
                 X0 => CompressorIn_bh4_123_188,
                 X1 => CompressorIn_bh4_123_189);
   heap_bh4_w83_9 <= CompressorOut_bh4_123_123(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w84_8 <= CompressorOut_bh4_123_123(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w85_8 <= CompressorOut_bh4_123_123(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_124_190 <= heap_bh4_w85_7 & heap_bh4_w85_6 & heap_bh4_w85_5;
   CompressorIn_bh4_124_191 <= heap_bh4_w86_7 & heap_bh4_w86_6;
      Compressor_bh4_124: Compressor_23_3
      port map ( R => CompressorOut_bh4_124_124,
                 X0 => CompressorIn_bh4_124_190,
                 X1 => CompressorIn_bh4_124_191);
   heap_bh4_w85_9 <= CompressorOut_bh4_124_124(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w86_8 <= CompressorOut_bh4_124_124(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w87_9 <= CompressorOut_bh4_124_124(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_125_192 <= heap_bh4_w90_7 & heap_bh4_w90_6 & heap_bh4_w90_5;
   CompressorIn_bh4_125_193 <= heap_bh4_w91_7 & heap_bh4_w91_6;
      Compressor_bh4_125: Compressor_23_3
      port map ( R => CompressorOut_bh4_125_125,
                 X0 => CompressorIn_bh4_125_192,
                 X1 => CompressorIn_bh4_125_193);
   heap_bh4_w90_9 <= CompressorOut_bh4_125_125(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w91_8 <= CompressorOut_bh4_125_125(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w92_8 <= CompressorOut_bh4_125_125(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_126_194 <= heap_bh4_w92_7 & heap_bh4_w92_6 & heap_bh4_w92_5;
   CompressorIn_bh4_126_195 <= heap_bh4_w93_7 & heap_bh4_w93_6;
      Compressor_bh4_126: Compressor_23_3
      port map ( R => CompressorOut_bh4_126_126,
                 X0 => CompressorIn_bh4_126_194,
                 X1 => CompressorIn_bh4_126_195);
   heap_bh4_w92_9 <= CompressorOut_bh4_126_126(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w93_8 <= CompressorOut_bh4_126_126(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w94_8 <= CompressorOut_bh4_126_126(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_127_196 <= heap_bh4_w94_7 & heap_bh4_w94_6 & heap_bh4_w94_5;
   CompressorIn_bh4_127_197 <= heap_bh4_w95_6 & heap_bh4_w95_5;
      Compressor_bh4_127: Compressor_23_3
      port map ( R => CompressorOut_bh4_127_127,
                 X0 => CompressorIn_bh4_127_196,
                 X1 => CompressorIn_bh4_127_197);
   heap_bh4_w94_9 <= CompressorOut_bh4_127_127(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w95_7 <= CompressorOut_bh4_127_127(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w96_7 <= CompressorOut_bh4_127_127(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_128_198 <= heap_bh4_w96_6 & heap_bh4_w96_5 & heap_bh4_w96_4;
   CompressorIn_bh4_128_199 <= heap_bh4_w97_5 & heap_bh4_w97_4;
      Compressor_bh4_128: Compressor_23_3
      port map ( R => CompressorOut_bh4_128_128,
                 X0 => CompressorIn_bh4_128_198,
                 X1 => CompressorIn_bh4_128_199);
   heap_bh4_w96_8 <= CompressorOut_bh4_128_128(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w97_6 <= CompressorOut_bh4_128_128(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w98_7 <= CompressorOut_bh4_128_128(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_129_200 <= heap_bh4_w98_6 & heap_bh4_w98_5 & heap_bh4_w98_4;
   CompressorIn_bh4_129_201 <= heap_bh4_w99_5 & heap_bh4_w99_4;
      Compressor_bh4_129: Compressor_23_3
      port map ( R => CompressorOut_bh4_129_129,
                 X0 => CompressorIn_bh4_129_200,
                 X1 => CompressorIn_bh4_129_201);
   heap_bh4_w98_8 <= CompressorOut_bh4_129_129(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w99_6 <= CompressorOut_bh4_129_129(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w100_7 <= CompressorOut_bh4_129_129(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_130_202 <= heap_bh4_w100_6 & heap_bh4_w100_5 & heap_bh4_w100_4;
   CompressorIn_bh4_130_203 <= heap_bh4_w101_5 & heap_bh4_w101_4;
      Compressor_bh4_130: Compressor_23_3
      port map ( R => CompressorOut_bh4_130_130,
                 X0 => CompressorIn_bh4_130_202,
                 X1 => CompressorIn_bh4_130_203);
   heap_bh4_w100_8 <= CompressorOut_bh4_130_130(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w101_6 <= CompressorOut_bh4_130_130(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w102_7 <= CompressorOut_bh4_130_130(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_131_204 <= heap_bh4_w102_6 & heap_bh4_w102_5 & heap_bh4_w102_4;
   CompressorIn_bh4_131_205 <= heap_bh4_w103_5 & heap_bh4_w103_4;
      Compressor_bh4_131: Compressor_23_3
      port map ( R => CompressorOut_bh4_131_131,
                 X0 => CompressorIn_bh4_131_204,
                 X1 => CompressorIn_bh4_131_205);
   heap_bh4_w102_8 <= CompressorOut_bh4_131_131(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w103_6 <= CompressorOut_bh4_131_131(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w104_7 <= CompressorOut_bh4_131_131(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_132_206 <= heap_bh4_w104_6 & heap_bh4_w104_5 & heap_bh4_w104_4;
   CompressorIn_bh4_132_207 <= heap_bh4_w105_1 & heap_bh4_w105_0;
      Compressor_bh4_132: Compressor_23_3
      port map ( R => CompressorOut_bh4_132_132,
                 X0 => CompressorIn_bh4_132_206,
                 X1 => CompressorIn_bh4_132_207);
   heap_bh4_w104_8 <= CompressorOut_bh4_132_132(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w105_4 <= CompressorOut_bh4_132_132(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w106_5 <= CompressorOut_bh4_132_132(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_133_208 <= heap_bh4_w112_1 & heap_bh4_w112_0 & heap_bh4_w112_2;
   CompressorIn_bh4_133_209 <= heap_bh4_w113_1 & heap_bh4_w113_0;
      Compressor_bh4_133: Compressor_23_3
      port map ( R => CompressorOut_bh4_133_133,
                 X0 => CompressorIn_bh4_133_208,
                 X1 => CompressorIn_bh4_133_209);
   heap_bh4_w112_3 <= CompressorOut_bh4_133_133(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w113_2 <= CompressorOut_bh4_133_133(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w114_2 <= CompressorOut_bh4_133_133(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_134_210 <= heap_bh4_w62_9 & heap_bh4_w62_8 & heap_bh4_w62_7;
   CompressorIn_bh4_134_211(0) <= heap_bh4_w63_8;
      Compressor_bh4_134: Compressor_13_3
      port map ( R => CompressorOut_bh4_134_134,
                 X0 => CompressorIn_bh4_134_210,
                 X1 => CompressorIn_bh4_134_211);
   heap_bh4_w62_11 <= CompressorOut_bh4_134_134(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w63_13 <= CompressorOut_bh4_134_134(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w64_11 <= CompressorOut_bh4_134_134(2); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_135_212 <= heap_bh4_w30_8 & heap_bh4_w30_7 & heap_bh4_w30_6;
      Compressor_bh4_135: Compressor_3_2
      port map ( R => CompressorOut_bh4_135_135,
                 X0 => CompressorIn_bh4_135_212);
   heap_bh4_w30_10 <= CompressorOut_bh4_135_135(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w31_9 <= CompressorOut_bh4_135_135(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_136_213 <= heap_bh4_w40_9 & heap_bh4_w40_8 & heap_bh4_w40_7;
      Compressor_bh4_136: Compressor_3_2
      port map ( R => CompressorOut_bh4_136_136,
                 X0 => CompressorIn_bh4_136_213);
   heap_bh4_w40_11 <= CompressorOut_bh4_136_136(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w41_12 <= CompressorOut_bh4_136_136(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_137_214 <= heap_bh4_w42_9 & heap_bh4_w42_8 & heap_bh4_w42_7;
      Compressor_bh4_137: Compressor_3_2
      port map ( R => CompressorOut_bh4_137_137,
                 X0 => CompressorIn_bh4_137_214);
   heap_bh4_w42_11 <= CompressorOut_bh4_137_137(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w43_12 <= CompressorOut_bh4_137_137(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_138_215 <= heap_bh4_w44_9 & heap_bh4_w44_8 & heap_bh4_w44_7;
      Compressor_bh4_138: Compressor_3_2
      port map ( R => CompressorOut_bh4_138_138,
                 X0 => CompressorIn_bh4_138_215);
   heap_bh4_w44_11 <= CompressorOut_bh4_138_138(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w45_12 <= CompressorOut_bh4_138_138(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_139_216 <= heap_bh4_w47_9 & heap_bh4_w47_8 & heap_bh4_w47_7;
      Compressor_bh4_139: Compressor_3_2
      port map ( R => CompressorOut_bh4_139_139,
                 X0 => CompressorIn_bh4_139_216);
   heap_bh4_w47_12 <= CompressorOut_bh4_139_139(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w48_12 <= CompressorOut_bh4_139_139(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_140_217 <= heap_bh4_w49_9 & heap_bh4_w49_8 & heap_bh4_w49_7;
      Compressor_bh4_140: Compressor_3_2
      port map ( R => CompressorOut_bh4_140_140,
                 X0 => CompressorIn_bh4_140_217);
   heap_bh4_w49_11 <= CompressorOut_bh4_140_140(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w50_12 <= CompressorOut_bh4_140_140(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_141_218 <= heap_bh4_w51_9 & heap_bh4_w51_8 & heap_bh4_w51_7;
      Compressor_bh4_141: Compressor_3_2
      port map ( R => CompressorOut_bh4_141_141,
                 X0 => CompressorIn_bh4_141_218);
   heap_bh4_w51_11 <= CompressorOut_bh4_141_141(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w52_12 <= CompressorOut_bh4_141_141(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_142_219 <= heap_bh4_w54_9 & heap_bh4_w54_8 & heap_bh4_w54_7;
      Compressor_bh4_142: Compressor_3_2
      port map ( R => CompressorOut_bh4_142_142,
                 X0 => CompressorIn_bh4_142_219);
   heap_bh4_w54_12 <= CompressorOut_bh4_142_142(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w55_12 <= CompressorOut_bh4_142_142(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_143_220 <= heap_bh4_w56_9 & heap_bh4_w56_8 & heap_bh4_w56_7;
      Compressor_bh4_143: Compressor_3_2
      port map ( R => CompressorOut_bh4_143_143,
                 X0 => CompressorIn_bh4_143_220);
   heap_bh4_w56_11 <= CompressorOut_bh4_143_143(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w57_12 <= CompressorOut_bh4_143_143(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_144_221 <= heap_bh4_w58_9 & heap_bh4_w58_8 & heap_bh4_w58_7;
      Compressor_bh4_144: Compressor_3_2
      port map ( R => CompressorOut_bh4_144_144,
                 X0 => CompressorIn_bh4_144_221);
   heap_bh4_w58_11 <= CompressorOut_bh4_144_144(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w59_12 <= CompressorOut_bh4_144_144(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_145_222 <= heap_bh4_w60_9 & heap_bh4_w60_8 & heap_bh4_w60_7;
      Compressor_bh4_145: Compressor_3_2
      port map ( R => CompressorOut_bh4_145_145,
                 X0 => CompressorIn_bh4_145_222);
   heap_bh4_w60_11 <= CompressorOut_bh4_145_145(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w61_12 <= CompressorOut_bh4_145_145(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_146_223 <= heap_bh4_w64_9 & heap_bh4_w64_8 & heap_bh4_w64_7;
      Compressor_bh4_146: Compressor_3_2
      port map ( R => CompressorOut_bh4_146_146,
                 X0 => CompressorIn_bh4_146_223);
   heap_bh4_w64_12 <= CompressorOut_bh4_146_146(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w65_12 <= CompressorOut_bh4_146_146(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_147_224 <= heap_bh4_w66_9 & heap_bh4_w66_8 & heap_bh4_w66_7;
      Compressor_bh4_147: Compressor_3_2
      port map ( R => CompressorOut_bh4_147_147,
                 X0 => CompressorIn_bh4_147_224);
   heap_bh4_w66_11 <= CompressorOut_bh4_147_147(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w67_12 <= CompressorOut_bh4_147_147(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_148_225 <= heap_bh4_w68_9 & heap_bh4_w68_8 & heap_bh4_w68_7;
      Compressor_bh4_148: Compressor_3_2
      port map ( R => CompressorOut_bh4_148_148,
                 X0 => CompressorIn_bh4_148_225);
   heap_bh4_w68_11 <= CompressorOut_bh4_148_148(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w69_12 <= CompressorOut_bh4_148_148(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_149_226 <= heap_bh4_w71_9 & heap_bh4_w71_8 & heap_bh4_w71_7;
      Compressor_bh4_149: Compressor_3_2
      port map ( R => CompressorOut_bh4_149_149,
                 X0 => CompressorIn_bh4_149_226);
   heap_bh4_w71_12 <= CompressorOut_bh4_149_149(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w72_12 <= CompressorOut_bh4_149_149(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_150_227 <= heap_bh4_w73_9 & heap_bh4_w73_8 & heap_bh4_w73_7;
      Compressor_bh4_150: Compressor_3_2
      port map ( R => CompressorOut_bh4_150_150,
                 X0 => CompressorIn_bh4_150_227);
   heap_bh4_w73_11 <= CompressorOut_bh4_150_150(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w74_12 <= CompressorOut_bh4_150_150(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_151_228 <= heap_bh4_w75_9 & heap_bh4_w75_8 & heap_bh4_w75_7;
      Compressor_bh4_151: Compressor_3_2
      port map ( R => CompressorOut_bh4_151_151,
                 X0 => CompressorIn_bh4_151_228);
   heap_bh4_w75_11 <= CompressorOut_bh4_151_151(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w76_12 <= CompressorOut_bh4_151_151(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_152_229 <= heap_bh4_w87_8 & heap_bh4_w87_7 & heap_bh4_w87_6;
      Compressor_bh4_152: Compressor_3_2
      port map ( R => CompressorOut_bh4_152_152,
                 X0 => CompressorIn_bh4_152_229);
   heap_bh4_w87_10 <= CompressorOut_bh4_152_152(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh4_w88_9 <= CompressorOut_bh4_152_152(1); -- cycle= 0 cp= 3.44844e-09

   CompressorIn_bh4_153_230 <= heap_bh4_w32_6 & heap_bh4_w32_5 & heap_bh4_w32_8;
   CompressorIn_bh4_153_231 <= heap_bh4_w33_9 & heap_bh4_w33_8;
      Compressor_bh4_153: Compressor_23_3
      port map ( R => CompressorOut_bh4_153_153,
                 X0 => CompressorIn_bh4_153_230,
                 X1 => CompressorIn_bh4_153_231);
   heap_bh4_w32_9 <= CompressorOut_bh4_153_153(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w33_10 <= CompressorOut_bh4_153_153(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w34_9 <= CompressorOut_bh4_153_153(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_154_232 <= heap_bh4_w41_12 & heap_bh4_w41_11 & heap_bh4_w41_10;
   CompressorIn_bh4_154_233 <= heap_bh4_w42_11 & heap_bh4_w42_10;
      Compressor_bh4_154: Compressor_23_3
      port map ( R => CompressorOut_bh4_154_154,
                 X0 => CompressorIn_bh4_154_232,
                 X1 => CompressorIn_bh4_154_233);
   heap_bh4_w41_13 <= CompressorOut_bh4_154_154(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w42_12 <= CompressorOut_bh4_154_154(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w43_13 <= CompressorOut_bh4_154_154(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_155_234 <= heap_bh4_w43_12 & heap_bh4_w43_11 & heap_bh4_w43_10;
   CompressorIn_bh4_155_235 <= heap_bh4_w44_11 & heap_bh4_w44_10;
      Compressor_bh4_155: Compressor_23_3
      port map ( R => CompressorOut_bh4_155_155,
                 X0 => CompressorIn_bh4_155_234,
                 X1 => CompressorIn_bh4_155_235);
   heap_bh4_w43_14 <= CompressorOut_bh4_155_155(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w44_12 <= CompressorOut_bh4_155_155(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w45_13 <= CompressorOut_bh4_155_155(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_156_236 <= heap_bh4_w45_12 & heap_bh4_w45_11 & heap_bh4_w45_10;
   CompressorIn_bh4_156_237 <= heap_bh4_w46_12 & heap_bh4_w46_11;
      Compressor_bh4_156: Compressor_23_3
      port map ( R => CompressorOut_bh4_156_156,
                 X0 => CompressorIn_bh4_156_236,
                 X1 => CompressorIn_bh4_156_237);
   heap_bh4_w45_14 <= CompressorOut_bh4_156_156(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w46_13 <= CompressorOut_bh4_156_156(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w47_13 <= CompressorOut_bh4_156_156(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_157_238 <= heap_bh4_w47_12 & heap_bh4_w47_11 & heap_bh4_w47_10;
   CompressorIn_bh4_157_239 <= heap_bh4_w48_12 & heap_bh4_w48_11;
      Compressor_bh4_157: Compressor_23_3
      port map ( R => CompressorOut_bh4_157_157,
                 X0 => CompressorIn_bh4_157_238,
                 X1 => CompressorIn_bh4_157_239);
   heap_bh4_w47_14 <= CompressorOut_bh4_157_157(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w48_13 <= CompressorOut_bh4_157_157(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w49_12 <= CompressorOut_bh4_157_157(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_158_240 <= heap_bh4_w50_12 & heap_bh4_w50_11 & heap_bh4_w50_10;
   CompressorIn_bh4_158_241 <= heap_bh4_w51_11 & heap_bh4_w51_10;
      Compressor_bh4_158: Compressor_23_3
      port map ( R => CompressorOut_bh4_158_158,
                 X0 => CompressorIn_bh4_158_240,
                 X1 => CompressorIn_bh4_158_241);
   heap_bh4_w50_13 <= CompressorOut_bh4_158_158(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w51_12 <= CompressorOut_bh4_158_158(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w52_13 <= CompressorOut_bh4_158_158(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_159_242 <= heap_bh4_w52_12 & heap_bh4_w52_11 & heap_bh4_w52_10;
   CompressorIn_bh4_159_243 <= heap_bh4_w53_12 & heap_bh4_w53_11;
      Compressor_bh4_159: Compressor_23_3
      port map ( R => CompressorOut_bh4_159_159,
                 X0 => CompressorIn_bh4_159_242,
                 X1 => CompressorIn_bh4_159_243);
   heap_bh4_w52_14 <= CompressorOut_bh4_159_159(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w53_13 <= CompressorOut_bh4_159_159(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w54_13 <= CompressorOut_bh4_159_159(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_160_244 <= heap_bh4_w54_12 & heap_bh4_w54_11 & heap_bh4_w54_10;
   CompressorIn_bh4_160_245 <= heap_bh4_w55_12 & heap_bh4_w55_11;
      Compressor_bh4_160: Compressor_23_3
      port map ( R => CompressorOut_bh4_160_160,
                 X0 => CompressorIn_bh4_160_244,
                 X1 => CompressorIn_bh4_160_245);
   heap_bh4_w54_14 <= CompressorOut_bh4_160_160(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w55_13 <= CompressorOut_bh4_160_160(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w56_12 <= CompressorOut_bh4_160_160(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_161_246 <= heap_bh4_w57_12 & heap_bh4_w57_11 & heap_bh4_w57_10;
   CompressorIn_bh4_161_247 <= heap_bh4_w58_11 & heap_bh4_w58_10;
      Compressor_bh4_161: Compressor_23_3
      port map ( R => CompressorOut_bh4_161_161,
                 X0 => CompressorIn_bh4_161_246,
                 X1 => CompressorIn_bh4_161_247);
   heap_bh4_w57_13 <= CompressorOut_bh4_161_161(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w58_12 <= CompressorOut_bh4_161_161(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w59_13 <= CompressorOut_bh4_161_161(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_162_248 <= heap_bh4_w59_12 & heap_bh4_w59_11 & heap_bh4_w59_10;
   CompressorIn_bh4_162_249 <= heap_bh4_w60_11 & heap_bh4_w60_10;
      Compressor_bh4_162: Compressor_23_3
      port map ( R => CompressorOut_bh4_162_162,
                 X0 => CompressorIn_bh4_162_248,
                 X1 => CompressorIn_bh4_162_249);
   heap_bh4_w59_14 <= CompressorOut_bh4_162_162(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w60_12 <= CompressorOut_bh4_162_162(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w61_13 <= CompressorOut_bh4_162_162(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_163_250 <= heap_bh4_w61_12 & heap_bh4_w61_11 & heap_bh4_w61_10;
   CompressorIn_bh4_163_251 <= heap_bh4_w62_11 & heap_bh4_w62_10;
      Compressor_bh4_163: Compressor_23_3
      port map ( R => CompressorOut_bh4_163_163,
                 X0 => CompressorIn_bh4_163_250,
                 X1 => CompressorIn_bh4_163_251);
   heap_bh4_w61_14 <= CompressorOut_bh4_163_163(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w62_12 <= CompressorOut_bh4_163_163(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w63_14 <= CompressorOut_bh4_163_163(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_164_252 <= heap_bh4_w63_13 & heap_bh4_w63_12 & heap_bh4_w63_11;
   CompressorIn_bh4_164_253 <= heap_bh4_w64_12 & heap_bh4_w64_11;
      Compressor_bh4_164: Compressor_23_3
      port map ( R => CompressorOut_bh4_164_164,
                 X0 => CompressorIn_bh4_164_252,
                 X1 => CompressorIn_bh4_164_253);
   heap_bh4_w63_15 <= CompressorOut_bh4_164_164(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w64_13 <= CompressorOut_bh4_164_164(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w65_13 <= CompressorOut_bh4_164_164(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_165_254 <= heap_bh4_w65_12 & heap_bh4_w65_11 & heap_bh4_w65_10;
   CompressorIn_bh4_165_255 <= heap_bh4_w66_11 & heap_bh4_w66_10;
      Compressor_bh4_165: Compressor_23_3
      port map ( R => CompressorOut_bh4_165_165,
                 X0 => CompressorIn_bh4_165_254,
                 X1 => CompressorIn_bh4_165_255);
   heap_bh4_w65_14 <= CompressorOut_bh4_165_165(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w66_12 <= CompressorOut_bh4_165_165(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w67_13 <= CompressorOut_bh4_165_165(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_166_256 <= heap_bh4_w67_12 & heap_bh4_w67_11 & heap_bh4_w67_10;
   CompressorIn_bh4_166_257 <= heap_bh4_w68_11 & heap_bh4_w68_10;
      Compressor_bh4_166: Compressor_23_3
      port map ( R => CompressorOut_bh4_166_166,
                 X0 => CompressorIn_bh4_166_256,
                 X1 => CompressorIn_bh4_166_257);
   heap_bh4_w67_14 <= CompressorOut_bh4_166_166(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w68_12 <= CompressorOut_bh4_166_166(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w69_13 <= CompressorOut_bh4_166_166(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_167_258 <= heap_bh4_w69_12 & heap_bh4_w69_11 & heap_bh4_w69_10;
   CompressorIn_bh4_167_259 <= heap_bh4_w70_12 & heap_bh4_w70_11;
      Compressor_bh4_167: Compressor_23_3
      port map ( R => CompressorOut_bh4_167_167,
                 X0 => CompressorIn_bh4_167_258,
                 X1 => CompressorIn_bh4_167_259);
   heap_bh4_w69_14 <= CompressorOut_bh4_167_167(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w70_13 <= CompressorOut_bh4_167_167(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w71_13 <= CompressorOut_bh4_167_167(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_168_260 <= heap_bh4_w71_12 & heap_bh4_w71_11 & heap_bh4_w71_10;
   CompressorIn_bh4_168_261 <= heap_bh4_w72_12 & heap_bh4_w72_11;
      Compressor_bh4_168: Compressor_23_3
      port map ( R => CompressorOut_bh4_168_168,
                 X0 => CompressorIn_bh4_168_260,
                 X1 => CompressorIn_bh4_168_261);
   heap_bh4_w71_14 <= CompressorOut_bh4_168_168(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w72_13 <= CompressorOut_bh4_168_168(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w73_12 <= CompressorOut_bh4_168_168(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_169_262 <= heap_bh4_w74_12 & heap_bh4_w74_11 & heap_bh4_w74_10;
   CompressorIn_bh4_169_263 <= heap_bh4_w75_11 & heap_bh4_w75_10;
      Compressor_bh4_169: Compressor_23_3
      port map ( R => CompressorOut_bh4_169_169,
                 X0 => CompressorIn_bh4_169_262,
                 X1 => CompressorIn_bh4_169_263);
   heap_bh4_w74_13 <= CompressorOut_bh4_169_169(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w75_12 <= CompressorOut_bh4_169_169(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w76_13 <= CompressorOut_bh4_169_169(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_170_264 <= heap_bh4_w76_12 & heap_bh4_w76_11 & heap_bh4_w76_10;
   CompressorIn_bh4_170_265 <= heap_bh4_w77_11 & heap_bh4_w77_10;
      Compressor_bh4_170: Compressor_23_3
      port map ( R => CompressorOut_bh4_170_170,
                 X0 => CompressorIn_bh4_170_264,
                 X1 => CompressorIn_bh4_170_265);
   heap_bh4_w76_14 <= CompressorOut_bh4_170_170(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w77_12 <= CompressorOut_bh4_170_170(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w78_11 <= CompressorOut_bh4_170_170(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_171_266 <= heap_bh4_w78_6 & heap_bh4_w78_10 & heap_bh4_w78_9;
   CompressorIn_bh4_171_267 <= heap_bh4_w79_10 & heap_bh4_w79_9;
      Compressor_bh4_171: Compressor_23_3
      port map ( R => CompressorOut_bh4_171_171,
                 X0 => CompressorIn_bh4_171_266,
                 X1 => CompressorIn_bh4_171_267);
   heap_bh4_w78_12 <= CompressorOut_bh4_171_171(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w79_11 <= CompressorOut_bh4_171_171(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w80_10 <= CompressorOut_bh4_171_171(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_172_268 <= heap_bh4_w82_6 & heap_bh4_w82_5 & heap_bh4_w82_8;
   CompressorIn_bh4_172_269 <= heap_bh4_w83_9 & heap_bh4_w83_8;
      Compressor_bh4_172: Compressor_23_3
      port map ( R => CompressorOut_bh4_172_172,
                 X0 => CompressorIn_bh4_172_268,
                 X1 => CompressorIn_bh4_172_269);
   heap_bh4_w82_9 <= CompressorOut_bh4_172_172(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w83_10 <= CompressorOut_bh4_172_172(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w84_9 <= CompressorOut_bh4_172_172(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_173_270 <= heap_bh4_w89_6 & heap_bh4_w89_5 & heap_bh4_w89_8;
   CompressorIn_bh4_173_271 <= heap_bh4_w90_9 & heap_bh4_w90_8;
      Compressor_bh4_173: Compressor_23_3
      port map ( R => CompressorOut_bh4_173_173,
                 X0 => CompressorIn_bh4_173_270,
                 X1 => CompressorIn_bh4_173_271);
   heap_bh4_w89_9 <= CompressorOut_bh4_173_173(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w90_10 <= CompressorOut_bh4_173_173(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w91_9 <= CompressorOut_bh4_173_173(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_174_272 <= heap_bh4_w106_4 & heap_bh4_w106_3 & heap_bh4_w106_5;
   CompressorIn_bh4_174_273 <= heap_bh4_w107_0 & heap_bh4_w107_3;
      Compressor_bh4_174: Compressor_23_3
      port map ( R => CompressorOut_bh4_174_174,
                 X0 => CompressorIn_bh4_174_272,
                 X1 => CompressorIn_bh4_174_273);
   heap_bh4_w106_6 <= CompressorOut_bh4_174_174(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w107_4 <= CompressorOut_bh4_174_174(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w108_5 <= CompressorOut_bh4_174_174(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_175_274 <= heap_bh4_w114_1 & heap_bh4_w114_0 & heap_bh4_w114_2;
   CompressorIn_bh4_175_275 <= heap_bh4_w115_1 & heap_bh4_w115_0;
      Compressor_bh4_175: Compressor_23_3
      port map ( R => CompressorOut_bh4_175_175,
                 X0 => CompressorIn_bh4_175_274,
                 X1 => CompressorIn_bh4_175_275);
   heap_bh4_w114_3 <= CompressorOut_bh4_175_175(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w115_2 <= CompressorOut_bh4_175_175(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh4_w116_2 <= CompressorOut_bh4_175_175(2); -- cycle= 0 cp= 3.97916e-09

   CompressorIn_bh4_176_276 <= heap_bh4_w34_5 & heap_bh4_w34_8 & heap_bh4_w34_9;
   CompressorIn_bh4_176_277 <= heap_bh4_w35_9 & heap_bh4_w35_8;
      Compressor_bh4_176: Compressor_23_3
      port map ( R => CompressorOut_bh4_176_176,
                 X0 => CompressorIn_bh4_176_276,
                 X1 => CompressorIn_bh4_176_277);
   heap_bh4_w34_10 <= CompressorOut_bh4_176_176(0); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w35_10 <= CompressorOut_bh4_176_176(1); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w36_10 <= CompressorOut_bh4_176_176(2); -- cycle= 0 cp= 4.50988e-09

   CompressorIn_bh4_177_278 <= heap_bh4_w80_6 & heap_bh4_w80_9 & heap_bh4_w80_10;
   CompressorIn_bh4_177_279 <= heap_bh4_w81_9 & heap_bh4_w81_8;
      Compressor_bh4_177: Compressor_23_3
      port map ( R => CompressorOut_bh4_177_177,
                 X0 => CompressorIn_bh4_177_278,
                 X1 => CompressorIn_bh4_177_279);
   heap_bh4_w80_11 <= CompressorOut_bh4_177_177(0); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w81_10 <= CompressorOut_bh4_177_177(1); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w82_10 <= CompressorOut_bh4_177_177(2); -- cycle= 0 cp= 4.50988e-09

   CompressorIn_bh4_178_280 <= heap_bh4_w84_5 & heap_bh4_w84_8 & heap_bh4_w84_9;
   CompressorIn_bh4_178_281 <= heap_bh4_w85_9 & heap_bh4_w85_8;
      Compressor_bh4_178: Compressor_23_3
      port map ( R => CompressorOut_bh4_178_178,
                 X0 => CompressorIn_bh4_178_280,
                 X1 => CompressorIn_bh4_178_281);
   heap_bh4_w84_10 <= CompressorOut_bh4_178_178(0); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w85_10 <= CompressorOut_bh4_178_178(1); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w86_9 <= CompressorOut_bh4_178_178(2); -- cycle= 0 cp= 4.50988e-09

   CompressorIn_bh4_179_282 <= heap_bh4_w91_5 & heap_bh4_w91_8 & heap_bh4_w91_9;
   CompressorIn_bh4_179_283 <= heap_bh4_w92_9 & heap_bh4_w92_8;
      Compressor_bh4_179: Compressor_23_3
      port map ( R => CompressorOut_bh4_179_179,
                 X0 => CompressorIn_bh4_179_282,
                 X1 => CompressorIn_bh4_179_283);
   heap_bh4_w91_10 <= CompressorOut_bh4_179_179(0); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w92_10 <= CompressorOut_bh4_179_179(1); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w93_9 <= CompressorOut_bh4_179_179(2); -- cycle= 0 cp= 4.50988e-09

   CompressorIn_bh4_180_284 <= heap_bh4_w108_4 & heap_bh4_w108_3 & heap_bh4_w108_5;
   CompressorIn_bh4_180_285 <= heap_bh4_w109_0 & heap_bh4_w109_3;
      Compressor_bh4_180: Compressor_23_3
      port map ( R => CompressorOut_bh4_180_180,
                 X0 => CompressorIn_bh4_180_284,
                 X1 => CompressorIn_bh4_180_285);
   heap_bh4_w108_6 <= CompressorOut_bh4_180_180(0); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w109_4 <= CompressorOut_bh4_180_180(1); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w110_5 <= CompressorOut_bh4_180_180(2); -- cycle= 0 cp= 4.50988e-09

   CompressorIn_bh4_181_286 <= heap_bh4_w116_1 & heap_bh4_w116_0 & heap_bh4_w116_2;
   CompressorIn_bh4_181_287 <= heap_bh4_w117_1 & heap_bh4_w117_0;
      Compressor_bh4_181: Compressor_23_3
      port map ( R => CompressorOut_bh4_181_181,
                 X0 => CompressorIn_bh4_181_286,
                 X1 => CompressorIn_bh4_181_287);
   heap_bh4_w116_3 <= CompressorOut_bh4_181_181(0); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w117_2 <= CompressorOut_bh4_181_181(1); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w118_2 <= CompressorOut_bh4_181_181(2); -- cycle= 0 cp= 4.50988e-09

   CompressorIn_bh4_182_288 <= heap_bh4_w49_11 & heap_bh4_w49_10 & heap_bh4_w49_12;
   CompressorIn_bh4_182_289(0) <= heap_bh4_w50_13;
      Compressor_bh4_182: Compressor_13_3
      port map ( R => CompressorOut_bh4_182_182,
                 X0 => CompressorIn_bh4_182_288,
                 X1 => CompressorIn_bh4_182_289);
   heap_bh4_w49_13 <= CompressorOut_bh4_182_182(0); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w50_14 <= CompressorOut_bh4_182_182(1); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w51_13 <= CompressorOut_bh4_182_182(2); -- cycle= 0 cp= 4.50988e-09

   CompressorIn_bh4_183_290 <= heap_bh4_w56_11 & heap_bh4_w56_10 & heap_bh4_w56_12;
   CompressorIn_bh4_183_291(0) <= heap_bh4_w57_13;
      Compressor_bh4_183: Compressor_13_3
      port map ( R => CompressorOut_bh4_183_183,
                 X0 => CompressorIn_bh4_183_290,
                 X1 => CompressorIn_bh4_183_291);
   heap_bh4_w56_13 <= CompressorOut_bh4_183_183(0); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w57_14 <= CompressorOut_bh4_183_183(1); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w58_13 <= CompressorOut_bh4_183_183(2); -- cycle= 0 cp= 4.50988e-09

   CompressorIn_bh4_184_292 <= heap_bh4_w73_11 & heap_bh4_w73_10 & heap_bh4_w73_12;
   CompressorIn_bh4_184_293(0) <= heap_bh4_w74_13;
      Compressor_bh4_184: Compressor_13_3
      port map ( R => CompressorOut_bh4_184_184,
                 X0 => CompressorIn_bh4_184_292,
                 X1 => CompressorIn_bh4_184_293);
   heap_bh4_w73_13 <= CompressorOut_bh4_184_184(0); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w74_14 <= CompressorOut_bh4_184_184(1); -- cycle= 0 cp= 4.50988e-09
   heap_bh4_w75_13 <= CompressorOut_bh4_184_184(2); -- cycle= 0 cp= 4.50988e-09

   CompressorIn_bh4_185_294 <= heap_bh4_w36_6 & heap_bh4_w36_9 & heap_bh4_w36_10;
   CompressorIn_bh4_185_295 <= heap_bh4_w37_10 & heap_bh4_w37_9;
      Compressor_bh4_185: Compressor_23_3
      port map ( R => CompressorOut_bh4_185_185,
                 X0 => CompressorIn_bh4_185_294,
                 X1 => CompressorIn_bh4_185_295);
   heap_bh4_w36_11 <= CompressorOut_bh4_185_185(0); -- cycle= 0 cp= 5.0406e-09
   heap_bh4_w37_11 <= CompressorOut_bh4_185_185(1); -- cycle= 0 cp= 5.0406e-09
   heap_bh4_w38_10 <= CompressorOut_bh4_185_185(2); -- cycle= 0 cp= 5.0406e-09

   CompressorIn_bh4_186_296 <= heap_bh4_w86_5 & heap_bh4_w86_8 & heap_bh4_w86_9;
   CompressorIn_bh4_186_297 <= heap_bh4_w87_10 & heap_bh4_w87_9;
      Compressor_bh4_186: Compressor_23_3
      port map ( R => CompressorOut_bh4_186_186,
                 X0 => CompressorIn_bh4_186_296,
                 X1 => CompressorIn_bh4_186_297);
   heap_bh4_w86_10 <= CompressorOut_bh4_186_186(0); -- cycle= 0 cp= 5.0406e-09
   heap_bh4_w87_11 <= CompressorOut_bh4_186_186(1); -- cycle= 0 cp= 5.0406e-09
   heap_bh4_w88_10 <= CompressorOut_bh4_186_186(2); -- cycle= 0 cp= 5.0406e-09

   CompressorIn_bh4_187_298 <= heap_bh4_w93_5 & heap_bh4_w93_8 & heap_bh4_w93_9;
   CompressorIn_bh4_187_299 <= heap_bh4_w94_9 & heap_bh4_w94_8;
      Compressor_bh4_187: Compressor_23_3
      port map ( R => CompressorOut_bh4_187_187,
                 X0 => CompressorIn_bh4_187_298,
                 X1 => CompressorIn_bh4_187_299);
   heap_bh4_w93_10 <= CompressorOut_bh4_187_187(0); -- cycle= 0 cp= 5.0406e-09
   heap_bh4_w94_10 <= CompressorOut_bh4_187_187(1); -- cycle= 0 cp= 5.0406e-09
   heap_bh4_w95_8 <= CompressorOut_bh4_187_187(2); -- cycle= 0 cp= 5.0406e-09

   CompressorIn_bh4_188_300 <= heap_bh4_w110_4 & heap_bh4_w110_3 & heap_bh4_w110_5;
   CompressorIn_bh4_188_301 <= heap_bh4_w111_0 & heap_bh4_w111_3;
      Compressor_bh4_188: Compressor_23_3
      port map ( R => CompressorOut_bh4_188_188,
                 X0 => CompressorIn_bh4_188_300,
                 X1 => CompressorIn_bh4_188_301);
   heap_bh4_w110_6 <= CompressorOut_bh4_188_188(0); -- cycle= 0 cp= 5.0406e-09
   heap_bh4_w111_4 <= CompressorOut_bh4_188_188(1); -- cycle= 0 cp= 5.0406e-09
   heap_bh4_w112_4 <= CompressorOut_bh4_188_188(2); -- cycle= 0 cp= 5.0406e-09

   CompressorIn_bh4_189_302 <= heap_bh4_w118_1 & heap_bh4_w118_0 & heap_bh4_w118_2;
   CompressorIn_bh4_189_303 <= heap_bh4_w119_1 & heap_bh4_w119_0;
      Compressor_bh4_189: Compressor_23_3
      port map ( R => CompressorOut_bh4_189_189,
                 X0 => CompressorIn_bh4_189_302,
                 X1 => CompressorIn_bh4_189_303);
   heap_bh4_w118_3 <= CompressorOut_bh4_189_189(0); -- cycle= 0 cp= 5.0406e-09
   heap_bh4_w119_2 <= CompressorOut_bh4_189_189(1); -- cycle= 0 cp= 5.0406e-09
   heap_bh4_w120_2 <= CompressorOut_bh4_189_189(2); -- cycle= 0 cp= 5.0406e-09

   CompressorIn_bh4_190_304 <= heap_bh4_w38_6 & heap_bh4_w38_9 & heap_bh4_w38_10;
   CompressorIn_bh4_190_305 <= heap_bh4_w39_11 & heap_bh4_w39_10;
      Compressor_bh4_190: Compressor_23_3
      port map ( R => CompressorOut_bh4_190_190,
                 X0 => CompressorIn_bh4_190_304,
                 X1 => CompressorIn_bh4_190_305);
   heap_bh4_w38_11 <= CompressorOut_bh4_190_190(0); -- cycle= 0 cp= 5.57132e-09
   heap_bh4_w39_12 <= CompressorOut_bh4_190_190(1); -- cycle= 0 cp= 5.57132e-09
   heap_bh4_w40_12 <= CompressorOut_bh4_190_190(2); -- cycle= 0 cp= 5.57132e-09

   CompressorIn_bh4_191_306 <= heap_bh4_w95_4 & heap_bh4_w95_7 & heap_bh4_w95_8;
   CompressorIn_bh4_191_307 <= heap_bh4_w96_8 & heap_bh4_w96_7;
      Compressor_bh4_191: Compressor_23_3
      port map ( R => CompressorOut_bh4_191_191,
                 X0 => CompressorIn_bh4_191_306,
                 X1 => CompressorIn_bh4_191_307);
   heap_bh4_w95_9 <= CompressorOut_bh4_191_191(0); -- cycle= 0 cp= 5.57132e-09
   heap_bh4_w96_9 <= CompressorOut_bh4_191_191(1); -- cycle= 0 cp= 5.57132e-09
   heap_bh4_w97_7 <= CompressorOut_bh4_191_191(2); -- cycle= 0 cp= 5.57132e-09

   CompressorIn_bh4_192_308 <= heap_bh4_w120_1 & heap_bh4_w120_0 & heap_bh4_w120_2;
   CompressorIn_bh4_192_309 <= heap_bh4_w121_1 & heap_bh4_w121_0;
      Compressor_bh4_192: Compressor_23_3
      port map ( R => CompressorOut_bh4_192_192,
                 X0 => CompressorIn_bh4_192_308,
                 X1 => CompressorIn_bh4_192_309);
   heap_bh4_w120_3 <= CompressorOut_bh4_192_192(0); -- cycle= 0 cp= 5.57132e-09
   heap_bh4_w121_2 <= CompressorOut_bh4_192_192(1); -- cycle= 0 cp= 5.57132e-09
   heap_bh4_w122_2 <= CompressorOut_bh4_192_192(2); -- cycle= 0 cp= 5.57132e-09

   CompressorIn_bh4_193_310 <= heap_bh4_w88_9 & heap_bh4_w88_8 & heap_bh4_w88_10;
   CompressorIn_bh4_193_311(0) <= heap_bh4_w89_9;
      Compressor_bh4_193: Compressor_13_3
      port map ( R => CompressorOut_bh4_193_193,
                 X0 => CompressorIn_bh4_193_310,
                 X1 => CompressorIn_bh4_193_311);
   heap_bh4_w88_11 <= CompressorOut_bh4_193_193(0); -- cycle= 0 cp= 5.57132e-09
   heap_bh4_w89_10 <= CompressorOut_bh4_193_193(1); -- cycle= 0 cp= 5.57132e-09
   heap_bh4_w90_11 <= CompressorOut_bh4_193_193(2); -- cycle= 0 cp= 5.57132e-09

   CompressorIn_bh4_194_312 <= heap_bh4_w122_1 & heap_bh4_w122_0 & heap_bh4_w122_2;
   CompressorIn_bh4_194_313 <= heap_bh4_w123_1 & heap_bh4_w123_0;
      Compressor_bh4_194: Compressor_23_3
      port map ( R => CompressorOut_bh4_194_194,
                 X0 => CompressorIn_bh4_194_312,
                 X1 => CompressorIn_bh4_194_313);
   heap_bh4_w122_3 <= CompressorOut_bh4_194_194(0); -- cycle= 0 cp= 6.10204e-09
   heap_bh4_w123_2 <= CompressorOut_bh4_194_194(1); -- cycle= 0 cp= 6.10204e-09
   heap_bh4_w124_2 <= CompressorOut_bh4_194_194(2); -- cycle= 0 cp= 6.10204e-09

   CompressorIn_bh4_195_314 <= heap_bh4_w40_11 & heap_bh4_w40_10 & heap_bh4_w40_12;
   CompressorIn_bh4_195_315(0) <= heap_bh4_w41_13;
      Compressor_bh4_195: Compressor_13_3
      port map ( R => CompressorOut_bh4_195_195,
                 X0 => CompressorIn_bh4_195_314,
                 X1 => CompressorIn_bh4_195_315);
   heap_bh4_w40_13 <= CompressorOut_bh4_195_195(0); -- cycle= 0 cp= 6.10204e-09
   heap_bh4_w41_14 <= CompressorOut_bh4_195_195(1); -- cycle= 0 cp= 6.10204e-09
   heap_bh4_w42_13 <= CompressorOut_bh4_195_195(2); -- cycle= 0 cp= 6.10204e-09

   CompressorIn_bh4_196_316 <= heap_bh4_w124_1 & heap_bh4_w124_0 & heap_bh4_w124_2;
   CompressorIn_bh4_196_317 <= heap_bh4_w125_1 & heap_bh4_w125_0;
      Compressor_bh4_196: Compressor_23_3
      port map ( R => CompressorOut_bh4_196_196,
                 X0 => CompressorIn_bh4_196_316,
                 X1 => CompressorIn_bh4_196_317);
   heap_bh4_w124_3 <= CompressorOut_bh4_196_196(0); -- cycle= 0 cp= 6.63276e-09
   heap_bh4_w125_2 <= CompressorOut_bh4_196_196(1); -- cycle= 0 cp= 6.63276e-09
   heap_bh4_w126_2 <= CompressorOut_bh4_196_196(2); -- cycle= 0 cp= 6.63276e-09

   CompressorIn_bh4_197_318 <= heap_bh4_w126_1 & heap_bh4_w126_0 & heap_bh4_w126_2;
   CompressorIn_bh4_197_319 <= heap_bh4_w127_1 & heap_bh4_w127_0;
      Compressor_bh4_197: Compressor_23_3
      port map ( R => CompressorOut_bh4_197_197,
                 X0 => CompressorIn_bh4_197_318,
                 X1 => CompressorIn_bh4_197_319);
   heap_bh4_w126_3 <= CompressorOut_bh4_197_197(0); -- cycle= 0 cp= 7.16348e-09
   heap_bh4_w127_2 <= CompressorOut_bh4_197_197(1); -- cycle= 0 cp= 7.16348e-09
   heap_bh4_w128_2 <= CompressorOut_bh4_197_197(2); -- cycle= 0 cp= 7.16348e-09

   CompressorIn_bh4_198_320 <= heap_bh4_w128_1 & heap_bh4_w128_0 & heap_bh4_w128_2;
   CompressorIn_bh4_198_321(0) <= heap_bh4_w129_0;
      Compressor_bh4_198: Compressor_13_3
      port map ( R => CompressorOut_bh4_198_198,
                 X0 => CompressorIn_bh4_198_320,
                 X1 => CompressorIn_bh4_198_321);
   heap_bh4_w128_3 <= CompressorOut_bh4_198_198(0); -- cycle= 0 cp= 7.6942e-09
   heap_bh4_w129_1 <= CompressorOut_bh4_198_198(1); -- cycle= 0 cp= 7.6942e-09
   finalAdderIn0_bh4 <= "0" & heap_bh4_w129_1 & heap_bh4_w128_3 & heap_bh4_w127_2 & heap_bh4_w126_3 & heap_bh4_w125_2 & heap_bh4_w124_3 & heap_bh4_w123_2 & heap_bh4_w122_3 & heap_bh4_w121_2 & heap_bh4_w120_3 & heap_bh4_w119_2 & heap_bh4_w118_3 & heap_bh4_w117_2 & heap_bh4_w116_3 & heap_bh4_w115_2 & heap_bh4_w114_3 & heap_bh4_w113_2 & heap_bh4_w112_3 & heap_bh4_w111_4 & heap_bh4_w110_6 & heap_bh4_w109_4 & heap_bh4_w108_6 & heap_bh4_w107_4 & heap_bh4_w106_6 & heap_bh4_w105_3 & heap_bh4_w104_8 & heap_bh4_w103_6 & heap_bh4_w102_8 & heap_bh4_w101_6 & heap_bh4_w100_8 & heap_bh4_w99_6 & heap_bh4_w98_8 & heap_bh4_w97_6 & heap_bh4_w96_9 & heap_bh4_w95_9 & heap_bh4_w94_10 & heap_bh4_w93_10 & heap_bh4_w92_10 & heap_bh4_w91_10 & heap_bh4_w90_10 & heap_bh4_w89_10 & heap_bh4_w88_11 & heap_bh4_w87_11 & heap_bh4_w86_10 & heap_bh4_w85_10 & heap_bh4_w84_10 & heap_bh4_w83_10 & heap_bh4_w82_9 & heap_bh4_w81_10 & heap_bh4_w80_11 & heap_bh4_w79_11 & heap_bh4_w78_12 & heap_bh4_w77_12 & heap_bh4_w76_14 & heap_bh4_w75_12 & heap_bh4_w74_14 & heap_bh4_w73_13 & heap_bh4_w72_10 & heap_bh4_w71_14 & heap_bh4_w70_13 & heap_bh4_w69_14 & heap_bh4_w68_12 & heap_bh4_w67_14 & heap_bh4_w66_12 & heap_bh4_w65_14 & heap_bh4_w64_10 & heap_bh4_w63_15 & heap_bh4_w62_12 & heap_bh4_w61_14 & heap_bh4_w60_12 & heap_bh4_w59_14 & heap_bh4_w58_12 & heap_bh4_w57_14 & heap_bh4_w56_13 & heap_bh4_w55_10 & heap_bh4_w54_14 & heap_bh4_w53_13 & heap_bh4_w52_14 & heap_bh4_w51_12 & heap_bh4_w50_14 & heap_bh4_w49_13 & heap_bh4_w48_10 & heap_bh4_w47_14 & heap_bh4_w46_13 & heap_bh4_w45_14 & heap_bh4_w44_12 & heap_bh4_w43_14 & heap_bh4_w42_12 & heap_bh4_w41_14 & heap_bh4_w40_13 & heap_bh4_w39_12 & heap_bh4_w38_11 & heap_bh4_w37_11 & heap_bh4_w36_11 & heap_bh4_w35_10 & heap_bh4_w34_10 & heap_bh4_w33_10 & heap_bh4_w32_9 & heap_bh4_w31_9 & heap_bh4_w30_10 & heap_bh4_w29_7 & heap_bh4_w28_8 & heap_bh4_w27_6 & heap_bh4_w26_8 & heap_bh4_w25_6 & heap_bh4_w24_7 & heap_bh4_w23_5 & heap_bh4_w22_5 & heap_bh4_w21_0 & heap_bh4_w20_4 & heap_bh4_w19_0 & heap_bh4_w18_4 & heap_bh4_w17_0 & heap_bh4_w16_4 & heap_bh4_w15_0 & heap_bh4_w14_4 & heap_bh4_w13_0 & heap_bh4_w12_3 & heap_bh4_w11_1 & heap_bh4_w10_1 & heap_bh4_w9_1 & heap_bh4_w8_1 & heap_bh4_w7_1 & heap_bh4_w6_1 & heap_bh4_w5_1;
   finalAdderIn1_bh4 <= "0" & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & heap_bh4_w112_4 & '0' & '0' & '0' & '0' & '0' & '0' & heap_bh4_w105_4 & heap_bh4_w104_7 & '0' & heap_bh4_w102_7 & '0' & heap_bh4_w100_7 & '0' & heap_bh4_w98_7 & heap_bh4_w97_7 & '0' & '0' & '0' & '0' & '0' & '0' & heap_bh4_w90_11 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & heap_bh4_w82_10 & '0' & '0' & '0' & heap_bh4_w78_11 & '0' & heap_bh4_w76_13 & heap_bh4_w75_13 & '0' & '0' & heap_bh4_w72_13 & heap_bh4_w71_13 & '0' & heap_bh4_w69_13 & '0' & heap_bh4_w67_13 & '0' & heap_bh4_w65_13 & heap_bh4_w64_13 & heap_bh4_w63_14 & '0' & heap_bh4_w61_13 & '0' & heap_bh4_w59_13 & heap_bh4_w58_13 & '0' & '0' & heap_bh4_w55_13 & heap_bh4_w54_13 & '0' & heap_bh4_w52_13 & heap_bh4_w51_13 & '0' & '0' & heap_bh4_w48_13 & heap_bh4_w47_13 & '0' & heap_bh4_w45_13 & '0' & heap_bh4_w43_13 & heap_bh4_w42_13 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & heap_bh4_w31_8 & heap_bh4_w30_9 & '0' & heap_bh4_w28_7 & '0' & heap_bh4_w26_7 & '0' & '0' & heap_bh4_w23_4 & heap_bh4_w22_4 & heap_bh4_w21_3 & heap_bh4_w20_3 & heap_bh4_w19_3 & heap_bh4_w18_3 & heap_bh4_w17_3 & heap_bh4_w16_3 & heap_bh4_w15_3 & heap_bh4_w14_3 & heap_bh4_w13_3 & '0' & heap_bh4_w11_0 & heap_bh4_w10_0 & heap_bh4_w9_0 & heap_bh4_w8_0 & heap_bh4_w7_0 & heap_bh4_w6_0 & heap_bh4_w5_0;
   finalAdderCin_bh4 <= '0';
      Adder_final4_0: IntAdder_126_f400_uid411
      port map ( Cin => finalAdderCin_bh4,
                 R => finalAdderOut_bh4,
                 X => finalAdderIn0_bh4,
                 Y => finalAdderIn1_bh4);
   -- concatenate all the compressed chunks
   CompressionResult4 <= finalAdderOut_bh4 & tempR_bh4_0;
   -- End of code generated by BitHeap::generateCompressorVHDL
   R <= CompressionResult4(129 downto 0);
end architecture;

