-- alpha-mod's contribution to the shared script.
--
-- beta-mod appends to this same script. Neither knows about the other, and both survive: `qm link`
-- composes every installed Shipment's appends onto one base and compiles once.
--
-- Order is by `load.requires` first — a Shipment you require is linked before you — then by the
-- order the Shipments were requested in. Neither of these two requires the other, so the request
-- order alone decides which append comes first.

Debug.Printf("[alpha] my Lua survived alongside the other mod\n")
