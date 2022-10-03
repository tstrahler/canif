#include <stdint.h>
#include "ctucanfd_regs.h"
#include "canif.h"

void can_write_32(uint32_t if_no, enum ctu_can_fd_can_registers reg, uint32_t data){
    *((uint32_t *) CTU_CAN_FD_BASE_ADDR + CTU_CAN_FD_SIZE * if_no + reg) = data;
}


uint32_t can_read_32(uint32_t if_no, enum ctu_can_fd_can_registers reg){
    return *((uint32_t *) CTU_CAN_FD_BASE_ADDR + CTU_CAN_FD_SIZE * if_no + reg);
}

