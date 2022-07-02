LDFLAGS="-L/usr/local/opt/flex/lib"

run: rgb
#	cat prog.qst | ./rgb
	echo vert add bleu | ./rgb

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
