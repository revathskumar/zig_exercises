const fs = require('fs');
const source = fs.readFileSync("./string_to_wasm.wasm");
const typedArray = new Uint8Array(source);

let mem; 

WebAssembly.instantiate(typedArray, {
  env: {
    print: (pointer, length) => { 
      const message = decodeString(pointer, length); 
      console.log("Message from Zig : ", message); 
    }
  }}).then(result => {
  mem = result.instance.exports.memory;
  const hello = result.instance.exports.hello;
  hello();
});

function decodeString(pointer, length) {
  const slice = new Uint8Array(mem.buffer, pointer, Number(length))
  return new TextDecoder().decode(slice);
}