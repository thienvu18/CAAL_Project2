.data
	menu:		.asciiz	"============= Menu ============\n1. Nhap mang\n2. Xuat mang\n3. Liet ke so nguyen to trong mang\n4. Liet ke so hoan thien trong mang\n5. Tinh tong cac so chinh phuong trong mang\n6. Tinh trung binh cong cac so doi xung trong mang\n7. Tim gia tri lon nhat trong mang\n8. Sap xep mang tang dan theo Selection sort\n9. Sap xep mang giam dan theo Bubble sort\n10. Thoat\n================================\n"
	choose_msg:	.asciiz	"Nhap so ban chon: "
	pause_msg:	.asciiz	"Nhan enter de tiep tuc."
	chosen:		.word	1
	array: 		.word 1,9,5,3
	n: 		.word 4
        
        tb1:  .asciiz  "Nhap n: "
	tb2:  .asciiz  "a[ "
	tb3:  .asciiz  " ] = "
	output:  .asciiz  "\nMang da nhap: "
	arr:  .word  0:100   # int array[100]

	tb4: .asciiz "Tong cac so chinh phuong trong mang: "

.text
	.globl main
main:
#Show the menu and then read the user's chosen
main.menu:
	#Print menu
	li $v0, 4
	la $a0, menu
	syscall
	
	#Print chosen request
	li $v0, 4
	la $a0, choose_msg
	syscall
	
	#Read user's choen
	li $v0, 5
	syscall
	sw $v0, chosen			#Save user's chosen to ram
	
	#Jump to execute
	j main.execute
	
#Execute the option that the user choose
main.execute:
	lw $t0, chosen				#Load user's choosen
	
	slti $t1, $t0, 1			#if user choose a number that less than 1
	beq $t1, 1, main.menu			#then show the menu and ask user to choose again
	sgtu $t1, $t0, 10			#if user choose a number that greater than 10
	beq $t1, 1, main.menu			#ask him to choose again, too
	
	beq $t0, 1, main.exe_ReadArray		#If user choose 1 then jump to ReadArray
	beq $t0, 2, main.exe_PrintArray		#If user choose 2 then jump to PrintArray
	beq $t0, 3, main.exe_ListPrimes		#If user choose 3 then jump to ListPrimes
	beq $t0, 4, main.exe_ListPerfects	#If user choose 4 then jump to ListPerfects
	beq $t0, 5, main.exe_SumSquareNums	#If user choose 5 then jump to SumSquareNums
	beq $t0, 6, main.exe_AveragePalindromes	#If user choose 6 then jump to AveragePalindromes
	beq $t0, 7, main.exe_FindMax		#If user choose 7 then jump to FindMax
	beq $t0, 8, main.exe_SelectionSort	#If user choose 8 then jump to SelectionSort
	beq $t0, 9, main.exe_BubbleSort		#If user choose 9 then jump to BubbleSort
	beq $t0, 10, main.exit			#If user choose 10 then exit
	
main.exe_ReadArray:
	#Call ReadArray
	la $a0, array			#Load dia chi mang vao a0
	lw $a1, n			#Load so phan tu mang vao a1
	jal _ReadArray			#Goi ham
	#Pause program
	j main.pause
main.exe_PrintArray:
        #Call PrintArray
	la $a0, array			#Load array address to a0
	lw $a1, n			#Load number lenght of array to a1
        jal _PrintArray 
        
	#Pause program
	j main.pause
main.exe_ListPrimes:
	#Pause program
	j main.pause
main.exe_ListPerfects:
	#Pause program
	j main.pause
main.exe_SumSquareNums:
        la $a0, array
        lw $a1, n
        jal _SumSquareNums
	#Pause program
	j main.pause
main.exe_AveragePalindromes:
        #Call AveragePalindromes
	la $a0, array			#Load array address to a0
	lw $a1, n			#Load number lenght of array to a1
        jal _AveragePalindromes
        
	#Pause program
	j main.pause
