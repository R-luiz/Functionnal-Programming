# ft_turing - single-tape Turing machine simulator
#
# The subject requires the Makefile to detect missing libraries/tools
# and install them via OPAM so the peer-evaluator installs nothing.

NAME    := ft_turing
BUILD   := _build/default/src/main.exe

.PHONY: all deps build clean fclean re run

all: deps build

deps:
	@command -v opam >/dev/null 2>&1 || { \
		echo "ERROR: opam is required but not found in PATH"; exit 1; }
	@opam list --installed 2>/dev/null | grep -q '^dune ' \
		|| opam install -y dune
	@opam list --installed 2>/dev/null | grep -q '^yojson ' \
		|| opam install -y yojson

build:
	@opam exec -- dune build ./src/main.exe
	@cp -f $(BUILD) ./$(NAME)
	@chmod +x ./$(NAME)

run: all
	@./$(NAME) resources/unary_sub.json "111-11="

clean:
	@opam exec -- dune clean 2>/dev/null || true

fclean: clean
	@rm -f ./$(NAME)

re: fclean all
