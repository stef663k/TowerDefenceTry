extends Control


@export var ip_address = "127.0.0.1"
@export var port = 6942
@export var player_scene = preload("res://test.tscn")
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func peer_connected(id):
	print("Player joined: " + str(id))
	add_player()

func peer_disconnected(id):
	multiplayer.peer_disconnected.disconnect(peer_disconnected)
	del_peer(id)
	print("Player left: " + str(id))

func del_peer(id):
	rpc("_peer-disconnected", id)

@rpc("any_peer", "call_local") func _peer_disconnected(id):
	var player = get_node("Player" + str(id))
	player.queue_free()

func connected_to_server():
	print("Connected to server")

func connection_failed():
	print("Connection failed")
	
func _on_host_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port, 2)
	multiplayer.multiplayer_peer = peer
	add_player()
	print("Hosting on port " + str(port))

			
func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, port)
	multiplayer.multiplayer_peer = peer
	print("Joining " + ip_address + ":" + str(port))

func _on_start_game_button_down():
	pass # Replace with function body.

func add_player():
	var player = player_scene.instantiate()
	player.set_name("Player" + str(peer.get_unique_id()))
	call_deferred("add_child", player)
