class_name AutohideProgressBar extends TextureProgressBar

## How long until hiding the bar after being full.
@export var _hide_after_dt = 0.35

## Time that the bar has been filled.
var _full_dt = 0.0

func _ready() -> void:
	if _hide_after_dt > 0:
		hide()

func _process(delta: float) -> void:
	if value == max_value:
		_full_dt += delta
	if _full_dt >= _hide_after_dt:
		hide()

func set_value_bar(value: float):
	if value != max_value:
		self.value = value
		show()
		_full_dt = 0
