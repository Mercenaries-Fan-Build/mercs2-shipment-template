# Examples

Each directory is a complete, runnable Shipment. Lint any of them with no game install:

```sh
qm lint examples/01-overwrite-a-texture
```

CI lints every one on each push, so none of them can quietly stop working.

| | teaches |
|---|---|
| [01-overwrite-a-texture](01-overwrite-a-texture) | Replacing existing game content |
| [02-add-new-content](02-add-new-content) | Adding a new asset, and what a donor is |
| [03-bundle-lua](03-bundle-lua) | Shipping Lua, and why it is an append |
| [04-two-mods-coexisting](04-two-mods-coexisting) | Two mods editing one script and both surviving |
| [05-what-the-linter-catches](05-what-the-linter-catches) | The failures, on purpose |

## The two halves

**01** overwrites: same asset hash, your bytes. Your overlay is mounted last and wins the lookup, and
the base WAD is never touched — uninstalling is deleting one file.

**02** adds: a new hash that did not exist. Nothing in the base game changes, and two Shipments
adding different names can never conflict.

Most real mods do both. The root [`manifest.yaml`](../manifest.yaml) does.

## The interesting one

**04** is the case this whole format exists for.

Scripts do not load individually — all 114 live in one block. If each mod shipped its own copy of
that block, the last one installed would erase every other mod's Lua, silently. So a Shipment
declares an *append*, and `qm link` composes every installed Shipment's appends onto one base and
compiles once:

```sh
qm link examples/04-two-mods-coexisting/alpha \
        examples/04-two-mods-coexisting/beta \
        --out /tmp/link --corpus <corpus>
```

```
linking 2 mutation(s) from 2 Shipment(s)
linked wifpmcinterior: 58828 → 59339 B source, 80475 B bytecode, from ["alpha-mod", "beta-mod"]
```

Both survive, and neither mod knows the other exists.

Ordering is by **Shipment name, not install order**. A saved costume is stored as a *position* in
the outfit list, so if install order set the indices, reinstalling mods in a different order would
silently re-dress the player — or leave a saved index pointing at nothing and wedge the load.

## The failures are the point

**05** contains Shipments that are meant to be broken, and CI asserts they still fail. That check
matters more than it looks: without it, the passing examples would stay green with the linter
entirely disabled.

Each one is a real mistake with no in-game symptom. The game does not report asset errors — it hangs
on a loading screen, or loads fine and quietly does nothing.
