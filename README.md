# TweetNacl in CT-Wasm

This repository is a fork of [TweetNacl in WebAssembly](https://github.com/TorstenStueber/TweetNacl-WebAssembly) annotated with CT-Wasm labels to ensure constant-time.

Work in Progress

This is a semi-handwritten port of the crypto library TweetNacl to CT-Wasm. This is the fastest library for end-to-end encryption running in the browser. It provides state of the art strong cryptography.

It provides the following features:

- Secret-key authenticated encryption
	- implements XSalsa20, Poly1305
- Public-key authenticatd encryption
	- implements X25519, XSalsa20, Poly1305
- Public-key signatures
	- implements Ed25519
- Hashing
	- implements SHA512

The CT-Wasm source code can be found in the `src/wat/*` directory. 

### Build

Run
```bash
npm run build -- path/to/ct_wasm_spec
```
to build the JavaScript file `dist/wasmCode.js`. A pre-built version of the library 
can be found in our [pre-built release](https://github.com/PLSysSec/ct-wasm-spec/releases) 
under `tweetnacl-ctwasm.zip`, and the interpreter binary under `*_binaries.zip`. 

### Run

Open `index.html` with Chromium to run `dist/wasmCode.js`. Then open up the console 
to see the benchmark numbers. 
