-------------------------------------------------------------------------------
--Usage of the reader:
--
--CONSTANT ihex_data : STRING :=
--"/home/pro/autosub/erkka/digital/matlab/esim.HEX;
--VARIABLE memory : program_array := (OTHERS => (OTHERS => '0'));
--
--read_ihex_file(ihex_data, memory);
--
-- If some constant definitions are missing, try to figure them out.
-- If you can't contact Erkka Laulainen, elaulain@ecdl.tkk.fi, room I313A
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.std_logic_arith.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL;
USE ieee.std_logic_misc.ALL;


PACKAGE read_intel_hex_pack IS
  CONSTANT debug : BOOLEAN := true;
  
  ------------------------------------------------------------------------------
  ----- Design Parameters  -----------------------------------------------------
  ------------------------------------------------------------------------------  
  
  CONSTANT Inst_bits  : INTEGER := 14;   
  CONSTANT data_bits  : INTEGER := 8;
  CONSTANT inst_mem_size : INTEGER := 1024;
  TYPE program_array IS ARRAY (0 TO inst_mem_size-1) OF STD_LOGIC_VECTOR(Inst_bits-1 DOWNTO 0);
    
  ------------------------------------------------------------------------------
  ----- Reset Values -----------------------------------------------------------
  ------------------------------------------------------------------------------  
   
--  CONSTANT W_RESET          : STD_ULOGIC_VECTOR(data_bits-1 DOWNTO 0) := "XXXXXXXX";
--  CONSTANT INDF_RESET       : STD_ULOGIC_VECTOR(data_bits-1 DOWNTO 0) := "--------";
--  CONSTANT TMR0_RESET       : STD_ULOGIC_VECTOR(data_bits-1 DOWNTO 0) := "XXXXXXXX";
--  CONSTANT PCL_RESET        : STD_ULOGIC_VECTOR(data_bits-1 DOWNTO 0) := "00000000";
--  CONSTANT STATUS_RESET     : STD_ULOGIC_VECTOR(data_bits-1 DOWNTO 0) := "00011XXX";
--  CONSTANT FSR_RESET        : STD_ULOGIC_VECTOR(data_bits-1 DOWNTO 0) := "XXXXXXXX";
--  CONSTANT PORTA_RESET      : STD_ULOGIC_VECTOR(4 DOWNTO 0)           := "XXXXX";
--  CONSTANT PORTB_RESET      : STD_ULOGIC_VECTOR(data_bits-1 DOWNTO 0) := "XXXXXXXX";
--  CONSTANT EEDATA_RESET     : STD_ULOGIC_VECTOR(data_bits-1 DOWNTO 0) := "XXXXXXXX";
--  CONSTANT EEADR_RESET      : STD_ULOGIC_VECTOR(data_bits-1 DOWNTO 0) := "XXXXXXXX";
--  CONSTANT PCLATH_RESET     : STD_ULOGIC_VECTOR(4 DOWNTO 0)           := "00000";
--  CONSTANT INTCON_RESET     : STD_ULOGIC_VECTOR(data_bits-1 DOWNTO 0) := "0000000X";
--  CONSTANT OPTION_REG_RESET : STD_ULOGIC_VECTOR(data_bits-1 DOWNTO 0) := "11111111";
--  CONSTANT TRISA_RESET      : STD_ULOGIC_VECTOR(4 DOWNTO 0)           := "11111";
--  CONSTANT TRISB_RESET      : STD_ULOGIC_VECTOR(data_bits-1 DOWNTO 0) := "11111111";
--  CONSTANT EECON1_RESET     : STD_ULOGIC_VECTOR(4 DOWNTO 0)           := "0X000";
--  CONSTANT EECON2_RESET     : STD_ULOGIC_VECTOR(data_bits-1 DOWNTO 0) := "--------";
     
  ------------------------------------------------------------------------------
  ----- Operations Codes -------------------------------------------------------
  ------------------------------------------------------------------------------    

  ----- BYTE-ORIENTED FILE REGISTER OPERATIONS ---------------------------------
   
