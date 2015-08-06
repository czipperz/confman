all:
	(cd src && ghc --make -o ../hs-confman main.hs)

out/%.o: src/%.hs
	@mkdir -p out
	ghc -o $@ -c $<
