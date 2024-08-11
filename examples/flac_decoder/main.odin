package main

import f "../.."
import "base:runtime"
import "core:fmt"
import "core:path/filepath"
import "core:strings"

clientapp :: struct {
	i: i32,
}
papp :: ^clientapp

error_callback :: proc "c" (decoder: ^f.FLAC__StreamDecoder, status: f.FLAC__StreamDecoderErrorStatus, client_data: rawptr) {
	context = runtime.default_context()
	app := papp(client_data)
	fmt.println(#procedure, status, app)
}

metadata_callback :: proc "c" (decoder: ^f.FLAC__StreamDecoder, metadata: ^f.FLAC__StreamMetadata, client_data: rawptr) {
	context = runtime.default_context()
	app := papp(client_data)
	fmt.println(#procedure, app)
	if metadata != nil {
		fmt.println("type", metadata.type)
		fmt.println("length", metadata.length)
		#partial switch metadata.type {
		case .FLAC__METADATA_TYPE_STREAMINFO:
			fmt.println("stream_info", metadata.data.stream_info)
		case .FLAC__METADATA_TYPE_PADDING:
			fmt.println("padding", metadata.data.padding)
		case .FLAC__METADATA_TYPE_APPLICATION:
			fmt.println("application", metadata.data.application)
		case .FLAC__METADATA_TYPE_SEEKTABLE:
			fmt.println("seek_table", metadata.data.seek_table)
		case .FLAC__METADATA_TYPE_VORBIS_COMMENT:
			fmt.println("vorbis_comment", metadata.data.vorbis_comment)
		case .FLAC__METADATA_TYPE_CUESHEET:
			fmt.println("cue_sheet", metadata.data.cue_sheet)
		case .FLAC__METADATA_TYPE_PICTURE:
			fmt.println("picture", metadata.data.picture)
		case .FLAC__METADATA_TYPE_UNDEFINED:
			fmt.println("unknown", metadata.data.unknown)
		}
	}
}

write_callback :: proc "c" (decoder: ^f.FLAC__StreamDecoder, frame: ^f.FLAC__Frame, buffer: []f.FLAC__int32, client_data: rawptr) -> f.FLAC__StreamDecoderWriteStatus {
	context = runtime.default_context()
	app := papp(client_data)
	fmt.println(#procedure, app)
	{
		header := frame.header
		fmt.println("  [header]")
		fmt.println("    blocksize", header.blocksize)
		fmt.println("    sample_rate", header.sample_rate)
		fmt.println("    channels", header.channels)
		fmt.println("    channel_assignment", header.channel_assignment)
		fmt.println("    bits_per_sample", header.bits_per_sample)
		fmt.println("    crc", header.crc)
		switch header.number_type {
		case .FLAC__FRAME_NUMBER_TYPE_FRAME_NUMBER:
			fmt.println("    frame_number", header.number.frame_number)
		case .FLAC__FRAME_NUMBER_TYPE_SAMPLE_NUMBER:
			fmt.println("    sample_number", header.number.sample_number)
		}
	}

	for i in 0 ..< frame.header.channels {
		subframe := frame.subframes[i]
		fmt.println("  [subframe]", i)
		fmt.println("    type", subframe.type)
		if subframe.wasted_bits > 0 {
			fmt.println("    wasted_bits", subframe.wasted_bits)
		}
		// switch subframe.type {
		// case .FLAC__SUBFRAME_TYPE_CONSTANT:
		// 	fmt.println("  constant", subframe.data.constant)
		// case .FLAC__SUBFRAME_TYPE_FIXED:
		// 	fmt.println("  fixed", subframe.data.fixed)
		// case .FLAC__SUBFRAME_TYPE_LPC:
		// 	fmt.println("  lpc", subframe.data.lpc)
		// case .FLAC__SUBFRAME_TYPE_VERBATIM:
		// 	fmt.println("  verbatim", subframe.data.verbatim)
		// }
	}

	{
		footer := frame.footer
		fmt.println("  [footer]")
		fmt.println("    crc", footer.crc)
	}
	return f.FLAC__StreamDecoderWriteStatus.FLAC__STREAM_DECODER_WRITE_STATUS_CONTINUE
}

main :: proc() {
	decoder := f.FLAC__stream_decoder_new()
	defer f.FLAC__stream_decoder_delete(decoder)

	ok: f.FLAC__bool
	flac_file := strings.clone_to_cstring(filepath.clean("../flac/data/audio/lossless-flac-44khz-16bit-stereo.flac"))
	fmt.println("flac_file:", flac_file)

	fmt.println("version:", f.FLAC__VERSION_STRING)

	fmt.println("state:", f.FLAC__stream_decoder_get_state(decoder))

	app : clientapp = {
		i = 666,
	}

	status := f.FLAC__stream_decoder_init_file(decoder, flac_file, write_callback, metadata_callback, error_callback, &app)
	fmt.println("FLAC__stream_decoder_init_file:", status)

	fmt.println("state:", f.FLAC__stream_decoder_get_state(decoder))

	if status == .FLAC__STREAM_DECODER_INIT_STATUS_OK {
		ok = f.FLAC__stream_decoder_process_until_end_of_stream(decoder)
		fmt.println("FLAC__stream_decoder_process_until_end_of_stream", ok)
	}

	fmt.println("state:", f.FLAC__stream_decoder_get_state(decoder))

	ok = f.FLAC__stream_decoder_finish(decoder)
	fmt.println("FLAC__stream_decoder_finish", ok)

	fmt.println("state:", f.FLAC__stream_decoder_get_state(decoder))

	fmt.println("done.")
}
