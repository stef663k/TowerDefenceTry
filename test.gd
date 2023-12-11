extends Node2D
var bullet = preload("res://bullet.tscn")
var multiplayerSynchronizer

func _ready():
	multiplayerSynchronizer = get_node("MultiplayerSynchronizer")

func _process(_delta):
	pass

func _on_peer_connected(id):
	var player = multiplayerSynchronizer.spawn_player(Vector2(306.5, 277.5), id)
	print("player id: " + str(id))

func _on_player_shooting(pos, angle):
	var b = bullet.instantiate()
	b.global_position = pos
	b.rotation = angle - PI / 2
	add_child(b)
