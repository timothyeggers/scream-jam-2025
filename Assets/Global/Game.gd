extends Node

signal player_died

var ui: UI : get = get_ui

## The player state represents the mentality of the player.
enum PlayerMentalState {
	## The player mentally is doing great!
	DEFAULT,
	## The player is stressed, because there's no light, or something weird is happening.
	STRESSED,
	## The player is actively in danger of something.
	IN_DANGER
}

var _mental_state = PlayerMentalState.DEFAULT

func get_ui() -> UI:
	var ui = get_tree().get_first_node_in_group("UI")
	if ui is UI:
		return ui
	return null

## How quickly does the player stamina drain?
func get_stamina_consumption_rate() -> float:
	match _mental_state:
		PlayerMentalState.DEFAULT:
			return 0.0
		PlayerMentalState.STRESSED:
			return 0.5
		PlayerMentalState.IN_DANGER:
			return 1.0 
		_:
			return 1.0

func set_player_mental_state(state: PlayerMentalState):
	_mental_state = state

func get_player() -> Player:
	return get_tree().get_first_node_in_group("Player")

func get_world() -> Node2D:
	return get_tree().get_first_node_in_group("World")
