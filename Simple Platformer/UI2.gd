extends CanvasLayer

func _on_Player_status(health, coins):
	$MarginContainer/HBoxContainer/VBoxContainer/Label.text = "Health: " + str(health)
	$MarginContainer/HBoxContainer/VBoxContainer/Label2.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	$MarginContainer/HBoxContainer/VBoxContainer/Label3.text = "Coins: " + str(coins)
