extends Node2D

@export var mob_scene: PackedScene = preload("res://mob.tscn")
@export var player_scene: PackedScene = preload("res://player.tscn")
var bullet = preload("res://bullet.tscn")
# Multiplayer variables
var multiplayerSynchronizer
var peer = ENetMultiplayerPeer.new()
@export var ip_address = "127.0.0.1"
@export var port = 6942

func _on_host_button_down():
	peer.create_server(port, 2)
	multiplayer.multiplayer_peer = peer
	
	print("Hosting on port " + str(port))
	_add_player()
	
func _on_join_button_down():
	peer.create_client(ip_address, port)
	multiplayer.multiplayer_peer = peer
	print("Joining " + ip_address + ":" + str(port))

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func _on_multiplayer_scene_player_start():
	startGame()
@rpc
func startGame():
	print("Starting game")

	if player_scene == null:
		printerr("Player scene not found")
		return

	if is_multiplayer_authority():
		startGame.rpc()

	var playerID = str(multiplayer.get_unique_id())
	var playerName = "Player" + playerID

	# Check if the player node already exists
	var existingPlayer = get_node(playerName)

	if existingPlayer == null:
		var player = player_scene.instantiate()
		player.name = playerName
		add_child(player)
	else:
		print("Player node already exists with name: " + playerName)

	var delay_timer = Timer.new()
	delay_timer.one_shot = true
	delay_timer.wait_time = 1.0
	add_child(delay_timer)

	# Connect the timeout signal using a lambda function
	delay_timer.connect("timeout", func(): _on_delay_timer_timeout(playerName))

	delay_timer.start()

# Use an argument for the signal
func _on_delay_timer_timeout(playerName: String):
	var node = get_node(playerName)

	if node:
		node.visible = true
		print("Game started on the client with player ID: " + str(multiplayer.get_unique_id()))
	else:
		print("Player not found with ID: " + str(multiplayer.get_unique_id()))

	new_game()

func _ready():
	#multiplayerSynchronizer = get_node("MultiplayerSynchronizer")
	pass
	#new_game()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

func new_game():
	#player.start($PlayerSpawn.position)
	$MobTimer.start()
	$StartTimer.start()

func _process(_delta):
	pass

func _on_peer_connected(id):
	#var _player = multiplayerSynchronizer.spawn_player(Vector2(306.5, 277.5), id)
	print("player id: " + str(id))



func _on_player_shooting(pos, angle):
	if bullet:
		var b = bullet.instantiate()
		b.global_position = pos
		b.rotation = angle - PI / 2
		add_child(b)
	


func _on_mob_timer_timeout():
	if mob_scene:
		var mob = mob_scene.instantiate()
		var mob_spawn_locations = get_node("MobPath/MobSpawnLocation")
		mob_spawn_locations.progress_ratio = randf()
		var direction = mob_spawn_locations.rotation + PI / 2
		mob.position = mob_spawn_locations.position
		mob.position = mob_spawn_locations.position
		direction += randf_range(-PI / 4, PI / 4)
		mob.rotation = direction
		var velocity = Vector2(randf_range(150, 250), 0)
		mob.linear_velocity = velocity.rotated(direction)
		add_child(mob)


func _on_start_timer_timeout():
	pass # Replace with function body.




