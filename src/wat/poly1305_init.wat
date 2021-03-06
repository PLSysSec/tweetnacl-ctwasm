;; Author: Torsten Stüber

;; polyobject
;;  pad: 0..15
;;  r: 16..35
;;  leftover: 36..39 (unused)
;;  h: 40..59 
;;  final: 60..63
;;  buffer: 64..79

;; output pointer $polyobject: 80 bytes
;; input pointer $k: 32 bytes
(func $poly1305_init (export "poly1305_init") untrusted
	(param $polyobject i32)
	(param $k i32)
	
	(s32.store offset=16 (get_local $polyobject) (s32.and (s32.load offset=0 (get_local $k))                            (s32.const 0x3ffffff)))
	(s32.store offset=20 (get_local $polyobject) (s32.and (s32.shr_u (s32.load offset=3 ( get_local $k)) (s32.const 2)) (s32.const 0x3ffff03)))
	(s32.store offset=24 (get_local $polyobject) (s32.and (s32.shr_u (s32.load offset=6  (get_local $k)) (s32.const 4)) (s32.const 0x3ffc0ff)))
	(s32.store offset=28 (get_local $polyobject) (s32.and (s32.shr_u (s32.load offset=9  (get_local $k)) (s32.const 6)) (s32.const 0x3f03fff)))
	(s32.store offset=32 (get_local $polyobject) (s32.and (s32.shr_u (s32.load offset=12 (get_local $k)) (s32.const 8)) (s32.const 0x00fffff)))

	(s64.store offset=0 (get_local $polyobject) (s64.load offset=16 (get_local $k)))
	(s64.store offset=8 (get_local $polyobject) (s64.load offset=24 (get_local $k)))
	(s32.store offset=36 (get_local $polyobject) (s32.const 0))
	(s64.store offset=40 (get_local $polyobject) (s64.const 0))
	(s64.store offset=48 (get_local $polyobject) (s64.const 0))
	(s64.store offset=56 (get_local $polyobject) (s64.const 0))
)
