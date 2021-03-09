extends Camera2D

onready var world = get_node("res://")

onready var player = get_node("/root/World2/Player")

func _process(_delta):
	
	position.x = player.position.x
