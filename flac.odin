package flac

import _c "core:c"

foreign import flac_lib "FLAC.lib"

uint32_t :: _c.uint32_t
size_t :: _c.size_t
int :: _c.int
long :: _c.long
char :: _c.char
FILE :: rawptr

FLAC__int8 :: i8
FLAC__int16 :: i16
FLAC__int32 :: i32
FLAC__int64 :: i64

FLAC__uint8 :: u8
FLAC__uint16 :: u16
FLAC__uint32 :: u32
FLAC__uint64 :: u64

FLAC__bool :: bool
FLAC__byte :: FLAC__uint8

// format

FLAC__MAX_METADATA_TYPE_CODE :: 126
FLAC__MIN_BLOCK_SIZE :: 16
FLAC__MAX_BLOCK_SIZE :: 65535
FLAC__SUBSET_MAX_BLOCK_SIZE_48000HZ :: 4608
FLAC__MAX_CHANNELS :: 8
FLAC__MIN_BITS_PER_SAMPLE :: 4
FLAC__MAX_BITS_PER_SAMPLE :: 32
FLAC__REFERENCE_CODEC_MAX_BITS_PER_SAMPLE :: 32
FLAC__MAX_SAMPLE_RATE :: 1048575
FLAC__MAX_LPC_ORDER :: 32
FLAC__SUBSET_MAX_LPC_ORDER_48000HZ :: 12
FLAC__MIN_QLP_COEFF_PRECISION :: 5
FLAC__MAX_QLP_COEFF_PRECISION :: 15
FLAC__MAX_FIXED_ORDER :: 4
FLAC__MAX_RICE_PARTITION_ORDER :: 15
FLAC__SUBSET_MAX_RICE_PARTITION_ORDER :: 8


FLAC__EntropyCodingMethodType :: enum {
	/**< Residual is coded by partitioning into contexts, each with it's own
	* 4-bit Rice parameter. */
	FLAC__ENTROPY_CODING_METHOD_PARTITIONED_RICE  = 0,

	/**< Residual is coded by partitioning into contexts, each with it's own
	* 5-bit Rice parameter. */
	FLAC__ENTROPY_CODING_METHOD_PARTITIONED_RICE2 = 1,
}
FLAC__EntropyCodingMethod_PartitionedRiceContents :: struct {
	/**< The Rice parameters for each context. */
	parameters:        ^uint32_t,

	/**< Widths for escape-coded partitions.  Will be non-zero for escaped
	* partitions and zero for unescaped partitions.
	*/
	raw_bits:          ^uint32_t,

	/**< The capacity of the \a parameters and \a raw_bits arrays
	* specified as an order, i.e. the number of array elements
	* allocated is 2 ^ \a capacity_by_order.
	*/
	capacity_by_order: uint32_t,
}
FLAC__EntropyCodingMethod_PartitionedRice :: struct {
	/**< The partition order, i.e. # of contexts = 2 ^ \a order. */
	order:    uint32_t,

	/**< The context's Rice parameters and/or raw bits. */
	contents: ^FLAC__EntropyCodingMethod_PartitionedRiceContents,
}

FLAC__EntropyCodingMethod :: struct {
	type: FLAC__EntropyCodingMethodType,
	data: struct #raw_union {
		partitioned_rice: FLAC__EntropyCodingMethod_PartitionedRice,
	},
}

FLAC__SubframeType :: enum {
	FLAC__SUBFRAME_TYPE_CONSTANT = 0, /**< constant signal */
	FLAC__SUBFRAME_TYPE_VERBATIM = 1, /**< uncompressed signal */
	FLAC__SUBFRAME_TYPE_FIXED    = 2, /**< fixed polynomial prediction */
	FLAC__SUBFRAME_TYPE_LPC      = 3, /**< linear prediction */
}
FLAC__Subframe_Constant :: struct {
	value: FLAC__int64, /**< The constant signal value. */
}
FLAC__VerbatimSubframeDataType :: enum {
	FLAC__VERBATIM_SUBFRAME_DATA_TYPE_INT32, /**< verbatim subframe has 32-bit int */
	FLAC__VERBATIM_SUBFRAME_DATA_TYPE_INT64, /**< verbatim subframe has 64-bit int */
}


