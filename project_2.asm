.data
	menu: .asciiz "============= Menu ============\n1. Nhap mang\n2. Xuat mang\n3. Liet ke so nguyen to trong mang\n4. Liet ke so hoan thien trong mang\n5. Tinh tong cac so chinh phuong trong mang\n6. Tinh trung binh cong cac so doi xung trong mang\n7. Tim gia tro lon nhat trong mang\n8. Sap xep mang tang dan theo Selection sort\n9. Sap xep mang giam dan theo Bubble sort\n10. Thoat\n================================\n"
	a: .word 1,9,5,3,7,11,0,2,8,6
	n: .word 10
.text
	.globl main
main:
	la $a0, a
	lw $a1, n
	jal _bubbleSort
	
	li $v0, 4
	la $a0, menu
	syscall
	
main.exit:
	li $v0, 10
	syscall	
	
##Use bubble sort algorithm to sort content of array a which has n elements
##Params:
##	$a0: a
##	$a1: n
##Return:
##	none
##Registers used:
##	$s0:	save a0
##	$s1:	save a1
##	$t0:	i (couting 1)
##	$t1:	j (couting 2)
##	$t2: 	commpare value
##	$t3:	a[j]
##	$t4:	a[j+1]
##	$t5:	temp
_bubbleSort:
##Procerduce header----------------------------------------------------------
	addi $sp, $sp, -32		#Create stack frame, framesize = 32
	sw $ra, 28($sp)			#Preserve return address
	sw $fp, 24($sp)			#Preserve frame pointer
	sw $s0, 20($sp)			#Preserve s0
	sw $s1, 16($sp)			#Preserve s1
	addi $fp, $sp, 32		#Move frame pointer to base of frame
	
	move $s0, $a0			#Get a0 from caller
	move $s1, $a1			#Get a1 from caller
##---------------------------------------------------End of procerduce header
	
	li $t5, 2			#temporarily set t0 = 2
	slt $t2, $s1, $t5		#check if length of array < 2
	beq $t2, 1, _bubbleSort.return	#if yes, return
	
	move $t0, $zero			#i = 0
_bubbleSort.loopI:
	move $t1, $zero			#j = 0
	move $s0, $a0			#s0 = a0
_bubbleSort.loopJ:
	lw $t3, ($s0)			#t3 = a[j]
	lw $t4, 4($s0)			#t4 = a[j+1]	
	
	sgt $t2, $t3, $t4		#check if a[j] > a[j+1]
	beq $t2, 0, _bubbleSort.loopJ.continue	#if not continue loop j
	
	sw $t4, ($s0)			#swap a[i]
	sw $t3, 4($s0)			#	and a[j+1]
_bubbleSort.loopJ.continue:
	addi $t1, $t1, 1		#j++
	addi $s0, $s0, 4		#a[j] = a[j+1]
	
	#t5 = n-i-1
	sub $t5, $s1, $t0		#t5 = n - i
	addi $t5, $t5, -1		#t5 = t5 - 1
	
	slt $t2, $t1, $t5		#check if j < n-i-1
	beq $t2, 1, _bubbleSort.loopJ	#if yes then loopJ
	
	addi $t0, $t0, 1		#i++
	addi $t5, $s1, -1		#t5 = n - i
	
	slt $t2, $t0, $t5		#check if i < n-1
	beq $t2, 1, _bubbleSort.loopI	#if yes then loopI
	
##Procerduce footer------------------------------------------------
_bubbleSort.return:
	lw $s1, 16($sp)			#Restore s1
	lw $s2, 20($sp)			#restore s2
	lw $fp, 24($sp)			#Restore frame pointer
	lw $ra, 28($sp)			#Restore return address
	addi $sp, $sp, 32		#Restore stack pointer
	jr $ra				#Return
##------------------------------------------End of procerduce footer
