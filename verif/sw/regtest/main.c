#include <neorv32.h>
#include "ctucanfd_regs.h"
#include "canif.h"

int main() {
    volatile int test0 = can_read_32(0, CTU_CAN_FD_YOLO_REG);
    volatile int test1 = can_read_32(1, CTU_CAN_FD_YOLO_REG);
    volatile int test2 = can_read_32(2, CTU_CAN_FD_YOLO_REG);
}
