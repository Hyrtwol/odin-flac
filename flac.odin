package flac

import "core:c/libc"

foreign import flac_lib "FLAC.lib"

uint32_t :: libc.uint32_t
size_t :: libc.size_t
int :: libc.int
long :: libc.long
char :: libc.char
FILE :: libc.FILE

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

/** The largest legal metadata type code. */
FLAC__MAX_METADATA_TYPE_CODE :: 126
/** The minimum block size, in samples, permitted by the format. */
FLAC__MIN_BLOCK_SIZE :: 16
/** The maximum block size, in samples, permitted by the format. */
FLAC__MAX_BLOCK_SIZE :: 65535
/** The maximum block size, in samples, permitted by the FLAC subset for
 *  sample rates up to 48kHz. */
FLAC__SUBSET_MAX_BLOCK_SIZE_48000HZ :: 4608
/** The maximum number of channels permitted by the format. */
FLAC__MAX_CHANNELS :: 8
/** The minimum sample resolution permitted by the format. */
FLAC__MIN_BITS_PER_SAMPLE :: 4
/** The maximum sample resolution permitted by the format. */
FLAC__MAX_BITS_PER_SAMPLE :: 32
/** The maximum sample resolution permitted by libFLAC.
 *
 * FLAC__MAX_BITS_PER_SAMPLE is the limit of the FLAC format.  However,
 * the reference encoder/decoder used to be limited to 24 bits. This
 * value was used to signal that limit.
 */
FLAC__REFERENCE_CODEC_MAX_BITS_PER_SAMPLE :: 32
/** The maximum sample rate permitted by the format.  The value is
 *  ((2 ^ 20) - 1)
 */
FLAC__MAX_SAMPLE_RATE :: 1048575
/** The maximum LPC order permitted by the format. */
FLAC__MAX_LPC_ORDER :: 32
/** The maximum LPC order permitted by the FLAC subset for sample rates
 *  up to 48kHz. */
FLAC__SUBSET_MAX_LPC_ORDER_48000HZ :: 12
/** The minimum quantized linear predictor coefficient precision
 *  permitted by the format.
 */
FLAC__MIN_QLP_COEFF_PRECISION :: 5
/** The maximum quantized linear predictor coefficient precision
 *  permitted by the format.
 */
FLAC__MAX_QLP_COEFF_PRECISION :: 15
/** The maximum order of the fixed predictors permitted by the format. */
FLAC__MAX_FIXED_ORDER :: 4
/** The maximum Rice partition order permitted by the format. */
FLAC__MAX_RICE_PARTITION_ORDER :: 15
/** The maximum Rice partition order permitted by the FLAC Subset. */
FLAC__SUBSET_MAX_RICE_PARTITION_ORDER :: 8

/** An enumeration of the available entropy coding methods. */
FLAC__EntropyCodingMethodType :: enum uint32_t {
	/**< Residual is coded by partitioning into contexts, each with it's own
	* 4-bit Rice parameter. */
	FLAC__ENTROPY_CODING_METHOD_PARTITIONED_RICE  = 0,

	/**< Residual is coded by partitioning into contexts, each with it's own
	* 5-bit Rice parameter. */
	FLAC__ENTROPY_CODING_METHOD_PARTITIONED_RICE2 = 1,
}

/** Contents of a Rice partitioned residual
 */
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

/** Header for a Rice partitioned residual.  (c.f. <A HREF="https://xiph.org/flac/format.html#partitioned_rice">format specification</A>)
 */
FLAC__EntropyCodingMethod_PartitionedRice :: struct {
	/**< The partition order, i.e. # of contexts = 2 ^ \a order. */
	order:    uint32_t,

	/**< The context's Rice parameters and/or raw bits. */
	contents: ^FLAC__EntropyCodingMethod_PartitionedRiceContents,
}

/** Header for the entropy coding method.  (c.f. <A HREF="https://xiph.org/flac/format.html#residual">format specification</A>)
 */
FLAC__EntropyCodingMethod :: struct {
	type: FLAC__EntropyCodingMethodType,
	data: struct #raw_union {
		partitioned_rice: FLAC__EntropyCodingMethod_PartitionedRice,
	},
}

