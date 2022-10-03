#ifndef _CANIF_H
#define _CANIF_H

#include <stdint.h>
#include "ctucanfd_regs.h"

#define CTU_CAN_FD_BASE_ADDR    0xA0000000
#define CTU_CAN_FD_SIZE         0x1000

void can_write_32(uint32_t if_no, enum ctu_can_fd_can_registers reg, uint32_t data);
uint32_t can_read_32(uint32_t if_no, enum ctu_can_fd_can_registers reg);

#endif /* _CANIF_H */
