;; Author: Torsten Stüber

;; polyobject
;;  pad: 0..15
;;  r: 16..35
;;  leftover: 36..39
;;  h: 40..59 
;;  final: 60..63
;;  buffer: 64..79

;; pointer $poly: 80 bytes (polyobject)
;; input value $final
;; input pointer $m: $bytes bytes
;; input value $bytes
(func $poly1305_blocks (export "poly1305_blocks") untrusted
	(param $poly i32)
	(param $final i32)
	(param $m i32)
	(param $bytes i32)

	(local $hibit s32)
	(local $r0 s32) (local $r1 s32) (local $r2 s32) (local $r3 s32) (local $r4 s32)
	(local $s1 s32) (local $s2 s32) (local $s3 s32) (local $s4 s32)
	(local $h0 s32) (local $h1 s32) (local $h2 s32) (local $h3 s32) (local $h4 s32)
	(local $d0 s64) (local $d1 s64) (local $d2 s64) (local $d3 s64) (local $d4 s64)
	(local $c s32)
	
	(if (i32.eq (get_local $final) (i32.const 0))
		(then
			(set_local $hibit (s32.const 16777216))
		)
	)

	(set_local $r0 (s32.load offset=16 (get_local $poly)))
	(set_local $s1 (s32.mul (s32.const 5) (tee_local $r1 (s32.load offset=20 (get_local $poly)))))
	(set_local $s2 (s32.mul (s32.const 5) (tee_local $r2 (s32.load offset=24 (get_local $poly)))))
	(set_local $s3 (s32.mul (s32.const 5) (tee_local $r3 (s32.load offset=28 (get_local $poly)))))
	(set_local $s4 (s32.mul (s32.const 5) (tee_local $r4 (s32.load offset=32 (get_local $poly)))))

	(set_local $h0 (s32.load offset=40 (get_local $poly)))
	(set_local $h1 (s32.load offset=44 (get_local $poly)))
	(set_local $h2 (s32.load offset=48 (get_local $poly)))
	(set_local $h3 (s32.load offset=52 (get_local $poly)))
	(set_local $h4 (s32.load offset=56 (get_local $poly)))

	(block $break
		(loop $top
			(br_if $break (i32.lt_u (get_local $bytes) (i32.const 16)))

			(set_local $h0 (s32.add (get_local $h0) (s32.and (s32.load offset=0 (get_local $m)) (s32.const 0x3ffffff))))
			(set_local $h1 (s32.add (get_local $h1) (s32.and (s32.shr_u (s32.load offset=3  (get_local $m)) (s32.const 2)) (s32.const 0x3ffffff))))
			(set_local $h2 (s32.add (get_local $h2) (s32.and (s32.shr_u (s32.load offset=6  (get_local $m)) (s32.const 4)) (s32.const 0x3ffffff))))
			(set_local $h3 (s32.add (get_local $h3) (s32.and (s32.shr_u (s32.load offset=9  (get_local $m)) (s32.const 6)) (s32.const 0x3ffffff))))
			(set_local $h4 (s32.add (get_local $h4) (s32.or  (s32.shr_u (s32.load offset=12 (get_local $m)) (s32.const 8)) (get_local $hibit))))

			(set_local $d0 (s64.add (s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h0)) (s64.extend_u/s32 (get_local $r0)))
					(s64.mul (s64.extend_u/s32 (get_local $h1)) (s64.extend_u/s32 (get_local $s4)))
			) (s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h2)) (s64.extend_u/s32 (get_local $s3)))
				(s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h3)) (s64.extend_u/s32 (get_local $s2)))
					(s64.mul (s64.extend_u/s32 (get_local $h4)) (s64.extend_u/s32 (get_local $s1)))
				)
			)))
			(set_local $d1 (s64.add (s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h0)) (s64.extend_u/s32 (get_local $r1)))
					(s64.mul (s64.extend_u/s32 (get_local $h1)) (s64.extend_u/s32 (get_local $r0)))
			) (s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h2)) (s64.extend_u/s32 (get_local $s4)))
				(s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h3)) (s64.extend_u/s32 (get_local $s3)))
					(s64.mul (s64.extend_u/s32 (get_local $h4)) (s64.extend_u/s32 (get_local $s2)))
				)
			)))
			(set_local $d2 (s64.add (s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h0)) (s64.extend_u/s32 (get_local $r2)))
					(s64.mul (s64.extend_u/s32 (get_local $h1)) (s64.extend_u/s32 (get_local $r1)))
			) (s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h2)) (s64.extend_u/s32 (get_local $r0)))
				(s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h3)) (s64.extend_u/s32 (get_local $s4)))
					(s64.mul (s64.extend_u/s32 (get_local $h4)) (s64.extend_u/s32 (get_local $s3)))
				)
			)))
			(set_local $d3 (s64.add (s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h0)) (s64.extend_u/s32 (get_local $r3)))
					(s64.mul (s64.extend_u/s32 (get_local $h1)) (s64.extend_u/s32 (get_local $r2)))
			) (s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h2)) (s64.extend_u/s32 (get_local $r1)))
				(s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h3)) (s64.extend_u/s32 (get_local $r0)))
					(s64.mul (s64.extend_u/s32 (get_local $h4)) (s64.extend_u/s32 (get_local $s4)))
				)
			)))
			(set_local $d4 (s64.add (s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h0)) (s64.extend_u/s32 (get_local $r4)))
					(s64.mul (s64.extend_u/s32 (get_local $h1)) (s64.extend_u/s32 (get_local $r3)))
			) (s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h2)) (s64.extend_u/s32 (get_local $r2)))
				(s64.add
					(s64.mul (s64.extend_u/s32 (get_local $h3)) (s64.extend_u/s32 (get_local $r1)))
					(s64.mul (s64.extend_u/s32 (get_local $h4)) (s64.extend_u/s32 (get_local $r0)))
				)
			)))

			(set_local $c (s32.wrap/s64 (s64.shr_u (get_local $d0) (s64.const 26))))
			(set_local $h0 (s32.wrap/s64 (s64.and (get_local $d0) (s64.const 0x3ffffff))))
			(set_local $d1 (s64.add (get_local $d1) (s64.extend_u/s32 (get_local $c))))
			(set_local $c (s32.wrap/s64 (s64.shr_u (get_local $d1) (s64.const 26))))
			(set_local $h1 (s32.wrap/s64 (s64.and (get_local $d1) (s64.const 0x3ffffff))))
			(set_local $d2 (s64.add (get_local $d2) (s64.extend_u/s32 (get_local $c))))
			(set_local $c (s32.wrap/s64 (s64.shr_u (get_local $d2) (s64.const 26))))
			(set_local $h2 (s32.wrap/s64 (s64.and (get_local $d2) (s64.const 0x3ffffff))))
			(set_local $d3 (s64.add (get_local $d3) (s64.extend_u/s32 (get_local $c))))
			(set_local $c (s32.wrap/s64 (s64.shr_u (get_local $d3) (s64.const 26))))
			(set_local $h3 (s32.wrap/s64 (s64.and (get_local $d3) (s64.const 0x3ffffff))))
			(set_local $d4 (s64.add (get_local $d4) (s64.extend_u/s32 (get_local $c))))
			(set_local $c (s32.wrap/s64 (s64.shr_u (get_local $d4) (s64.const 26))))
			(set_local $h4 (s32.wrap/s64 (s64.and (get_local $d4) (s64.const 0x3ffffff))))
			(set_local $h0 (s32.add (get_local $h0) (s32.mul (s32.const 5) (get_local $c))))
			(set_local $c (s32.shr_u (get_local $h0) (s32.const 26)))
			(set_local $h0 (s32.and (get_local $h0) (s32.const 0x3ffffff)))
			(set_local $h1 (s32.add (get_local $h1) (get_local $c)))

			(set_local $m (i32.add (get_local $m) (i32.const 16)))
			(set_local $bytes (i32.sub (get_local $bytes) (i32.const 16)))

			(br $top)
		)
	)

	(s32.store offset=40 (get_local $poly) (get_local $h0))
	(s32.store offset=44 (get_local $poly) (get_local $h1))
	(s32.store offset=48 (get_local $poly) (get_local $h2))
	(s32.store offset=52 (get_local $poly) (get_local $h3))
	(s32.store offset=56 (get_local $poly) (get_local $h4))
)