FLAC__Subframe_Verbatim :: struct {
	data:      struct #raw_union {
		int32: ^FLAC__int32, /**< A FLAC__int32 pointer to verbatim signal. */
		int64: ^FLAC__int64, /**< A FLAC__int64 pointer to verbatim signal. */
	},
	data_type: FLAC__VerbatimSubframeDataType,
}

FLAC__Subframe_Fixed :: struct {
	/**< The residual coding method. */
	entropy_coding_method: FLAC__EntropyCodingMethod,

	/**< The polynomial order. */
	order:                 uint32_t,

	/**< Warmup samples to prime the predictor, length == order. */
	warmup:                [FLAC__MAX_FIXED_ORDER]FLAC__int64,
	residual:              ^FLAC__int32,
}
FLAC__Subframe_LPC :: struct {
	/**< The residual coding method. */
	entropy_coding_method: FLAC__EntropyCodingMethod,

	/**< The FIR order. */
	order:                 uint32_t,

	/**< Quantized FIR filter coefficient precision in bits. */
	qlp_coeff_precision:   uint32_t,

	/**< The qlp coeff shift needed. */
	quantization_level:    int,

	/**< FIR filter coefficients. */
	qlp_coeff:             [FLAC__MAX_LPC_ORDER]FLAC__int32,

	/**< Warmup samples to prime the predictor, length == order. */
	warmup:                [FLAC__MAX_LPC_ORDER]FLAC__int64,
	residual:              ^FLAC__int32,
}

FLAC__Subframe :: struct {
	type:        FLAC__SubframeType,
	data:        struct #raw_union {
		constant: FLAC__Subframe_Constant,
		fixed:    FLAC__Subframe_Fixed,
		lpc:      FLAC__Subframe_LPC,
		verbatim: FLAC__Subframe_Verbatim,
	},
	wasted_bits: uint32_t,
}

FLAC__ChannelAssignment :: enum {
	FLAC__CHANNEL_ASSIGNMENT_INDEPENDENT = 0, /**< independent channels */
	FLAC__CHANNEL_ASSIGNMENT_LEFT_SIDE   = 1, /**< left+side stereo */
	FLAC__CHANNEL_ASSIGNMENT_RIGHT_SIDE  = 2, /**< right+side stereo */
	FLAC__CHANNEL_ASSIGNMENT_MID_SIDE    = 3, /**< mid+side stereo */
}
FLAC__FrameNumberType :: enum {
	FLAC__FRAME_NUMBER_TYPE_FRAME_NUMBER, /**< number contains the frame number */
	FLAC__FRAME_NUMBER_TYPE_SAMPLE_NUMBER, /**< number contains the sample number of first sample in frame */
}

FLAC__FrameHeader :: struct {
	/**< The number of samples per subframe. */
	blocksize:          uint32_t,
	/**< The sample rate in Hz. */
	sample_rate:        uint32_t,
	/**< The number of channels (== number of subframes). */
	channels:           uint32_t,
	/**< The channel assignment for the frame. */
	channel_assignment: FLAC__ChannelAssignment,
	/**< The sample resolution. */
	bits_per_sample:    uint32_t,
	/**< The numbering scheme used for the frame.  As a convenience, the
	* decoder will always convert a frame number to a sample number because
	* the rules are complex. */
	number_type:        FLAC__FrameNumberType,
	/**< The frame number or sample number of first sample in frame;
	 * use the \a number_type value to determine which to use. */
	number:             struct #raw_union {
		frame_number:  FLAC__uint32,
		sample_number: FLAC__uint64,
	},
	/**< CRC-8 (polynomial = x^8 + x^2 + x^1 + x^0, initialized with 0)
	* of the raw frame header bytes, meaning everything before the CRC byte
	* including the sync code.
	*/
	crc:                FLAC__uint8,
}

FLAC__FrameFooter :: struct {
	crc: FLAC__uint16,
}

FLAC__Frame :: struct {
	header:    FLAC__FrameHeader,
	subframes: [FLAC__MAX_CHANNELS]FLAC__Subframe,
	footer:    FLAC__FrameFooter,
}

