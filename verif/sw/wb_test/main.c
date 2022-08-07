#include <neorv32.h>
#include "../../../ip/ctucanfd/driver/ctucanfd_regs.h"

#define CTUCAN_BASE 0xA0000000
#define CTUCAN_SIZE 0x1000

#define CANIO(IF, ADDR) (*(uint32_t *)(CTUCAN_BASE + IF * CTUCAN_SIZE + ADDR))

int main() {
    CANIO(0, CTU_CAN_FD_MODE) = 1 << 1;
    CANIO(1, CTU_CAN_FD_MODE) = 2 << 1;
    CANIO(2, CTU_CAN_FD_MODE) = 3 << 1;
    CANIO(3, CTU_CAN_FD_MODE) = 4 << 1;

    int test0 = CANIO(0, CTU_CAN_FD_MODE);
    int test1 = CANIO(1, CTU_CAN_FD_MODE);
    int test2 = CANIO(2, CTU_CAN_FD_MODE);
    int test3 = CANIO(3, CTU_CAN_FD_MODE);

    if(test0 || test1 || test2 || test3){
        neorv32_gpio_port_set(0);
        neorv32_gpio_port_set(1);
    }
    
    
}
