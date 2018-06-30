;; Author: Torsten Stüber

;; output pointer $mac: 16 bytes
;; input pointer $m: $bytes bytes
;; input value $bytes
;; input pointer $key: 32 bytes
;; alloc pointer $alloc: 80 bytes
(func $crypto_onetimeauth (export "crypto_onetimeauth") untrusted
	(param $mac i32)
	(param $m i32)
	(param $bytes i32)
	(param $key i32)
	(param $alloc i32)

	(local $leftover i32)
	(set_local $leftover (i32.const 0))

	(get_local $alloc)
	(get_local $key)
	(call $poly1305_init) ;; poly1305_init

	(get_local $alloc)
	(get_local $leftover)
	(get_local $m)
	(get_local $bytes)
	(call $poly1305_update) ;; poly1305_update
	(set_local $leftover)

	(get_local $alloc)
	(get_local $leftover)
	(get_local $mac)
	(call $poly1305_finish) ;; poly1305_finish
)

;; input pointer $h: 16 bytes
;; input pointer $m: $bytes bytes
;; input value $bytes
;; input pointer $key: 32 bytes
;; alloc pointer $alloc: 96 bytes
;; return bool
(func $crypto_onetimeauth_verify (export "crypto_onetimeauth_verify") untrusted
	(param $h i32)
	(param $m i32)
	(param $bytes i32)
	(param $key i32)
	(param $alloc i32)
	(result s32)
	
	(i32.add (get_local $alloc) (i32.const 80))
	(get_local $m)
	(get_local $bytes)
	(get_local $key)
	(get_local $alloc)
	(call $crypto_onetimeauth)

	(get_local $h)
	(i32.add (get_local $alloc) (i32.const 80))
	(call $crypto_verify_16)
)