/** An enumeration of the available subframe types. */
FLAC__SubframeType :: enum uint32_t {
	FLAC__SUBFRAME_TYPE_CONSTANT = 0, /**< constant signal */
	FLAC__SUBFRAME_TYPE_VERBATIM = 1, /**< uncompressed signal */
	FLAC__SUBFRAME_TYPE_FIXED    = 2, /**< fixed polynomial prediction */
	FLAC__SUBFRAME_TYPE_LPC      = 3, /**< linear prediction */
}

/** CONSTANT subframe.  (c.f. <A HREF="https://xiph.org/flac/format.html#subframe_constant">format specification</A>)
 */
FLAC__Subframe_Constant :: struct {
	value: FLAC__int64, /**< The constant signal value. */
}

/** An enumeration of the possible verbatim subframe data types. */
FLAC__VerbatimSubframeDataType :: enum uint32_t {
	FLAC__VERBATIM_SUBFRAME_DATA_TYPE_INT32, /**< verbatim subframe has 32-bit int */
	FLAC__VERBATIM_SUBFRAME_DATA_TYPE_INT64, /**< verbatim subframe has 64-bit int */
}

/** VERBATIM subframe.  (c.f. <A HREF="https://xiph.org/flac/format.html#subframe_verbatim">format specification</A>)
 */
FLAC__Subframe_Verbatim :: struct {
	data:      struct #raw_union {
		int32: ^FLAC__int32, /**< A FLAC__int32 pointer to verbatim signal. */
		int64: ^FLAC__int64, /**< A FLAC__int64 pointer to verbatim signal. */
	},
	data_type: FLAC__VerbatimSubframeDataType,
}

/** FIXED subframe.  (c.f. <A HREF="https://xiph.org/flac/format.html#subframe_fixed">format specification</A>)
 */
FLAC__Subframe_Fixed :: struct {
	/**< The residual coding method. */
	entropy_coding_method: FLAC__EntropyCodingMethod,

	/**< The polynomial order. */
	order:                 uint32_t,

	/**< Warmup samples to prime the predictor, length == order. */
	warmup:                [FLAC__MAX_FIXED_ORDER]FLAC__int64,
	residual:              ^FLAC__int32,
}

/** LPC subframe.  (c.f. <A HREF="https://xiph.org/flac/format.html#subframe_lpc">format specification</A>)
 */
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

/** FLAC subframe structure.  (c.f. <A HREF="https://xiph.org/flac/format.html#subframe">format specification</A>)
 */
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

/** An enumeration of the available channel assignments. */
FLAC__ChannelAssignment :: enum uint32_t {
	FLAC__CHANNEL_ASSIGNMENT_INDEPENDENT = 0, /**< independent channels */
	FLAC__CHANNEL_ASSIGNMENT_LEFT_SIDE   = 1, /**< left+side stereo */
	FLAC__CHANNEL_ASSIGNMENT_RIGHT_SIDE  = 2, /**< right+side stereo */
	FLAC__CHANNEL_ASSIGNMENT_MID_SIDE    = 3, /**< mid+side stereo */
}

/** An enumeration of the possible frame numbering methods. */
FLAC__FrameNumberType :: enum uint32_t {
	FLAC__FRAME_NUMBER_TYPE_FRAME_NUMBER, /**< number contains the frame number */
	FLAC__FRAME_NUMBER_TYPE_SAMPLE_NUMBER, /**< number contains the sample number of first sample in frame */
}

/** FLAC frame header structure.  (c.f. <A HREF="https://xiph.org/flac/format.html#frame_header">format specification</A>)
 */
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

/** FLAC frame footer structure.  (c.f. <A HREF="https://xiph.org/flac/format.html#frame_footer">format specification</A>)
 */
FLAC__FrameFooter :: struct {
	crc: FLAC__uint16,
}

/** FLAC frame structure.  (c.f. <A HREF="https://xiph.org/flac/format.html#frame">format specification</A>)
 */
