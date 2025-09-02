----------------------------------------------------------------------------------
-- Module Name : Adder 
-- Created by  : Noridel Herron
-- Note : If you have any recommendation how to improve this code, I highly appreciated the feedback.
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
    constant NUM_TESTS    : integer := 500; -- Increase this up as high as you want just change the simulation runtime
    constant DATA_WIDTH   : integer := 4;  -- change it based on the number of bits of your adder
    constant isSIGNED     : integer := 0;  -- UNSIGNED = 0 | SIGNED = 1
    
    -- Set MIN and MAX according to the limits of the chosen type (signed/unsigned)
    constant SIGNED_MAX_VALUE    : integer := 7; 
    constant SIGNED_MIN_VALUE    : integer := -8; 
    constant UNSIGNED_MAX_VALUE  : integer := 15; 
    constant UNSIGNED_MIN_VALUE  : integer := 0; 
    
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
        variable mod_element    : integer                               := 0;
        variable exp_temp       : std_logic_vector(DATA_WIDTH downto 0) := (others => '0');
        
        --Keep track pass/fail for debugging purpose
        variable pass, fail         : integer                           := 0;
        variable fail_sum, fail_co  : integer                           := 0;
        variable fail_sC, fail_UsC  : integer                           := 0;
  
    begin
        wait for 10 ns;
        
        for i in 0 to NUM_TESTS - 1 loop
                -- i < 9 is intended to catch corner cases, if you think I missed anything please let me know.
                case i is
                    when 0 =>
                        if isSIGNED = 1 then
                            rand_temp.A  := std_logic_vector(to_signed(-1, DATA_WIDTH)); 
                            rand_temp.B  := std_logic_vector(to_signed(-1, DATA_WIDTH));
                            rand_temp.Ci := '0';
                        else
                            rand_temp.A  := (others => '0');
                            rand_temp.B  := (others => '0');
                            rand_temp.Ci := '0';
                        end if;
                        
                    when 1 =>
                        if isSIGNED = 1 then
                            rand_temp.A  := std_logic_vector(to_signed(SIGNED_MIN_VALUE, DATA_WIDTH));
                            rand_temp.B  := std_logic_vector(to_signed(-1, DATA_WIDTH));
                            rand_temp.Ci := '0';
                        else -- minimal addition
                            rand_temp.A    := (others => '0');
                            rand_temp.B    := (others => '0');
                            rand_temp.B(0) := '1';  
                            rand_temp.Ci   := '0';
                        end if;
            
                    when 2 =>
                        if isSIGNED = 1 then
                            rand_temp.A    := std_logic_vector(to_signed(SIGNED_MAX_VALUE, DATA_WIDTH));
                            rand_temp.B    := (others => '0');
                            rand_temp.B(0) := '1';  
                            rand_temp.Ci   := '0';
                        else
                            rand_temp.A    := std_logic_vector(to_unsigned(UNSIGNED_MAX_VALUE, DATA_WIDTH));
                            rand_temp.B    := (others => '0');
                            rand_temp.B(0) := '1';  
                            rand_temp.Ci   := '0';
                        end if;
                        
                    when 3 =>
                        if isSIGNED = 1 then
                            rand_temp.A    := std_logic_vector(to_signed(SIGNED_MIN_VALUE / (-2) , DATA_WIDTH));
                            rand_temp.B    := std_logic_vector(to_signed(SIGNED_MIN_VALUE / (-2) , DATA_WIDTH));
                            rand_temp.Ci   := '0';
                        else
                            rand_temp.A    := std_logic_vector(to_unsigned(UNSIGNED_MAX_VALUE, DATA_WIDTH));
                            rand_temp.B    := std_logic_vector(to_unsigned(UNSIGNED_MAX_VALUE, DATA_WIDTH));
                            rand_temp.Ci   := '0';
                        end if;
                        
                   when 4 =>
                        if isSIGNED = 1 then
                            rand_temp.A    := std_logic_vector(to_signed(SIGNED_MIN_VALUE / 2 , DATA_WIDTH));
                            rand_temp.B    := std_logic_vector(to_signed(SIGNED_MIN_VALUE / 2 , DATA_WIDTH));
                            rand_temp.Ci   := '0';
                            
                        else -- Alternating bits
                            rand_temp.A    := (others => '0'); 
                            rand_temp.A(0) := '1'; 
                            for j in 1 to DATA_WIDTH - 1 loop
                                if (j mod 2) = 0 then
                                    rand_temp.A(j) := '1';
                                end if;
                            end loop;
                            rand_temp.B    := not rand_temp.A;
                            rand_temp.Ci   := '0';
                        end if;
                        
                      -- Uncomment to check if its the alternating bits value or check the waveform 
                      --  report "A value = " & integer'image(to_integer(unsigned(rand_temp.A))) &
                      --      " | B value = " & integer'image(to_integer(unsigned(rand_temp.B)));                        
                   when 5 =>
                        if isSIGNED = 1 then
                            rand_temp.A  := std_logic_vector(to_signed(SIGNED_MAX_VALUE, DATA_WIDTH));
                            rand_temp.B  := std_logic_vector(to_signed(SIGNED_MIN_VALUE, DATA_WIDTH));
                            rand_temp.Ci := '0';
                        else
                            rand_temp.A    := (others => '0');
                            rand_temp.B    := std_logic_vector(to_unsigned(UNSIGNED_MAX_VALUE, DATA_WIDTH));
                            rand_temp.Ci   := '0';
                        end if;
            
                    when 6 =>
                        if isSIGNED = 1 then
                            rand_temp.A    := std_logic_vector(to_signed(-1, DATA_WIDTH));
                            rand_temp.A    := std_logic_vector(to_signed(1, DATA_WIDTH));
                            rand_temp.Ci   := '0';
                        else
                            rand_temp.A    := std_logic_vector(to_unsigned(((UNSIGNED_MAX_VALUE - 1 ) / 2) + 2, DATA_WIDTH));
                            rand_temp.B    := std_logic_vector(to_unsigned(((UNSIGNED_MAX_VALUE - 1 ) / 2), DATA_WIDTH));
                            rand_temp.Ci   := '0';
                        end if;
                        
                   when 7 =>
                        if isSIGNED = 1 then
                            rand_temp.A    := std_logic_vector(to_signed((SIGNED_MIN_VALUE / 2 ) + 1, DATA_WIDTH));
                            rand_temp.B    := std_logic_vector(to_signed((SIGNED_MIN_VALUE / 2 ) - 1, DATA_WIDTH));
                            rand_temp.Ci   := '0';
                        else
                            rand_temp.A    := std_logic_vector(to_unsigned((UNSIGNED_MAX_VALUE - 1 ) / 2, DATA_WIDTH));
                            rand_temp.B    := std_logic_vector(to_unsigned(((UNSIGNED_MAX_VALUE - 1 ) / 2) + 1, DATA_WIDTH));
                            rand_temp.Ci   := '0';
                        end if;    
                        
                   when 8 =>
                        if isSIGNED = 1 then
                            rand_temp.A    := std_logic_vector(to_signed( 1, DATA_WIDTH));
                            rand_temp.B    := std_logic_vector(to_signed( - 1, DATA_WIDTH));
                            rand_temp.Ci   := '1';
                        else
                            rand_temp.A    := (others => '1');
                            rand_temp.B    := (others => '0');
                            rand_temp.B(0) := '1';  
                            rand_temp.Ci   := '0';
                        end if; 
                    
                    when others => 
                        -- Generate random value
                        uniform(seed1, seed2, rA);
                        uniform(seed1, seed2, rB);
                        uniform(seed1, seed2, rCi);
                        
                        if rCi < 0.5 then
                                rand_temp.Ci := '0';
                            else
                                rand_temp.Ci := '1';
                            end if;
                            
                        if isSigned = 1 then
                            rand_temp.A := std_logic_vector(to_signed((integer(rA * real(SIGNED_MAX_VALUE - SIGNED_MIN_VALUE + 1)) 
                                           + SIGNED_MIN_VALUE), DATA_WIDTH));
                            
                            rand_temp.B := std_logic_vector(to_signed((integer(rA * real(SIGNED_MAX_VALUE - SIGNED_MIN_VALUE + 1)) 
                                           + SIGNED_MIN_VALUE), DATA_WIDTH));
                                           
                        else
                            rand_temp.A := std_logic_vector(to_unsigned((integer(rA * real(UNSIGNED_MAX_VALUE - UNSIGNED_MIN_VALUE + 1)) 
                                           + UNSIGNED_MIN_VALUE), DATA_WIDTH));
                            
                            rand_temp.B := std_logic_vector(to_unsigned((integer(rA * real(UNSIGNED_MAX_VALUE - UNSIGNED_MIN_VALUE + 1)) 
                                           + UNSIGNED_MIN_VALUE), DATA_WIDTH));
                        end if;
                end case;
            
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
                if i < 9 then
                    if isSigned = 1 then
                        fail_sC := fail_sC + 1;
                    else
                        fail_UsC := fail_UsC + 1;
                    end if;
                else
                    if act_out.sum /= exp_out.sum then
                        fail_sum := fail_sum + 1;
                    end if;
                    
                    if act_out.Co /= exp_out.Co then
                        fail_co := fail_co + 1;
                    end if;
                end if;
            end if;

            wait for 5 ns;
        end loop;

        -- Test Summary Report
        if (fail = 0) then
            report "ADDER PASSED: " & integer'image(pass) & " out of " & integer'image(NUM_TESTS);
        else
            report "ADDER FAILED: " & integer'image(fail) & " out of " & integer'image(NUM_TESTS);
        
            if fail_sC /= 0 then
                report "Your adder is broken for SIGNED " & integer'image(fail_sC);
            end if;
            
            if fail_UsC /= 0 then
                report "Your adder is broken for UNSIGNED " & integer'image(fail_UsC);
            end if;
            
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




