CREATE FUNCTION plruby_call_handler () RETURNS language_handler
	AS '$libdir/plruby'
        language C;

CREATE OR REPLACE LANGUAGE plruby
	HANDLER  plruby_call_handler;
