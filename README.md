# zig exercises

## Version

0.11.0

## Run

```
zig run src/main.zig
zig run src/file_read.zig
zig test src/file_read.zig
zig run src/fstat.zig
```

wasm

```
zig build-lib src/string_to_wasm.zig -target wasm32-freestanding -dynamic -rdynamic
node wasm.js
```

## License

MIT
