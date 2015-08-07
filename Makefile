all:
	@echo "ghc --make -o ../confman main.hs"
	@(cd src && ghc --make -o ../confman main.hs)

install: all
	cp confman /bin

clean:
	rm src/*.{o,hi}
