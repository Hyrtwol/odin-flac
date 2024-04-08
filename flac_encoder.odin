package flac

FLAC__StreamEncoderState :: enum u32 {
	FLAC__STREAM_ENCODER_OK = 0,
	/* The encoder is in the normal OK state and samples can be processed. */
	FLAC__STREAM_ENCODER_UNINITIALIZED,
	/* The encoder is in the uninitialized state; one of the
	 * FLAC__stream_encoder_init_*() functions must be called before samples
	 * can be processed.
	 */
	FLAC__STREAM_ENCODER_OGG_ERROR,
	/* An error occurred in the underlying Ogg layer.  */
	FLAC__STREAM_ENCODER_VERIFY_DECODER_ERROR,
	/* An error occurred in the underlying verify stream decoder;
	 * check FLAC__stream_encoder_get_verify_decoder_state().
	 */
	FLAC__STREAM_ENCODER_VERIFY_MISMATCH_IN_AUDIO_DATA,
	/* The verify decoder detected a mismatch between the original
	 * audio signal and the decoded audio signal.
	 */
	FLAC__STREAM_ENCODER_CLIENT_ERROR,
	/* One of the callbacks returned a fatal error. */
	FLAC__STREAM_ENCODER_IO_ERROR,
	/* An I/O error occurred while opening/reading/writing a file.
	 * Check \c errno.
	 */
	FLAC__STREAM_ENCODER_FRAMING_ERROR,
	/* An error occurred while writing the stream; usually, the
	 * write_callback returned an error.
	 */
	FLAC__STREAM_ENCODER_MEMORY_ALLOCATION_ERROR,
	/* Memory allocation failed. */
}

FLAC__StreamEncoderInitStatus :: enum u32 {
	FLAC__STREAM_ENCODER_INIT_STATUS_OK = 0,
	/* Initialization was successful. */
	FLAC__STREAM_ENCODER_INIT_STATUS_ENCODER_ERROR,
	/* General failure to set up encoder; call FLAC__stream_encoder_get_state() for cause. */
	FLAC__STREAM_ENCODER_INIT_STATUS_UNSUPPORTED_CONTAINER,
	/* The library was not compiled with support for the given container
	 * format.
	 */
	FLAC__STREAM_ENCODER_INIT_STATUS_INVALID_CALLBACKS,
	/* A required callback was not supplied. */
	FLAC__STREAM_ENCODER_INIT_STATUS_INVALID_NUMBER_OF_CHANNELS,
	/* The encoder has an invalid setting for number of channels. */
	FLAC__STREAM_ENCODER_INIT_STATUS_INVALID_BITS_PER_SAMPLE,
	/* The encoder has an invalid setting for bits-per-sample.
	 * FLAC supports 4-32 bps but the reference encoder currently supports
	 * only up to 24 bps.
	 */
	FLAC__STREAM_ENCODER_INIT_STATUS_INVALID_SAMPLE_RATE,
	/* The encoder has an invalid setting for the input sample rate. */
	FLAC__STREAM_ENCODER_INIT_STATUS_INVALID_BLOCK_SIZE,
	/* The encoder has an invalid setting for the block size. */
	FLAC__STREAM_ENCODER_INIT_STATUS_INVALID_MAX_LPC_ORDER,
	/* The encoder has an invalid setting for the maximum LPC order. */
	FLAC__STREAM_ENCODER_INIT_STATUS_INVALID_QLP_COEFF_PRECISION,
	/* The encoder has an invalid setting for the precision of the quantized linear predictor coefficients. */
	FLAC__STREAM_ENCODER_INIT_STATUS_BLOCK_SIZE_TOO_SMALL_FOR_LPC_ORDER,
	/* The specified block size is less than the maximum LPC order. */
	FLAC__STREAM_ENCODER_INIT_STATUS_NOT_STREAMABLE,
	/* The encoder is bound to the <A HREF="../format.html#subset">Subset</A> but other settings violate it. */
	FLAC__STREAM_ENCODER_INIT_STATUS_INVALID_METADATA,
	/* The metadata input to the encoder is invalid, in one of the following ways:
	 * - FLAC__stream_encoder_set_metadata() was called with a null pointer but a block count > 0
	 * - One of the metadata blocks contains an undefined type
	 * - It contains an illegal CUESHEET as checked by FLAC__format_cuesheet_is_legal()
	 * - It contains an illegal SEEKTABLE as checked by FLAC__format_seektable_is_legal()
	 * - It contains more than one SEEKTABLE block or more than one VORBIS_COMMENT block
	 */
	FLAC__STREAM_ENCODER_INIT_STATUS_ALREADY_INITIALIZED,
	/* FLAC__stream_encoder_init_*() was called when the encoder was
	 * already initialized, usually because
	 * FLAC__stream_encoder_finish() was not called.
	 */
}

FLAC__StreamEncoderReadStatus :: enum u32 {
	FLAC__STREAM_ENCODER_READ_STATUS_CONTINUE,
	/* The read was OK and decoding can continue. */
	FLAC__STREAM_ENCODER_READ_STATUS_END_OF_STREAM,
	/* The read was attempted at the end of the stream. */
	FLAC__STREAM_ENCODER_READ_STATUS_ABORT,
	/* An unrecoverable error occurred. */
	FLAC__STREAM_ENCODER_READ_STATUS_UNSUPPORTED,
	/* Client does not support reading back from the output. */
}

FLAC__StreamEncoderWriteStatus :: enum u32 {
	FLAC__STREAM_ENCODER_WRITE_STATUS_OK = 0,
	/* The write was OK and encoding can continue. */
	FLAC__STREAM_ENCODER_WRITE_STATUS_FATAL_ERROR,
	/* An unrecoverable error occurred.  The encoder will return from the process call. */
}

FLAC__StreamEncoderSeekStatus :: enum u32 {
	FLAC__STREAM_ENCODER_SEEK_STATUS_OK,
	/* The seek was OK and encoding can continue. */
	FLAC__STREAM_ENCODER_SEEK_STATUS_ERROR,
	/* An unrecoverable error occurred. */
	FLAC__STREAM_ENCODER_SEEK_STATUS_UNSUPPORTED,
	/* Client does not support seeking. */
}

FLAC__StreamEncoderTellStatus :: enum u32 {
	FLAC__STREAM_ENCODER_TELL_STATUS_OK,
	/* The tell was OK and encoding can continue. */
	FLAC__STREAM_ENCODER_TELL_STATUS_ERROR,
	/* An unrecoverable error occurred. */
	FLAC__STREAM_ENCODER_TELL_STATUS_UNSUPPORTED,
	/* Client does not support seeking. */
}

FLAC__StreamEncoder :: struct {}
