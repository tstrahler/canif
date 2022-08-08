
main.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	30005073          	csrwi	mstatus,0

00000004 <__crt0_pointer_init>:
   4:	80002117          	auipc	sp,0x80002
   8:	ff810113          	addi	sp,sp,-8 # 80001ffc <__crt0_stack_begin+0x0>
   c:	80000197          	auipc	gp,0x80000
  10:	7f418193          	addi	gp,gp,2036 # 80000800 <__crt0_stack_begin+0xffffe804>

00000014 <__crt0_cpu_csr_init>:
  14:	00000517          	auipc	a0,0x0
  18:	13050513          	addi	a0,a0,304 # 144 <__crt0_trap_handler>
  1c:	30551073          	csrw	mtvec,a0
  20:	30001073          	csrw	mstatus,zero
  24:	30401073          	csrw	mie,zero
  28:	34401073          	csrw	mip,zero
  2c:	32001073          	csrw	mcountinhibit,zero
  30:	30601073          	csrw	mcounteren,zero
  34:	b0001073          	csrw	mcycle,zero
  38:	b8001073          	csrw	mcycleh,zero
  3c:	b0201073          	csrw	minstret,zero
  40:	b8201073          	csrw	minstreth,zero

00000044 <__crt0_reg_file_init>:
  44:	00000213          	li	tp,0
  48:	00000293          	li	t0,0
  4c:	00000313          	li	t1,0
  50:	00000393          	li	t2,0
  54:	00000813          	li	a6,0
  58:	00000893          	li	a7,0
  5c:	00000913          	li	s2,0
  60:	00000993          	li	s3,0
  64:	00000a13          	li	s4,0
  68:	00000a93          	li	s5,0
  6c:	00000b13          	li	s6,0
  70:	00000b93          	li	s7,0
  74:	00000c13          	li	s8,0
  78:	00000c93          	li	s9,0
  7c:	00000d13          	li	s10,0
  80:	00000d93          	li	s11,0
  84:	00000e13          	li	t3,0
  88:	00000e93          	li	t4,0
  8c:	00000f13          	li	t5,0
  90:	00000f93          	li	t6,0

00000094 <__crt0_copy_data>:
  94:	20000593          	li	a1,512
  98:	80000617          	auipc	a2,0x80000
  9c:	f6860613          	addi	a2,a2,-152 # 80000000 <__crt0_stack_begin+0xffffe004>
  a0:	80000697          	auipc	a3,0x80000
  a4:	f6068693          	addi	a3,a3,-160 # 80000000 <__crt0_stack_begin+0xffffe004>
  a8:	00c58e63          	beq	a1,a2,c4 <__crt0_clear_bss>

000000ac <__crt0_copy_data_loop>:
  ac:	00d65c63          	bge	a2,a3,c4 <__crt0_clear_bss>
  b0:	0005a703          	lw	a4,0(a1)
  b4:	00e62023          	sw	a4,0(a2)
  b8:	00458593          	addi	a1,a1,4
  bc:	00460613          	addi	a2,a2,4
  c0:	fedff06f          	j	ac <__crt0_copy_data_loop>

000000c4 <__crt0_clear_bss>:
  c4:	80000717          	auipc	a4,0x80000
  c8:	f3c70713          	addi	a4,a4,-196 # 80000000 <__crt0_stack_begin+0xffffe004>
  cc:	80000797          	auipc	a5,0x80000
  d0:	f3478793          	addi	a5,a5,-204 # 80000000 <__crt0_stack_begin+0xffffe004>

000000d4 <__crt0_clear_bss_loop>:
  d4:	00f75863          	bge	a4,a5,e4 <__crt0_call_constructors>
  d8:	00072023          	sw	zero,0(a4)
  dc:	00470713          	addi	a4,a4,4
  e0:	ff5ff06f          	j	d4 <__crt0_clear_bss_loop>

000000e4 <__crt0_call_constructors>:
  e4:	20000413          	li	s0,512
  e8:	20000493          	li	s1,512

000000ec <__crt0_call_constructors_loop>:
  ec:	00945a63          	bge	s0,s1,100 <__crt0_call_constructors_loop_end>
  f0:	0009a083          	lw	ra,0(s3)
  f4:	000080e7          	jalr	ra
  f8:	00440413          	addi	s0,s0,4
  fc:	ff1ff06f          	j	ec <__crt0_call_constructors_loop>

