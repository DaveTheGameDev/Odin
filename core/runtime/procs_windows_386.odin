package runtime

foreign import kernel32 "system:Kernel32.lib"

@private
@(link_name="_tls_index")
_tls_index: u32;

@private
@(link_name="_fltused")
_fltused: i32 = 0x9875;

@(link_name="memcpy")
memcpy :: proc "c" (dst, src: rawptr, len: int) -> rawptr {
	foreign kernel32 {
		RtlCopyMemory :: proc "c" (dst, src: rawptr, len: int) ---
	}
	if dst == nil || src == nil || len == 0 {
		return dst;
	}
	RtlCopyMemory(dst, src, len);
	return dst;
}

@(link_name="memmove")
memmove :: proc "c" (dst, src: rawptr, len: int) -> rawptr {
	foreign kernel32 {
		RtlMoveMemory :: proc "c" (dst, src: rawptr, len: int) ---
	}
	if dst == nil || src == nil || len == 0 {
		return dst;
	}
	RtlMoveMemory(dst, src, len);
	return dst;
}

@(link_name="memset")
memset :: proc "c" (ptr: rawptr, val: i32, len: int) -> rawptr {
	if ptr == nil || len == 0 {
		return ptr;
	}
	d := uintptr(ptr);
	b := byte(val);
	for i in 0..<uintptr(len) {
		(^byte)(d+i)^ = b;
	}
	return ptr;
}

// @(link_name="memcmp")
// memcmp :: proc "c" (dst, src: rawptr, len: int) -> i32 {
// 	if dst == nil || src == nil {
// 		return 0;
// 	}
// 	if dst == src {
// 		return 0;
// 	}
// 	d, s := uintptr(dst), uintptr(src);
// 	n := uintptr(len);

// 	for i := uintptr(0); i < n; i += 1 {
// 		x, y := (^byte)(d+i)^, (^byte)(s+i)^;
// 		if x != y {
// 			return x < y ? -1 : +1;
// 		}
// 	}
// 	return 0;
// }
