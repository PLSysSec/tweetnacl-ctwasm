;; Author: Torsten Stüber

;; output pointer $sm: $n + 64 bytes
;; input value $n
;; input $sk: 64 bytes
;; alloc pointer $alloc: 896 + 3 * 64 + 2 * 512 = 2112 bytes
(func $crypto_sign (export "crypto_sign") untrusted
	(param $sm i32)
	(param $n i32)
	(param $sk i32)
	(param $alloc i32)
	
	(local $d i32)
	(local $h i32)
	(local $r i32)
	(local $x i32)
	(local $p i32)
	(local $i i32)
	(local $j i32)
	(local $tmp i32)

	(tee_local $d (i32.add (get_local $alloc) (i32.const 896)))
	(tee_local $h (i32.add (i32.const 64)))
	(tee_local $r (i32.add (i32.const 64)))
	(tee_local $x (i32.add (i32.const 64)))
	(set_local $p (i32.add (i32.const 512)))
	
	(get_local $d)
	(get_local $sk)
	(i32.const 32)
	(get_local $alloc)
	(call $crypto_hash)

	(s32.store8 offset=0 (get_local $d) (s32.and
		(s32.load8_u offset=0 (get_local $d))
		(s32.const 248)
	))
	(s32.store8 offset=31 (get_local $d) (s32.and
		(s32.load8_u offset=31 (get_local $d))
		(s32.const 127)
	))
	(s32.store8 offset=31 (get_local $d) (s32.or
		(s32.load8_u offset=31 (get_local $d))
		(s32.const 64)
	))

	(s64.store offset=32 (get_local $sm) (s64.load offset=32 (get_local $d)))
	(s64.store offset=40 (get_local $sm) (s64.load offset=40 (get_local $d)))
	(s64.store offset=48 (get_local $sm) (s64.load offset=48 (get_local $d)))
	(s64.store offset=56 (get_local $sm) (s64.load offset=56 (get_local $d)))

	(get_local $r)
	(i32.add (get_local $sm) (i32.const 32))
	(i32.add (get_local $n) (i32.const 32))
	(get_local $alloc)
	(call $crypto_hash)

	(get_local $r)
	(get_local $alloc)
	(call $reduce)

	(get_local $p)
	(get_local $r)
	(get_local $alloc)
	(call $scalarbase)

	(get_local $sm)
	(get_local $p)
	(get_local $alloc)
	(call $pack)

	(s64.store offset=32 (get_local $sm) (s64.load offset=32 (get_local $sk)))
	(s64.store offset=40 (get_local $sm) (s64.load offset=40 (get_local $sk)))
	(s64.store offset=48 (get_local $sm) (s64.load offset=48 (get_local $sk)))
	(s64.store offset=56 (get_local $sm) (s64.load offset=56 (get_local $sk)))

	(get_local $h)
	(get_local $sm)
	(i32.add (get_local $n) (i32.const 64))
	(get_local $alloc)
	(call $crypto_hash)

	(get_local $h)
	(get_local $alloc)
	(call $reduce)

	(block
		(loop
			(br_if 1 (i32.eq (get_local $i) (i32.const 32)))

			(s64.store (i32.add (get_local $x) (i32.shl (get_local $i) (i32.const 3)))
				(s64.load8_u (i32.add (get_local $r) (get_local $i)))
			)
			
			(set_local $i (i32.add (get_local $i) (i32.const 1)))
			(br 0)
		)
	)

	(block
		(loop
			(br_if 1 (i32.eq (get_local $i) (i32.const 64)))

			(s64.store (i32.add (get_local $x) (i32.shl (get_local $i) (i32.const 3)))
				(s64.const 0)
			)
			
			(set_local $i (i32.add (get_local $i) (i32.const 1)))
			(br 0)
		)
	)

	(set_local $i (i32.const 0))
	(block
		(loop
			(br_if 1 (i32.eq (get_local $i) (i32.const 32)))

			(set_local $tmp (i32.add (get_local $x) (i32.shl (get_local $i) (i32.const 3))))
			(set_local $j (i32.const 0))
			(block
				(loop
					(br_if 1 (i32.eq (get_local $j) (i32.const 32)))

					(s64.store (get_local $tmp) (s64.add
						(s64.load (get_local $tmp))
						(s64.mul
							(s64.load8_u (i32.add (get_local $h) (get_local $i)))
							(s64.load8_u (i32.add (get_local $d) (get_local $j)))
						)
					))

					(set_local $tmp (i32.add (get_local $tmp) (i32.const 8)))
					(set_local $j (i32.add (get_local $j) (i32.const 1)))
					(br 0)
				)
			)

			(set_local $i (i32.add (get_local $i) (i32.const 1)))
			(br 0)
		)
	)

	(i32.add (get_local $sm) (i32.const 32))
	(get_local $x)
	(call $modL)
)
