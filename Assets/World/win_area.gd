extends Area2D

func _ready():
	body_entered.connect(_body_entered)

func _body_entered(body):
	if body is not Player:
		return
	Game.end_game_good()
