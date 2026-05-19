# Functional Programming

Two independent OCaml projects from the 42 functional-programming branch.
Each project is self-contained with its own build system.

```
.
├── projects/
│   ├── ft_turing/      # single-tape Turing machine simulator (CLI)
│   └── h42n42/         # virus-population web simulator (Ocsigen/Eliom)
├── subjects/           # original project subjects (PDF)
└── README.md
```

| Project | Summary | Toolchain | Status |
|---------|---------|-----------|--------|
| [ft_turing](projects/ft_turing/) | Simulate a single-headed, single-tape Turing machine from a JSON description | OCaml, dune, yojson | Implemented |
| [h42n42](projects/h42n42/) | Browser game: a Creature population threatened by the H42N42 virus | OCaml, Ocsigen, Eliom, js_of_ocaml | Not started |

See each project's own `README.md` for build and usage instructions.
