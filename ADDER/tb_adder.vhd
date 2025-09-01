----------------------------------------------------------------------------------
-- Module Name : Adder 
-- Created by  : Noridel Herron
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity tb_adder is
--  Port ( );
end tb_adder;

architecture sim of tb_adder is

    -- number of test (value can be change)
    constant NUM_TESTS    : integer := 300; -- Increase this up as high as you want just change the simulation runtime
    constant DATA_WIDTH   : integer := 4;  -- change it based on the number of bits of your adder
    
    -- Maximum value of 4 bits 
    -- You can choose any value as long as it is lower than the max value of the bits
    constant MAX_VALUE    : integer := 15; 
    
    type adder_input is record
        A, B : std_logic_vector(DATA_WIDTH - 1 downto 0);
        Ci   : std_logic;
    end record;
    
    type adder_output is record
        sum  : std_logic_vector(DATA_WIDTH - 1 downto 0);
        Co   : std_logic;
    end record;
    
    constant empty_input : adder_input := (
        A   => (others => '0'),
        B   => (others => '0'),
        Ci  => '0'
    );
    
    constant empty_output : adder_output := (
        sum => (others => '0'),
        Co  => '0'
    );


    signal act_in,  exp_in  : adder_input  := empty_input;
    signal act_out, exp_out : adder_output := empty_output;

begin
    -- Test the adder
    UUT: entity work.adder_wrapper port map (  
            A    => act_in.A,
            B    => act_in.B,
            Ci   => act_in.Ci,
            Sum  => act_out.sum,
            Cout => act_out.Co   
        );
        
    stimulus : process
        -- for generating value 
        -- variable for generating randomize value
        variable rA, rB, rCi    : real;
        variable seed1, seed2   : positive                              := 42; -- (value can be change)
        variable rand_temp      : adder_input                           := empty_input;
        variable rand_Ci        : std_logic_vector(DATA_WIDTH downto 0) := (others => '0');
        
        variable exp_temp           : std_logic_vector(DATA_WIDTH downto 0) := (others => '0');
        
        --Keep track pass/fail for debugging purpose
        variable pass, fail         : integer                           := 0;
        variable fail_sum, fail_co  : integer                           := 0;
  
    begin
        wait for 10 ns;

        for i in 0 to NUM_TESTS - 1 loop
            -- Generate random value
            uniform(seed1, seed2, rA);
            rand_temp.A := std_logic_vector(to_unsigned(integer(rA * real(MAX_VALUE)), DATA_WIDTH));
            uniform(seed1, seed2, rB);
            rand_temp.B := std_logic_vector(to_unsigned(integer(rB * real(MAX_VALUE)), DATA_WIDTH));
            uniform(seed1, seed2, rCi);
            if rCi < 0.5 then
                rand_temp.Ci := '0';
            else
                rand_temp.Ci := '1';
            end if;
            
            -- Apply actual inputs 
            act_in.A  <= rand_temp.A;
            act_in.B  <= rand_temp.B;
            act_in.Ci <= rand_temp.Ci;
            
            -- Apply expected inputs 
            exp_in.A  <= rand_temp.A;
            exp_in.B  <= rand_temp.B;
            exp_in.Ci <= rand_temp.Ci;
            
            exp_temp := std_logic_vector(('0' & unsigned( rand_temp.A)) + 
                                         ('0' & unsigned( rand_temp.B)) + 
                                         ('0' & (unsigned( rand_Ci(DATA_WIDTH - 1 downto 1)) &  rand_temp.Ci)));
            
            -- expected outputs 
            exp_out.co   <= exp_temp(DATA_WIDTH);
            exp_out.sum  <= exp_temp(DATA_WIDTH - 1 downto 0);

            wait for 5 ns;
            
            -- Check i/o
            if act_in /= exp_in then
                report "ACTUAL INPUTS != EXPECTED INPUTS" severity error; -- This will ensure that inputs are plugged in correctly
                
            elsif act_out = exp_out then
                pass := pass + 1;  
                 
            else
                fail := fail + 1;
                if act_out.sum /= exp_out.sum then
                    fail_sum := fail_sum + 1;
                end if;
                
                if act_out.Co /= exp_out.Co then
                    fail_co := fail_co + 1;
                end if;
                
            end if;

            wait for 5 ns;
        end loop;

        -- Test Summary Report
        if (fail = 0) then
            report "ADDER PASSED: " & integer'image(pass) & " out of " & integer'image(NUM_TESTS);
        else
            report "ADDER FAILED: " & integer'image(fail) & " out of " & integer'image(NUM_TESTS);
            if fail_sum /= 0 then
                report "ACTUAL SUM != EXPECTED SUM : # of fail " & integer'image(fail_sum);
            end if;
            
            if fail_co /= 0 then
                report "ACTUAL Cout != EXPECTED Cout :  # of fail " & integer'image(fail_co);
            end if;
        end if;
        
        std.env.stop;
    end process;

end sim;




