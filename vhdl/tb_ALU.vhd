LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

LIBRARY work;
USE work.cpu_types.ALL;

ENTITY tb_alu IS
END ENTITY tb_alu;

ARCHITECTURE behav OF tb_alu IS

    SIGNAL  op1, op2    : word8;
    SIGNAL  op_func     : op_code;
    SIGNAL  bs          : word3;
    SIGNAL  st          : word3;
    SIGNAL  st_in       : word3;
    SIGNAL  res         : word8;
            

BEGIN
    
    ALU : ENTITY work.alu(rtl)
    PORT MAP (
            W           => op1,
            f 		    => op2,
            operation   => op_func,
            bit_select  => bs,
            st_in   => st_in,
            result      => res,
            st_out      => st
        );
    run_sim : PROCESS IS

        VARIABLE line_var   : LINE;
        VARIABLE op_var     : STRING(1 TO 6);
        VARIABLE vector_var : INTEGER;

        FILE input_file : TEXT
            OPEN READ_MODE IS "inputs.txt";
        FILE output_file : TEXT
            OPEN WRITE_MODE IS "outputs.txt";

    BEGIN
        st_in   <= "000";
        WHILE NOT ENDFILE(input_file) LOOP
            READLINE(input_file, line_var);
            READ(line_var, op_var);
            op_func <= str_to_op(op_var);
            READ(line_var, vector_var);
            op1 <= STD_LOGIC_VECTOR(TO_UNSIGNED(vector_var,8));
            READ(line_var, vector_var);
            op2 <= STD_LOGIC_VECTOR(TO_UNSIGNED(vector_var,8));
            READ(line_var, vector_var);
            bs <= STD_LOGIC_VECTOR(TO_UNSIGNED(vector_var,3));
            WAIT FOR 5 ns;
            write(line_var, res);
            write(line_var, ' ');
            write(line_var, st);
            writeline(output_file, line_var);
        END LOOP;
        WAIT;

    END PROCESS;



END ARCHITECTURE behav;
