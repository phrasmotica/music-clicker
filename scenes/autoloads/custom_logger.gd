@tool
extends Node

enum Level { FATAL, ERROR, WARNING, INFO, DEBUG }

const MIN_LEVEL := Level.INFO

var _prefixes := {
	Level.FATAL: "FTL",
	Level.ERROR: "ERR",
	Level.WARNING: "WRN",
	Level.INFO: "INF",
	Level.DEBUG: "DBG",
}

func _init() -> void:
	if not Engine.is_editor_hint():
		_print_message("Minimum console logging level: %s" % _prefixes[MIN_LEVEL], Level.INFO)

func fatal(msg: String) -> void:
	if Level.FATAL <= MIN_LEVEL:
		_print_message(msg, Level.FATAL)

func error(msg: String) -> void:
	if Level.ERROR <= MIN_LEVEL:
		_print_message(msg, Level.ERROR)

func warning(msg: String) -> void:
	if Level.WARNING <= MIN_LEVEL:
		_print_message(msg, Level.WARNING)

func info(msg: String) -> void:
	if Level.INFO <= MIN_LEVEL:
		_print_message(msg, Level.INFO)

func debug(msg: String) -> void:
	if Level.DEBUG <= MIN_LEVEL:
		_print_message(msg, Level.DEBUG)

func _print_message(msg: String, level: Level) -> void:
	var resolved_message := "[%s] %s" % [_prefixes[level], msg]
	print(resolved_message)