--  CONSTANT ADDWF  : STD_ULOGIC_VECTOR := "000111--------";
--  CONSTANT ANDWF  : STD_ULOGIC_VECTOR := "000101--------";
--  CONSTANT CLRF   : STD_ULOGIC_VECTOR := "0000011-------";
--  CONSTANT CLRW   : STD_ULOGIC_VECTOR := "0000010-------";
--  CONSTANT COMF   : STD_ULOGIC_VECTOR := "001001--------";
--  CONSTANT DECF   : STD_ULOGIC_VECTOR := "000011--------";
--  CONSTANT DECFSZ : STD_ULOGIC_VECTOR := "001011--------";
--  CONSTANT INCF   : STD_ULOGIC_VECTOR := "001010--------";
--  CONSTANT INCFSZ : STD_ULOGIC_VECTOR := "001111--------";
--  CONSTANT IORWF  : STD_ULOGIC_VECTOR := "000100--------";
--  CONSTANT MOVF   : STD_ULOGIC_VECTOR := "001000--------";
--  CONSTANT MOVWF  : STD_ULOGIC_VECTOR := "0000001-------";
--  CONSTANT NOP    : STD_ULOGIC_VECTOR := "0000000--00000";
--  CONSTANT RLF    : STD_ULOGIC_VECTOR := "001101--------";
--  CONSTANT RRF    : STD_ULOGIC_VECTOR := "001100--------";
--  CONSTANT SUBWF  : STD_ULOGIC_VECTOR := "000010--------";
--  CONSTANT SWAPF  : STD_ULOGIC_VECTOR := "001110--------";
--  CONSTANT XORWF  : STD_ULOGIC_VECTOR := "000110--------";
   
  ----- BIT-ORIENTED FILE REGISTER OPERATIONS ----------------------------------
   
--  CONSTANT BCF    : STD_ULOGIC_VECTOR := "0100----------";
--  CONSTANT BSF    : STD_ULOGIC_VECTOR := "0101----------";
--  CONSTANT BTFSC  : STD_ULOGIC_VECTOR := "0110----------";
--  CONSTANT BTFSS  : STD_ULOGIC_VECTOR := "0111----------";

  ----- LITERAL AND CONTROL OPERATIONS -----------------------------------------

--  CONSTANT ADDLW  : STD_ULOGIC_VECTOR := "11111---------";
--  CONSTANT ANDLW  : STD_ULOGIC_VECTOR := "111001--------";
--  CONSTANT CALL   : STD_ULOGIC_VECTOR := "100-----------";
--  CONSTANT CLRWDT : STD_ULOGIC_VECTOR := "00000001100100";
--  CONSTANT GOTO   : STD_ULOGIC_VECTOR := "101-----------";
--  CONSTANT IORLW  : STD_ULOGIC_VECTOR := "111000--------";
--  CONSTANT MOVLW  : STD_ULOGIC_VECTOR := "1100----------";
--  CONSTANT RETFIE : STD_ULOGIC_VECTOR := "00000000001001";
--  CONSTANT RETLW  : STD_ULOGIC_VECTOR := "1101----------";
--  CONSTANT RET    : STD_ULOGIC_VECTOR := "00000000001000";
--  CONSTANT SLEEP  : STD_ULOGIC_VECTOR := "00000001100011";
--  CONSTANT SUBLW  : STD_ULOGIC_VECTOR := "11110---------";
--  CONSTANT XORLW  : STD_ULOGIC_VECTOR := "111010--------";
  
  ------------------------------------------------------------------------------
  ----- Special Function Register Address --------------------------------------
  ------------------------------------------------------------------------------  
   