FLAC__MetadataType :: enum {
	/**< <A HREF="https://xiph.org/flac/format.html#metadata_block_streaminfo">STREAMINFO</A> block */
	FLAC__METADATA_TYPE_STREAMINFO     = 0,

	/**< <A HREF="https://xiph.org/flac/format.html#metadata_block_padding">PADDING</A> block */
	FLAC__METADATA_TYPE_PADDING        = 1,

	/**< <A HREF="https://xiph.org/flac/format.html#metadata_block_application">APPLICATION</A> block */
	FLAC__METADATA_TYPE_APPLICATION    = 2,

	/**< <A HREF="https://xiph.org/flac/format.html#metadata_block_seektable">SEEKTABLE</A> block */
	FLAC__METADATA_TYPE_SEEKTABLE      = 3,

	/**< <A HREF="https://xiph.org/flac/format.html#metadata_block_vorbis_comment">VORBISCOMMENT</A> block (a.k.a. FLAC tags) */
	FLAC__METADATA_TYPE_VORBIS_COMMENT = 4,

	/**< <A HREF="https://xiph.org/flac/format.html#metadata_block_cuesheet">CUESHEET</A> block */
	FLAC__METADATA_TYPE_CUESHEET       = 5,

	/**< <A HREF="https://xiph.org/flac/format.html#metadata_block_picture">PICTURE</A> block */
	FLAC__METADATA_TYPE_PICTURE        = 6,

	/**< marker to denote beginning of undefined type range; this number will increase as new metadata types are added */
	FLAC__METADATA_TYPE_UNDEFINED      = 7,

	/**< No type will ever be greater than this. There is not enough room in the protocol block. */
	FLAC__MAX_METADATA_TYPE            = FLAC__MAX_METADATA_TYPE_CODE,
}


FLAC__StreamMetadata_StreamInfo :: struct {
	min_blocksize, max_blocksize: uint32_t,
	min_framesize, max_framesize: uint32_t,
	sample_rate:                  uint32_t,
	channels:                     uint32_t,
	bits_per_sample:              uint32_t,
	total_samples:                FLAC__uint64,
	md5sum:                       [16]FLAC__byte,
}

FLAC__StreamMetadata_Padding :: struct {
	/**< Conceptually this is an empty struct since we don't store the
	 * padding bytes.  Empty structs are not allowed by some C compilers,
	 * hence the dummy.
	 */
	_: int,
}

FLAC__StreamMetadata_Application :: struct {
	id:   [4]FLAC__byte,
	data: ^FLAC__byte,
}

FLAC__StreamMetadata_SeekPoint :: struct {
	/**<  The sample number of the target frame. */
	sample_number: FLAC__uint64,

	/**< The offset, in bytes, of the target frame with respect to
	* beginning of the first frame. */
	stream_offset: FLAC__uint64,

	/**< The number of samples in the target frame. */
	frame_samples: uint32_t,
}

