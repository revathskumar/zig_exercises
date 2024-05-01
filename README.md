# zig exercises

## Version

0.12.0

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


C 

```
gcc syscall.c -o syscall
./syscall

strace ./syscall
```

 ~/bin/zig-13/zig run src/termios.zig -lc # use libc


```
 ~/bin/zig-13/zig translate-c syscall.c -I/usr/include -I/usr/include/x86_64-linux-gnu > src/tui_basic.zig
```


```
	 ~/bin/zig-13/zig cc tui.c -o tui-zig
```

## License

MIT
