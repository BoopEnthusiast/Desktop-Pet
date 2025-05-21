@tool
extends Setting


@export var label_text: String

@onready var _label_2: Label = $Label2


func _ready() -> void:
	super()
	_label_2.text = label_text
