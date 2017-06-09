(function () {
	function compareArrays(arr1, arr2) {
		if (!arr1 || !arr2 || arr1.length !== arr2.length) {
			console.log(arr1);
			console.log(arr2);
			return false;
		}

		const length = arr1.length;
		for (let i = 0; i < length; i++) {
			if (arr1[i] !== arr2[i]) {
				console.log(arr1);
				console.log(arr2);
				return false;
			}
		}
		return true;
	}

	function fillRandom(array) {
		for (let i = 0; i < array.length; i++) {
			array[i] = Math.floor(Math.random() * 256);
		}
	}

	//experimental
	function fillFRandom(array) {
		for (let i = 0; i < array.length; i++) {
			array[i] = Math.floor(Math.random() * 10000 - 5000);
		}
	}

	function getPerformanceString(names) {
		let durationOfFirst;
		const performanceString = names.map((name, index) => {
			const duration = performance.getEntriesByName(name + 'Measure')[0].duration;
			if (index === 0) {
				durationOfFirst = duration;
			}
			const durationString = name + ': ' + (Math.round(duration * 1000) / 1000) + 'ms'
			return durationString + (index > 0 ?
				' ' + (Math.round(duration / durationOfFirst * 10) / 10) + 'x' :
				''
			) ;
		}).join('; ');

		performance.clearMarks();
		performance.clearMeasures();

		return '(' + performanceString + ')';
	}

	function testCryptoCoreHSalsa20() {
		const p = new Uint8Array(16);
		const k = new Uint8Array(32);
		const c = new Uint8Array(16);

		fillRandom(p);
		fillRandom(k);
		fillRandom(c);

		let o;
		performance.mark('wasmMark');
		for (let i = 0; i < 100; i++) o = window.nacl_wasm.lowlevel.crypto_core_hsalsa20(p, k, c);
		performance.measure('wasmMeasure', 'wasmMark');

		const o2 = new Uint8Array(32);
		performance.mark('jsMark');
		for (let i = 0; i < 100; i++) window.nacl.lowlevel.crypto_core_hsalsa20(o2, p, k, c);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_core_hsalsa20',
			compareArrays(o, o2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testCryptoStreamSalsa20() {
		const d = 23423323;
		const n = new Uint8Array(8);
		const k = new Uint8Array(32);

		fillRandom(n);
		fillRandom(k);

		performance.mark('wasmMark');
		const c = window.nacl_wasm.lowlevel.crypto_stream_salsa20(d, n, k);
		performance.measure('wasmMeasure', 'wasmMark');

		const c2 = new Uint8Array(d);
		performance.mark('jsMark');
		window.nacl.lowlevel.crypto_stream_salsa20(c2, 0, d, n, k);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_stream_salsa20',
			compareArrays(c, c2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testCryptoStreamSalsa20Xor() {
		const d = 23423323;

		const m = new Uint8Array(d);
		const n = new Uint8Array(8);
		const k = new Uint8Array(32);

		fillRandom(m);
		fillRandom(n);
		fillRandom(k);

		window.crypto.subtle.generateKey({
			name: 'AES-GCM',
			length: 256
		}, false, ['encrypt']
		).then(key => {
			var rand = window.crypto.getRandomValues(new Uint8Array(12));
			performance.mark('nativeMark');
			window.crypto.subtle.encrypt({
				name: "AES-GCM",
				iv: rand
			}, key, m)
			.then(() => {
				performance.measure('nativeMeasure', 'nativeMark');

				performance.mark('wasmMark');
				const c = window.nacl_wasm.lowlevel.crypto_stream_salsa20_xor(m, n, k)
				performance.measure('wasmMeasure', 'wasmMark');

				const c2 = new Uint8Array(d);
				performance.mark('jsMark');
				window.nacl.lowlevel.crypto_stream_salsa20_xor(c2, 0, m, 0, d, n, k);
				performance.measure('jsMeasure', 'jsMark');

				console.log('test crypto_stream_salsa20_xor',
					compareArrays(c, c2) ? 'Equal' : 'Not equal',
					getPerformanceString(['wasm', 'native', 'js']));
			})
		})
	}

	function testCryptoStream() {
		const d = 23423323;

		const n = new Uint8Array(24);
		const k = new Uint8Array(32);

		fillRandom(n);
		fillRandom(k);

		performance.mark('wasmMark');
		const c = window.nacl_wasm.lowlevel.crypto_stream(d, n, k);
		performance.measure('wasmMeasure', 'wasmMark');

		const c2 = new Uint8Array(d);
		performance.mark('jsMark');
		window.nacl.lowlevel.crypto_stream(c2, 0, d, n, k);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_stream',
			compareArrays(c, c2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testCryptoStreamXor() {
		const d = 23423323;

		const m = new Uint8Array(d);
		const n = new Uint8Array(24);
		const k = new Uint8Array(32);

		fillRandom(m);
		fillRandom(n);
		fillRandom(k);

		performance.mark('wasmMark');
		const c = window.nacl_wasm.lowlevel.crypto_stream_xor(m, n, k);
		performance.measure('wasmMeasure', 'wasmMark');

		const c2 = new Uint8Array(d);
		performance.mark('jsMark');
		window.nacl.lowlevel.crypto_stream_xor(c2, 0, m, 0, d, n, k);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_stream_xor',
			compareArrays(c, c2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testCryptoOnetimeAuth() {
		const bytes = 23423323;

		const m = new Uint8Array(bytes);
		const key = new Uint8Array(32);

		fillRandom(m);
		fillRandom(key);

		performance.mark('wasmMark');
		const mac = window.nacl_wasm.lowlevel.crypto_onetimeauth(m, key);
		performance.measure('wasmMeasure', 'wasmMark');

		const mac2 = new Uint8Array(16);
		performance.mark('jsMark');
		window.nacl.lowlevel.crypto_onetimeauth(mac2, 0, m, 0, bytes, key);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_onetimeauth',
			compareArrays(mac, mac2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testCryptoOnetimeAuthVerify() {
		const bytes = 23423323;

		const wrongMac = new Uint8Array(16);
		const m = new Uint8Array(bytes);
		const key = new Uint8Array(32);

		fillRandom(m);
		fillRandom(key);
		fillRandom(wrongMac);
		const mac = window.nacl_wasm.lowlevel.crypto_onetimeauth(m, key);
		if (wrongMac[0] === mac[0]) {
			wrongMac[0]++;
		}

		performance.mark('wasmMark');
		const t = window.nacl_wasm.lowlevel.crypto_onetimeauth_verify(mac, m, key);
		const f = window.nacl_wasm.lowlevel.crypto_onetimeauth_verify(wrongMac, m, key);
		performance.measure('wasmMeasure', 'wasmMark');

		performance.mark('jsMark');
		const t2 = window.nacl.lowlevel.crypto_onetimeauth_verify(mac, 0, m, 0, bytes, key);
		const f2 = window.nacl.lowlevel.crypto_onetimeauth_verify(wrongMac, 0, m, 0, bytes, key);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_onetimeauth_verify', t === t2 && f === f2 ? 'Equal' : 'Not equal',
			getPerformanceString(['wasm', 'js']));
	}

	function testCryptoSecretBox() {
		const d = 23423323;

		const m = new Uint8Array(d);
		const n = new Uint8Array(24);
		const key = new Uint8Array(32);

		fillRandom(m);
		fillRandom(n);
		fillRandom(key);

		performance.mark('wasmMark');
		const c = window.nacl_wasm.lowlevel.crypto_secretbox(m, n, key);
		performance.measure('wasmMeasure', 'wasmMark');

		const c2 = new Uint8Array(d);
		performance.mark('jsMark');
		window.nacl.lowlevel.crypto_secretbox(c2, m, d, n, key);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_secretbox',
			compareArrays(c, c2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testCryptoSecretBoxOpen() {
		const d = 23423323;

		const m = new Uint8Array(d);
		const n = new Uint8Array(24);
		const key = new Uint8Array(32);

		fillRandom(m);
		fillRandom(n);
		fillRandom(key);
		for (let i = 0; i < 32; i++) {
			m[i] = 0;
		}

		const c = window.nacl_wasm.lowlevel.crypto_secretbox(m, n, key);

		performance.mark('wasmMark');
		const m2 = window.nacl_wasm.lowlevel.crypto_secretbox_open(c, n, key);
		performance.measure('wasmMeasure', 'wasmMark');

		let m3 = new Uint8Array(d);
		performance.mark('jsMark');
		m3 = window.nacl.lowlevel.crypto_secretbox_open(m3, c, d, n, key) ? null : m3;
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_secretbox_open',
			m2 === m3 || compareArrays(m2, m3) ? 'Equal' : 'Not equal', 
			getPerformanceString(['wasm', 'js']));
	}

	function testNaclSecretbox() {
		const d = 23423323;

		const msg = new Uint8Array(d);
		const nonce = new Uint8Array(24);
		const key = new Uint8Array(32);

		fillRandom(msg);
		fillRandom(nonce);
		fillRandom(key);

		performance.mark('wasmMark');
		const c = window.nacl_wasm.secretbox(msg, nonce, key);
		performance.measure('wasmMeasure', 'wasmMark');

		performance.mark('jsMark');
		const c2 = window.nacl.secretbox(msg, nonce, key);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test nacl_secretbox',
			compareArrays(c, c2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testNaclSecretboxOpen() {
		const d = 23423323;

		const msg = new Uint8Array(d);
		const nonce = new Uint8Array(24);
		const key = new Uint8Array(32);

		fillRandom(msg);
		fillRandom(nonce);
		fillRandom(key);

		const c = window.nacl_wasm.secretbox(msg, nonce, key);

		performance.mark('wasmMark');
		const msg2 = window.nacl_wasm.secretbox.open(c, nonce, key);
		performance.measure('wasmMeasure', 'wasmMark');

		performance.mark('jsMark');
		const msg3 = window.nacl.secretbox.open(c, nonce, key);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test nacl_secretbox_open',
			compareArrays(msg2, msg3) ? 'Equal' : 'Not equal',
			getPerformanceString(['wasm', 'js']));
	}

	function testVerify() {
		const d = 23423323;

		const x = new Uint8Array(d);
		const y = new Uint8Array(d);
		const y32 = new Uint8Array(d);
		const y16 = new Uint8Array(d);
		fillRandom(x);
		y.set(x);
		y32.set(x);
		y16.set(x);
		index = Math.floor(Math.random() * d);
		y[index] ^= Math.floor(Math.random() * 255) + 1;
		index32 = Math.floor(Math.random() * 32);
		y32[index32] ^= Math.floor(Math.random() * 255) + 1;
		index16 = Math.floor(Math.random() * 16);
		y16[index16] ^= Math.floor(Math.random() * 255) + 1;

		performance.mark('wasmMark');
		const t = window.nacl_wasm.verify(x, x);
		const f = window.nacl_wasm.verify(x, y);
		const t3 = window.nacl_wasm.lowlevel.crypto_verify_32(x.subarray(0, 32), x.subarray(0, 32));
		const f3 = window.nacl_wasm.lowlevel.crypto_verify_32(x.subarray(0, 32), y32);
		const t5 = window.nacl_wasm.lowlevel.crypto_verify_16(x.subarray(0, 16), x.subarray(0, 16));
		const f5 = window.nacl_wasm.lowlevel.crypto_verify_16(x.subarray(0, 16), y16);
		performance.measure('wasmMeasure', 'wasmMark');

		performance.mark('jsMark');
		const t2 = window.nacl.verify(x, x);
		const f2 = window.nacl.verify(x, y);
		const t4 = window.nacl.lowlevel.crypto_verify_32(x.subarray(0, 32), 0, x.subarray(0, 32), 0);
		const f4 = window.nacl.lowlevel.crypto_verify_32(x.subarray(0, 32), 0, y32, 0);
		const t6 = window.nacl.lowlevel.crypto_verify_16(x.subarray(0, 16), 0, x.subarray(0, 16), 0);
		const f6 = window.nacl.lowlevel.crypto_verify_16(x.subarray(0, 16), 0, y16, 0);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_verify',
			t === t2 && f === f2 && t3 === t4 && f3 === f4 && t5 === t6 && f5 === f6 ?
			'Equal' : 'Not equal',
			getPerformanceString(['wasm', 'js'])
		);
	}

	function testCryptoScalarMult() {
		const n = new Uint8Array(32);
		const p = new Uint8Array(32);

		fillRandom(n);
		fillRandom(p);

		let q;
		performance.mark('wasmMark');
		for (let i = 0; i < 100; i++) q = window.nacl_wasm.lowlevel.crypto_scalarmult(n, p);
		performance.measure('wasmMeasure', 'wasmMark');

		const q2 = new Uint8Array(32);
		performance.mark('jsMark');
		for (let i = 0; i < 100; i++) window.nacl.lowlevel.crypto_scalarmult(q2, n, p);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_scalarmult',
			compareArrays(q, q2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testCryptoScalarMultBase() {
		const n = new Uint8Array(32);

		fillRandom(n);

		let q;
		performance.mark('wasmMark');
		for (let i = 0; i < 100; i++) q = window.nacl_wasm.lowlevel.crypto_scalarmult_base(n);
		performance.measure('wasmMeasure', 'wasmMark');

		const q2 = new Uint8Array(32);
		performance.mark('jsMark');
		for (let i = 0; i < 100; i++) window.nacl.lowlevel.crypto_scalarmult_base(q2, n);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_scalarmult_base',
			compareArrays(q, q2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testCryptoBoxBeforenm() {
		const y = new Uint8Array(32);
		const x = new Uint8Array(32);

		fillRandom(y);
		fillRandom(x);

		let k;
		performance.mark('wasmMark');
		for (let i = 0; i < 100; i++) k = window.nacl_wasm.lowlevel.crypto_box_beforenm(y, x);
		performance.measure('wasmMeasure', 'wasmMark');

		const k2 = new Uint8Array(32);
		performance.mark('jsMark');
		for (let i = 0; i < 100; i++) window.nacl.lowlevel.crypto_box_beforenm(k2, y, x);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_box_beforenm',
			compareArrays(k, k2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testCryptoBoxAfternm() {
		const d = 23423323;

		const m = new Uint8Array(d);
		const n = new Uint8Array(24);
		const key = new Uint8Array(32);

		fillRandom(m);
		fillRandom(n);
		fillRandom(key);

		performance.mark('wasmMark');
		const c = window.nacl_wasm.lowlevel.crypto_box_afternm(m, n, key);
		performance.measure('wasmMeasure', 'wasmMark');

		const c2 = new Uint8Array(d);
		performance.mark('jsMark');
		window.nacl.lowlevel.crypto_box_afternm(c2, m, d, n, key);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_box_afternm',
			compareArrays(c, c2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testCryptoBox() {
		const d = 23423323;

		const m = new Uint8Array(d);
		const n = new Uint8Array(24);
		const y = new Uint8Array(32);
		const x = new Uint8Array(32);

		fillRandom(m);
		fillRandom(n);
		fillRandom(y);
		fillRandom(x);

		performance.mark('wasmMark');
		const c = window.nacl_wasm.lowlevel.crypto_box(m, n, y, x);
		performance.measure('wasmMeasure', 'wasmMark');

		const c2 = new Uint8Array(d);
		performance.mark('jsMark');
		window.nacl.lowlevel.crypto_box(c2, m, m.length, n, y, x);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_box',
			compareArrays(c, c2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testCryptoBoxOpen() {
		const d = 23423323;

		const m = new Uint8Array(d);
		const n = new Uint8Array(24);
		const y = new Uint8Array(32);
		const x = new Uint8Array(32);

		fillRandom(m);
		fillRandom(n);
		fillRandom(y);
		fillRandom(x);
		for (let i = 0; i < 32; i++) {
			m[i] = 0;
		}

		const c = window.nacl_wasm.lowlevel.crypto_box(m, n, y, x);

		performance.mark('wasmMark');
		const m2 = window.nacl_wasm.lowlevel.crypto_box_open(c, n, y, x);
		performance.measure('wasmMeasure', 'wasmMark');

		const m3 = new Uint8Array(d);
		performance.mark('jsMark');
		window.nacl.lowlevel.crypto_box_open(m3, c, c.length, n, y, x);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_box_open',
			compareArrays(m2, m3) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testCryptoBoxKeypair() {
		let keyPair;
		performance.mark('wasmMark');
		for (let i = 0; i < 100; i++) keyPair = window.nacl_wasm.lowlevel.crypto_box_keypair();
		performance.measure('wasmMeasure', 'wasmMark');

		const x = new Uint8Array(32);
		const y = new Uint8Array(32);
		performance.mark('jsMark');
		for (let i = 0; i < 100; i++) window.nacl.lowlevel.crypto_box_keypair(y, x);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test crypto_box_keypair', 'Not comparable', getPerformanceString(['wasm', 'js']));
	}

	function testNaclScalarMult() {
		const n = new Uint8Array(32);
		const p = new Uint8Array(32);

		fillRandom(n);
		fillRandom(p);

		let q;
		performance.mark('wasmMark');
		for (let i = 0; i < 100; i++) q = window.nacl_wasm.scalarMult(n, p);
		performance.measure('wasmMeasure', 'wasmMark');

		let q2;
		performance.mark('jsMark');
		for (let i = 0; i < 100; i++) q2 = window.nacl.scalarMult(n, p);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test nacl_scalarmult',
			compareArrays(q, q2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testNaclScalarMultBase() {
		const n = new Uint8Array(32);

		fillRandom(n);

		let q;
		performance.mark('wasmMark');
		for (let i = 0; i < 100; i++) q = window.nacl_wasm.scalarMult.base(n);
		performance.measure('wasmMeasure', 'wasmMark');

		let q2;
		performance.mark('jsMark');
		for (let i = 0; i < 100; i++) q2 = window.nacl.scalarMult.base(n);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test nacl_scalarmult_base',
			compareArrays(q, q2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testNaclBox() {
		const d = 23423323;

		const m = new Uint8Array(d);
		const n = new Uint8Array(24);
		const y = new Uint8Array(32);
		const x = new Uint8Array(32);

		fillRandom(m);
		fillRandom(n);
		fillRandom(y);
		fillRandom(x);

		performance.mark('wasmMark');
		const c = window.nacl_wasm.box(m, n, y, x);
		performance.measure('wasmMeasure', 'wasmMark');

		performance.mark('jsMark');
		const c2 = window.nacl.box(m, n, y, x);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test nacl_box',
			compareArrays(c, c2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testNaclBoxBefore() {
		const y = new Uint8Array(32);
		const x = new Uint8Array(32);

		fillRandom(y);
		fillRandom(x);

		let k;
		performance.mark('wasmMark');
		for (let i = 0; i < 100; i++) k = window.nacl_wasm.box.before(y, x);
		performance.measure('wasmMeasure', 'wasmMark');

		let k2;
		performance.mark('jsMark');
		for (let i = 0; i < 100; i++) k2 = window.nacl.box.before(y, x);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test nacl_box_before',
			compareArrays(k, k2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testNaclBoxAfter() {
		const d = 23423323;

		const m = new Uint8Array(d);
		const n = new Uint8Array(24);
		const key = new Uint8Array(32);

		fillRandom(m);
		fillRandom(n);
		fillRandom(key);

		performance.mark('wasmMark');
		const c = window.nacl_wasm.box.after(m, n, key);
		performance.measure('wasmMeasure', 'wasmMark');

		performance.mark('jsMark');
		const c2 = window.nacl.box.after(m, n, key);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test nacl_box_after',
			compareArrays(c, c2) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testNaclBoxOpen() {
		const d = 23423323;

		const m = new Uint8Array(d);
		const n = new Uint8Array(24);
		const y = new Uint8Array(32);
		const x = new Uint8Array(32);

		fillRandom(m);
		fillRandom(n);
		fillRandom(y);
		fillRandom(x);

		const c = window.nacl_wasm.box(m, n, y, x);

		performance.mark('wasmMark');
		const m2 = window.nacl_wasm.box.open(c, n, y, x);
		performance.measure('wasmMeasure', 'wasmMark');

		performance.mark('jsMark');
		const m3 = window.nacl.box.open(c, n, y, x);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test nacl_box_open',
			compareArrays(m2, m3) ? 'Equal' : 'Not equal', getPerformanceString(['wasm', 'js']));
	}

	function testNaclBoxKeyPair() {
		let keyPair;
		performance.mark('wasmMark');
		for (let i = 0; i < 100; i++) keyPair = window.nacl_wasm.box.keyPair();
		performance.measure('wasmMeasure', 'wasmMark');

		let keyPair2;
		performance.mark('jsMark');
		for (let i = 0; i < 100; i++) keyPair2 = window.nacl.box.keyPair();
		performance.measure('jsMeasure', 'jsMark');

		console.log('test nacl_box_keypair', 'Not comparable', getPerformanceString(['wasm', 'js']));
	}

	function testNaclBoxKeyPairFromSecretKey() {
		const x = new Uint8Array(32);
		fillRandom(x);

		let keyPair;
		performance.mark('wasmMark');
		for (let i = 0; i < 100; i++) keyPair = window.nacl_wasm.box.keyPair.fromSecretKey(x);
		performance.measure('wasmMeasure', 'wasmMark');

		let keyPair2;
		performance.mark('jsMark');
		for (let i = 0; i < 100; i++) keyPair2 = window.nacl.box.keyPair.fromSecretKey(x);
		performance.measure('jsMeasure', 'jsMark');

		console.log('test nacl_box_keypair_fromsecretkey',
			compareArrays(keyPair.publicKey, keyPair2.publicKey) ? 'Equal' : 'Not equal', 
			getPerformanceString(['wasm', 'js']));
	}

	function testtest() {
		const d = 128;
		const h = new Uint8Array([216, 178, 41, 175, 126, 145, 203, 8, 201, 178, 81, 77, 105, 192, 184, 252, 144, 169, 230, 127, 176, 109, 229, 188, 110, 242, 111, 225, 71, 248, 86, 125, 190, 129, 250, 70, 180, 21, 73, 210, 71, 70, 19, 27, 145, 100, 56, 255, 187, 231, 97, 154, 142, 65, 16, 178, 68, 132, 25, 141, 30, 223, 141, 79]);
		const m = new Uint8Array([51, 179, 132, 43, 99, 45, 36, 74, 255, 49, 194, 103, 52, 214, 37, 104, 215, 30, 7, 78, 155, 135, 197, 22, 134, 115, 76, 33, 251, 33, 117, 41, 192, 42, 178, 67, 145, 110, 163, 82, 188, 100, 194, 153, 209, 211, 226, 202, 38, 252, 93, 145, 103, 27, 68, 73, 74, 173, 97, 213, 136, 255, 214, 44, 26, 200, 102, 235, 20, 199, 51, 155, 143, 194, 251, 11, 173, 7, 185, 83, 178, 10, 142, 58, 5, 111, 81, 24, 172, 179, 81, 78, 20, 58, 210, 141, 68, 15, 213, 225, 78, 4, 193, 118, 2, 38, 223, 156, 122, 159, 89, 202, 48, 198, 34, 117, 167, 27, 60, 57, 189, 231, 164, 114, 234, 170, 247, 159]);
		//fillRandom(h);
		//fillRandom(m);

		const c = window.nacl_wasm.test(h, m);
		
		const hh = new Int32Array(8);
		const hl = new Int32Array(8);

		for (let i = 0; i < 8; i++) {
			hl[i] = h[8*i] + (h[8*i + 1] << 8) + (h[8*i + 2] << 16) + (h[8*i + 3] << 24);
			hh[i] = h[8*i + 4] + (h[8*i + 5] << 8) + (h[8*i + 6] << 16) + (h[8*i + 7] << 24);
		}

		window.nacl_wasm.test2(hh, hl, m, m.length);

		const h2 = new Uint8Array(64);
		for (let i = 0; i < 8; i++) {
			h2[8*i] = hl[i] & 0xff;
			h2[8*i + 1] = (hl[i] >>> 8) & 0xff;
			h2[8*i + 2] = (hl[i] >>> 16) & 0xff;
			h2[8*i + 3] = (hl[i] >>> 24) & 0xff;
			h2[8*i + 4] = hh[i] & 0xff;
			h2[8*i + 5] = (hh[i] >>> 8) & 0xff;
			h2[8*i + 6] = (hh[i] >>> 16) & 0xff;
			h2[8*i + 7] = (hh[i] >>> 24) & 0xff;
		}

		console.log('test test',
			compareArrays(h, h2) ? 'Equal' : 'Not equal')
	}

	window.nacl_wasm.instanceReady()
		.then(() => {
			//low level
			/*testCryptoCoreHSalsa20();
			testCryptoStreamSalsa20();
			testCryptoStreamSalsa20Xor();
			testCryptoStream();
			testCryptoStreamXor();
			testCryptoOnetimeAuth();
			testCryptoOnetimeAuthVerify();
			testCryptoSecretBox();
			testCryptoSecretBoxOpen();
			testVerify();
			testCryptoScalarMult();
			testCryptoScalarMultBase();
			testCryptoBoxBeforenm();
			testCryptoBoxAfternm();
			testCryptoBox();
			testCryptoBoxOpen();
			testCryptoBoxKeypair();

			//high level
			testNaclSecretbox();
			testNaclSecretboxOpen();
			testNaclScalarMult();
			testNaclScalarMultBase();
			testNaclBox();
			testNaclBoxBefore();
			testNaclBoxAfter();
			testNaclBoxOpen();
			testNaclBoxKeyPair();
			testNaclBoxKeyPairFromSecretKey();*/

			testtest();
		});
})();