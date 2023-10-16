cargame.o: cargame.c kbhit.h
	gcc -c cargame.c kbhit.h

kbhit.o: kbhit.c kbhit.h
	gcc -c kbhit.c kbhit.h

car: cargame.o kbhit.o
	mkdir -p exefile
	gcc -o exefile/car cargame.o kbhit.o
	rm *.o
