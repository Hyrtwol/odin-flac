package test_flac

import _t "core:testing"
import _u "shared:ounit"
import f ".."

@(test)
verify_sizes :: proc(t: ^_t.T) {
	_u.expect_size(t, f.FLAC__int8, 1)
	_u.expect_size(t, f.FLAC__int16, 2)
	_u.expect_size(t, f.FLAC__int32, 4)
	_u.expect_size(t, f.FLAC__int64, 8)
	_u.expect_size(t, f.FLAC__uint8, 1)
	_u.expect_size(t, f.FLAC__uint16, 2)
	_u.expect_size(t, f.FLAC__uint32, 4)
	_u.expect_size(t, f.FLAC__uint64, 8)
	_u.expect_size(t, f.FLAC__bool, 1)
	_u.expect_size(t, f.FLAC__byte, 1)
}

@(test)
verify_struct_sizes :: proc(t: ^_t.T) {
	_u.expect_size(t, f.FLAC__StreamMetadata_StreamInfo, 56)

}

@(test)
const_strings :: proc(t: ^_t.T) {
	_t.expectf(t, f.FLAC__VERSION_STRING == "git-7f7da558 20240226", "version=%s", f.FLAC__VERSION_STRING)
}

@(test)
can_construct_decoder :: proc(t: ^_t.T) {
	decoder := f.FLAC__stream_decoder_new()
	defer f.FLAC__stream_decoder_delete(decoder)

	_t.expect(t, decoder != nil)
}

@(test)
stream_decoder_get_state :: proc(t: ^_t.T) {
	decoder := f.FLAC__stream_decoder_new()
	defer f.FLAC__stream_decoder_delete(decoder)
	_t.expect(t, decoder != nil)
	state := f.FLAC__stream_decoder_get_state(decoder)
	//fmt.printf("%v\n", state)
	_t.expect(t, state == .FLAC__STREAM_DECODER_UNINITIALIZED)
}

@(test)
stream_decoder_get_resolved_state_string :: proc(t: ^_t.T) {
	decoder := f.FLAC__stream_decoder_new()
	defer f.FLAC__stream_decoder_delete(decoder)
	_t.expect(t, decoder != nil)
	state := f.FLAC__stream_decoder_get_resolved_state_string(decoder)
	//fmt.printf("%v\n", state)
	_t.expect(t, state == "FLAC__STREAM_DECODER_UNINITIALIZED")
}

@(test)
stream_decoder_get_md5_checking :: proc(t: ^_t.T) {
	decoder := f.FLAC__stream_decoder_new()
	defer f.FLAC__stream_decoder_delete(decoder)
	_t.expect(t, decoder != nil)
	state := f.FLAC__stream_decoder_get_md5_checking(decoder)
	//fmt.printf("%v\n", state)
	_t.expect(t, state == false)
}

@(test)
can_construct_encoder :: proc(t: ^_t.T) {
	decoder := f.FLAC__stream_encoder_new()
	defer f.FLAC__stream_encoder_delete(decoder)

	_t.expect(t, decoder != nil)
}
