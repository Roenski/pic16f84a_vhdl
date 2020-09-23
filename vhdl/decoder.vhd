LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

LIBRARY work;
USE work.cpu_types.ALL;

ENTITY decoder IS
    PORT ( 
            -- INPUTS
            instr       : IN    word14;  -- instruction word
            clk         : IN    word1;   -- clock signal
            reset       : IN    word1;   -- reset signal
            -- OUTPUTS
            lit         : OUT   word8;   -- literal (instr 7-0)
            bit_select  : OUT   word3;   -- bit select (instr 9-7)
            addr_bus    : OUT   word7;   -- address bus
            we          : OUT   word1;   -- write enable
            re          : OUT   word1;   -- read enable
            wreg_en     : OUT   word1;   -- write-to-work-register enable
            alu_en      : OUT   word1;   -- alu enable
            pc_out      : OUT   word13;  -- program counter out
            in_select   : OUT   word1;   -- input select (selects second ALU operand)
            d           : OUT   word1;   -- d bit - chooses the destination of ALU output (0->W, 1->RAM)
            operation   : OUT   op_code; -- operation (decoded from instruction)
            cur_state   : OUT   state    -- reports the current state, used for simulations
         );
END ENTITY decoder;

ARCHITECTURE rtl OF decoder IS
    SIGNAL next_state : state; -- holds information for the next state
    SIGNAL pc : word13;        -- holds the value of the program counter
BEGIN
    -- The synhcronous decoding process
    decode : PROCESS (clk, reset) IS
    BEGIN
        -- Initialize everything to zero with reset
        -- state initialized to the first state, fetch
        IF reset = '1' THEN
            next_state  <= fetch;
            pc          <= (OTHERS => '0');
            we          <= '0';
            re          <= '0';
            lit         <= (OTHERS => '0');
            bit_select  <= (OTHERS => '0');
            addr_bus    <= (OTHERS => '0');
            alu_en      <= '0';
            wreg_en     <= '0';

        -- Finite State Machine operation
        ELSIF RISING_EDGE(clk) THEN
            CASE next_state IS
                -- Fetch the instruction and decode it
                WHEN fetch =>
                    cur_state <= fetch; -- this is solely for simulation
                    we <= '0'; re <= '0'; alu_en <= '0'; wreg_en <= '0'; -- disable everything
                    in_select <= '0'; -- ALU input will always be literal, unless read operation is done
                    addr_bus <= instr(6 DOWNTO 0); -- address is always found on the same location

                    -- Decoding of the instruction
                    -- The next state and ALU output destination are also decoded here
                    IF    STD_MATCH("000111--------", instr) THEN operation <= ADDWF; d <= instr(7); next_state <= read;    
                    ELSIF STD_MATCH("000101--------", instr) THEN operation <= ANDWF; d <= instr(7); next_state <= read;    
                    ELSIF STD_MATCH("0000011-------", instr) THEN operation <= CLRF;  d <= instr(7); next_state <= execute; 
                    ELSIF STD_MATCH("0000010-------", instr) THEN operation <= CLRW;  d <= instr(7); next_state <= execute; 
                    ELSIF STD_MATCH("001001--------", instr) THEN operation <= COMF;  d <= instr(7); next_state <= read;    
                    ELSIF STD_MATCH("000011--------", instr) THEN operation <= DECF;  d <= instr(7); next_state <= read;    
                    ELSIF STD_MATCH("001010--------", instr) THEN operation <= INCF;  d <= instr(7); next_state <= read;    
                    ELSIF STD_MATCH("000100--------", instr) THEN operation <= IORWF; d <= instr(7); next_state <= read;    
                    ELSIF STD_MATCH("001000--------", instr) THEN operation <= MOVF;  d <= instr(7); next_state <= read;    
                    ELSIF STD_MATCH("0000001-------", instr) THEN operation <= MOVWF; d <= instr(7); next_state <= execute; 
                    ELSIF STD_MATCH("0000000-------", instr) THEN operation <= NOP;   d <= '1';      next_state <= execute; 
                    ELSIF STD_MATCH("001101--------", instr) THEN operation <= RLF;   d <= instr(7); next_state <= read;    
                    ELSIF STD_MATCH("001100--------", instr) THEN operation <= RRF;   d <= instr(7); next_state <= read;    
                    ELSIF STD_MATCH("000010--------", instr) THEN operation <= SUBWF; d <= instr(7); next_state <= read;    
                    ELSIF STD_MATCH("001110--------", instr) THEN operation <= SWAPF; d <= instr(7); next_state <= read;    
                    ELSIF STD_MATCH("000110--------", instr) THEN operation <= XORWF; d <= instr(7); next_state <= read;    
                    ELSIF STD_MATCH("0100----------", instr) THEN operation <= BCF;   d <= '1';      next_state <= read;    
                    ELSIF STD_MATCH("0101----------", instr) THEN operation <= BSF;   d <= '1';      next_state <= read;    
                    ELSIF STD_MATCH("11111---------", instr) THEN operation <= ADDLW; d <= '0';      next_state <= execute; 
                    ELSIF STD_MATCH("111001--------", instr) THEN operation <= ANDLW; d <= '0';      next_state <= execute; 
                    ELSIF STD_MATCH("111000--------", instr) THEN operation <= IORLW; d <= '0';      next_state <= execute; 
                    ELSIF STD_MATCH("1100----------", instr) THEN operation <= MOVLW; d <= '0';      next_state <= execute; 
                    ELSIF STD_MATCH("11110---------", instr) THEN operation <= SUBLW; d <= '0';      next_state <= execute; 
                    ELSIF STD_MATCH("111010--------", instr) THEN operation <= XORLW; d <= '0';      next_state <= execute; 
                    ELSE                                          operation <= NOP;   d <= '1';      next_state <= execute; 
                    END IF;

                -- Read the second operand from memory (if needed)
                WHEN read =>
                    cur_state  <= read;
                    in_select  <= '1'; -- set ALU input to read bus
                    re         <= '1';
                    next_state <= execute;

                -- Execute the operation, increment program counter
                WHEN execute =>
                    cur_state  <= execute;
                    alu_en     <= '1';
                    bit_select <= instr(9 DOWNTO 7);
                    lit        <= instr(7 DOWNTO 0);
                    next_state <= write; 
                    pc         <= STD_LOGIC_VECTOR(UNSIGNED(pc) + 1);

                -- Write the result to memory (work register or RAM)
                WHEN write =>
                    we         <= '1';
                    wreg_en    <= '1';
                    cur_state  <= write;
                    next_state <= fetch;
            END CASE;
        END IF;
    END PROCESS decode;

    -- PC output is always tied to the program counter
    pc_out <= pc;

END ARCHITECTURE rtl;


