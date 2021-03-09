extends StaticBody2D

onready var animationPlayer = $AnimationPlayer

func _process(_delta):
	animationPlayer.play("Hover")

func _on_Area2D_body_entered(body):
	if body.name == "Player" and body.coins >= 3:
		body.coins -= 3
		body.drip = "COLLECTED"
		body.MAX_SPEED = 90
		body.JUMP_FORCE = 200
		queue_free()
