LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

PACKAGE cpu_types IS
    
    -- Types to be used throughout the design
    SUBTYPE word14 IS STD_LOGIC_VECTOR(13 DOWNTO 0);
    SUBTYPE word13 IS STD_LOGIC_VECTOR(12 DOWNTO 0);
    SUBTYPE word9  IS STD_LOGIC_VECTOR(8 DOWNTO 0);
    SUBTYPE word8  IS STD_LOGIC_VECTOR(7 DOWNTO 0);
    SUBTYPE word7  IS STD_LOGIC_VECTOR(6 DOWNTO 0);
    SUBTYPE word5  IS STD_LOGIC_VECTOR(4 DOWNTO 0);
    SUBTYPE word4  IS STD_LOGIC_VECTOR(3 DOWNTO 0);
    SUBTYPE word3  IS STD_LOGIC_VECTOR(2 DOWNTO 0);
    SUBTYPE word1  IS STD_LOGIC;

    
    -- Program size - 1024 words
    CONSTANT prog_mem_size : INTEGER := 1024;
    
    -- f = Register file address (0x00 to 0x7F)
    -- W = Working register
    TYPE op_code IS (
                    ADDWF,
                    ANDWF,
                    CLRF,  
                    CLRW,  
                    COMF, 
                    DECF, 
                    INCF,  
                    IORWF,
                    MOVF,  
                    MOVWF,
                    NOP,  
                    RLF,  
                    RRF,  
                    SUBWF,
                    SWAPF,
                    XORWF,

                    BCF,   
                    BSF,  
                    BTFSC,
                    BTFSS,

                    ADDLW,  
                    ANDLW,  
                    CALL,
                    CLRWDT,
                    GOTO,
                    IORLW,  
                    MOVLW,
                    RETFIE,
                    RETLW,
                    fRETURN,
                    SLEEP,
                    SUBLW,  
                    XORLW   
                );
    TYPE state IS (fetch, read, execute, write);
    SUBTYPE byte_op IS op_code RANGE ADDWF TO XORWF;
    SUBTYPE bit_op IS op_code RANGE BCF TO BTFSS;
    SUBTYPE lit_op IS op_code RANGE ADDLW TO XORLW;
    FUNCTION str_to_op (str : IN STRING(1 TO 6)) RETURN op_code;   


END PACKAGE cpu_types;

PACKAGE BODY cpu_types IS

    FUNCTION str_to_op (str : IN STRING(1 TO 6)) RETURN op_code IS
    BEGIN
        IF    str =  "ADDLW "   THEN RETURN ADDLW;
        ELSIF str =  "ADDWF "   THEN RETURN ADDWF;
        ELSIF str =  "ANDLW "   THEN RETURN ANDLW;
        ELSIF str =  "ANDWF "   THEN RETURN ANDWF;
        ELSIF str =  "BCF   "   THEN RETURN BCF;
        ELSIF str =  "BSF   "   THEN RETURN BSF;
        ELSIF str =  "CLRW  "   THEN RETURN CLRW;
        ELSIF str =  "CLRF  "   THEN RETURN CLRF;
        ELSIF str =  "COMF  "   THEN RETURN COMF;
        ELSIF str =  "DECF  "   THEN RETURN DECF;
        ELSIF str =  "INCF  "   THEN RETURN INCF;
        ELSIF str =  "IORLW "   THEN RETURN IORLW;
        ELSIF str =  "IORWF "   THEN RETURN IORWF;
        ELSIF str =  "MOVF  "   THEN RETURN MOVF;
        ELSIF str =  "MOVLW "   THEN RETURN MOVLW;
        ELSIF str =  "MOVWF "   THEN RETURN MOVWF;
        ELSIF str =  "NOP   "   THEN RETURN NOP;
        ELSIF str =  "RLF   "   THEN RETURN RLF;
        ELSIF str =  "RRF   "   THEN RETURN RRF;
        ELSIF str =  "SUBLW "   THEN RETURN SUBLW;
        ELSIF str =  "SUBWF "   THEN RETURN SUBWF;
        ELSIF str =  "SWAPF "   THEN RETURN SWAPF;
        ELSIF str =  "XORLW "   THEN RETURN XORLW;
        ELSIF str =  "XORWF "   THEN RETURN XORWF;
        ELSIF str =  "BTFSC "   THEN RETURN BTFSC;
        ELSIF str =  "BTFSS "   THEN RETURN BTFSS;
        ELSIF str =  "CALL  "   THEN RETURN CALL;
        ELSIF str =  "CLRWDT"   THEN RETURN CLRWDT;
        ELSIF str =  "GOTO  "   THEN RETURN GOTO;
        ELSIF str =  "RETFIE"   THEN RETURN RETFIE;
        ELSIF str =  "RETLW "   THEN RETURN RETLW;
        ELSIF str =  "RETURN"   THEN RETURN fRETURN;
        ELSIF str =  "SLEEP "   THEN RETURN SLEEP;
        ELSE RETURN NOP;
        END IF;
    END FUNCTION str_to_op;

END PACKAGE BODY cpu_types;
