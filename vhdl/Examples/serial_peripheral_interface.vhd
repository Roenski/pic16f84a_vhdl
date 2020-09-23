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


-- Implementation of a generic SPI digital interface.
--
-- Data are fed into the inteface serially, through a long shift register.
-- From there, data are transferred to the configuration ports (by asserting
-- "write_config"), from where they reach the circuits to be controlled.
-- Reading of the monitor ports works the other way around: data are first
-- transferred to the shift register, then fed to output serially.
--
-- For more general information about the SPI standard, visit
-- http://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus
--
--
-- Created by Enrico Roverato on 04.07.2014
-- Last modification by Enrico Roverato on 17.02.2015


-- GENERICS:
-- WLconf => wordlength of configuration port
-- WLmon  => wordlength of monitor port
--
-- INPUT PORTS:
-- rst          => asynchronous reset signal
-- clk          => slow clock signal
-- MOSI         => Master Out Serial In (input serial data, must come MSB first)
-- write_config => asserted for one clock period to write to configuration port
-- read_monitor => asserted for one clock period to read from monitor port
-- monitor_port => input monitor signals
--
-- OUTPUT PORTS:
-- MISO        => Master In Serial Out (output serial data, will come MSB first)
-- config_port => output configuration signals


library ieee;
use ieee.std_logic_1164.all;


entity serial_peripheral_interface is
   generic(WLconf: integer := 500;
           WLmon:  integer := 500);
   port(rst:          in  std_logic;
        clk:          in  std_logic;
        MOSI:         in  std_logic;
        write_config: in  std_logic;
        read_monitor: in  std_logic;
        monitor_port: in  std_logic_vector(WLmon-1 downto 0);
        MISO:         out std_logic;
        config_port:  out std_logic_vector(WLconf-1 downto 0));
end serial_peripheral_interface;


architecture struct of serial_peripheral_interface is

   -- COMPONENT DECLARATIONS
   
   component d_ff is
      port(d:     in  std_logic;
           c:     in  std_logic;
           reset: in  std_logic;
           q:     out std_logic);
   end component;
   
   component n_bit_register_en is
      generic(n: integer);
      port(d:     in  std_logic_vector(n-1 downto 0);
           c:     in  std_logic;
           en:    in  std_logic;
           reset: in  std_logic;
           q:     out std_logic_vector(n-1 downto 0));
   end component;
   
   
   -- FUNCTION DECLARATIONS
   
   function max(L, R: integer) return integer is
   begin
      if L > R then
         return L;
      else
         return R;
      end if;
   end;
   
   
   -- CONSTANT DECLARATIONS
   
   constant WLspi: integer := max(WLmon, WLconf);
   
   
   -- SIGNAL DECLARATIONS
   
   signal data_chain: std_logic_vector(WLspi-1 downto 0);
   
   
begin

   -- connect local signals
   MISO <= data_chain(WLspi-1);
   
   
   ------------------------------------------------------------------------------
   -- SPI SHIFT REGISTER
   -- Consists of a chain of D flip-flops connected in series.
   ------------------------------------------------------------------------------
   
   SPI_shift_reg: for i in 0 to WLspi-1 generate
      signal d_ff_input, d_ff_output: std_logic;
   begin
      
      -- get output of previous flip-flop in the chain
      prev_dff_LSB: if i = 0 generate
         d_ff_output <= MOSI;
      end generate;
      pref_dff_MSBs: if i > 0 generate
         d_ff_output <= data_chain(i-1);
      end generate;
      
      -- set input to current flip-flop (2-to-1 muxes allow reading of the
      -- monitor port straight into the shift register)
      SPI_muxes: if i < WLmon generate
         d_ff_input <= monitor_port(i) when read_monitor = '1'
                       else d_ff_output;
      end generate;
      SPI_no_muxes: if i >= WLmon generate
         d_ff_input <= d_ff_output;
      end generate;
      
      -- instantiate current D flip-flop
      SPI_dff_inst: d_ff
         port map(d     => d_ff_input,
                  c     => clk,
                  reset => rst,
                  q     => data_chain(i));
      
   end generate;
   
   
   ------------------------------------------------------------------------------
   -- CONFIGURATION PORT REGISTER
   -- Takes data from input shift register when "write_config" is asserted.
   ------------------------------------------------------------------------------
   
   conf_port_reg: n_bit_register_en
      generic map(n => WLconf)
      port map(d     => data_chain(WLconf-1 downto 0),
               c     => clk,
               en    => write_config,
               reset => rst,
               q     => config_port);


end struct;
