LDFLAGS="-L/usr/local/opt/flex/lib"


run: exo01
	echo "2*3+4" | ./exo01
	echo "2+3*4" | ./exo01
	echo "2+1/0" | ./exo01
	echo "2+1/2" | ./exo01
	echo "2*(1-2)" | ./exo01
	echo "3*|4-12|" | ./exo01
	echo "7*12%5" | ./exo01
	echo "si (2+3-5) alors 4-1 sinon 2 finsi" | ./exo01
	echo "si (2+3-6) alors 4-1 sinon 2 finsi" | ./exo01


exo01: exo01.tab.c exo01.yy.c
	gcc -o $@ $^ ${LDFLAGS} -ly -lfl
#	gcc -mmacosx-version-min=12.3 -o $@ $^ ${LDFLAGS} -ly -lfl

exo01.tab.c: exo01.y
	bison -d -v $^
#	bison -d -v -g $^
# -d pour générer le fichier exo01.tab.h
# -v pour générer le fichier exo01.output
# -g pour générer le fichier exo01.vcg

exo01.yy.c: exo01.l
	flex -o $@ $^


clean:
	rm -f exo01 exo01.output exo01.vcg
	rm -f exo01.tab.c exo01.tab.h
	rm -f exo01.yy.c



LADIR="BISON"

zip:
	rm -rf ${LADIR}
	mkdir ${LADIR}
	cp exo01.l exo01.y Makefile ${LADIR}
	rm -f ${LADIR}.zip
	zip -r ${LADIR}.zip ${LADIR}
	rm -rf ${LADIR}
