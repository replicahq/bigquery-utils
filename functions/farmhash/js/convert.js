// Convert this to rust...
const fs = require('fs');

const glue = fs.readFileSync("wasm/farmhash.js", { encoding: "utf8" });
const buffer = fs.readFileSync("wasm/farmhash_bg.wasm");

const bytes = Array.from(new Uint8Array(buffer.buffer));

console.log(`\
const encoding = require("text-encoding");
const TextDecoder = encoding.TextDecoder
const TextEncoder = encoding.TextEncoder

${glue}

// this.wasm_bindgen = wasm_bindgen;
let wasm = wasm_bindgen(new Uint8Array(${JSON.stringify(bytes)}));
this.fingerprint64 = (s) => {
    return wasm.then(() => {
        return wasm_bindgen.fingerprint64(s);
    });
};
this.fingerprint64_array = (s) => {
    return wasm.then(() => {
        return wasm_bindgen.fingerprint64_array(s);
    });
};
`);
