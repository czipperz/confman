all:
	(cd src && ghc --make -o ../hs-confman main.hs)

install: all
	cp confman /bin

clean:
	rm src/*.{o,hi}
