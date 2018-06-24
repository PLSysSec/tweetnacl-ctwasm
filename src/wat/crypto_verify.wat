;; Author: Torsten Stüber

;; input pointer $x: $n bytes
;; input pointer $y: $n bytes
;; input value $n
;; return bool
(func $vn (export "vn")
	(param $x i32)
	(param $y i32)
	(param $n i32)
	(result s32)

	(local $d s64)
	
	(block
		(loop
			(br_if 1 (i32.lt_u (get_local $n) (i32.const 8)))

			(set_local $d (s64.or (get_local $d)
				(s64.xor (s64.load (get_local $x)) (s64.load (get_local $y)))))

			(set_local $n (i32.sub (get_local $n) (i32.const 8)))
			(set_local $x (i32.add (get_local $x) (i32.const 8)))
			(set_local $y (i32.add (get_local $y) (i32.const 8)))
			(br 0)
		)
	)

	(set_local $d (s64.or
		(s64.and (get_local $d) (s64.const 0xffffffff))
		(s64.shr_u (get_local $d) (s64.const 32))
	))

	(block
		(loop
			(br_if 1 (i32.eqz (get_local $n)))

			(set_local $d (s64.or (get_local $d)
				(s64.xor (s64.load8_u (get_local $x)) (s64.load8_u (get_local $y)))))

			(set_local $n (i32.sub (get_local $n) (i32.const 1)))
			(set_local $x (i32.add (get_local $x) (i32.const 1)))
			(set_local $y (i32.add (get_local $y) (i32.const 1)))
			(br 0)
		)
	)

	(s32.wrap/s64 (s64.sub
		(s64.and (s64.const 1) (s64.shr_u (s64.sub (get_local $d) (s64.const 1)) (s64.const 32))) 
		(s64.const 1)))
)

;; input pointer $x: 16 bytes
;; input pointer $y: 16 bytes
;; return bool
(func $crypto_verify_16 (export "crypto_verify_16")
	(param $x i32)
	(param $y i32)
	(result s32)

	(local $d s64)
	(set_local $d (s64.or
		(s64.xor (s64.load offset=0 (get_local $x)) (s64.load offset=0 (get_local $y)))
		(s64.xor (s64.load offset=8 (get_local $x)) (s64.load offset=8 (get_local $y)))
	))

	(set_local $d (s64.or
		(s64.and (get_local $d) (s64.const 0xffffffff))
		(s64.shr_u (get_local $d) (s64.const 32))
	))

	(s32.wrap/s64 (s64.sub
		(s64.and (s64.const 1) (s64.shr_u (s64.sub (get_local $d) (s64.const 1)) (s64.const 32))) 
		(s64.const 1)))
)

;; input pointer $x: 32 bytes
;; input pointer $y: 32 bytes
;; return bool
(func $crypto_verify_32 (export "crypto_verify_32")
	(param $x i32)
	(param $y i32)
	(result s32)

	(local $d s64)
	(set_local $d (s64.or
		(s64.or
			(s64.xor (s64.load offset=0 (get_local $x)) (s64.load offset=0 (get_local $y)))
			(s64.xor (s64.load offset=8 (get_local $x)) (s64.load offset=8 (get_local $y)))
		)
		(s64.or
			(s64.xor (s64.load offset=16 (get_local $x)) (s64.load offset=16 (get_local $y)))
			(s64.xor (s64.load offset=24 (get_local $x)) (s64.load offset=24 (get_local $y)))
		)
	))

	(set_local $d (s64.or
		(s64.and (get_local $d) (s64.const 0xffffffff))
		(s64.shr_u (get_local $d) (s64.const 32))
	))

	(s32.wrap/s64 (s64.sub
		(s64.and (s64.const 1) (s64.shr_u (s64.sub (get_local $d) (s64.const 1)) (s64.const 32))) 
		(s64.const 1)))
)
