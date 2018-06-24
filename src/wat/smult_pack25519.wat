;; Author: Torsten Stüber

;; output pointer $o: 32 bytes
;; input pointer $n: 16 i64 = 128 bytes
;; alloc pointer $alloc: 256 bytes
(func $pack25519 (export "pack25519")
	(param $o i32)
	(param $n i32)
	(param $alloc i32)

	(local $b s32)
	(local $m i32)
	(local $t i32)

	(tee_local $m (get_local $alloc))
	(set_local $t (i32.add (i32.const 128)))

	(s64.store offset=0 (get_local $t) (s64.load offset=0 (get_local $n)))
	(s64.store offset=8 (get_local $t) (s64.load offset=8 (get_local $n)))
	(s64.store offset=16 (get_local $t) (s64.load offset=16 (get_local $n)))
	(s64.store offset=24 (get_local $t) (s64.load offset=24 (get_local $n)))
	(s64.store offset=32 (get_local $t) (s64.load offset=32 (get_local $n)))
	(s64.store offset=40 (get_local $t) (s64.load offset=40 (get_local $n)))
	(s64.store offset=48 (get_local $t) (s64.load offset=48 (get_local $n)))
	(s64.store offset=56 (get_local $t) (s64.load offset=56 (get_local $n)))
	(s64.store offset=64 (get_local $t) (s64.load offset=64 (get_local $n)))
	(s64.store offset=72 (get_local $t) (s64.load offset=72 (get_local $n)))
	(s64.store offset=80 (get_local $t) (s64.load offset=80 (get_local $n)))
	(s64.store offset=88 (get_local $t) (s64.load offset=88 (get_local $n)))
	(s64.store offset=96 (get_local $t) (s64.load offset=96 (get_local $n)))
	(s64.store offset=104 (get_local $t) (s64.load offset=104 (get_local $n)))
	(s64.store offset=112 (get_local $t) (s64.load offset=112 (get_local $n)))
	(s64.store offset=120 (get_local $t) (s64.load offset=120 (get_local $n)))

	(get_local $t)
	(call $car25519)
	(get_local $t)
	(call $car25519)
	(get_local $t)
	(call $car25519)

	
	(s64.store offset=0 (get_local $m) (s64.sub (s64.load offset=0 (get_local $t)) (s64.const 0xffed)))
	(s64.store offset=8 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=8 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=0 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=0 (get_local $m) (s64.and (s64.load offset=0 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=16 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=16 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=8 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=8 (get_local $m) (s64.and (s64.load offset=8 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=24 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=24 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=16 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=16 (get_local $m) (s64.and (s64.load offset=16 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=32 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=32 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=24 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=24 (get_local $m) (s64.and (s64.load offset=24 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=40 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=40 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=32 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=32 (get_local $m) (s64.and (s64.load offset=32 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=48 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=48 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=40 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=40 (get_local $m) (s64.and (s64.load offset=40 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=56 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=56 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=48 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=48 (get_local $m) (s64.and (s64.load offset=48 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=64 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=64 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=56 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=56 (get_local $m) (s64.and (s64.load offset=56 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=72 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=72 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=64 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=64 (get_local $m) (s64.and (s64.load offset=64 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=80 (get_local $m) (s64.sub 
		(s64.sub (s64.load offset=80 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=72 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=72 (get_local $m) (s64.and (s64.load offset=72 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=88 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=88 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=80 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=80 (get_local $m) (s64.and (s64.load offset=80 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=96 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=96 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=88 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=88 (get_local $m) (s64.and (s64.load offset=88 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=104 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=104 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=96 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=96 (get_local $m) (s64.and (s64.load offset=96 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=112 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=112 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=104 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=104 (get_local $m) (s64.and (s64.load offset=104 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=120 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=120 (get_local $t)) (s64.const 0x7fff)) 
		(s64.and (s64.shr_s (s64.load offset=112 (get_local $m)) (s64.const 16)) (s64.const 1))
	))

	(set_local $b (s32.wrap/s64 (s64.and
		(s64.shr_s (s64.load offset=120 (get_local $m)) (s64.const 16))
		(s64.const 1)
	)))
	(s64.store offset=112 (get_local $m) (s64.and (s64.load offset=112 (get_local $m)) (s64.const 0xffff)))

	(get_local $t)
	(get_local $m)
	(s32.sub (s32.const 1) (get_local $b))
	(call $sel25519)


	(s64.store offset=0 (get_local $m) (s64.sub (s64.load offset=0 (get_local $t)) (s64.const 0xffed)))
	(s64.store offset=8 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=8 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=0 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=0 (get_local $m) (s64.and (s64.load offset=0 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=16 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=16 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=8 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=8 (get_local $m) (s64.and (s64.load offset=8 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=24 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=24 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=16 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=16 (get_local $m) (s64.and (s64.load offset=16 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=32 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=32 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=24 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=24 (get_local $m) (s64.and (s64.load offset=24 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=40 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=40 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=32 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=32 (get_local $m) (s64.and (s64.load offset=32 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=48 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=48 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=40 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=40 (get_local $m) (s64.and (s64.load offset=40 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=56 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=56 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=48 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=48 (get_local $m) (s64.and (s64.load offset=48 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=64 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=64 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=56 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=56 (get_local $m) (s64.and (s64.load offset=56 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=72 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=72 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=64 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=64 (get_local $m) (s64.and (s64.load offset=64 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=80 (get_local $m) (s64.sub 
		(s64.sub (s64.load offset=80 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=72 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=72 (get_local $m) (s64.and (s64.load offset=72 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=88 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=88 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=80 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=80 (get_local $m) (s64.and (s64.load offset=80 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=96 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=96 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=88 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=88 (get_local $m) (s64.and (s64.load offset=88 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=104 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=104 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=96 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=96 (get_local $m) (s64.and (s64.load offset=96 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=112 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=112 (get_local $t)) (s64.const 0xffff)) 
		(s64.and (s64.shr_s (s64.load offset=104 (get_local $m)) (s64.const 16)) (s64.const 1))
	))
	(s64.store offset=104 (get_local $m) (s64.and (s64.load offset=104 (get_local $m)) (s64.const 0xffff)))
	(s64.store offset=120 (get_local $m) (s64.sub
		(s64.sub (s64.load offset=120 (get_local $t)) (s64.const 0x7fff)) 
		(s64.and (s64.shr_s (s64.load offset=112 (get_local $m)) (s64.const 16)) (s64.const 1))
	))

	(set_local $b (s32.wrap/s64 (s64.and
		(s64.shr_s (s64.load offset=120 (get_local $m)) (s64.const 16))
		(s64.const 1)
	)))
	(s64.store offset=112 (get_local $m) (s64.and (s64.load offset=112 (get_local $m)) (s64.const 0xffff)))

	(get_local $t)
	(get_local $m)
	(s32.sub (s32.const 1) (get_local $b))
	(call $sel25519)

	(s64.store16 offset=0 (get_local $o) (s64.load offset=0 (get_local $t)))
	(s64.store16 offset=2 (get_local $o) (s64.load offset=8 (get_local $t)))
	(s64.store16 offset=4 (get_local $o) (s64.load offset=16 (get_local $t)))
	(s64.store16 offset=6 (get_local $o) (s64.load offset=24 (get_local $t)))
	(s64.store16 offset=8 (get_local $o) (s64.load offset=32 (get_local $t)))
	(s64.store16 offset=10 (get_local $o) (s64.load offset=40 (get_local $t)))
	(s64.store16 offset=12 (get_local $o) (s64.load offset=48 (get_local $t)))
	(s64.store16 offset=14 (get_local $o) (s64.load offset=56 (get_local $t)))
	(s64.store16 offset=16 (get_local $o) (s64.load offset=64 (get_local $t)))
	(s64.store16 offset=18 (get_local $o) (s64.load offset=72 (get_local $t)))
	(s64.store16 offset=20 (get_local $o) (s64.load offset=80 (get_local $t)))
	(s64.store16 offset=22 (get_local $o) (s64.load offset=88 (get_local $t)))
	(s64.store16 offset=24 (get_local $o) (s64.load offset=96 (get_local $t)))
	(s64.store16 offset=26 (get_local $o) (s64.load offset=104 (get_local $t)))
	(s64.store16 offset=28 (get_local $o) (s64.load offset=112 (get_local $t)))
	(s64.store16 offset=30 (get_local $o) (s64.load offset=120 (get_local $t)))
)