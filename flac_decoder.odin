package flac

FLAC__StreamDecoderState :: enum u32 {
	FLAC__STREAM_DECODER_SEARCH_FOR_METADATA = 0,
	/* The decoder is ready to search for metadata. */
	FLAC__STREAM_DECODER_READ_METADATA,
	/* The decoder is ready to or is in the process of reading metadata. */
	FLAC__STREAM_DECODER_SEARCH_FOR_FRAME_SYNC,
	/* The decoder is ready to or is in the process of searching for the
	 * frame sync code.
	 */
	FLAC__STREAM_DECODER_READ_FRAME,
	/* The decoder is ready to or is in the process of reading a frame. */
	FLAC__STREAM_DECODER_END_OF_STREAM,
	/* The decoder has reached the end of the stream. */
	FLAC__STREAM_DECODER_OGG_ERROR,
	/* An error occurred in the underlying Ogg layer.  */
	FLAC__STREAM_DECODER_SEEK_ERROR,
	/* An error occurred while seeking.  The decoder must be flushed
	 * with FLAC__stream_decoder_flush() or reset with
	 * FLAC__stream_decoder_reset() before decoding can continue.
	 */
	FLAC__STREAM_DECODER_ABORTED,
	/* The decoder was aborted by the read or write callback. */
	FLAC__STREAM_DECODER_MEMORY_ALLOCATION_ERROR,
	/* An error occurred allocating memory.  The decoder is in an invalid
	 * state and can no longer be used.
	 */
	FLAC__STREAM_DECODER_UNINITIALIZED,
	/* The decoder is in the uninitialized state; one of the
	 * FLAC__stream_decoder_init_*() functions must be called before samples
	 * can be processed.
	 */
}

FLAC__StreamDecoderInitStatus :: enum u32 {
	FLAC__STREAM_DECODER_INIT_STATUS_OK = 0,
	/* Initialization was successful. */
	FLAC__STREAM_DECODER_INIT_STATUS_UNSUPPORTED_CONTAINER,
	/* The library was not compiled with support for the given container
	 * format.
	 */
	FLAC__STREAM_DECODER_INIT_STATUS_INVALID_CALLBACKS,
	/* A required callback was not supplied. */
	FLAC__STREAM_DECODER_INIT_STATUS_MEMORY_ALLOCATION_ERROR,
	/* An error occurred allocating memory. */
	FLAC__STREAM_DECODER_INIT_STATUS_ERROR_OPENING_FILE,
	/* fopen() failed in FLAC__stream_decoder_init_file() or
	 * FLAC__stream_decoder_init_ogg_file(). */
	FLAC__STREAM_DECODER_INIT_STATUS_ALREADY_INITIALIZED,
	/* FLAC__stream_decoder_init_*() was called when the decoder was
	 * already initialized, usually because
	 * FLAC__stream_decoder_finish() was not called.
	 */
}

FLAC__StreamDecoderReadStatus :: enum u32 {
	FLAC__STREAM_DECODER_READ_STATUS_CONTINUE,
	/* The read was OK and decoding can continue. */
	FLAC__STREAM_DECODER_READ_STATUS_END_OF_STREAM,
	/* The read was attempted while at the end of the stream.  Note that
	 * the client must only return this value when the read callback was
	 * called when already at the end of the stream.  Otherwise, if the read
	 * itself moves to the end of the stream, the client should still return
	 * the data and \c FLAC__STREAM_DECODER_READ_STATUS_CONTINUE, and then on
	 * the next read callback it should return
	 * \c FLAC__STREAM_DECODER_READ_STATUS_END_OF_STREAM with a byte count
	 * of \c 0.
	 */
	FLAC__STREAM_DECODER_READ_STATUS_ABORT,
	/* An unrecoverable error occurred.  The decoder will return from the process call. */
}

FLAC__StreamDecoderSeekStatus :: enum u32 {
	FLAC__STREAM_DECODER_SEEK_STATUS_OK,
	/* The seek was OK and decoding can continue. */
	FLAC__STREAM_DECODER_SEEK_STATUS_ERROR,
	/* An unrecoverable error occurred.  The decoder will return from the process call. */
	FLAC__STREAM_DECODER_SEEK_STATUS_UNSUPPORTED,
	/* Client does not support seeking. */
}

FLAC__StreamDecoderTellStatus :: enum u32 {
	FLAC__STREAM_DECODER_TELL_STATUS_OK,
	/* The tell was OK and decoding can continue. */
	FLAC__STREAM_DECODER_TELL_STATUS_ERROR,
	/* An unrecoverable error occurred.  The decoder will return from the process call. */
	FLAC__STREAM_DECODER_TELL_STATUS_UNSUPPORTED,
	/* Client does not support telling the position. */
}

FLAC__StreamDecoderLengthStatus :: enum u32 {
	FLAC__STREAM_DECODER_LENGTH_STATUS_OK,
	/* The length call was OK and decoding can continue. */
	FLAC__STREAM_DECODER_LENGTH_STATUS_ERROR,
	/* An unrecoverable error occurred.  The decoder will return from the process call. */
	FLAC__STREAM_DECODER_LENGTH_STATUS_UNSUPPORTED,
	/* Client does not support reporting the length. */
}

FLAC__StreamDecoderWriteStatus :: enum u32 {
	FLAC__STREAM_DECODER_WRITE_STATUS_CONTINUE,
	/* The write was OK and decoding can continue. */
	FLAC__STREAM_DECODER_WRITE_STATUS_ABORT,
	/* An unrecoverable error occurred.  The decoder will return from the process call. */
}

FLAC__StreamDecoderErrorStatus :: enum u32 {
	FLAC__STREAM_DECODER_ERROR_STATUS_LOST_SYNC,
	/* An error in the stream caused the decoder to lose synchronization. */
	FLAC__STREAM_DECODER_ERROR_STATUS_BAD_HEADER,
	/* The decoder encountered a corrupted frame header. */
	FLAC__STREAM_DECODER_ERROR_STATUS_FRAME_CRC_MISMATCH,
	/* The frame's data did not match the CRC in the footer. */
	FLAC__STREAM_DECODER_ERROR_STATUS_UNPARSEABLE_STREAM,
	/* The decoder encountered reserved fields in use in the stream. */
}

FLAC__StreamDecoder :: struct {}
