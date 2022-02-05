library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ts_gen is
    generic(
        -- System base clock frequency
        g_clk_freq  : integer := 12000000;

        -- increment timestamp every 1 us
        g_ts_freq   : integer := 1000000
    );
    port(
        -- Clock input
        i_clk   : in std_logic;
        -- Reset input
        i_rst_n : in std_logic;
        
        -- Timestamp value input
        o_ts    : out std_logic_vector(63 downto 0)
    );
end entity;

architecture rtl of ts_gen is
    constant c_ts_max   : unsigned(63 downto 0) := (others => '1');
    signal s_ts         : unsigned(63 downto 0);

    signal s_cnt : integer range 0 to g_clk_freq / g_ts_freq;

begin

    process(i_clk)
    begin
        if rising_edge(i_clk) then
            -- Generate syncronous reset
            if(i_rst_n = '0') then
                s_cnt <= 0;
                s_ts  <= (others => '0'); 
            else
            
                if( s_cnt < (g_clk_freq / g_ts_freq) - 1 ) then
                    s_cnt <= s_cnt + 1;
                else
                    s_cnt <= 0;

                    if( s_ts < c_ts_max) then
                        s_ts <= s_ts + 1;
                    else
                        s_ts <= (others => '0');
                    end if;
                end if;

            end if;
        end if;
    end process;

    o_ts <= std_logic_vector(s_ts);

end architecture;
