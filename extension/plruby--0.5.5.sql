-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION plruby" to load this file. \quit

CREATE FUNCTION plruby_call_handler () RETURNS language_handler
	AS '$libdir/plruby'
        language C;

CREATE OR REPLACE LANGUAGE plruby
	HANDLER  plruby_call_handler;
