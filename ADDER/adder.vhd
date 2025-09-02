----------------------------------------------------------------------------------
-- Module Name : Adder 
-- Created by  : Noridel Herron
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
    Generic( DATA_WIDTH : natural := 4 );  
    Port (
            A, B : in  std_logic_vector (DATA_WIDTH - 1 downto 0);
            Ci   : in  std_logic;
            Sum  : out std_logic_vector (DATA_WIDTH - 1 downto 0);
            Cout : out std_logic
        ); 
end adder;

architecture Equation of adder is

-- Internal Signals
signal C  : std_logic_vector (DATA_WIDTH - 1 downto 1) := (others => '0');
    
begin
    -- Instantiate FullAdders 
    FA0: entity work.FullAdder port map (
        A  => A(0),
        B  => B(0),
        Ci => Ci,
        Co => C(1),
        S  => Sum(0)
    );

    FA_Gen: for i in 1 to DATA_WIDTH - 2 generate
        FA: entity work.FullAdder port map (
            A  => A(i),
            B  => B(i),
            Ci => C(i),
            Co => C(i+1),
            S  => Sum(i)
        );
    end generate;

    -- Last Full Adder (DATA_WIDTH - 1) outputs to Co
    FA: entity work.FullAdder port map (
        A  => A(DATA_WIDTH - 1),
        B  => B(DATA_WIDTH - 1),
        Ci => C(DATA_WIDTH - 1),
        Co => Cout,
        S  => Sum(DATA_WIDTH - 1)
    );

end Equation;