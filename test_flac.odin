package flac

//import "core:bytes"
//import "core:fmt"
//import "core:runtime"
import _t "core:testing"
import _u "shared:ounit"

@(test)
verify_sizes :: proc(t: ^_t.T) {
	_u.expect_size(t, FLAC__int8, 1)
	_u.expect_size(t, FLAC__int16, 2)
	_u.expect_size(t, FLAC__int32, 4)
	_u.expect_size(t, FLAC__int64, 8)
	_u.expect_size(t, FLAC__uint8, 1)
	_u.expect_size(t, FLAC__uint16, 2)
	_u.expect_size(t, FLAC__uint32, 4)
	_u.expect_size(t, FLAC__uint64, 8)
	_u.expect_size(t, FLAC__bool, 1)
	_u.expect_size(t, FLAC__byte, 1)
}

@(test)
verify_struct_sizes :: proc(t: ^_t.T) {
	_u.expect_size(t, FLAC__StreamMetadata_StreamInfo, 56)

}

@(test)
const_strings :: proc(t: ^_t.T) {
	_t.expectf(t, FLAC__VERSION_STRING == "git-7f7da558 20240226", "version=%s", FLAC__VERSION_STRING)
}

@(test)
can_construct_decoder :: proc(t: ^_t.T) {
	decoder := FLAC__stream_decoder_new()
	defer FLAC__stream_decoder_delete(decoder)

	_t.expect(t, decoder != nil)
}

@(test)
stream_decoder_get_state :: proc(t: ^_t.T) {
	decoder := FLAC__stream_decoder_new()
	defer FLAC__stream_decoder_delete(decoder)
	_t.expect(t, decoder != nil)
	state := FLAC__stream_decoder_get_state(decoder)
	//fmt.printf("%v\n", state)
	_t.expect(t, state == .FLAC__STREAM_DECODER_UNINITIALIZED)
}

@(test)
stream_decoder_get_resolved_state_string :: proc(t: ^_t.T) {
	decoder := FLAC__stream_decoder_new()
	defer FLAC__stream_decoder_delete(decoder)
	_t.expect(t, decoder != nil)
	state := FLAC__stream_decoder_get_resolved_state_string(decoder)
	//fmt.printf("%v\n", state)
	_t.expect(t, state == "FLAC__STREAM_DECODER_UNINITIALIZED")
}

@(test)
stream_decoder_get_md5_checking :: proc(t: ^_t.T) {
	decoder := FLAC__stream_decoder_new()
	defer FLAC__stream_decoder_delete(decoder)
	_t.expect(t, decoder != nil)
	state := FLAC__stream_decoder_get_md5_checking(decoder)
	//fmt.printf("%v\n", state)
	_t.expect(t, state == false)
}

@(test)
can_construct_encoder :: proc(t: ^_t.T) {
	decoder := FLAC__stream_encoder_new()
	defer FLAC__stream_encoder_delete(decoder)

	_t.expect(t, decoder != nil)
}