FLAC__Frame :: struct {
	header:    FLAC__FrameHeader,
	subframes: [FLAC__MAX_CHANNELS]FLAC__Subframe,
	footer:    FLAC__FrameFooter,
}

/** An enumeration of the available metadata block types. */
FLAC__MetadataType :: enum uint32_t {
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

/** FLAC STREAMINFO structure.  (c.f. <A HREF="https://xiph.org/flac/format.html#metadata_block_streaminfo">format specification</A>)
 */
FLAC__StreamMetadata_StreamInfo :: struct {
	min_blocksize, max_blocksize: uint32_t,
	min_framesize, max_framesize: uint32_t,
	sample_rate:                  uint32_t,
	channels:                     uint32_t,
	bits_per_sample:              uint32_t,
	total_samples:                FLAC__uint64,
	md5sum:                       [16]FLAC__byte,
}

/** FLAC PADDING structure.  (c.f. <A HREF="https://xiph.org/flac/format.html#metadata_block_padding">format specification</A>)
 */
FLAC__StreamMetadata_Padding :: struct {
	/**< Conceptually this is an empty struct since we don't store the
	 * padding bytes.  Empty structs are not allowed by some C compilers,
	 * hence the dummy.
	 */
	_: int,
}

/** FLAC APPLICATION structure.  (c.f. <A HREF="https://xiph.org/flac/format.html#metadata_block_application">format specification</A>)
 */
FLAC__StreamMetadata_Application :: struct {
	id:   [4]FLAC__byte,
	data: ^FLAC__byte,
}

/** SeekPoint structure used in SEEKTABLE blocks.  (c.f. <A HREF="https://xiph.org/flac/format.html#seekpoint">format specification</A>)
 */
FLAC__StreamMetadata_SeekPoint :: struct {
	/**<  The sample number of the target frame. */
	sample_number: FLAC__uint64,

	/**< The offset, in bytes, of the target frame with respect to
	* beginning of the first frame. */
	stream_offset: FLAC__uint64,

	/**< The number of samples in the target frame. */
	frame_samples: uint32_t,
}

/** FLAC SEEKTABLE structure.  (c.f. <A HREF="https://xiph.org/flac/format.html#metadata_block_seektable">format specification</A>)
 *
 * \note From the format specification:
 * - The seek points must be sorted by ascending sample number.
 * - Each seek point's sample number must be the first sample of the
 *   target frame.
 * - Each seek point's sample number must be unique within the table.
 * - Existence of a SEEKTABLE block implies a correct setting of
 *   total_samples in the stream_info block.
 * - Behavior is undefined when more than one SEEKTABLE block is
 *   present in a stream.
 */
FLAC__StreamMetadata_SeekTable :: struct {
	num_points: uint32_t,
	points:     ^FLAC__StreamMetadata_SeekPoint,
}

/** Vorbis comment entry structure used in VORBIS_COMMENT blocks.  (c.f. <A HREF="https://xiph.org/flac/format.html#metadata_block_vorbis_comment">format specification</A>)
 *
 *  For convenience, the APIs maintain a trailing NUL character at the end of
 *  \a entry which is not counted toward \a length, i.e.
 *  \code strlen(entry) == length \endcode
 */
FLAC__StreamMetadata_VorbisComment_Entry :: struct {
	length: FLAC__uint32,
	entry:  ^FLAC__byte,
}

/** FLAC VORBIS_COMMENT structure.  (c.f. <A HREF="https://xiph.org/flac/format.html#metadata_block_vorbis_comment">format specification</A>)
 */
FLAC__StreamMetadata_VorbisComment :: struct {
	vendor_string: FLAC__StreamMetadata_VorbisComment_Entry,
	num_comments:  FLAC__uint32,
	comments:      ^FLAC__StreamMetadata_VorbisComment_Entry,
}

/** FLAC CUESHEET track index structure.  (See the
 * <A HREF="https://xiph.org/flac/format.html#cuesheet_track_index">format specification</A> for
 * the full description of each field.)
 */
FLAC__StreamMetadata_CueSheet_Index :: struct {
	/**< Offset in samples, relative to the track offset, of the index
	* point.
	*/
	offset: FLAC__uint64,

	/**< The index point number. */
	number: FLAC__byte,
}

/** FLAC CUESHEET track structure.  (See the
 * <A HREF="https://xiph.org/flac/format.html#cuesheet_track">format specification</A> for
 * the full description of each field.)
 */
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

/** FLAC CUESHEET structure.  (See the
 * <A HREF="https://xiph.org/flac/format.html#metadata_block_cuesheet">format specification</A>
 * for the full description of each field.)
 */
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

/** An enumeration of the PICTURE types (see FLAC__StreamMetadataPicture and id3 v2.4 APIC tag). */
FLAC__StreamMetadata_Picture_Type :: enum uint32_t {
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
/** FLAC PICTURE structure.  (See the
 * <A HREF="https://xiph.org/flac/format.html#metadata_block_picture">format specification</A>
 * for the full description of each field.)
 */
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
/** Structure that is used when a metadata block of unknown type is loaded.
 *  The contents are opaque.  The structure is used only internally to
 *  correctly handle unknown metadata.
 */
FLAC__StreamMetadata_Unknown :: struct {
	data: ^FLAC__byte,
}

/** FLAC metadata block structure.  (c.f. <A HREF="https://xiph.org/flac/format.html#metadata_block">format specification</A>)
 */
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

@(default_calling_convention = "c")
foreign flac_lib {
	/* The version string of the release, stamped onto the libraries and binaries. */
	FLAC__VERSION_STRING: cstring
	/* The vendor string inserted by the encoder into the VORBIS_COMMENT block. */
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
	FLAC__stream_decoder_init_ogg_stream :: proc(decoder: ^FLAC__StreamDecoder, read_callback: FLAC__StreamDecoderReadCallback, seek_callback: FLAC__StreamDecoderSeekCallback, tell_callback: FLAC__StreamDecoderTellCallback, length_callback: FLAC__StreamDecoderLengthCallback, eof_callback: FLAC__StreamDecoderEofCallback, write_callback: FLAC__StreamDecoderWriteCallback, metadata_callback: FLAC__StreamDecoderMetadataCallback, error_callback: FLAC__StreamDecoderErrorCallback, client_data: rawptr) -> FLAC__StreamDecoderInitStatus ---
	FLAC__stream_decoder_init_FILE :: proc(decoder: ^FLAC__StreamDecoder, file: FILE, write_callback: FLAC__StreamDecoderWriteCallback, metadata_callback: FLAC__StreamDecoderMetadataCallback, error_callback: FLAC__StreamDecoderErrorCallback, client_data: rawptr) -> FLAC__StreamDecoderInitStatus ---
	FLAC__stream_decoder_init_ogg_FILE :: proc(decoder: ^FLAC__StreamDecoder, file: FILE, write_callback: FLAC__StreamDecoderWriteCallback, metadata_callback: FLAC__StreamDecoderMetadataCallback, error_callback: FLAC__StreamDecoderErrorCallback, client_data: rawptr) -> FLAC__StreamDecoderInitStatus ---
	FLAC__stream_decoder_init_file :: proc(decoder: ^FLAC__StreamDecoder, file: cstring, write_callback: FLAC__StreamDecoderWriteCallback, metadata_callback: FLAC__StreamDecoderMetadataCallback, error_callback: FLAC__StreamDecoderErrorCallback, client_data: rawptr) -> FLAC__StreamDecoderInitStatus ---
	FLAC__stream_decoder_init_ogg_file :: proc(decoder: ^FLAC__StreamDecoder, file: cstring, write_callback: FLAC__StreamDecoderWriteCallback, metadata_callback: FLAC__StreamDecoderMetadataCallback, error_callback: FLAC__StreamDecoderErrorCallback, client_data: rawptr) -> FLAC__StreamDecoderInitStatus ---
	FLAC__stream_decoder_finish :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_flush :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_reset :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_process_single :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_process_until_end_of_metadata :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_process_until_end_of_stream :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_skip_single_frame :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_seek_absolute :: proc(decoder: ^FLAC__StreamDecoder, sample: FLAC__uint64) -> FLAC__bool ---

	FLAC__stream_encoder_new :: proc() -> ^FLAC__StreamEncoder ---
	FLAC__stream_encoder_delete :: proc(encoder: ^FLAC__StreamEncoder) ---
	FLAC__stream_encoder_set_ogg_serial_number :: proc(encoder: ^FLAC__StreamEncoder, serial_number: long) -> FLAC__bool ---
	FLAC__stream_encoder_set_verify :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_streamable_subset :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_channels :: proc(encoder: ^FLAC__StreamEncoder, value: uint32_t) -> FLAC__bool ---
	FLAC__stream_encoder_set_bits_per_sample :: proc(encoder: ^FLAC__StreamEncoder, value: uint32_t) -> FLAC__bool ---
	FLAC__stream_encoder_set_sample_rate :: proc(encoder: ^FLAC__StreamEncoder, value: uint32_t) -> FLAC__bool ---
	FLAC__stream_encoder_set_compression_level :: proc(encoder: ^FLAC__StreamEncoder, value: uint32_t) -> FLAC__bool ---
	FLAC__stream_encoder_set_blocksize :: proc(encoder: ^FLAC__StreamEncoder, value: uint32_t) -> FLAC__bool ---
	FLAC__stream_encoder_set_do_mid_side_stereo :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_loose_mid_side_stereo :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_apodization :: proc(encoder: ^FLAC__StreamEncoder, specification: cstring) -> FLAC__bool ---
	FLAC__stream_encoder_set_max_lpc_order :: proc(encoder: ^FLAC__StreamEncoder, value: uint32_t) -> FLAC__bool ---
	FLAC__stream_encoder_set_qlp_coeff_precision :: proc(encoder: ^FLAC__StreamEncoder, value: uint32_t) -> FLAC__bool ---
	FLAC__stream_encoder_set_do_qlp_coeff_prec_search :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_do_escape_coding :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_do_exhaustive_model_search :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_min_residual_partition_order :: proc(encoder: ^FLAC__StreamEncoder, value: uint32_t) -> FLAC__bool ---
	FLAC__stream_encoder_set_max_residual_partition_order :: proc(encoder: ^FLAC__StreamEncoder, value: uint32_t) -> FLAC__bool ---
	FLAC__stream_encoder_set_num_threads :: proc(encoder: ^FLAC__StreamEncoder, value: uint32_t) -> uint32_t ---
	FLAC__stream_encoder_set_rice_parameter_search_dist :: proc(encoder: ^FLAC__StreamEncoder, value: uint32_t) -> FLAC__bool ---
	FLAC__stream_encoder_set_total_samples_estimate :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__uint64) -> FLAC__bool ---
	FLAC__stream_encoder_set_metadata :: proc(encoder: ^FLAC__StreamEncoder, metadata: ^^FLAC__StreamMetadata, num_blocks: uint32_t) -> FLAC__bool ---
	FLAC__stream_encoder_set_limit_min_bitrate :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_get_state :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__StreamEncoderState ---
	FLAC__stream_encoder_get_verify_decoder_state :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__StreamDecoderState ---
	FLAC__stream_encoder_get_resolved_state_string :: proc(encoder: ^FLAC__StreamEncoder) -> cstring ---
	FLAC__stream_encoder_get_verify_decoder_error_stats :: proc(encoder: ^FLAC__StreamEncoder, absolute_sample: ^FLAC__uint64, frame_number: ^uint32_t, channel: ^uint32_t, sample: ^uint32_t, expected: ^FLAC__int32, got: ^FLAC__int32) ---
	FLAC__stream_encoder_get_verify :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__bool ---
	FLAC__stream_encoder_get_streamable_subset :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__bool ---
	FLAC__stream_encoder_get_channels :: proc(encoder: ^FLAC__StreamEncoder) -> uint32_t ---
	FLAC__stream_encoder_get_bits_per_sample :: proc(encoder: ^FLAC__StreamEncoder) -> uint32_t ---
	FLAC__stream_encoder_get_sample_rate :: proc(encoder: ^FLAC__StreamEncoder) -> uint32_t ---
	FLAC__stream_encoder_get_blocksize :: proc(encoder: ^FLAC__StreamEncoder) -> uint32_t ---
	FLAC__stream_encoder_get_do_mid_side_stereo :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__bool ---
	FLAC__stream_encoder_get_loose_mid_side_stereo :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__bool ---
	FLAC__stream_encoder_get_max_lpc_order :: proc(encoder: ^FLAC__StreamEncoder) -> uint32_t ---
	FLAC__stream_encoder_get_qlp_coeff_precision :: proc(encoder: ^FLAC__StreamEncoder) -> uint32_t ---
	FLAC__stream_encoder_get_do_qlp_coeff_prec_search :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__bool ---
	FLAC__stream_encoder_get_do_escape_coding :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__bool ---
	FLAC__stream_encoder_get_do_exhaustive_model_search :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__bool ---
	FLAC__stream_encoder_get_min_residual_partition_order :: proc(encoder: ^FLAC__StreamEncoder) -> uint32_t ---
	FLAC__stream_encoder_get_max_residual_partition_order :: proc(encoder: ^FLAC__StreamEncoder) -> uint32_t ---
	FLAC__stream_encoder_get_num_threads :: proc(encoder: ^FLAC__StreamEncoder) -> uint32_t ---
	FLAC__stream_encoder_get_rice_parameter_search_dist :: proc(encoder: ^FLAC__StreamEncoder) -> uint32_t ---
	FLAC__stream_encoder_get_total_samples_estimate :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__uint64 ---
	FLAC__stream_encoder_get_limit_min_bitrate :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__bool ---
	FLAC__stream_encoder_init_stream :: proc(encoder: ^FLAC__StreamEncoder, write_callback: FLAC__StreamEncoderWriteCallback, seek_callback: FLAC__StreamEncoderSeekCallback, tell_callback: FLAC__StreamEncoderTellCallback, metadata_callback: FLAC__StreamEncoderMetadataCallback, client_data: rawptr) -> FLAC__StreamEncoderInitStatus ---
	FLAC__stream_encoder_init_ogg_stream :: proc(encoder: ^FLAC__StreamEncoder, read_callback: FLAC__StreamEncoderReadCallback, write_callback: FLAC__StreamEncoderWriteCallback, seek_callback: FLAC__StreamEncoderSeekCallback, tell_callback: FLAC__StreamEncoderTellCallback, metadata_callback: FLAC__StreamEncoderMetadataCallback, client_data: rawptr) -> FLAC__StreamEncoderInitStatus ---
	FLAC__stream_encoder_init_FILE :: proc(encoder: ^FLAC__StreamEncoder, file: FILE, progress_callback: FLAC__StreamEncoderProgressCallback, client_data: rawptr) -> FLAC__StreamEncoderInitStatus ---
	FLAC__stream_encoder_init_ogg_FILE :: proc(encoder: ^FLAC__StreamEncoder, file: FILE, progress_callback: FLAC__StreamEncoderProgressCallback, client_data: rawptr) -> FLAC__StreamEncoderInitStatus ---
	FLAC__stream_encoder_init_file :: proc(encoder: ^FLAC__StreamEncoder, filename: cstring, progress_callback: FLAC__StreamEncoderProgressCallback, client_data: rawptr) -> FLAC__StreamEncoderInitStatus ---
	FLAC__stream_encoder_init_ogg_file :: proc(encoder: ^FLAC__StreamEncoder, filename: cstring, progress_callback: FLAC__StreamEncoderProgressCallback, client_data: rawptr) -> FLAC__StreamEncoderInitStatus ---
	FLAC__stream_encoder_finish :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__bool ---
	FLAC__stream_encoder_process :: proc(encoder: ^FLAC__StreamEncoder, buffer: []FLAC__int32, samples: uint32_t) -> FLAC__bool ---
	FLAC__stream_encoder_process_interleaved :: proc(encoder: ^FLAC__StreamEncoder, buffer: []FLAC__int32, samples: uint32_t) -> FLAC__bool ---
}