--  CONSTANT INDF_ADR    : STD_ULOGIC_VECTOR := "-0000000";
--  CONSTANT TMR0_ADR    : STD_ULOGIC_VECTOR := "00000001";
--  CONSTANT PCL_ADR     : STD_ULOGIC_VECTOR := "-0000010";
--  CONSTANT STATUS_ADR  : STD_ULOGIC_VECTOR := "-0000011";
--  CONSTANT FSR_ADR     : STD_ULOGIC_VECTOR := "-0000100";
--  CONSTANT PORTA_ADR   : STD_ULOGIC_VECTOR := "00000101";
--  CONSTANT PORTB_ADR   : STD_ULOGIC_VECTOR := "00000110";
--  CONSTANT EEDATA_ADR  : STD_ULOGIC_VECTOR := "00001000";
--  CONSTANT EEARD_ADR   : STD_ULOGIC_VECTOR := "00001001";
--  CONSTANT PCLATH_ADR  : STD_ULOGIC_VECTOR := "-0001010";
--  CONSTANT INTCON_ADR  : STD_ULOGIC_VECTOR := "-0001011";
--  CONSTANT OPTION_ADR  : STD_ULOGIC_VECTOR := "10000001";
--  CONSTANT TRISA_ADR   : STD_ULOGIC_VECTOR := "10000101";
--  CONSTANT TRISB_ADR   : STD_ULOGIC_VECTOR := "10000110";
--  CONSTANT EECON1_ADR  : STD_ULOGIC_VECTOR := "10001000";
--  CONSTANT EECON2_ADR  : STD_ULOGIC_VECTOR := "10001001";
   
  ------------------------------------------------------------------------------
  ----- STATUS Register Constants ----------------------------------------------
  ------------------------------------------------------------------------------
   
--  CONSTANT RP0_BIT   : INTEGER := 5;
--  CONSTANT TO_BIT    : INTEGER := 4;
--  CONSTANT PD_BIT    : INTEGER := 3;
--  CONSTANT Z_BIT     : INTEGER := 2;
--  CONSTANT DC_BIT    : INTEGER := 1;
--  CONSTANT CARRY_BIT : INTEGER := 0;
    
  ------------------------------------------------------------------------------
  ----- INTCON Register Constants ----------------------------------------------
  ------------------------------------------------------------------------------
    
--  CONSTANT GIE_BIT  : INTEGER := 7;
--  CONSTANT EEIE_BIT : INTEGER := 6;
--  CONSTANT T0IE_BIT : INTEGER := 5;
--  CONSTANT INTE_BIT : INTEGER := 4;
--  CONSTANT RBIE_BIT : INTEGER := 3;
--  CONSTANT T0IF_BIT : INTEGER := 2;
--  CONSTANT INTF_BIT : INTEGER := 1;
--  CONSTANT RBIF_BIT : INTEGER := 0;
       
  ------------------------------------------------------------------------------
  ----- OPTION Register Constants ----------------------------------------------
  ------------------------------------------------------------------------------
    
--  CONSTANT RBPU_BIT   : INTEGER := 7;
--  CONSTANT INTEDG_BIT : INTEGER := 6;
--  CONSTANT T0CS_BIT   : INTEGER := 5;
--  CONSTANT T0SE_BIT   : INTEGER := 4;
--  CONSTANT PSA_BIT    : INTEGER := 3;
--  CONSTANT PS2_BIT    : INTEGER := 2;
--  CONSTANT PS1_BIT    : INTEGER := 1;
--  CONSTANT PS0_BIT    : INTEGER := 0;    
  
  PROCEDURE read_ihex_file (program_name : IN STRING; memory : OUT program_array);
  
END PACKAGE read_intel_hex_pack;

