@tool
class_name GameSettings
extends Node

@export
var starting_score: int = 0:
	set(value):
		starting_score = maxi(value, 0)

		if Engine.is_editor_hint():
			starting_score_changed.emit(starting_score)

@export
var products: Array[ProductCounter] = []:
	set(value):
		products = value

		for p in products:
			if p:
				SignalHelper.persist(p.changed, _emit_products)

		if Engine.is_editor_hint():
			_emit_products()

signal starting_score_changed(starting_score: int)
signal products_changed(products: Array[ProductCounter])

func _ready() -> void:
	if Engine.is_editor_hint():
		SignalHelper.once_next_frame(_preview_game)
	else:
		SignalHelper.once_next_frame(_start_game)

func _preview_game() -> void:
	starting_score_changed.emit(starting_score)
	_emit_products()

func _start_game() -> void:
	ScoreManager.set_starting_score(starting_score)
	GameEvents.emit_score_changed(starting_score)

	ProductRouter.set_products(products)
	GameEvents.emit_products_changed(products)

func _emit_products() -> void:
	products_changed.emit(products)
