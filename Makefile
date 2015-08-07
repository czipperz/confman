all:
	@echo "ghc --make -o ../confman main.hs"
	@(cd src && ghc --make -o ../confman main.hs)

install: all
	./install

clean:
	rm src/*.{o,hi}
