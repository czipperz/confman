all:
	(cd src && ghc --make -o ../hs-confman main.hs)

clean:
	rm src/*.{o,hi}
