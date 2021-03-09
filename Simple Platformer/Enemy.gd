extends KinematicBody2D

const speed = 25
const GRAVITY = 200
const FRICTION = 0.05
const type = "Enemy"

var motion = Vector2.ZERO
onready var player = Vector2.ZERO
onready var sprite =$Sprite

var health = 2

func _physics_process(delta):
	player = get_parent().get_node("Player").position
	if abs(player.x - position.x) < 60 and abs(player.y - position.y) < 70:
		motion.x = speed * delta * (floor(player.x) - position.x)
		sprite.flip_h = motion.x < 0
	if not is_on_floor():
		motion.y += GRAVITY * delta
	else:
		motion.y = 0
		motion.x = lerp(motion.x, 0, FRICTION)
	
	move_and_slide(motion, Vector2.UP)
