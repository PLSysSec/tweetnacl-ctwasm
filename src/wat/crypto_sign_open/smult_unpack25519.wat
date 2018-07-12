;; Author: Torsten Stüber

;; output pointer $o: 16 i64 = 128 bytes
;; input pointer $n: 32 bytes
(func $unpack25519 (export "unpack25519") untrusted
	(param $o i32)
	(param $n i32)

	(s64.store offset=0   (get_local $o) (s64.load16_u offset=0  (get_local $n)))
	(s64.store offset=8   (get_local $o) (s64.load16_u offset=2  (get_local $n)))
	(s64.store offset=16  (get_local $o) (s64.load16_u offset=4  (get_local $n)))
	(s64.store offset=24  (get_local $o) (s64.load16_u offset=6  (get_local $n)))
	(s64.store offset=32  (get_local $o) (s64.load16_u offset=8  (get_local $n)))
	(s64.store offset=40  (get_local $o) (s64.load16_u offset=10 (get_local $n)))
	(s64.store offset=48  (get_local $o) (s64.load16_u offset=12 (get_local $n)))
	(s64.store offset=56  (get_local $o) (s64.load16_u offset=14 (get_local $n)))
	(s64.store offset=64  (get_local $o) (s64.load16_u offset=16 (get_local $n)))
	(s64.store offset=72  (get_local $o) (s64.load16_u offset=18 (get_local $n)))
	(s64.store offset=80  (get_local $o) (s64.load16_u offset=20 (get_local $n)))
	(s64.store offset=88  (get_local $o) (s64.load16_u offset=22 (get_local $n)))
	(s64.store offset=96  (get_local $o) (s64.load16_u offset=24 (get_local $n)))
	(s64.store offset=104 (get_local $o) (s64.load16_u offset=26 (get_local $n)))
	(s64.store offset=112 (get_local $o) (s64.load16_u offset=28 (get_local $n)))
	(s64.store offset=120 (get_local $o) (s64.and (s64.load16_u offset=30 (get_local $n)) (s64.const 0x7fff)))
)