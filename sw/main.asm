
main.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__ctr0_io_space_end>:
   0:	00000037          	lui	zero,0x0

00000004 <__crt0_pointer_init>:
   4:	80002117          	auipc	sp,0x80002
   8:	ff810113          	addi	sp,sp,-8 # 80001ffc <__ctr0_io_space_begin+0x800021fc>
   c:	80000197          	auipc	gp,0x80000
  10:	7f418193          	addi	gp,gp,2036 # 80000800 <__ctr0_io_space_begin+0x80000a00>

00000014 <__crt0_cpu_csr_init>:
  14:	00000517          	auipc	a0,0x0
  18:	12450513          	addi	a0,a0,292 # 138 <__crt0_dummy_trap_handler>
  1c:	30551073          	csrw	mtvec,a0
  20:	34151073          	csrw	mepc,a0
  24:	30001073          	csrw	mstatus,zero
  28:	30401073          	csrw	mie,zero
  2c:	30601073          	csrw	mcounteren,zero
  30:	ffa00593          	li	a1,-6
  34:	32059073          	csrw	mcountinhibit,a1
  38:	b0001073          	csrw	mcycle,zero
  3c:	b8001073          	csrw	mcycleh,zero
  40:	b0201073          	csrw	minstret,zero
  44:	b8201073          	csrw	minstreth,zero

00000048 <__crt0_reg_file_clear>:
  48:	00000093          	li	ra,0
  4c:	00000213          	li	tp,0
  50:	00000293          	li	t0,0
  54:	00000313          	li	t1,0
  58:	00000393          	li	t2,0
  5c:	00000713          	li	a4,0
  60:	00000793          	li	a5,0
  64:	00000813          	li	a6,0
  68:	00000893          	li	a7,0
  6c:	00000913          	li	s2,0
  70:	00000993          	li	s3,0
  74:	00000a13          	li	s4,0
  78:	00000a93          	li	s5,0
  7c:	00000b13          	li	s6,0
  80:	00000b93          	li	s7,0
  84:	00000c13          	li	s8,0
  88:	00000c93          	li	s9,0
  8c:	00000d13          	li	s10,0
  90:	00000d93          	li	s11,0
  94:	00000e13          	li	t3,0
  98:	00000e93          	li	t4,0
  9c:	00000f13          	li	t5,0
  a0:	00000f93          	li	t6,0

000000a4 <__crt0_reset_io>:
  a4:	00000417          	auipc	s0,0x0
  a8:	d5c40413          	addi	s0,s0,-676 # fffffe00 <__ctr0_io_space_begin+0x0>
  ac:	00000497          	auipc	s1,0x0
  b0:	f5448493          	addi	s1,s1,-172 # 0 <__ctr0_io_space_end>

000000b4 <__crt0_reset_io_loop>:
  b4:	00042023          	sw	zero,0(s0)
  b8:	00440413          	addi	s0,s0,4
  bc:	fe941ce3          	bne	s0,s1,b4 <__crt0_reset_io_loop>

000000c0 <__crt0_clear_bss>:
  c0:	80000597          	auipc	a1,0x80000
  c4:	f4058593          	addi	a1,a1,-192 # 80000000 <__ctr0_io_space_begin+0x80000200>
  c8:	80000617          	auipc	a2,0x80000
  cc:	f3860613          	addi	a2,a2,-200 # 80000000 <__ctr0_io_space_begin+0x80000200>

000000d0 <__crt0_clear_bss_loop>:
  d0:	00c5d863          	bge	a1,a2,e0 <__crt0_clear_bss_loop_end>
  d4:	00058023          	sb	zero,0(a1)
  d8:	00158593          	addi	a1,a1,1
  dc:	ff5ff06f          	j	d0 <__crt0_clear_bss_loop>

000000e0 <__crt0_clear_bss_loop_end>:
  e0:	00000597          	auipc	a1,0x0
  e4:	10858593          	addi	a1,a1,264 # 1e8 <__crt0_copy_data_src_begin>
  e8:	80000617          	auipc	a2,0x80000
  ec:	f1860613          	addi	a2,a2,-232 # 80000000 <__ctr0_io_space_begin+0x80000200>
  f0:	80000697          	auipc	a3,0x80000
  f4:	f1068693          	addi	a3,a3,-240 # 80000000 <__ctr0_io_space_begin+0x80000200>