main.exe_FindMax:
	la $a0, array			#Load array address to a0
	lw $a1, n			#Load number lenght of array to a1
	jal _FindMax			#Call
	
	move $t0,$v1

	li $v0, 4
	la $a0,tb1
	syscall

	li $v0, 1
	move $a0, $t0
	syscall
	#Pause program
	j main.pause
main.exe_SelectionSort:
	#Call SelectionSort
	la $a0, array			#Load array address to a0
	lw $a1, n			#Load number lenght of array to a1
	jal _selectionSort		#Call
	
	#Pause program
	j main.pause
main.exe_BubbleSort:
	#Call BubbleSort
	la $a0, array			#Load array address to a0
	lw $a1, n			#Load number lenght of array to a1
	jal _bubbleSort			#Call
	
	#Pause program
	j main.pause
	
main.pause:
	#Print pause message
	li $v0, 4
	la $a0, pause_msg
	syscall
	
	#Pause program by call read char
	li $v0, 12
	syscall
	
	#Return to print menu
	j main.menu	
	
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
	
	slt $t2, $t3, $t4		#check if a[j] < a[j+1]
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
_PrintArray:
	#size of stack
	addi $sp,$sp,-20
	#backup registers
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $t0,12($sp)
	sw $t1,16($sp)

	move $s0, $a0			#save address of arr to $s0
	move $s1, $a1			#save size of arr to $s1	
	#innit i = 0
	li $t0,0
outputLoop:
	
	li $v0, 1			#print a[i]
	lw $a0, ($s0)
	syscall

	li $v0, 11			#printf space
	li $a0, 32 			#32 = space
	syscall

	addi $s0, $s0, 4		#increase address of arr
	
	addi $t0, $t0, 1		#i++

	slt $t1, $t0, $s1		#if i < n then goto outputLoop
	bne $t1, $0, outputLoop

	#restore registers
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $t0,12($sp)
	lw $t1,16($sp)

	#delete stack
	addi $sp,$sp,20

	#return adrress $ra
	jr $ra

_AveragePalindromes:	
	#size of stack
	addi $sp,$sp,-56
	#backup registers
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4,20($sp)
	sw $t0,24($sp)
	sw $t1,28($sp)
	sw $t2,32($sp)
	sw $t3,36($sp)
	sw $t4,40($sp)
	sw $t5,44($sp)
	sw $t6,48($sp)
	sw $t7,52($sp)

	move $s0, $a0			#save address of arr to $s0
	move $s1, $a1			#save size of arr to $s1
	
	li $t0, 0			#init i = 0
	li $t1, 0			#init amount of symmetric numbers k = 0
	li $s2, 0			#init result = 0

LoopOfI:
	lw $t2, ($s0)			#$t2 = a[i]
	slti $t3, $t2, 11 		#if a[i] > 10 go L0
	beq $t3, $0, L0			
					#else
L2:
	addi $t0, $t0, 1		#i++
	addi $s0, $s0, 4		#increase address of a[i]
	slt $t3, $t0, $s1 		#if i < n then goto LoopOfI
	bne $t3, $0, LoopOfI		
	j L3				#else goto L3
L0:
	li $s3, 0			#init s= 0
	lw $s4, ($s0)			#init temp = a[i]
LoopOfSeperate:
	div $s4, $s4, 10		#temp /= 10
	mflo $t4			#lo
	mfhi $t5			#hi
	li $t6, 10			#$t6 = 10
	mult $s3, $t6			#s *= 10
	mflo $t7			#result of s
	move $s3, $t7			
	add $s3, $s3, $t5		#s += hi
	bne $t4, $0, LoopOfSeperate	#if lo != 0 goto LoopOfSeperate
	beq $s3, $t2, L1
	j L2
L1:
	add $s2, $s2, $t2		#s+=a[i]
	addi $t1, $t1, 1		#k++
	j L2
L3:
	#result
	beq $s2, $0, L4
	div $s2, $t1
	mflo $s2
L4:
	move $v0, $s2			#save $s2 to $v0
	#restore registers
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $t0,24($sp)
	lw $t1,28($sp)
	lw $t2,32($sp)
	lw $t3,36($sp)
	lw $t4,40($sp)
	lw $t5,44($sp)
	lw $t6,48($sp)
	lw $t7,52($sp)

	#delete stack
	addi $sp,$sp,56

	#return address $ra
	jr $ra

