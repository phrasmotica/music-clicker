@tool
class_name HighlightableText extends Label

@export_tool_button("Preview Highlight")
var preview: Callable = do_highlight

@export
var highlight_colour: Color:
	set(value):
		highlight_colour = value

		_refresh()

@export_range(0.5, 5.0)
var duration := 1.0:
	set(value):
		duration = value

		_refresh()

@onready
var updater: ShaderParamUpdater = %ShaderParamUpdater

@onready
var progressor: ShaderProgressor = %ShaderProgressor

func _ready() -> void:
	if progressor:
		progressor.progress_finished.connect(_handle_finished)

	_refresh()

func do_highlight() -> void:
	if progressor:
		print("Preview Highlight")

		progressor.trigger()

func _handle_finished() -> void:
	print("Highlight finished")

func _refresh() -> void:
	if updater:
		updater.update("highlight_colour", highlight_colour)

	if progressor:
		progressor.duration = duration