FLAC__StreamMetadata_SeekTable :: struct {
	num_points: uint32_t,
	points:     ^FLAC__StreamMetadata_SeekPoint,
}
FLAC__StreamMetadata_VorbisComment_Entry :: struct {
	length: FLAC__uint32,
	entry:  ^FLAC__byte,
}
FLAC__StreamMetadata_VorbisComment :: struct {
	vendor_string: FLAC__StreamMetadata_VorbisComment_Entry,
	num_comments:  FLAC__uint32,
	comments:      ^FLAC__StreamMetadata_VorbisComment_Entry,
}
FLAC__StreamMetadata_CueSheet_Index :: struct {
	/**< Offset in samples, relative to the track offset, of the index
	* point.
	*/
	offset: FLAC__uint64,

	/**< The index point number. */
	number: FLAC__byte,
}
FLAC__StreamMetadata_CueSheet_Track :: struct {
	/**< Track offset in samples, relative to the beginning of the FLAC audio stream. */
	offset:       FLAC__uint64,

	/**< The track number. */
	number:       FLAC__byte,

	/**< Track ISRC.  This is a 12-digit alphanumeric code plus a trailing \c NUL byte */
	isrc:         [13]char,

	/**< The track type: 0 for audio, 1 for non-audio. */
	type:         uint32_t,

	/**< The pre-emphasis flag: 0 for no pre-emphasis, 1 for pre-emphasis. */
	pre_emphasis: uint32_t,

	/**< The number of track index points. */
	num_indices:  FLAC__byte,

	/**< NULL if num_indices == 0, else pointer to array of index points. */
	indices:      ^FLAC__StreamMetadata_CueSheet_Index,
}
FLAC__StreamMetadata_CueSheet :: struct {
	/**< Media catalog number, in ASCII printable characters 0x20-0x7e.  In
	* general, the media catalog number may be 0 to 128 bytes long; any
	* unused characters should be right-padded with NUL characters.
	*/
	media_catalog_number: [129]char,

	/**< The number of lead-in samples. */
	lead_in:              FLAC__uint64,

	/**< \c true if CUESHEET corresponds to a Compact Disc, else \c false. */
	is_cd:                FLAC__bool,

	/**< The number of tracks. */
	num_tracks:           uint32_t,

	/**< NULL if num_tracks == 0, else pointer to array of tracks. */
	tracks:               ^FLAC__StreamMetadata_CueSheet_Track,
}
// FLAC__STREAM_METADATA_PICTURE_TYPE
FLAC__StreamMetadata_Picture_Type :: enum {
	OTHER = 0, /**< Other */
	FILE_ICON_STANDARD = 1, /**< 32x32 pixels 'file icon' (PNG only) */
	FILE_ICON = 2, /**< Other file icon */
	FRONT_COVER = 3, /**< Cover (front) */
	BACK_COVER = 4, /**< Cover (back) */
	LEAFLET_PAGE = 5, /**< Leaflet page */
	MEDIA = 6, /**< Media (e.g. label side of CD) */
	LEAD_ARTIST = 7, /**< Lead artist/lead performer/soloist */
	ARTIST = 8, /**< Artist/performer */
	CONDUCTOR = 9, /**< Conductor */
	BAND = 10, /**< Band/Orchestra */
	COMPOSER = 11, /**< Composer */
	LYRICIST = 12, /**< Lyricist/text writer */
	RECORDING_LOCATION = 13, /**< Recording Location */
	DURING_RECORDING = 14, /**< During recording */
	DURING_PERFORMANCE = 15, /**< During performance */
	VIDEO_SCREEN_CAPTURE = 16, /**< Movie/video screen capture */
	FISH = 17, /**< A bright coloured fish */
	ILLUSTRATION = 18, /**< Illustration */
	BAND_LOGOTYPE = 19, /**< Band/artist logotype */
	PUBLISHER_LOGOTYPE = 20, /**< Publisher/Studio logotype */
	UNDEFINED,
}
FLAC__StreamMetadata_Picture :: struct {
	/**< The kind of picture stored. */
	type:        FLAC__StreamMetadata_Picture_Type,

	/**< Picture data's MIME type, in ASCII printable characters
	* 0x20-0x7e, NUL terminated.  For best compatibility with players,
	* use picture data of MIME type \c image/jpeg or \c image/png.  A
	* MIME type of '-->' is also allowed, in which case the picture
	* data should be a complete URL.  In file storage, the MIME type is
	* stored as a 32-bit length followed by the ASCII string with no NUL
	* terminator, but is converted to a plain C string in this structure
	* for convenience.
	*/
	mime_type:   ^char,

	/**< Picture's description in UTF-8, NUL terminated.  In file storage,
	* the description is stored as a 32-bit length followed by the UTF-8
	* string with no NUL terminator, but is converted to a plain C string
	* in this structure for convenience.
	*/
	description: ^FLAC__byte,

	/**< Picture's width in pixels. */
	width:       FLAC__uint32,

	/**< Picture's height in pixels. */
	height:      FLAC__uint32,

	/**< Picture's color depth in bits-per-pixel. */
	depth:       FLAC__uint32,

	/**< For indexed palettes (like GIF), picture's number of colors (the
	* number of palette entries), or \c 0 for non-indexed (i.e. 2^depth).
	*/
	colors:      FLAC__uint32,

	/**< Length of binary picture data in bytes. */
	data_length: FLAC__uint32,

	/**< Binary picture data. */
	data:        ^FLAC__byte,
}
FLAC__StreamMetadata_Unknown :: struct {
	data: ^FLAC__byte,
}

