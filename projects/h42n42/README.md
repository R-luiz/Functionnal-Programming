# h42n42

> Status: **not started** — this directory is a placeholder.

Interactive web simulator of a Creature ("Creet") population threatened by the
H42N42 virus. Client-side UI written in OCaml, compiled to JavaScript via the
Ocsigen toolchain (Eliom + js_of_ocaml + Lwt).

See [`../../subjects/h42n42.subject.pdf`](../../subjects/h42n42.subject.pdf) for
the full subject.

## Mandatory requirements (from the subject)

- Rectangular play area: toxic river on top, hospital on the bottom.
- Creets move in straight lines, rebound on edges, randomly change direction
  (rarely).
- A Creet touching the river gets sick: changes color, becomes contagious,
  15% slower.
- Contagious Creet touching a healthy one: 2% contamination chance per
  iteration, no collision/rebound.
- Sick Creet: 10% chance **berserk** (grows up to 4× over its life) **or**
  10% chance **mean** (shrinks 15%, chases healthy Creets). Never both.
- Healthy Creets reproduce spontaneously while ≥1 healthy remains; healthy
  Creets never die.
- User can grab-move Creets with the mouse; grabbed healthy Creet becomes
  invulnerable.
- Only Creets the user drags to the hospital get healed (random contact does
  not heal).
- Difficulty accelerates over time; GAME OVER when no healthy Creet remains.
- Each Creet driven by its own Lwt thread; rendered as a DOM element; mouse
  events via `Lwt_js_event`.

## Bonus ideas

- Graphically pleasant rendering.
- On-page controls (forms / sliders / checkboxes) for simulation parameters.
- Quadtree-optimized collision detection.

## Planned layout (not yet created)

```
h42n42/
├── src/            # creet.ml, world.ml, h42n42.eliom ...
├── static/         # css / assets
├── Makefile
└── dune-project
```
