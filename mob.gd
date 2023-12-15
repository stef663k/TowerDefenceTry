extends RigidBody2D
signal hit

func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])



func _on_body_entered(body):
	if body.is_in_group("bullets"):
		emit_signal("hit")
		queue_free()
