const fs = require('fs');
const path = require('path');

const watSourceDirectory = './src/wat';
const sourceDirectory = './src';
const wasmOutputDirectory = './dist';

const naclWasmSourceSearchString = 'const wasmCode = \'\';'

const filesToAssemble = fs.readdirSync(watSourceDirectory).filter(
	fileName => fileName.substring(fileName.length - 4) === '.wat'
);

const codeArray = filesToAssemble.map(fileName => {
	return fs.readFileSync(path.join(watSourceDirectory, fileName)).toString('utf8');
});

const completeModule = '(module (import "js" "mem" (memory secret 1))' + 
	codeArray.join('\n') + ')';

const {promisify} = require('util');
const {exec} = require('child_process');

const wat = path.join(wasmOutputDirectory, 'build.wat');
const wasm = path.join(wasmOutputDirectory, 'build.wasm');

if (process.argv.length != 3) {
	console.log("Usage: " + __filename + " <path/to/ct_wasm_spec>");
	process.exit(-1);
}

function wast2wasm(m, _) {
	fs.writeFileSync(wat, m);
	return promisify(exec)(`${process.argv[2]} -d -i ${wat} -o ${wasm}`,{});
		
}
wast2wasm(completeModule, true)
	.then(output => {
		return fs.readFileSync(wasm).toString('base64');
	})
	.then(output => {
		let chunkedOutput = output.match(/.{1,100}/g).map(chunk => JSON.stringify(chunk)).join(' +\n\t\t');
		let naclWasmSource = fs.readFileSync(path.join(sourceDirectory, 'nacl-wasm.js')).toString('utf8');
		naclWasmSource = naclWasmSource.replace(naclWasmSourceSearchString, 'const wasmCode =\n\t\t' + chunkedOutput);
		
		if (!fs.existsSync(wasmOutputDirectory)) {
			fs.mkdirSync(wasmOutputDirectory);
		}

		fs.writeFileSync(path.join(wasmOutputDirectory, 'nacl-wasm.js'), naclWasmSource);
	});

