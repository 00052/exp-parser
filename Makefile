all: calc
CC=gcc
INCLUDE= .
LEX=flex
YACC=yacc
calc: gram.c scan.c main.c
	$(YACC) -do gram.c gram.y
	$(LEX) -o scan.c scan.l
	$(CC) -I$(INCLUDE) -o calc main.c gram.c scan.c -lm
clean:
	@rm gram.c gram.h scan.c calc
test: calc
	echo '(2.0+1.5)*sqr(9.00)^((1+1)/2)+avg(-1,-2,-3)'|./calc
