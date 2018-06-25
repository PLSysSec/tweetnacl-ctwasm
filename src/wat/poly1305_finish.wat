;; Author: Torsten Stüber

;; polyobject
;;  pad: 0..15
;;  r: 16..35
;;  leftover: 36..39 (unused)
;;  h: 40..59 
;;  final: 60..63
;;  buffer: 64..79

;; pointer $poly: 80 bytes (polyobject)
;; input value $leftover
;; output pointer $mac: 16 bytes
(func $poly1305_finish (export "poly1305_finish") trusted
	(param $poly i32)
	(param $leftover i32)
	(param $mac i32)

	(local $h0 s32) (local $h1 s32) (local $h2 s32) (local $h3 s32) (local $h4 s32) (local $c s32)
	(local $g0 s32) (local $g1 s32) (local $g2 s32) (local $g3 s32) (local $g4 s32)
	(local $f s64)
	(local $mask s32)
	(local $i i32) (local $tmp i32)

	(if (i32.gt_u (get_local $leftover) (i32.const 0))
		(then
			(set_local $i (i32.add (i32.const 1) (get_local $leftover)))
			(set_local $tmp (i32.add (get_local $poly) (get_local $i)))
			(s32.store8 offset=63 (get_local $tmp) (s32.const 1))
			(block $break
				(loop $top
					(br_if $break (i32.eq (get_local $i) (i32.const 16)))
					
					(s32.store8 offset=64 (get_local $tmp) (s32.const 0))

					(set_local $i (i32.add (get_local $i) (i32.const 1)))
					(set_local $tmp (i32.add (get_local $tmp) (i32.const 1)))

					(br $top)
				)
			)

			(s32.store offset=60 (get_local $poly) (s32.const 1))
			
			(get_local $poly)
			(i32.add (get_local $poly) (i32.const 64))
			(i32.const 16)
			(call $poly1305_blocks) ;; poly1305_blocks
		)
	)

	(set_local $h0 (s32.load offset=40 (get_local $poly)))
	(set_local $h1 (s32.load offset=44 (get_local $poly)))
	(set_local $h2 (s32.load offset=48 (get_local $poly)))
	(set_local $h3 (s32.load offset=52 (get_local $poly)))
	(set_local $h4 (s32.load offset=56 (get_local $poly)))

	(set_local $c (s32.shr_u (get_local $h1) (s32.const 26)))
	(set_local $h1 (s32.and (get_local $h1) (s32.const 0x3ffffff)))
	(set_local $h2 (s32.add (get_local $h2) (get_local $c)))
	(set_local $c (s32.shr_u (get_local $h2) (s32.const 26)))
	(set_local $h2 (s32.and (get_local $h2) (s32.const 0x3ffffff)))
	(set_local $h3 (s32.add (get_local $h3) (get_local $c)))
	(set_local $c (s32.shr_u (get_local $h3) (s32.const 26)))
	(set_local $h3 (s32.and (get_local $h3) (s32.const 0x3ffffff)))
	(set_local $h4 (s32.add (get_local $h4) (get_local $c)))
	(set_local $c (s32.shr_u (get_local $h4) (s32.const 26)))
	(set_local $h4 (s32.and (get_local $h4) (s32.const 0x3ffffff)))
	(set_local $h0 (s32.add (get_local $h0) (s32.mul (get_local $c) (s32.const 5))))
	(set_local $c (s32.shr_u (get_local $h0) (s32.const 26)))
	(set_local $h0 (s32.and (get_local $h0) (s32.const 0x3ffffff)))
	(set_local $h1 (s32.add (get_local $h1) (get_local $c)))

	(set_local $g0 (s32.add (get_local $h0) (s32.const 5)))
	(set_local $c (s32.shr_u (get_local $g0) (s32.const 26)))
	(set_local $g0 (s32.and (get_local $g0) (s32.const 0x3ffffff)))
	(set_local $g1 (s32.add (get_local $h1) (get_local $c)))
	(set_local $c (s32.shr_u (get_local $g1) (s32.const 26)))
	(set_local $g1 (s32.and (get_local $g1) (s32.const 0x3ffffff)))
	(set_local $g2 (s32.add (get_local $h2) (get_local $c)))
	(set_local $c (s32.shr_u (get_local $g2) (s32.const 26)))
	(set_local $g2 (s32.and (get_local $g2) (s32.const 0x3ffffff)))
	(set_local $g3 (s32.add (get_local $h3) (get_local $c)))
	(set_local $c (s32.shr_u (get_local $g3) (s32.const 26)))
	(set_local $g3 (s32.and (get_local $g3) (s32.const 0x3ffffff)))
	(set_local $g4 (s32.sub (s32.add (get_local $h4) (get_local $c)) (s32.const 67108864)))

	(set_local $mask (s32.sub (s32.shr_u (get_local $g4) (s32.const 31)) (s32.const 1)))
	(set_local $g0 (s32.and (get_local $g0) (get_local $mask)))
	(set_local $g1 (s32.and (get_local $g1) (get_local $mask)))
	(set_local $g2 (s32.and (get_local $g2) (get_local $mask)))
	(set_local $g3 (s32.and (get_local $g3) (get_local $mask)))
	(set_local $g4 (s32.and (get_local $g4) (get_local $mask)))
	(set_local $mask (s32.sub (s32.const -1) (get_local $mask)))
	(set_local $h0 (s32.or (s32.and (get_local $h0) (get_local $mask)) (get_local $g0)))
	(set_local $h1 (s32.or (s32.and (get_local $h1) (get_local $mask)) (get_local $g0)))
	(set_local $h2 (s32.or (s32.and (get_local $h2) (get_local $mask)) (get_local $g0)))
	(set_local $h3 (s32.or (s32.and (get_local $h3) (get_local $mask)) (get_local $g0)))
	(set_local $h4 (s32.or (s32.and (get_local $h4) (get_local $mask)) (get_local $g0)))

	(set_local $h0 (s32.or (get_local $h0) (s32.shl (get_local $h1) (s32.const 26))))
	(set_local $h1 (s32.or (s32.shr_u (get_local $h1) (s32.const 6)) (s32.shl (get_local $h2) (s32.const 20))))
	(set_local $h2 (s32.or (s32.shr_u (get_local $h2) (s32.const 12)) (s32.shl (get_local $h3) (s32.const 14))))
	(set_local $h3 (s32.or (s32.shr_u (get_local $h3) (s32.const 18)) (s32.shl (get_local $h4) (s32.const 8))))

	(set_local $f (s64.add (s64.extend_u/s32 (get_local $h0)) (s64.load32_u offset=0 (get_local $poly))))
	(set_local $h0 (s32.wrap/s64 (get_local $f)))
	(set_local $f (s64.add (s64.add (s64.extend_u/s32 (get_local $h1)) (s64.load32_u offset=4 (get_local $poly))) (s64.shr_u (get_local $f) (s64.const 32))))
	(set_local $h1 (s32.wrap/s64 (get_local $f)))
	(set_local $f (s64.add (s64.add (s64.extend_u/s32 (get_local $h2)) (s64.load32_u offset=8 (get_local $poly))) (s64.shr_u (get_local $f) (s64.const 32))))
	(set_local $h2 (s32.wrap/s64 (get_local $f)))
	(set_local $f (s64.add (s64.add (s64.extend_u/s32 (get_local $h3)) (s64.load32_u offset=12 (get_local $poly))) (s64.shr_u (get_local $f) (s64.const 32))))
	(set_local $h3 (s32.wrap/s64 (get_local $f)))

	(s32.store offset=0 (get_local $mac) (get_local $h0))
	(s32.store offset=4 (get_local $mac) (get_local $h1))
	(s32.store offset=8 (get_local $mac) (get_local $h2))
	(s32.store offset=12 (get_local $mac) (get_local $h3))

	(s64.store offset=0 (get_local $poly) (s64.const 0))
	(s64.store offset=8 (get_local $poly) (s64.const 0))
	(s64.store offset=16 (get_local $poly) (s64.const 0))
	(s64.store offset=24 (get_local $poly) (s64.const 0))
	(s64.store offset=32 (get_local $poly) (s64.const 0))
	(s64.store offset=40 (get_local $poly) (s64.const 0))
	(s64.store offset=48 (get_local $poly) (s64.const 0))
	(s64.store offset=56 (get_local $poly) (s64.const 0))
	(s64.store offset=64 (get_local $poly) (s64.const 0))
	(s64.store offset=72 (get_local $poly) (s64.const 0))
)