00000100 <__crt0_call_constructors_loop_end>:
 100:	00000513          	li	a0,0
 104:	00000593          	li	a1,0
 108:	088000ef          	jal	ra,190 <main>

0000010c <__crt0_main_exit>:
 10c:	30047073          	csrci	mstatus,8
 110:	34051073          	csrw	mscratch,a0

00000114 <__crt0_call_destructors>:
 114:	20000413          	li	s0,512
 118:	20000493          	li	s1,512

0000011c <__crt0_call_destructors_loop>:
 11c:	00945a63          	bge	s0,s1,130 <__crt0_call_destructors_loop_end>
 120:	00042083          	lw	ra,0(s0)
 124:	000080e7          	jalr	ra
 128:	00440413          	addi	s0,s0,4
 12c:	ff1ff06f          	j	11c <__crt0_call_destructors_loop>

00000130 <__crt0_call_destructors_loop_end>:
 130:	00000093          	li	ra,0
 134:	00008463          	beqz	ra,13c <__crt0_main_aftermath_end>
 138:	000080e7          	jalr	ra

0000013c <__crt0_main_aftermath_end>:
 13c:	10500073          	wfi
 140:	0000006f          	j	140 <__crt0_main_aftermath_end+0x4>

00000144 <__crt0_trap_handler>:
 144:	ff810113          	addi	sp,sp,-8
 148:	00812023          	sw	s0,0(sp)
 14c:	00912223          	sw	s1,4(sp)
 150:	34202473          	csrr	s0,mcause
 154:	02044663          	bltz	s0,180 <__crt0_trap_handler_end>
 158:	34102473          	csrr	s0,mepc
 15c:	00041483          	lh	s1,0(s0)
 160:	0034f493          	andi	s1,s1,3
 164:	00240413          	addi	s0,s0,2
 168:	34141073          	csrw	mepc,s0
 16c:	00300413          	li	s0,3
 170:	00941863          	bne	s0,s1,180 <__crt0_trap_handler_end>
 174:	34102473          	csrr	s0,mepc
 178:	00240413          	addi	s0,s0,2
 17c:	34141073          	csrw	mepc,s0

00000180 <__crt0_trap_handler_end>:
 180:	00012403          	lw	s0,0(sp)
 184:	00412483          	lw	s1,4(sp)
 188:	00810113          	addi	sp,sp,8
 18c:	30200073          	mret

00000190 <main>:
 190:	ff010113          	addi	sp,sp,-16
 194:	00112623          	sw	ra,12(sp)
 198:	a00007b7          	lui	a5,0xa0000
 19c:	00200713          	li	a4,2
 1a0:	00e7a223          	sw	a4,4(a5) # a0000004 <__crt0_stack_begin+0x1fffe008>
 1a4:	a00017b7          	lui	a5,0xa0001
 1a8:	00400713          	li	a4,4
 1ac:	00e7a223          	sw	a4,4(a5) # a0001004 <__crt0_stack_begin+0x1ffff008>
 1b0:	a00027b7          	lui	a5,0xa0002
 1b4:	00600713          	li	a4,6
 1b8:	00e7a223          	sw	a4,4(a5) # a0002004 <__crt0_stack_begin+0x20000008>
 1bc:	a00037b7          	lui	a5,0xa0003
 1c0:	00800713          	li	a4,8
 1c4:	00e7a223          	sw	a4,4(a5) # a0003004 <__crt0_stack_begin+0x20001008>
 1c8:	00000513          	li	a0,0
 1cc:	00000593          	li	a1,0
 1d0:	020000ef          	jal	ra,1f0 <neorv32_gpio_port_set>
 1d4:	00100513          	li	a0,1
 1d8:	00000593          	li	a1,0
 1dc:	014000ef          	jal	ra,1f0 <neorv32_gpio_port_set>
 1e0:	00c12083          	lw	ra,12(sp)
 1e4:	00000513          	li	a0,0
 1e8:	01010113          	addi	sp,sp,16
 1ec:	00008067          	ret

000001f0 <neorv32_gpio_port_set>:
 1f0:	fc000793          	li	a5,-64
 1f4:	00a7a423          	sw	a0,8(a5)
 1f8:	00b7a623          	sw	a1,12(a5)
 1fc:	00008067          	ret
