extends CharacterBody2D
signal shooting

const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _physics_process(_delta):
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("ui_accept"):
			shooting.emit($bulletPoint.global_position, rotation)
		
		if has_node("bulletPoint"):
			var bulletPoint = get_node("bulletPoint")
			if bulletPoint is Node2D:
				look_at(get_global_mouse_position())
				rotation += PI * 0.5
			else:
				print("bulletPoint is not a Node2D")
		else:
			print("bulletPoint does not exist")


