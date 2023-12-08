extends MultiplayerSynchronizer


var player_scene = preload("res://player.tscn")

func spawn_player(position, unique_id):
	var player = player_scene.instantiate()
	player.global_position = position
	add_child(player)
	player.set_multiplayer_authority(unique_id)
	return player
   