# $t0 so phan tu mang	
# $t1 chi so phan tu mang
# $a1 dia chi cac phan tu mang
# $s0 thanh ghi luu cac phan tu mang
#Phan Header
_ReadArray:
	#Khai b�o kich thuoc stack
	addi $sp, $sp, -16
	#Backup thanh ghi
	sw $ra,($sp)
	sw $t0, 4($sp)
	sw $s0, 8($sp)
	sw $t1, 12($sp)

#Phan Than
_ReadArray.TaoVongLap:
	li $t0, 0  		 # i = 0
	la $s0, arr		 #load dia chi mang vao s0

_ReadArray.XuatTB1:		#Xuat tb1
	li $v0,4
	la $a0,tb1
	syscall
_ReadArray.Nhapn:
	li $v0,5		#Nhap n
	syscall
	
	sw $v0,n		#Luu vao n
	lw $s1,n		#Truyen tham so
	
	
_ReadArray.XuatTB2:		#Xuat tb2
	li $v0,4
	la $a0,tb2
	syscall

_ReadArray.Xuati:		#xuat chi so i
	li $v0,1
	move $a0,$t0
	syscall

_ReadArray.XuatTB3:		#Xuat tb3
	li $v0,4
	la $a0,tb3
	syscall

	
_ReadArray.Nhapmang:		#Nhap so nguyen
	li $v0,5
	syscall
	sw $v0,($s0)		#Luu vao a[i] ($s0)
	addi $s0 , $s0 , 4	#Tang dia chi mang
	addi $t0,$t0,1		#Tang chi so i
_ReadArray.KiemTra:	
	slt $t1 , $t0, $s1
	beq $t1 , 1 , _ReadArray.XuatTB2
	j _ReadArray.Ketthuc

#Phan ket thuc
_ReadArray.Ketthuc:
	lw $ra,($sp)
	lw $t0, 4($sp)
	lw $s0, 8($sp)
	lw $t1, 12($sp)

	addi $sp, $sp, 20
	#Nhay ve dia chi ham $ra
	jr $ra

##Tong cac so chinh phuong trong mang
#Phan Header
_SumSquareNums:
	#size of stack
	addi $sp,$sp,-36
	#backup thanh ghi
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $t0,16($sp)
	sw $t1,20($sp)
	sw $t2,24($sp)
	sw $t3,28($sp)
	sw $t4,32($sp)

        move $s0, $a0
        move $s1, $a1

#Phan Than
_SumSquareNums.XuatTB:
	li $v0,4
	la $a0,tb4
	syscall

	
	li $t0, 0			#Khoi tao i = 0
	li $s2, 0			#Khoi tao s = 0

_SumSquareNums.LapI:
	li $t1, 1			#Khoi tao j = 1
	lw $t2, ($s0)			#$t2 = a[i]
	
_SumSquareNums.LapJ:
	mult $t1, $t1			# j*j
	mflo $t3			# j*j
	beq $t3, $t2, _SumSquareNums.TangTong		# Neu (j*j == a[i], toi ham TangTong
	addi $t1, $t1, 1		# j++

	slt $t4, $t2, $t3		#Kiem tra j <= a[i]
	beq $t4, $0, _SumSquareNums.LapJ
_SumSquareNums.TangI:
	addi $t0, $t0, 1
	addi $s0, $s0, 4

	slt $t4, $t0, $s1		#Kiem tra i < n
	bne $t4, $0,_SumSquareNums.LapI
	j ketThuc

_SumSquareNums.TangTong:
	add $s2, $s2, $t2
	j _SumSquareNums.TangI
#Phan ket thuc
_KetThuc:
	
	move $v0, $s2			#luu $s2 vao $v0
	#restore thanh ghi
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $t0,16($sp)
	lw $t1,20($sp)
	lw $t2,24($sp)
	lw $t3,28($sp)
	lw $t4,32($sp)

	#Xoa stack
	addi $sp,$sp,36

	#Tra ve dia chi $ra
	jr $ra

