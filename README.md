# Mercenaries 2 Shipment template

A starting point for a Mercenaries 2 mod. Click **Use this template**, edit `manifest.yaml`, drop
your files in `src/`, and push — CI checks it on every commit.

The example that ships here replaces Mattias's skin. It builds and loads as-is, so you can confirm
your setup works before changing anything.

## Why the checks matter

Mercenaries 2 does not report asset errors. It hangs on a loading screen.

Declare one page too few for a texture and the engine overruns its heap. Point a LOD row at a block
that is not in your WAD and the streamer sizes a buffer from a garbage index and asks the OS for
something on the order of 549 GB. Neither gives you a message, a log line, or a crash — just a
frozen screen.

`qm lint` knows about those traps. Run it before you launch the game, and CI runs it for you on
every push.

## Layout

```
manifest.yaml     what your mod contributes
src/              your files — textures, models, scripts
build/            output; gitignored, never commit it
```

## Working on it locally

Grab `qm` from the [tools release page][releases] — there is nothing to compile.

```sh
qm lint .                       # check it; no game install needed
qm build . --out build          # produce the overlay WAD
```

`qm build` needs the game. It finds an install automatically; pass `--game <dir>` if yours is
somewhere unusual, and `qm rules` lists everything that gets checked.

Install the built WAD with [Modkit][modkit], which also keeps `qm` up to date.

### If a check fires

Every finding carries a code and a doc link:

```
[M0007] warning: pmc_hum_example is a STREAMED texture whose row names 3 finer rung(s)…
```

`warning` means "we think you should know"; `error` and `HANG` stop the build. `HANG` is the class
that would freeze the game with no explanation — those are never advisory.

## What you can put in a manifest

| kind | what it does |
|---|---|
| `replace_texture` | swap a texture for your own PNG |
| `add_model` | add new geometry |
| `add_outfit` | add a wearable outfit for a hero |
| `patch_lua` | append to a game script |

`qm rules` and the [format reference][format] cover the details, including the fields each kind
takes.

## Mods that coexist

Two mods editing the same thing usually means one silently wins. The manifest is how you avoid that:
it declares what your Shipment touches, so conflicts get detected instead of discovered.

Lua is the case worth understanding. Scripts load as one block rather than individually, so two mods
that both edit scripts cannot each ship their own copy — the last one installed would erase the
other. `qm link` composes every installed Shipment's changes into a single WAD, which is why you
declare an *append* rather than shipping a whole modified script.

## License

The template is MIT. Your mod is yours — replace this section with whatever you like.

[releases]: https://github.com/Mercenaries-Fan-Build/mercs2-wad-simulator/releases
[modkit]: https://github.com/Mercenaries-Fan-Build
[format]: https://github.com/Mercenaries-Fan-Build/notes-on-the-released-game
