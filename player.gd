extends CharacterBody2D
signal shooting

const SPEED = 300.0

var bullet = preload("res://bullet.tscn")
var can_shoot = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _physics_process(_delta):
	if has_node("bulletPoint"):
		var bulletPoint = get_node("bulletPoint")
		if bulletPoint is Node2D:
			look_at(get_global_mouse_position())
			rotation += PI * 0.5
			if Input.is_action_just_pressed("ui_accept"):
				shooting.emit(bulletPoint.global_position, rotation)
		else:
			print("bulletPoint is not a Node2D")
	else:
		print("bulletPoint does not exist")
	

func _input(event):
	if is_multiplayer_authority() and event is InputEventAction:
		if event.is_pressed() and event.get_action():
			can_shoot = false
			shooting.emit($bulletPoint.global_position, rotation)
			$Timer.start()
func _on_timer_timeout():
	can_shoot = true
