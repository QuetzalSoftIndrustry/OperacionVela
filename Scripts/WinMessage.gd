extends CanvasLayer

var tween : Tween

func _ready():
	tween = Tween.new()
	self.add_child(tween)

func mostrar_pantalla():
	get_tree().paused = true
	tween.interpolate_property($ColorRect,"modulate", Color("00ffffff"), Color("ffffff"),.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()

func _input(event):
	if ($ColorRect.modulate == Color("ffffffff")):
		tween.interpolate_property($ColorRect,"modulate", $ColorRect.modulate, Color("000000"),.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
		$ColorRect.color = Color("000000")
		yield(tween,"tween_completed")
		get_tree().paused = false
		get_tree().change_scene("res://Escenas/Interfaz.tscn")
		#get_tree().reload_current_scene()
