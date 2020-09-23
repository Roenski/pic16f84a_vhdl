LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

LIBRARY work;
USE work.cpu_types.ALL;

ENTITY RAM IS
    PORT (  
            -- INPUTS
            data_bus  : IN  word8;  -- data bus
            addr_bus  : IN  word7;  -- address bus
            st_in     : IN  word3;  -- status in from ALU
            pc_in     : IN  word13; -- program counter from decoder
            clk       : IN  word1;  -- clock signal
            we        : IN  word1;  -- write enable
            d         : IN  word1;  -- d bit - chooses the destination of ALU output (0->W, 1->RAM)
            re        : IN  word1;  -- read enable
            reset     : IN  word1;  -- reset (initializes all memory to 0)
            -- OUTPUTS
            read_bus  : OUT word8;  -- read bus
            st_out    : OUT word3;  -- status out
            RA        : OUT word5;  -- I/O pins, RA4:RA0
            RB        : OUT word8   -- I/O pins, RB7:RB0
        );
END ENTITY RAM;

ARCHITECTURE rtl OF RAM IS
    CONSTANT status_addr : INTEGER RANGE 0 TO 79 := 3;  -- STATUS register address
    CONSTANT FSR_addr    : INTEGER RANGE 0 TO 79 := 4;  -- FST register address
    CONSTANT PORTA_addr  : INTEGER RANGE 0 TO 79 := 5;  -- PORTA register address
    CONSTANT PORTB_addr  : INTEGER RANGE 0 TO 79 := 6;  -- PORTB register address
    CONSTANT PCL_addr    : INTEGER RANGE 0 TO 79 := 2;  -- PC register address, low 8 bits
    CONSTANT PCLATH_addr : INTEGER RANGE 0 TO 79 := 10; -- PC register address, high 5 bits
    TYPE mem_array IS ARRAY ( 0 TO 2**7 - 1 ) OF word8; -- memory bank (128 registers total)
    SIGNAL mem_block : mem_array;                       -- signal with all RAM memory
BEGIN


    -- Synchronous write and read
    write : PROCESS (clk, reset) IS
        VARIABLE temp_addr : INTEGER; -- temporary variable
        VARIABLE temp : word8;        -- temporary variable
    BEGIN
        -- Reset initializes all memory to zero. STATUS has an initial value.
        IF reset = '1' THEN
            mem_block <= (OTHERS => (OTHERS => '0')); -- set all values to zero
            mem_block(3) <= "00011000";               -- STATUS initial value
            read_bus <= "00000000";                   -- give read bus an initial value

        -- Both reading and writing occur on rising edge of the clock signal
        ELSIF RISING_EDGE(clk) THEN
            IF we = '1' THEN
                temp_addr := TO_INTEGER(UNSIGNED(addr_bus));

                -- Writing status and program counter
                -- Do not write status if STATUS register is being written to
                IF NOT(temp_addr = status_addr AND d = '1') THEN
                    mem_block(status_addr)(2 DOWNTO 0) <= st_in;
                END IF;
                mem_block(PCLATH_addr)(4 DOWNTO 0) <= pc_in(12 DOWNTO 8); -- Upper PC bits
                mem_block(PCL_addr) <= pc_in(7 DOWNTO 0);                 -- Lower PC bits

                -- Write to memory, if the ALU output has been set to RAM
                IF d = '1' THEN
                    -- Do not write to unimplemented locations
                    IF temp_addr < 80 AND temp_addr /= 7 AND temp_addr /= 0 THEN
                        mem_block(TO_INTEGER(UNSIGNED(addr_bus))) <= data_bus;
                    END IF;
                END IF;
            END IF;
            
            IF re = '1' THEN

                -- Indirect addressing
                IF TO_INTEGER(UNSIGNED(addr_bus)) = 0 THEN
                    temp := mem_block(FSR_addr);
                    read_bus <= mem_block(TO_INTEGER(UNSIGNED(temp(6 DOWNTO 0))));

                -- Normal reading operation
                ELSE
                    read_bus <= mem_block(TO_INTEGER(UNSIGNED(addr_bus)));
                END IF;
            END IF;
        END IF;
    END PROCESS write;

    -- Status bits and I/O ports are directly connected
    -- to their corresponding memory bits
    st_out <= mem_block(status_addr)(2 DOWNTO 0);
    RA     <= mem_block(PORTA_addr)(4 DOWNTO 0);
    RB     <= mem_block(PORTB_addr)(7 DOWNTO 0);

END ARCHITECTURE rtl;
