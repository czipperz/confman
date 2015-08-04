all: out/main.o
	ghc -o hs-confman $^

out/%.o: src/%.hs
	@mkdir -p out
	ghc -o $@ -c $<
