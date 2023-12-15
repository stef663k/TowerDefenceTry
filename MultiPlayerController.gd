extends Control

var player_scene: PackedScene = load("res://main.tscn")
signal player_host
signal player_join
signal player_joins
signal player_start
@onready var join_button = $VBoxContainer/Join
@onready var host_button = $VBoxContainer/Host
@onready var start_game_button = $VBoxContainer/StartGame
	
func _on_host_button_down():
	join_button.hide()
	host_button.hide()
	player_host.emit()

func _on_join_button_down():
	join_button.hide()
	host_button.hide()
	player_join.emit()

@rpc()
func startGame():
	print("Starting game")
	if player_scene == null:
		printerr("Player scene not found")
		return


	print("game exited")
var peer

var bullet = preload("res://bullet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if is_multiplayer_authority():
		print("Server started")
	else:
		print("Client started")
	
	
	join_button.modulate = Color(1, 0, 0)
	host_button.modulate = Color(1, 0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
func peer_connected(id):
	print("Player joined: " + str(id))
	

@rpc("any_peer", "call_local")
func peer_disconnected(id):
	multiplayer.peer_disconnected.disconnect(peer_disconnected)
	if not self.is_queued_for_deletion():  # Check if the node is still valid
		del_peer(id)
		print("Player left: " + str(id))

@rpc("any_peer", "call_local")
func _peer_disconnected(id):
	if is_multiplayer_authority():
		print("Player joined")
	else:
		print("Player joined on a client")

	var player = get_node("Player" + str(id))
	if player != null:
		player.queue_free()


func del_peer(id):
	rpc("_peer_disconnected", id)

func connected_to_server():
	print("Connected to server")

func connection_failed():
	print("Connection failed")

@rpc("unreliable")
func server_shoot_request(pos, angle):
	if is_multiplayer_authority():
		print("Server received shoot request")
		var b = bullet.instantiate()
		b.global_position = pos
		b.rotation = angle
		add_child(b)
	else:
		print("Client received shoot request")


func _on_start_game_button_down():
	if is_multiplayer_authority():
		start_game_button.hide()
		player_start.emit()

		
