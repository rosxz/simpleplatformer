extends KinematicBody2D

const speed = 125
const type = "Enemy"

var motion = Vector2.ZERO
onready var player = Vector2.ZERO
onready var sprite =$Sprite

var health = 1

func _physics_process(delta):
	player = get_parent().get_node("Player").position
	if abs(player.x - position.x) < 20 and abs(player.y - position.y) < 90:
		motion.y = speed
	
	move_and_slide(motion, Vector2.UP)