FLAC__StreamMetadata :: struct {
	/**< The type of the metadata block; used determine which member of the
	* \a data union to dereference.  If type >= FLAC__METADATA_TYPE_UNDEFINED
	* then \a data.unknown must be used. */
	type:    FLAC__MetadataType,

	/**< \c true if this metadata block is the last, else \a false */
	is_last: FLAC__bool,

	/**< Length, in bytes, of the block data as it appears in the stream. */
	length:  uint32_t,
	data:    struct #raw_union {
		stream_info:    FLAC__StreamMetadata_StreamInfo,
		padding:        FLAC__StreamMetadata_Padding,
		application:    FLAC__StreamMetadata_Application,
		seek_table:     FLAC__StreamMetadata_SeekTable,
		vorbis_comment: FLAC__StreamMetadata_VorbisComment,
		cue_sheet:      FLAC__StreamMetadata_CueSheet,
		picture:        FLAC__StreamMetadata_Picture,
		unknown:        FLAC__StreamMetadata_Unknown,
	},
}

//typedef FLAC__StreamDecoderReadStatus (*FLAC__StreamDecoderReadCallback)(const FLAC__StreamDecoder *decoder, FLAC__byte buffer[], size_t *bytes, void *client_data);
FLAC__StreamDecoderReadCallback :: #type proc "c" (decoder: ^FLAC__StreamDecoder, buffer: []FLAC__byte, bytes: ^size_t, client_data: rawptr) -> FLAC__StreamDecoderReadStatus
//typedef FLAC__StreamDecoderSeekStatus (*FLAC__StreamDecoderSeekCallback)(const FLAC__StreamDecoder *decoder, FLAC__uint64 absolute_byte_offset, void *client_data);
FLAC__StreamDecoderSeekCallback :: #type proc "c" (decoder: ^FLAC__StreamDecoder, absolute_byte_offset: FLAC__uint64, client_data: rawptr) -> FLAC__StreamDecoderSeekStatus
//typedef FLAC__StreamDecoderTellStatus (*FLAC__StreamDecoderTellCallback)(const FLAC__StreamDecoder *decoder, FLAC__uint64 *absolute_byte_offset, void *client_data);
FLAC__StreamDecoderTellCallback :: #type proc "c" (decoder: ^FLAC__StreamDecoder, absolute_byte_offset: FLAC__uint64, client_data: rawptr) -> FLAC__StreamDecoderTellStatus
//typedef FLAC__StreamDecoderLengthStatus (*FLAC__StreamDecoderLengthCallback)(const FLAC__StreamDecoder *decoder, FLAC__uint64 *stream_length, void *client_data);
FLAC__StreamDecoderLengthCallback :: #type proc "c" (decoder: ^FLAC__StreamDecoder, stream_length: FLAC__uint64, client_data: rawptr) -> FLAC__StreamDecoderLengthStatus
//typedef FLAC__bool (*FLAC__StreamDecoderEofCallback)(const FLAC__StreamDecoder *decoder, void *client_data);
FLAC__StreamDecoderEofCallback :: #type proc "c" (decoder: ^FLAC__StreamDecoder, client_data: rawptr) -> FLAC__bool
//typedef FLAC__StreamDecoderWriteStatus (*FLAC__StreamDecoderWriteCallback)(const FLAC__StreamDecoder *decoder, const FLAC__Frame *frame, const FLAC__int32 * const buffer[], void *client_data);
FLAC__StreamDecoderWriteCallback :: #type proc "c" (decoder: ^FLAC__StreamDecoder, frame: ^FLAC__Frame, buffer: []FLAC__int32, client_data: rawptr) -> FLAC__StreamDecoderWriteStatus
//typedef void (*FLAC__StreamDecoderMetadataCallback)(const FLAC__StreamDecoder *decoder, const FLAC__StreamMetadata *metadata, void *client_data);
FLAC__StreamDecoderMetadataCallback :: #type proc "c" (decoder: ^FLAC__StreamDecoder, metadata: ^FLAC__StreamMetadata, client_data: rawptr)
//typedef void (*FLAC__StreamDecoderErrorCallback)(const FLAC__StreamDecoder *decoder, FLAC__StreamDecoderErrorStatus status, void *client_data);
FLAC__StreamDecoderErrorCallback :: #type proc "c" (decoder: ^FLAC__StreamDecoder, status: FLAC__StreamDecoderErrorStatus, client_data: rawptr)

