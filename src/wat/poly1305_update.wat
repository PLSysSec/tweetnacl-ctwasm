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
;; input pointer $m: $bytes bytes
;; input value $bytes
;; result value: new leftover
(func $poly1305_update (export "poly1305_update") untrusted
	(param $poly i32)
	(param $leftover i32)
	(param $m i32)
	(param $bytes i32)
	(result i32)

	(local $i i32)
	(local $want i32)
	(local $tmp1 i32)
	(local $tmp2 i32)

	(if (i32.ne (get_local $leftover) (i32.const 0))
		(then
			(set_local $want (i32.sub (i32.const 16) (get_local $leftover)))
	
			(if (i32.gt_u (get_local $want) (get_local $bytes))
				(then
					(set_local $want (get_local $bytes))
				)
			)

			(set_local $tmp1 (i32.add (get_local $poly) (get_local $leftover)))
			(set_local $tmp2 (get_local $m))
			(block $break1
				(loop $top1
					(br_if $break1 (i32.eq (get_local $i) (get_local $want)))
					
					(s32.store8 offset=64 (get_local $tmp1) (s32.load8_u (get_local $tmp2)))

					(set_local $i (i32.add (get_local $i) (i32.const 1)))
					(set_local $tmp1 (i32.add (get_local $tmp1) (i32.const 1)))
					(set_local $tmp2 (i32.add (get_local $tmp2) (i32.const 1)))

					(br $top1)
				)
			)

			(set_local $bytes (i32.sub (get_local $bytes) (get_local $want)))
			(set_local $m (i32.add (get_local $m) (get_local $want)))
			(set_local $leftover (i32.add (get_local $want) (get_local $leftover)))

			(if (i32.lt_u (get_local $leftover) (i32.const 16))
				(then
					(return (get_local $leftover))
				)
			)

			(get_local $poly)
			(i32.const 0) ;; $final = 0
			(i32.add (get_local $poly) (i32.const 64))
			(i32.const 16)
			(call $poly1305_blocks) ;; poly1305_blocks

			(set_local $leftover (i32.const 0))
		)
	)

	(if (i32.ge_u (get_local $bytes) (i32.const 16))
		(then
			(set_local $want (i32.and (get_local $bytes) (i32.const 0xfffffff0)))
			
			(get_local $poly)
			(i32.const 0) ;; $final = 0
			(get_local $m)
			(get_local $want)
			(call $poly1305_blocks) ;; poly1305_blocks

			(set_local $m (i32.add (get_local $m) (get_local $want)))
			(set_local $bytes (i32.sub (get_local $bytes) (get_local $want)))
		)
	)

	(if (i32.gt_u (get_local $bytes) (i32.const 0))
		(then
			(set_local $i (i32.const 0))
			(set_local $tmp1 (i32.add (get_local $poly) (get_local $leftover)))
			(set_local $tmp2 (get_local $m))
			(block $break2
				(loop $top2
					(br_if $break2 (i32.eq (get_local $i) (get_local $bytes)))
					
					(s32.store8 offset=64 (get_local $tmp1) (s32.load8_u (get_local $tmp2)))

					(set_local $i (i32.add (get_local $i) (i32.const 1)))
					(set_local $tmp1 (i32.add (get_local $tmp1) (i32.const 1)))
					(set_local $tmp2 (i32.add (get_local $tmp2) (i32.const 1)))

					(br $top2)
				)
			)

			(set_local $leftover (i32.add (get_local $leftover) (get_local $bytes)))
		)
	)
	(get_local $leftover)
)
