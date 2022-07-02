LDFLAGS="-L/usr/local/opt/flex/lib"

run: run2 run3

run1: inf
	echo "2+3*4" | ./inf
	echo "(2+3)*4" | ./inf

run2: inf2post
	echo "2+3*4" | ./inf2post
	echo "(2+3)*4" | ./inf2post

run3: inf2pre
	echo "2+3*4" | ./inf2pre
	echo "(2+3)*4" | ./inf2pre

%: %.tab.c %.yy.c
	gcc  -o $@ $^ ${LDFLAGS} -ly -lfl
#	gcc -mmacosx-version-min=12.3 -o $@ $^ ${LDFLAGS} -ly -lfl

%.tab.c: %.y
	bison -d --report=all $^

%.yy.c: %.l
	flex -o $@ $^


clean:
	rm -f inf inf2post inf2pre
	rm -f *.output *.vcg *.tab.c *.tab.h *.yy.c


LADIR="PRE-POST-INF"

zip:
	rm -rf ${LADIR}
	mkdir ${LADIR}
	cp *.l *.y Makefile ${LADIR}
	rm -f ${LADIR}.zip
	zip -r ${LADIR}.zip ${LADIR}
	rm -rf ${LADIR}
