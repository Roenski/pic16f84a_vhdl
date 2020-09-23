LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

LIBRARY work;
USE work.cpu_types.ALL;

ENTITY tb_RAM IS
END ENTITY tb_RAM;

ARCHITECTURE behav OF tb_RAM IS
    SIGNAL addr_bus, data_bus, read_bus : word8;
    SIGNAL st_in, st_out                : word3;
    SIGNAL pc_out                       : word13;
    SIGNAL clk, we, d, re, reset        : BIT;

BEGIN


    RAM : ENTITY work.RAM(rtl)
                PORT MAP (  addr_bus  => addr_bus,
                            data_bus  => data_bus,
                            read_bus  => read_bus,
                            st_in     => st_in,
                            st_out    => st_out,
                            pc_out    => pc_out,
                            clk       => clk,
                            we        => we,
                            d         => d,
                            re        => re,
                            reset     => reset );
                            

    run_testf : PROCESS IS
    BEGIN
        -- initializations
        reset <= '1';
        clk <= '0';
        we <= '0';
        d <= '0';
        re <= '0';
        addr_bus <= "00000000";
        data_bus <= "00000000";
        st_in <= "000";
        wait for 1 ns;
        reset <= '0';
        wait for 4 ns;
        clk <= '1'; 
        wait for 5 ns;
        clk <= '0';
        addr_bus <= "00000011";
        data_bus <= "11111111";
        we <= '1';
        d <= '1';
        st_in <= "010";
        wait for 5 ns;
        clk <= '1'; 
        wait for 5 ns;
        clk <= '0'; re <= '1';
        wait for 5 ns;
        
     

        wait;
    END PROCESS run_testf;


END ARCHITECTURE behav;

