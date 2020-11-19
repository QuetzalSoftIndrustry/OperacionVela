extends CanvasLayer

func _ready():
	pass

func _input(event):
	if (!get_parent().get_node("AnimationGameOver").is_playing() && get_parent().vidas == 0):
		get_tree().paused = false
		get_tree().reload_current_scene()
		
	
