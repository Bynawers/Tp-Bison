LDFLAGS="-L/usr/local/opt/flex/lib"


run: moncompilo
	cat prog.qst | ./moncompilo
	cat output.c
	gcc -o output output.c
	./output

moncompilo: moncompilo.tab.c moncompilo.yy.c
#	gcc -o $@ $^ ${LDFLAGS} -ly -lfl
	gcc -o $@ $^ ${LDFLAGS} -ly -lfl

moncompilo.tab.c: moncompilo.y
	bison -d --report=all $^
#	bison -d -v -g $^
# -d pour générer le fichier exo01.tab.h
# -v pour générer le fichier exo01.output
# -g pour générer le fichier exo01.vcg

moncompilo.yy.c: moncompilo.l
	flex -o $@ $^


clean:
	rm -f moncompilo moncompilo.output moncompilo.vcg
	rm -f moncompilo.tab.c moncompilo.tab.h
	rm -f moncompilo.yy.c
	rm -f output output.c



LADIR="TD9_EXO_9.2.3"

zip:
	rm -rf ${LADIR}
	mkdir ${LADIR}
	cp moncompilo.l moncompilo.y prog.qst Makefile ${LADIR}
	rm -f ${LADIR}.zip
	zip -r ${LADIR}.zip ${LADIR}
	rm -rf ${LADIR}
