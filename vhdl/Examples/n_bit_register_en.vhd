------------------------------------------------------------------------------
-- Copyright (c) 2014  Aalto University
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- Licensee is not allowed to distribute the Software by making it publicly
-- available.
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
------------------------------------------------------------------------------


-- N-bit register with enable and ASYNCHRONOUS reset signal
--
-- Last modification by Enrico Roverato on 04.02.2013


-- GENERICS:
-- n = number of bits (i.e. wordlength)

-- INPUT PORTS:
-- d = data in
-- c = clock signal
-- en = enable signal
-- reset = asynchronous reset signal

-- OUTPUT PORTS:
-- q = data out


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY n_bit_register_en IS
    GENERIC(n: INTEGER);
    PORT(d:     IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
         c:     IN  STD_LOGIC;
         en:    IN  STD_LOGIC;
	       reset: IN  STD_LOGIC;
         q:     OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END ENTITY n_bit_register_en;


ARCHITECTURE n_bit_register_rtl OF n_bit_register_en is
  
BEGIN

  register_reg: PROCESS (c,reset)
  BEGIN
    IF reset = '1' THEN
      q <= (OTHERS => '0');
  	 ELSIF rising_edge(c) THEN
  	   IF en = '1' THEN
	      q <= d;
	    END IF;
  	 END IF;
  END PROCESS register_reg;

END ARCHITECTURE n_bit_register_rtl;