PACKAGE BODY read_intel_hex_pack IS

  PROCEDURE str_to_hex (str : IN STRING; result : INOUT NATURAL) IS
    VARIABLE ch : CHARACTER;
    VARIABLE i : INTEGER := 0;
  BEGIN
    result := 0;
    FOR i IN 1 TO str'LENGTH LOOP
      ch := str(i);
      IF '0' <= ch and ch <= '9' THEN
        result := result*16 + character'pos(ch) - character'pos('0');
      ELSIF 'A' <= ch and ch <= 'F' THEN
        result := result*16 + character'pos(ch) - character'pos('A') + 10;
      ELSIF 'a' <= ch and ch <= 'f' THEN
        result := result*16 + character'pos(ch) - character'pos('a') + 10;
      ELSE
        -- ASSERT 1; REPORT "FAILURE: str_to_hex: Non-hex character encountered!"; SEVERITY FAILURE;
      END IF;
    END LOOP;
  END str_to_hex;
  
  PROCEDURE read_line_header (L : INOUT LINE; byte_count : INOUT INTEGER; address : INOUT INTEGER; record_type : INOUT INTEGER)  IS
    VARIABLE byte_count_str : STRING(1 to 2);
    VARIABLE address_str : STRING(1 to 4);
    VARIABLE record_type_str : STRING(1 to 2);
  BEGIN
    -- Read byte count
    FOR i IN 1 TO 2 LOOP
      READ(L, byte_count_str(i));
    END LOOP;
    str_to_hex(byte_count_str, byte_count);
    -- ASSERT debug; REPORT "DEBUG read_line_header: byte count is" & byte_count; SEVERITY NOTE;
    -- Read address
    FOR i IN 1 TO 4 LOOP
      READ(L, address_str(i));
    END LOOP;
    str_to_hex(address_str, address);
    -- ASSERT debug; REPORT "DEBUG read_line_header: address is" & address; SEVERITY NOTE;
    -- Read record type
    FOR i IN 1 TO 2 LOOP
      READ(L, record_type_str(i));
    END LOOP;
    str_to_hex(record_type_str, record_type);
    -- ASSERT debug; REPORT "DEBUG read_line_header: record type is" & recod_type; SEVERITY NOTE;
  END read_line_header;
  
  
  PROCEDURE read_instruction (L : INOUT LINE; instruction_hex : INOUT INTEGER) IS
    VARIABLE instruction_str : STRING(1 TO 4);
    VARIABLE instruction_str_tmp : STRING(1 TO 4);
    VARIABLE i : INTEGER;
    VARIABLE ch : CHARACTER;
  BEGIN
    -- L pointer is pointing to the instruction we want to read
    -- Thus, no need to update pointer
    
    -- Read instruction
    FOR i IN 1 TO 4 LOOP
      READ(L, instruction_str(i));
    END LOOP;
  
    -- Swap 2 lower and 2 higher byte: 1234 -> 3412
    instruction_str_tmp(1 TO 2) := instruction_str(1 to 2);
    instruction_str(1 TO 2) := instruction_str(3 to 4);
    instruction_str(3 TO 4) := instruction_str_tmp(1 TO 2);
    str_to_hex(instruction_str, instruction_hex);
    -- ASSERT debug; REPORT "DEBUG read_instruction: instruction " & instruction_no & "is " & instruction_hex; SEVERITY NOTE;
  END read_instruction;
  
  
  PROCEDURE read_ihex_file (program_name : IN STRING; memory : OUT program_array) IS
    FILE program    : TEXT OPEN READ_MODE IS program_name;
    VARIABLE L : LINE;
    VARIABLE byte_count : INTEGER := 0;
    VARIABLE address : NATURAL := 0;
    VARIABLE record_type : INTEGER := 0;
    -- VARIABLE base_address : INTEGER := 0;
    -- VARIABLE current_address : INTEGER := 0;
    VARIABLE instruction : INTEGER := 0;
    VARIABLE ch : CHARACTER;
  BEGIN
    WHILE NOT ENDFILE(program) LOOP
      byte_count := 0;    
      address := 0;       
      record_type := 0;   

      READLINE(program, L);
    
      -- Move line pointer over semicolon
      READ(L, ch);
      -- Read first byte count, address and record type on the line
      read_line_header(L, byte_count, address, record_type);
      
      CASE record_type IS
        
        WHEN 0 => -- Data record
          FOR i IN 1 TO byte_count/2 LOOP -- toimiiko jos byte count == 1?
            read_instruction(L, instruction);
            memory(address/2+i-1) := STD_LOGIC_VECTOR(to_unsigned(instruction, Inst_bits)); -- XXX
          END LOOP; 
          
        WHEN 1 => -- EOF record
          NULL;
        
        WHEN 2 => -- Extended Segment Address Record
          -- ASSERT 1; REPORT "Extended Segment Address record type 0x02 not implemented"; SEVERITY FAILURE; 
        
        WHEN 3 => -- Start Segment Address Record
          -- ASSERT 1; REPORT "Start Segment Address record type 0x03 not implemented"; SEVERITY FAILURE; 
        
        WHEN 4 => -- 
          -- FOR i IN 0 TO 1 LOOP
          read_instruction(L, instruction);
            -- ASSERT (instruction /= 0); REPORT "Extended Linear Address Record not zero";SEVERITY FAILURE; 
          -- END LOOP;
        
        WHEN 5 => -- Start Linear Address Record
          -- ASSERT 1; REPORT "Start Linear Address record type 0x05 not implemented"; SEVERITY FAILURE; 
        
        WHEN OTHERS =>
          -- ASSERT 1; REPORT "Invalid Intel HEX format record type"; SEVERITY FAILURE;    
        
        END CASE;
    
    END LOOP; -- Read file
  END PROCEDURE read_ihex_file;

