# ft_turing

A functional implementation of a single-headed, single infinite-tape Turing
machine, driven by a JSON machine description.

## Layout

```
ft_turing/
├── src/
│   ├── main.ml       # parser + simulation loop + entry point
│   └── dune
├── resources/        # JSON machine descriptions
│   └── unary_sub.json
├── Makefile
├── dune-project
└── README.md
```

## Build

```sh
make            # installs missing OPAM deps (dune, yojson) then builds ./ft_turing
```

## Usage

```sh
./ft_turing [-h] jsonfile input

positional arguments:
  jsonfile   json description of the machine
  input      input of the machine

optional arguments:
  -h, --help show this help message and exit
```

Example:

```sh
./ft_turing resources/unary_sub.json "111-11="
```

## Required machine descriptions

The subject asks for five machines under `resources/`:

- [x] `unary_sub.json`  — unary subtraction (provided example)
- [ ] unary addition
- [ ] palindrome decider (writes `y`/`n`)
- [ ] `0^n 1^n` language decider
- [ ] `0^(2^n)` language decider
- [ ] universal machine running the unary-addition machine

## Bonus

- [ ] Compute and report the **time complexity** of the executed algorithm.
