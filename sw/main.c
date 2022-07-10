#include <neorv32.h>
#include "../rtl/ctucanfd_ip_core/driver/ctucanfd_regs.h"

#define CTUCAN_BASE 0xA0000000
#define CTUCAN_SIZE 0x1000

#define CANIO(IF, ADDR) (*(uint32_t *)(CTUCAN_BASE + IF * CTUCAN_SIZE + ADDR))

int main() {
    volatile int test0 = CANIO(0, CTU_CAN_FD_YOLO_REG);
    volatile int test1 = CANIO(1, CTU_CAN_FD_YOLO_REG);
    volatile int test2 = CANIO(2, CTU_CAN_FD_YOLO_REG);
    volatile int test3 = CANIO(3, CTU_CAN_FD_YOLO_REG);
    
    neorv32_gpio_port_set(0);
    neorv32_gpio_port_set(1);

    
}
