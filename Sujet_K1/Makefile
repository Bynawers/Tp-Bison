LDFLAGS="-L/usr/local/opt/flex/lib"

run: rgb
#	cat prog.qst | ./rgb
	echo 15 20 41 melange 42 53 64 | ./rgb
# rouge mélange bleu => violet
	echo 0 0 255 melange 255 0 0 | ./rgb
# noir et blanc
	echo 0 0 0 melange 255 255 255 | ./rgb
# aucun argument erreur syntax
#	echo melange | ./rgb
# dépassement d'intervalle
	echo 256 0 0 melange 0 0 0 | ./rgb
# trop d'argument à gauche
	echo 1 2 3 4 melange 1 2 3 | ./rgb
# trop d'argument à droite
	echo 1 2 3 melange 1 2 3 4 | ./rgb

rgb: rgb.tab.c rgb.yy.c
	gcc -o $@ $^ ${LDFLAGS} -ly -lfl
# gcc -mmacosx-version-min=12.3 -o $@ $^ ${LDFLAGS} -ly -lfl

rgb.tab.c: rgb.y
	bison -d -v $^

rgb.yy.c: rgb.l
	flex -o $@ $^

clean:
	rm -f rgb rgb.output rgb.vcg
	rm -f rgb.tab.c rgb.tab.h
	rm -f rgb.yy.c

LADIR="BISON"

zip:
	rm -rf ${LADIR}
	mkdir ${LADIR}
	cp rgb.l rgb.y Makefile ${LADIR}
	rm -f ${LADIR}.zip
	zip -r ${LADIR}.zip ${LADIR}
	rm -rf ${LADIR}
