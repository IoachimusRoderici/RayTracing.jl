all: compile run

compile:
	gcc main.c RayTracing.c ../C/GSL/MyGSLRandom.c ../C/MyLib/MyTime.c -lgsl -lblas -Wall

run:
	./a.out
