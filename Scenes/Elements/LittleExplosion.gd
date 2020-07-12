extends Node2D

func _ready():
	$Sprite.position = Vector2((randi() % 20) - 10, -(randi() % 20))
	$Sprite2.position = Vector2((randi() % 20) -40, (randi() % 30) - 10)
	$Sprite3.position = Vector2((randi() % 20), (randi() % 30) - 10)

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
