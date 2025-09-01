----------------------------------------------------------------------------------
-- Module Name : Adder 
-- Created by  : Noridel Herron
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_wrapper is
    Generic( DATA_WIDTH : natural := 4); -- Change the value based on you adder bit width
    Port (
            A, B      : in  std_logic_vector (DATA_WIDTH - 1 downto 0);
            Ci        : in  std_logic;
            Sum       : out std_logic_vector (DATA_WIDTH - 1 downto 0);
            Cout      : out std_logic
        ); 
end adder_wrapper;

architecture Behavioral of adder_wrapper is

    component adder -- change the component name or the i/o if you declare it differently
        Port (
                A, B : in  std_logic_vector (DATA_WIDTH - 1 downto 0);
                Ci   : in  std_logic;
                Sum  : out std_logic_vector (DATA_WIDTH - 1 downto 0);
                Cout : out std_logic
            ); 
    end component;

begin

    UUT : adder port map (   -- Make sure this matches the component (Note: Left the component i/o ; Right the actual i/o)
            A    => A,
            B    => B,
            Ci   => Ci, 
            Sum  => Sum,
            Cout => Cout
        );
        
end Behavioral;
