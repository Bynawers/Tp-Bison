LDFLAGS="-L/usr/local/opt/flex/lib"

run: run4

run4: bool
	echo "a := 2+4\nprint a" | ./bool
	echo "a := 8+4\nbien := a*4 + (4*a)\nprint bien\ncombien := 4-bien\nprint ccombien" | ./bool

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
