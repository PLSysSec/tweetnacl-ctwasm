;; Author: Torsten Stüber

;; output $o: 32 bytes
;; input pointer $p: 16 bytes
;; input pointer $k: 32 bytes
;; input pointer $c: 16 bytes
(func $core_hsalsa20 (export "core_hsalsa20") (param $o i32) (param $p i32) (param $k i32) (param $c i32)
	(local $j0 s32) (local $j1 s32) (local $j2 s32) (local $j3 s32)
	(local $j4 s32) (local $j5 s32) (local $j6 s32) (local $j7 s32)
	(local $j8 s32) (local $j9 s32) (local $j10 s32) (local $j11 s32)
	(local $j12 s32) (local $j13 s32) (local $j14 s32) (local $j15 s32)

	(local $x0 s32) (local $x1 s32) (local $x2 s32) (local $x3 s32)
	(local $x4 s32) (local $x5 s32) (local $x6 s32) (local $x7 s32)
	(local $x8 s32) (local $x9 s32) (local $x10 s32) (local $x11 s32)
	(local $x12 s32) (local $x13 s32) (local $x14 s32) (local $x15 s32)

	(local $i i32)

	(set_local $x0 (tee_local $j0  (s32.load offset=0  (get_local $c))))
	(set_local $x1 (tee_local $j1  (s32.load offset=0  (get_local $k))))
	(set_local $x2 (tee_local $j2  (s32.load offset=4  (get_local $k))))
	(set_local $x3 (tee_local $j3  (s32.load offset=8  (get_local $k))))
	(set_local $x4 (tee_local $j4  (s32.load offset=12 (get_local $k))))
	(set_local $x5 (tee_local $j5  (s32.load offset=4  (get_local $c))))
	(set_local $x6 (tee_local $j6  (s32.load offset=0  (get_local $p))))
	(set_local $x7 (tee_local $j7  (s32.load offset=4  (get_local $p))))
	(set_local $x8 (tee_local $j8  (s32.load offset=8  (get_local $p))))
	(set_local $x9 (tee_local $j9  (s32.load offset=12  (get_local $p))))
	(set_local $x10 (tee_local $j10 (s32.load offset=8  (get_local $c))))
	(set_local $x11 (tee_local $j11 (s32.load offset=16  (get_local $k))))
	(set_local $x12 (tee_local $j12 (s32.load offset=20 (get_local $k))))
	(set_local $x13 (tee_local $j13 (s32.load offset=24  (get_local $k))))
	(set_local $x14 (tee_local $j14 (s32.load offset=28  (get_local $k))))
	(set_local $x15 (tee_local $j15 (s32.load offset=12  (get_local $c))))

	(block $break
		(loop $top
			(br_if $break (i32.eq (get_local $i) (i32.const 20)))
			
			(set_local $x4  (s32.xor (get_local $x4)  (s32.rotl (s32.add (get_local $x0)  (get_local $x12)) (s32.const 7))))
			(set_local $x8  (s32.xor (get_local $x8)  (s32.rotl (s32.add (get_local $x4)  (get_local $x0))  (s32.const 9))))
			(set_local $x12 (s32.xor (get_local $x12) (s32.rotl (s32.add (get_local $x8)  (get_local $x4))  (s32.const 13))))
			(set_local $x0  (s32.xor (get_local $x0)  (s32.rotl (s32.add (get_local $x12) (get_local $x8))  (s32.const 18))))

			(set_local $x9  (s32.xor (get_local $x9)  (s32.rotl (s32.add (get_local $x5)  (get_local $x1))  (s32.const 7))))
			(set_local $x13 (s32.xor (get_local $x13) (s32.rotl (s32.add (get_local $x9)  (get_local $x5))  (s32.const 9))))
			(set_local $x1  (s32.xor (get_local $x1)  (s32.rotl (s32.add (get_local $x13) (get_local $x9))  (s32.const 13))))
			(set_local $x5  (s32.xor (get_local $x5)  (s32.rotl (s32.add (get_local $x1)  (get_local $x13)) (s32.const 18))))

			(set_local $x14 (s32.xor (get_local $x14) (s32.rotl (s32.add (get_local $x10) (get_local $x6))  (s32.const 7))))
			(set_local $x2  (s32.xor (get_local $x2)  (s32.rotl (s32.add (get_local $x14) (get_local $x10)) (s32.const 9))))
			(set_local $x6  (s32.xor (get_local $x6)  (s32.rotl (s32.add (get_local $x2)  (get_local $x14)) (s32.const 13))))
			(set_local $x10 (s32.xor (get_local $x10) (s32.rotl (s32.add (get_local $x6)  (get_local $x2))  (s32.const 18))))

			(set_local $x3  (s32.xor (get_local $x3)  (s32.rotl (s32.add (get_local $x15) (get_local $x11)) (s32.const 7))))
			(set_local $x7  (s32.xor (get_local $x7)  (s32.rotl (s32.add (get_local $x3)  (get_local $x15)) (s32.const 9))))
			(set_local $x11 (s32.xor (get_local $x11) (s32.rotl (s32.add (get_local $x7)  (get_local $x3))  (s32.const 13))))
			(set_local $x15 (s32.xor (get_local $x15) (s32.rotl (s32.add (get_local $x11) (get_local $x7))  (s32.const 18))))

			(set_local $x1  (s32.xor (get_local $x1)  (s32.rotl (s32.add (get_local $x0)  (get_local $x3))  (s32.const 7))))
			(set_local $x2  (s32.xor (get_local $x2)  (s32.rotl (s32.add (get_local $x1)  (get_local $x0))  (s32.const 9))))
			(set_local $x3  (s32.xor (get_local $x3)  (s32.rotl (s32.add (get_local $x2)  (get_local $x1))  (s32.const 13))))
			(set_local $x0  (s32.xor (get_local $x0)  (s32.rotl (s32.add (get_local $x3)  (get_local $x2))  (s32.const 18))))

			(set_local $x6  (s32.xor (get_local $x6)  (s32.rotl (s32.add (get_local $x5)  (get_local $x4))  (s32.const 7))))
			(set_local $x7  (s32.xor (get_local $x7)  (s32.rotl (s32.add (get_local $x6)  (get_local $x5))  (s32.const 9))))
			(set_local $x4  (s32.xor (get_local $x4)  (s32.rotl (s32.add (get_local $x7)  (get_local $x6))  (s32.const 13))))
			(set_local $x5  (s32.xor (get_local $x5)  (s32.rotl (s32.add (get_local $x4)  (get_local $x7))  (s32.const 18))))

			(set_local $x11 (s32.xor (get_local $x11) (s32.rotl (s32.add (get_local $x10) (get_local $x9))  (s32.const 7))))
			(set_local $x8  (s32.xor (get_local $x8)  (s32.rotl (s32.add (get_local $x11) (get_local $x10)) (s32.const 9))))
			(set_local $x9  (s32.xor (get_local $x9)  (s32.rotl (s32.add (get_local $x8)  (get_local $x11)) (s32.const 13))))
			(set_local $x10 (s32.xor (get_local $x10) (s32.rotl (s32.add (get_local $x9)  (get_local $x8))  (s32.const 18))))

			(set_local $x12 (s32.xor (get_local $x12) (s32.rotl (s32.add (get_local $x15) (get_local $x14)) (s32.const 7))))
			(set_local $x13 (s32.xor (get_local $x13) (s32.rotl (s32.add (get_local $x12) (get_local $x15)) (s32.const 9))))
			(set_local $x14 (s32.xor (get_local $x14) (s32.rotl (s32.add (get_local $x13) (get_local $x12)) (s32.const 13))))
			(set_local $x15 (s32.xor (get_local $x15) (s32.rotl (s32.add (get_local $x14) (get_local $x13))  (s32.const 18))))

			(set_local $i (i32.add (get_local $i) (i32.const 2)))
			(br $top)
		)
	)

	(s32.store offset=0  (get_local $o) (get_local $x0))
	(s32.store offset=4  (get_local $o) (get_local $x5))
	(s32.store offset=8  (get_local $o) (get_local $x10))
	(s32.store offset=12 (get_local $o) (get_local $x15))
	(s32.store offset=16 (get_local $o) (get_local $x6))
	(s32.store offset=20 (get_local $o) (get_local $x7))
	(s32.store offset=24 (get_local $o) (get_local $x8))
	(s32.store offset=28 (get_local $o) (get_local $x9))
)
