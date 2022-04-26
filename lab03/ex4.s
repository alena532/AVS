.globl iterative
.globl recursive

.data
n: .word 2
m: .word 2

.text
main:
    la t0, n
    lw a0, 0(t0)
    addi a1,zero,6
    jal tester
    
	mv t3,a0
    addi a0, x0, 1 # аргумент ecall указывающий на печать целого
    addi a1, t3, 0 # аргумент ecall, значение для печати
    ecall # вызов печати целого
   
    addi a0, x0, 10
    ecall # Exit

tester:
	addi  sp, sp, -12
	sw ra, 8(sp)
    sw a0, 4(sp)#номер элемента
    sw a1, 0(sp)#a1-первый элемент
    addi a0,a0,-1
	jal iterative
    
    mv t5,a0#save result 1
    lw    ra, 8(sp)
    lw a0, 4(sp)#номер элемента
    lw a1, 0(sp)#a1-первый элемент
    addi a0,a0,-1
    addi  sp, sp, 12
    addi  sp, sp, -4
    sw ra, 0(sp)

    jal recursive
    lw ra,0(sp)
    addi  sp, sp, 4
    mv a0,a1
    
    beq t5,a0,eq
    addi a0,zero,-1
    eq:
	jr ra

iterative:
    while:
    	beq zero,a0,done
        addi a1,a1,3#Увеличиваем 3 элемент на 3
        addi a0,a0,-1
        j while
    done:
    	mv a0,a1
        jr ra
    	
rec:
	addi a0,zero ,1
    jr ra
    
recursive:
    addi  sp, sp, -12
	sw   a0, 4(sp)
	sw   ra, 0(sp)
    sw   a1, 8(sp)
	bgt  a0, zero, else
	mv a0,a1
	addi sp, sp, 12
	jr   ra
	else:
    	addi a1, a1, 3
    	addi a0, a0, -1
		jal  recursive
   		lw   t1, 4(sp)
    	lw   ra, 0(sp)
    	lw   t2, 8(sp)
        addi  sp, sp, 12
	jr ra