## Find Max 
##Params:
##	$a0: a
##	$a1: n
##Return:
##	$s2	:max
##Registers used:
##	$s0:	save a0
##	$s1:	save a1
##	$s2:	min 
##	$t0:	i 
##	$t1:	a[i]
##	$t2:	compare value

_FindMax:
##Procerduce header----------------------------------------------------------
	addi $sp,$sp,-28
	
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $t0,16($sp)
	sw $t1,20($sp)
	sw $t2,24($sp)
##-----------------------------------------------------End of procerduce header
	move $s0,$a0
	move $s1,$a1
	lw $s2, ($s0)			# max = a[i]
	move $t0, $zero			#i = 0
	
_FindMax.for:	        
	lw $t1, ($s0)				#t1 = a[j]
	slt $t2, $s2, $t1               	#if a[j] > max
	beq $t2, 0,_FindMax.for.continue        #if a[j] < max

	move $s2, $t1				#min = a[j]
_FindMax.for.continue:
	addi $t0,$t0,1			#i++
	addi $s0, $s0, 4		#a[i++]
	slt $t2,$t0,$s1  		#if i < n
	beq $t2, 1, _FindMax.for 	#if yes then for

	move $v1, $s2

	j _FindMax.return

_FindMax.return:
##Procerduce footer------------------------------------------------
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $t0,16($sp)
	lw $t1,20($sp)
	lw $t2,24($sp)

	#Xoa stack
	addi $sp,$sp,28

	#Nhay ve dia chi goi ham
	jr $ra
	
##------------------------------------------End of procerduce footer

##Use selection sort algorithm to sort content of array a which has n elements
##Params:
##	$a0: a
##	$a1: n
##Return:
##	none
##Registers used:
##	$s0:	save a0
##	$s1:	save a1
##	$s2:	min 
##	$s3:	temp pointer
##	$s4:	save n-1
##	$t0:	i 
##	$t1:	a[i]
##	$t2: 	j
##	$t3:	a[j]
##	$t4:	compare value
##	$t5:	temp		
 _selectionSort:
##Procerduce header----------------------------------------------------------
	addi $sp,$sp,-48
	
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4,20($sp)
	sw $t0,24($sp)
	sw $t1,28($sp)
	sw $t2,32($sp)
	sw $t3,36($sp)
	sw $t4,40($sp)
##-----------------------------------------------------End of procerduce header


	move $s0,$a0	
	move $s1,$a1
	move $t0,$zero			#i=0
	addi $s4,$s1,-1			#n-1
_selectionSort.for:
	lw $t1, ($s0) 			#a[i]
	j _findMin			#jum to find min 
_findMin:
	
	lw $s2, ($s0)			# min = a[i]
	move $s3, $s0
	move $t2, $t0			#j = i
	
_findMin.for:	        
	lw $t3, ($s3)				#t1 = a[j]
	slt $t4, $t3, $s2               	#if a[j]< min
	beq $t4, 0,_findMin.for.continue        #if a[j]> min

	move $s2, $t3				#min = a[j]
_findMin.for.continue:
	addi $t2,$t2,1			#i++
	addi $s3, $s3, 4		#a[i++]
	slt $t4,$t2,$s1  		#if i < n
	beq $t4, 1, _findMin.for 	#if yes then for
	
	#swap a[j] and min
	move $t5,$t1			
	move $t1,$s2
	move $s2,$t5
	
	j _selectionSort.for.continue

_selectionSort.for.continue:
	addi $t0,$t0,1			#j++
	addi $s0,$s0,4			#a[j]=a[j++]
	
	slt $t4,$t0,$s4			#if j < n-1
	beq $t4,1,_selectionSort.for 	# if yes then for

	j _selectionSort.return


##Procerduce footer------------------------------------------------
_selectionSort.return:
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $t0,24($sp)
	lw $t1,28($sp)
	lw $t2,32($sp)
	lw $t3,36($sp)
	lw $t4,40($sp)

	#Xoa stack
	addi $sp,$sp,48

	#Nhay ve dia chi goi ham
	jr $ra
	
##------------------------------------------End of procerduce footer

