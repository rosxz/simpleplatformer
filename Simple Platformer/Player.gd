extends KinematicBody2D

export(String, FILE, "*.tscn") var world_scene

const ACCELERATION = 512
var MAX_SPEED = 64
const AIR_RES = 0.02
const FRICTION = 0.25
const GRAVITY = 200
var JUMP_FORCE = 128

var motion = Vector2.ZERO
var health = 3
var coins = 0
var attack_anim = false
var state = "Normal"
var drip = "NO DRIP"

onready var sprite =$Sprite
onready var animationPlayer =$AnimationPlayer
onready var CollisionS = $Area2D2/CollisionShape2D

signal status(value1, value2)

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	emit_signal("status", health, coins)
	
	if Input.is_key_pressed(KEY_TAB):
		get_tree().change_scene(world_scene)
		
	if Input.is_key_pressed(KEY_F1):
		health = 100
		coins = 100
	
	if Input.is_key_pressed(KEY_F2):
		drip = "GOD"
	
	if x_input != 0:
		if state == "Normal":
			animationPlayer.play("Run")
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
	elif state == "Normal":
		animationPlayer.play("Idle")
	
	motion.y += GRAVITY * delta
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)

		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
		
	else:
		if state == "Normal":
			animationPlayer.play("Jump")
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
			
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RES)
	
	if Input.is_action_pressed("ui_select"):
		state = "Attack"
		animationPlayer.play("Attack")
		if sprite.flip_h:
			CollisionS.position.x = -9
		else:
			CollisionS.position.x = 9
	
	motion = move_and_slide(motion, Vector2.UP)

func _on_Area2D_body_entered(body):
	var entity = body.get_collision_layer()
	if entity == 16 or entity == 32:
		hurt(body.position)
	if entity == 32:
		body.queue_free()
		
func hurt(pos):
	if drip != "GOD":
		state = "Hurt"
		animationPlayer.play("Hurt")
		#bounce func begin
		motion.y = -JUMP_FORCE/2
		if pos.x - position.x > 0:
			motion.x = -JUMP_FORCE/2
		else:
			motion.x = JUMP_FORCE/2
		#bounce func end
		health -= 1
		if health == 0:
			get_tree().change_scene(world_scene)
			
func health():
	return str(health)

func _on_Area2D2_body_entered(body):
	if body.get_collision_layer() == 16:
		body.health -= 1
		if body.health == 0:
			coins += 1
			body.queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack" or anim_name == "Hurt":
		state = "Normal"
