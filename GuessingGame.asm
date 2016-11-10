# Jacob Webber
# Computer Architecture Assignment 3
# Guessing Game
.data #storing data
	startmsg: .asciiz "I am thinking of a random number between 1 and 100\n\n"
	guessmsg: .asciiz "Enter your guess\n"
	tooHigh: .asciiz "Your guess is too high.\n"
	tooLow: .asciiz "\n\nYour guess is too low.\n\n"
	wingame: .asciiz "You have guessed the number. Well done!\n\n"
	losegame: .asciiz "Game over! You ran out of guesses.\n\n"
	guesspart1: .asciiz "You have "
	guesspart2: .asciiz " guesses\n"
.text #start of program

start:
	jal random
	addi $s0, $zero, 10 # store number of guesses allowed
	add $t0, $zero, $a0 # store random number $a0 in $t0
	li $v0, 4         # print string
	la $a0, startmsg
	syscall

#######################################
# Main game loop for guessing
guessing:
	la $a0, guessmsg
	li $v0, 4 # print string guessmsg
	syscall
	
	la $a0, guesspart1
	li $v0, 4 # print string guesspart1
	syscall
	add $a0, $zero, $s0
	li $v0, 1 # print guesses remaining 
	syscall
	la $a0, guesspart2
	li $v0, 4 # print string guesspart2
	syscall
	
	li $v0, 5 #read int from user
	syscall
    	move $t1, $v0 # store input in t1
    	#addi $t2, $zero, 1 #t2 = 1 (guess min)
	beq $t0, $t1, win # if stored int = user input, user won
	addi $s0, $s0, -1 # guess used, subtract
	beq $s0, $zero, lose # if number of guesses = zero, user lost
  	blt $t0, $t1, goLower # if stored int < user input, guess is too high
  	
	# otherwise, guess is too low
	la $a0, tooLow
	li $v0, 4 # print string tooLow
    	syscall
    	
	# loop guessing
	j guessing
	
#######################################
# goLower: Procedure if the user guess too high
goLower:
	la $a0, tooHigh
	li $v0, 4 # print tooHigh
	syscall
	# loop back to get another guess
	j guessing

#######################################
# User won, print win and restart
win:
	la $a0, wingame
	li $v0, 4 #print string wingame
	syscall
	j start

#######################################
# User lost, print losegame and restart
lose:
	la $a0, losegame
	li $v0, 4 #print string losegame
	syscall
	j start

#############################################
# LEAF PROCEDURE
# random: generate a rand number between 0 - 100
random: 
	li $v0, 42        # SERVICE 41 for a rand int
	#addi $a0, $zero, 0 # random number >= 0
	addi $a1, $zero, 100 #random number < 100
	#xor $a0, $a0, $a0  # Select random generator 0
	syscall            # Generate random int (returns in $a0)
	jr $ra
