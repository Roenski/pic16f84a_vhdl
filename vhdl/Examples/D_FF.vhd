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


-- D-type Flip-Flop with ASYNCHRONOUS reset signal
--
-- Last modification by Enrico Roverato on 23.01.2013


-- INPUT PORTS:
-- d = data in
-- c = clock signal
-- reset = asynchronous reset signal

-- OUTPUT PORTS:
-- q = data out


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY D_FF IS
PORT(d , c: IN  STD_LOGIC;
     reset: IN  STD_LOGIC;
     q:     OUT STD_LOGIC);
END ENTITY D_FF;


ARCHITECTURE D_FF_rtl OF D_FF IS
  
BEGIN

  dff_reg : PROCESS (c,reset)
  BEGIN
      IF reset = '1' THEN
        q <= '0';
      ELSIF c'event AND c = '1' THEN
	      q <= d;
      END IF;
  END PROCESS dff_reg;

END ARCHITECTURE D_FF_rtl;
