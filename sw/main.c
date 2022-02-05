#include <neorv32.h>
#include "../rtl/ctucanfd_ip_core/driver/ctucanfd_regs.h"

#define CTUCAN_BASE 0xA0000000

#define CANIO(ADDR) (*(uint32_t *)(CTUCAN_BASE + ADDR))

int main() {
    int test = 0;
    test = CANIO(CTU_CAN_FD_YOLO_REG);
    
    neorv32_gpio_port_set(0);

    if(test){
        while(1){
            neorv32_gpio_port_set(1);
            neorv32_gpio_port_set(0);
        }
    }
    
}
