LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

LIBRARY work;
USE work.cpu_types.ALL;
USE work.read_intel_hex_pack.ALL;

ENTITY tb_top IS
END ENTITY tb_top;

ARCHITECTURE behav of tb_top IS
    SIGNAL program : program_array;
    SIGNAL instr : word14;
    SIGNAL clk : word1; 
    SIGNAL pc : word13;
    SIGNAL reset : word1;
    SIGNAL RA : word5;
    SIGNAL RB : word8;
BEGIN

    top : ENTITY work.top(rtl)
        PORT MAP (  
                    reset   => reset,
                    clk     => clk,
                    instr   => instr,
                    pc_out  => pc,
                    RA      => RA,
                    RB      => RB
                 );

    run_test : PROCESS IS
        CONSTANT ihex_data : STRING := "../piklab/Led-blinker.hex";
        VARIABLE memory : program_array := (OTHERS => (OTHERS => '0'));
    BEGIN
        read_ihex_file(ihex_data, memory);
        program <= memory;
        WAIT FOR 1 ns;
        reset <= '1';
        clk <= '0';
        WAIT FOR 1 ns;
        reset <= '0';
        WHILE TO_INTEGER(UNSIGNED(pc)) < prog_mem_size LOOP
            IF (UNSIGNED(pc) > (prog_mem_size-1)) THEN
                NULL;
            ELSIF program(TO_INTEGER(UNSIGNED(pc))) /= "UUUUUUUUUUUUUU" THEN
                instr <= program(TO_INTEGER(UNSIGNED(pc)));
            ELSE
                instr <= (OTHERS => '0'); -- ambiguous instructions are intepreted as NOP
            END IF;
            WAIT FOR 5 ns;
            clk <= '1';
            WAIT FOR 5 ns;
            clk <= '0';
        END LOOP;
        WAIT FOR 5 ns;
        clk <= '1';
        WAIT FOR 5 ns;
        clk <= '0';
        WAIT;
    END PROCESS run_test;



END ARCHITECTURE behav;

