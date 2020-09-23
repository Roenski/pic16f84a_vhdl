LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

LIBRARY work;
USE work.cpu_types.ALL;

ENTITY alu IS
    PORT (
            -- INPUTS
            W           : IN    word8;   -- work register (first operand) 
            f           : IN    word8;   -- file register/literal (second operand)
            operation   : IN    op_code; -- operation (decoded from instruction)
            bit_select  : IN    word3;   -- bit select for BSF and BCF operations
            st_in       : IN    word3;   -- status in
            alu_en      : IN    word1;   -- ALU enable
            -- OUTPUTS
            result      : OUT   word8;   -- result of the operation
            st_out      : OUT   word3    -- status out
        );
END ENTITY alu;

ARCHITECTURE rtl OF alu IS
    
    -- Function to determine if the 8-bit word is zero
    FUNCTION is_zero (val : IN word8) RETURN STD_LOGIC IS
    BEGIN
        IF val = "00000000" THEN RETURN '1';
        ELSE RETURN '0';
        END IF;
    END FUNCTION is_zero;

BEGIN

    -- Fully combinatorial logic
    ALU : PROCESS (ALL) IS

        -- Variables to calculate mid-results
        VARIABLE temp5 : word5;
        VARIABLE temp8 : word8;
        VARIABLE temp9 : word9;
        VARIABLE mask  : word8;

    BEGIN
        
        -- Execution only when ALU is enabled by the decoder
        -- See descriptions for the operations in the PIC datasheet
        IF alu_en = '1' THEN
            CASE operation IS
            
            WHEN ADDLW|ADDWF =>
                temp5     := STD_LOGIC_VECTOR(UNSIGNED('0' & W(3 DOWNTO 0)) + UNSIGNED('0' & f(3 DOWNTO 0)));
                temp9     := STD_LOGIC_VECTOR(UNSIGNED('0' & W) + UNSIGNED('0' & f));
                result    <= temp9(7 DOWNTO 0);
                st_out(0) <= temp9(8);
                st_out(1) <= temp5(4);
                st_out(2) <= is_zero(temp9(7 DOWNTO 0));
            WHEN ANDLW|ANDWF =>
                temp8     := W AND f;
                result    <= temp8;
                st_out(0) <= st_in(0);
                st_out(1) <= st_in(1);
                st_out(2) <= is_zero(temp8);
            WHEN BCF =>
                mask      := "00000001";
                temp8     := f AND NOT(STD_LOGIC_VECTOR(SHIFT_LEFT(UNSIGNED(mask), 
                              TO_INTEGER(UNSIGNED(bit_select)))));
                result    <= temp8;
                st_out    <= st_in;
            WHEN BSF =>
                mask      := "00000001";
                temp8     := f OR STD_LOGIC_VECTOR(SHIFT_LEFT(UNSIGNED(mask), 
                                TO_INTEGER(UNSIGNED(bit_select))));
                result    <= temp8;
                st_out    <= st_in;
            WHEN CLRW|CLRF =>
                result    <= "00000000";
                st_out(0) <= st_in(0);
                st_out(1) <= st_in(1);
                st_out(2) <= '1';
            WHEN COMF =>
                temp8     := NOT(f); 
                result    <= temp8;
                st_out(0) <= st_in(0);
                st_out(1) <= st_in(1);
                st_out(2) <= is_zero(temp8);
            WHEN DECF =>
                temp8     :=   STD_LOGIC_VECTOR(UNSIGNED(f) - 1);
                result    <= temp8;
                st_out(0) <= st_in(0);
                st_out(1) <= st_in(1);
                st_out(2) <= is_zero(temp8);
            WHEN INCF =>
                temp8     :=   STD_LOGIC_VECTOR(UNSIGNED(f) + 1);
                result    <= temp8;
                st_out(0) <= st_in(0);
                st_out(1) <= st_in(1);
                st_out(2) <= is_zero(temp8);
            WHEN IORLW|IORWF =>
                temp8       := W OR f; 
                result    <= temp8;
                st_out(0) <= st_in(0);
                st_out(1) <= st_in(1);
                st_out(2) <= is_zero(temp8);
            WHEN MOVF =>
                temp8     := f;
                result    <= temp8;
                st_out(0) <= st_in(0);
                st_out(1) <= st_in(1);
                st_out(2) <= is_zero(temp8);
            WHEN MOVLW|MOVWF =>
                IF operation = MOVWF THEN result <= W;
                ELSE                      result <= f;
                END IF;
                st_out(0) <= st_in(0);
                st_out(1) <= st_in(1);
                st_out(2) <= st_in(2);
            WHEN RLF =>
                result    <= f(6 DOWNTO 0) & st_in(0);
                st_out(0) <= f(7);
                st_out(1) <= st_in(1);
                st_out(2) <= st_in(2);
            WHEN RRF =>
                result    <= st_in(0) & f(7 DOWNTO 1);
                st_out(0) <= f(0);
                st_out(1) <= st_in(1);
                st_out(2) <= st_in(2);
            WHEN SUBLW|SUBWF =>
                temp5     := STD_LOGIC_VECTOR(UNSIGNED('1' & f(3 DOWNTO 0)) - UNSIGNED('0' & W(3 DOWNTO 0)));
                temp9     := STD_LOGIC_VECTOR(UNSIGNED('1' & f) - UNSIGNED('0' & W));
                result    <= temp9(7 DOWNTO 0);
                st_out(0) <= temp9(8);
                st_out(1) <= temp5(4);
                st_out(2) <= is_zero(temp9(7 DOWNTO 0));
            WHEN SWAPF =>
                result    <= f(3 DOWNTO 0) & f(7 DOWNTO 4);
                st_out(0) <= st_in(0);
                st_out(1) <= st_in(1);
                st_out(2) <= st_in(2);
            WHEN XORLW|XORWF =>
                temp8     := W XOR f; 
                result    <= temp8;
                st_out(0) <= st_in(0);
                st_out(1) <= st_in(1);
                st_out(2) <= is_zero(temp8);
                
            -- Everything else is handled as NOP
            WHEN OTHERS =>
                result    <= "00000000";
                st_out    <= st_in;
        END CASE;
    -- ALU not enabled -> NOP behaviour
    ELSE
        result <= "00000000";
        st_out <= st_in;
    END IF;
END PROCESS ALU;

END ARCHITECTURE rtl;

