extends CharacterBody2D


func _ready():
	var mob_types = $AnimatedSprite2D.frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

