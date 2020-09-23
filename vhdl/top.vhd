LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

LIBRARY work;
USE work.cpu_types.ALL;

ENTITY top IS
    PORT (
            -- INPUTS
            reset        : IN word1;    -- reset signal
            clk          : IN word1;    -- clock signal
            instr        : IN word14;   -- instruction word
            -- OUTPUTS
            pc_out       : OUT word13;  -- program counter
            RA           : OUT word5;   -- I/O pins, A
            RB           : OUT word8    -- I/O pins, B
         );
END ENTITY top;

ARCHITECTURE rtl OF top IS
    -- Signals stored in the top entity
    SIGNAL data_bus, read_bus           : word8;
    SIGNAL addr_bus                     : word7;
    SIGNAL cur_state                    : state;
    SIGNAL pc                           : word13;
    SIGNAL W, f, lit                    : word8;
    SIGNAL st_in, st_out, bit_select    : word3;
    SIGNAL we, re, alu_en, wreg_en      : word1;
    SIGNAL d, in_select                 : word1;
    SIGNAL operation                    : op_code;
    SIGNAL instr_out                    : word14;
BEGIN
    RAM : ENTITY work.RAM(rtl)
        PORT MAP (  data_bus => data_bus,
                    addr_bus => addr_bus,
                    read_bus => read_bus,
                    st_in    => st_in,
                    st_out   => st_out,
                    pc_in    => pc,
                    clk      => clk,
                    we       => we,
                    d        => d,
                    re       => re,
                    reset    => reset, 
                    RA       => RA,
                    RB       => RB
                );

    ALU : ENTITY work.ALU(rtl)
        PORT MAP (  W           => W,
                    f           => f,
                    operation   => operation,
                    bit_select  => bit_select,
                    st_in       => st_out,
                    alu_en      => alu_en,
                    result      => data_bus,
                    st_out      => st_in 
                );

    DEC : ENTITY work.decoder(rtl)
        PORT MAP (  instr       => instr_out,
                    clk         => clk,
                    reset       => reset,
                    lit         => lit,
                    bit_select  => bit_select,
                    addr_bus    => addr_bus,
                    we          => we,
                    re          => re,
                    wreg_en     => wreg_en,
                    alu_en      => alu_en,
                    pc_out      => pc,
                    in_select   => in_select,
                    d           => d,
                    operation   => operation,
                    cur_state   => cur_state 
                );


    -- MUX for selecting the second ALU input
    mux : PROCESS (lit, in_select, read_bus)
    BEGIN
        IF in_select = '0' THEN f <= lit;
        ELSE                    f <= read_bus;
        END IF;
    END PROCESS mux;

    -- Work register
    W_reg : PROCESS (clk, reset, d, wreg_en, data_bus)
    BEGIN
        -- Initialize the work register on reset
        IF reset = '1' THEN
            W <= "00000000";
        -- Work register is written into ONLY when these conditions fulfill
        -- Otherwise it retains its data
        ELSIF RISING_EDGE(clk) AND (d = '0') AND (wreg_en = '1') THEN
            W <= data_bus;
        END IF;
    END PROCESS W_reg;

    -- Instruction register
    -- instr is the port where the instruction comes from
    -- instr_out is distributed to the decoder
    instr_reg : PROCESS(clk, reset, instr)
    BEGIN
        -- Initialize the instruction as NOP on reset
        IF reset = '1' THEN
            instr_out <= (OTHERS => '0');
        -- Instruction is distributed forwards on rising edge
        ELSIF RISING_EDGE(clk) THEN
            instr_out <= instr;
        END IF;
    END PROCESS instr_reg;
    
    -- Program counter output is tied to the internal signal
    pc_out        <= pc;

END ARCHITECTURE rtl;

