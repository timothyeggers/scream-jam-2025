class_name Log extends RichTextLabel

var _time_to_delete_next: float = 3
var _dt: float = 0

var _messages: Array[String] = []

func _process(delta: float) -> void:
	if _messages.size() == 0: return
	
	_dt += delta
	if _dt >= _time_to_delete_next:
		_messages.pop_back()
		_dt = 0
		_update_log()

func push_next(text: String):
	_messages.push_front(text)
	if _messages.size() == 1:
		_dt = 0
	_update_log()

func _update_log():
	clear()
	for m in _messages:
		append_text(m)
		newline()
