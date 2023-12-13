extends CharacterBody2D


const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _process(_delta):
	# Add the gravity.
	# if not is_on_floor():
	# 	velocity.y += gravity * delta
	velocity = Vector2.from_angle(rotation)*SPEED# * SPEED * delta
	# print(velocity)
	
	move_and_slide()