000000f8 <__crt0_copy_data_loop>:
  f8:	00d65c63          	bge	a2,a3,110 <__crt0_copy_data_loop_end>
  fc:	00058703          	lb	a4,0(a1)
 100:	00e60023          	sb	a4,0(a2)
 104:	00158593          	addi	a1,a1,1
 108:	00160613          	addi	a2,a2,1
 10c:	fedff06f          	j	f8 <__crt0_copy_data_loop>

00000110 <__crt0_copy_data_loop_end>:
 110:	00000513          	li	a0,0
 114:	00000593          	li	a1,0
 118:	06c000ef          	jal	ra,184 <main>

0000011c <__crt0_main_aftermath>:
 11c:	34051073          	csrw	mscratch,a0
 120:	00000093          	li	ra,0
 124:	00008463          	beqz	ra,12c <__crt0_main_aftermath_end>
 128:	000080e7          	jalr	ra

0000012c <__crt0_main_aftermath_end>:
 12c:	30047073          	csrci	mstatus,8

00000130 <__crt0_main_aftermath_end_loop>:
 130:	10500073          	wfi
 134:	ffdff06f          	j	130 <__crt0_main_aftermath_end_loop>

00000138 <__crt0_dummy_trap_handler>:
 138:	ff810113          	addi	sp,sp,-8
 13c:	00812023          	sw	s0,0(sp)
 140:	00912223          	sw	s1,4(sp)
 144:	34202473          	csrr	s0,mcause
 148:	02044663          	bltz	s0,174 <__crt0_dummy_trap_handler_irq>
 14c:	34102473          	csrr	s0,mepc

00000150 <__crt0_dummy_trap_handler_exc_c_check>:
 150:	00041483          	lh	s1,0(s0)
 154:	0034f493          	andi	s1,s1,3
 158:	00240413          	addi	s0,s0,2
 15c:	34141073          	csrw	mepc,s0
 160:	00300413          	li	s0,3
 164:	00941863          	bne	s0,s1,174 <__crt0_dummy_trap_handler_irq>

00000168 <__crt0_dummy_trap_handler_exc_uncrompressed>:
 168:	34102473          	csrr	s0,mepc
 16c:	00240413          	addi	s0,s0,2
 170:	34141073          	csrw	mepc,s0

00000174 <__crt0_dummy_trap_handler_irq>:
 174:	00012403          	lw	s0,0(sp)
 178:	00412483          	lw	s1,4(sp)
 17c:	00810113          	addi	sp,sp,8
 180:	30200073          	mret

00000184 <main>:
 184:	ff010113          	addi	sp,sp,-16
 188:	a00007b7          	lui	a5,0xa0000
 18c:	00812423          	sw	s0,8(sp)
 190:	0907a403          	lw	s0,144(a5) # a0000090 <__ctr0_io_space_begin+0xa0000290>
 194:	00000513          	li	a0,0
 198:	00000593          	li	a1,0
 19c:	00112623          	sw	ra,12(sp)
 1a0:	038000ef          	jal	ra,1d8 <neorv32_gpio_port_set>
 1a4:	02040063          	beqz	s0,1c4 <main+0x40>
 1a8:	00100513          	li	a0,1
 1ac:	00000593          	li	a1,0
 1b0:	028000ef          	jal	ra,1d8 <neorv32_gpio_port_set>
 1b4:	00000513          	li	a0,0
 1b8:	00000593          	li	a1,0
 1bc:	01c000ef          	jal	ra,1d8 <neorv32_gpio_port_set>
 1c0:	fe9ff06f          	j	1a8 <main+0x24>
 1c4:	00c12083          	lw	ra,12(sp)
 1c8:	00812403          	lw	s0,8(sp)
 1cc:	00000513          	li	a0,0
 1d0:	01010113          	addi	sp,sp,16
 1d4:	00008067          	ret

000001d8 <neorv32_gpio_port_set>:
 1d8:	fc000793          	li	a5,-64
 1dc:	00a7a423          	sw	a0,8(a5)
 1e0:	00b7a623          	sw	a1,12(a5)
 1e4:	00008067          	ret