@(default_calling_convention = "c")
foreign flac_lib {
	//@(link_name="FLAC__VERSION_STRING")
	FLAC__VERSION_STRING: cstring
	FLAC__VENDOR_STRING: cstring

	FLAC__stream_decoder_new :: proc() -> ^FLAC__StreamDecoder ---
	FLAC__stream_decoder_delete :: proc(decoder: ^FLAC__StreamDecoder) ---

	FLAC__stream_decoder_set_ogg_serial_number :: proc(decoder: ^FLAC__StreamDecoder, serial_number: long) -> FLAC__bool ---
	FLAC__stream_decoder_set_md5_checking :: proc(decoder: ^FLAC__StreamDecoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_decoder_set_metadata_respond :: proc(decoder: ^FLAC__StreamDecoder, type: FLAC__MetadataType) -> FLAC__bool ---
	FLAC__stream_decoder_set_metadata_respond_application :: proc(decoder: ^FLAC__StreamDecoder, id: [4]FLAC__byte) -> FLAC__bool ---
	FLAC__stream_decoder_set_metadata_respond_all :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_set_metadata_ignore :: proc(decoder: ^FLAC__StreamDecoder, type: FLAC__MetadataType) -> FLAC__bool ---
	FLAC__stream_decoder_set_metadata_ignore_application :: proc(decoder: ^FLAC__StreamDecoder, id: [4]FLAC__byte) -> FLAC__bool ---
	FLAC__stream_decoder_set_metadata_ignore_all :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_get_state :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__StreamDecoderState ---
	FLAC__stream_decoder_get_resolved_state_string :: proc(decoder: ^FLAC__StreamDecoder) -> cstring ---
	FLAC__stream_decoder_get_md5_checking :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_get_total_samples :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__uint64 ---
	FLAC__stream_decoder_get_channels :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__uint32 ---
	FLAC__stream_decoder_get_channel_assignment :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__ChannelAssignment ---
	FLAC__stream_decoder_get_bits_per_sample :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__uint32 ---
	FLAC__stream_decoder_get_sample_rate :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__uint32 ---
	FLAC__stream_decoder_get_blocksize :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__uint32 ---
	FLAC__stream_decoder_get_decode_position :: proc(decoder: ^FLAC__StreamDecoder, position: ^FLAC__uint64) -> FLAC__bool ---
	FLAC__stream_decoder_get_client_data :: proc(decoder: ^FLAC__StreamDecoder) -> rawptr ---

	FLAC__stream_decoder_init_stream :: proc(decoder: ^FLAC__StreamDecoder, read_callback: FLAC__StreamDecoderReadCallback, seek_callback: FLAC__StreamDecoderSeekCallback, tell_callback: FLAC__StreamDecoderTellCallback, length_callback: FLAC__StreamDecoderLengthCallback, eof_callback: FLAC__StreamDecoderEofCallback, write_callback: FLAC__StreamDecoderWriteCallback, metadata_callback: FLAC__StreamDecoderMetadataCallback, error_callback: FLAC__StreamDecoderErrorCallback, client_data: rawptr) -> FLAC__StreamDecoderInitStatus ---

	FLAC__stream_decoder_init_FILE :: proc(decoder: ^FLAC__StreamDecoder, file: FILE, write_callback: FLAC__StreamDecoderWriteCallback, metadata_callback: FLAC__StreamDecoderMetadataCallback, error_callback: FLAC__StreamDecoderErrorCallback) -> FLAC__StreamDecoderInitStatus ---

	FLAC__stream_encoder_new :: proc() -> ^FLAC__StreamEncoder ---
	FLAC__stream_encoder_delete :: proc(encoder: ^FLAC__StreamEncoder) ---
}
