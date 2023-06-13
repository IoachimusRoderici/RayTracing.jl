all: compile run

compile:
	gcc main.c RayTracing.c distribuciones.c ../C/MyLib/MyGSL/MyGSLRandom.c ../C/MyLib/MyGSL/MyGSLio.c ../C/MyLib/MyTime.c ../C/MyLib/MyList.c -lgsl -lblas -lm -Wall -Werror

run:
	./a.out