END PACKAGE BODY read_intel_hex_pack;
    
--PROCEDURE read_ihex_file (program_name : IN STRING; memory : OUT program_array) IS -- pitaako maaritella tyyppi muualla??
--  FILE program    : TEXT IS IN "/home/pro/autosub/erkka/digital/modelsim/" & program_name; -- saako program namen?
--  TYPE program_array IS ARRAY (0 TO inst_mem_size-1) OF STD_LOGIC_VECTOR(Inst_bits-1 DOWNTO 0);
--  VARIABLE L : LINE;
--  VARIABLE byte_count : INTEGER := 0;
--  VARIABLE address : INTEGER := 0;
--  VARIABLE record_type : INTEGER := 0;
--  VARIABLE base_address : INTEGER := 0;
--  -- VARIABLE current_address : INTEGER := 0;
--  VARIABLE instruction : INTEGER := 0;
--BEGIN
--  WHILE NOT ENDFILE(program) LOOP
--    READLINE(program, L);
--    read_line_header(L, byte_count, address, record_type);
--    
--    CASE record_type IS
--      
--      WHEN X"00" => -- Data record
--        FOR i IN 0 TO byte_count-1 LOOP -- toimiiko jos byte count == 1?
--          read_instruction(L, i, instruction);
--          program_array(address/2 + i) := instruction; -- tsekkaa
--        END LOOP; 
--        
--      WHEN X"01" => -- EOF record
--        NULL;
--      
--      WHEN X"02" => -- Extended Segment Address Record
--        ASSERT 1; REPORT "Extended Segment Address record type 0x02 not implemented"; SEVERITY FAILURE; 
--      
--      WHEN X"03" => -- Start Segment Address Record
--        ASSERT 1; REPORT "Start Segment Address record type 0x03 not implemented"; SEVERITY FAILURE; 
--      
--      WHEN X"04" => -- 
--        FOR i IN 0 TO 1 LOOP
--          read_instruction(L, i, instruction);
--          ASSERT (instruction /= 0); REPORT "Extended Linear Address Record not zero";SEVERITY FAILURE; 
--        END LOOP;
--      
--      WHEN X"05" => -- Start Linear Address Record
--        ASSERT 1; REPORT "Start Linear Address record type 0x05 not implemented"; SEVERITY FAILURE; 
--      
--      WHEN OTHERS =>
--        ASSERT 1; REPORT "Invalid Intel HEX format record type"; SEVERITY FAILURE;    
--      
--      END CASE;
--  
--  END LOOP; -- Read file
--END PROCESS read_ihex_file;
--  
