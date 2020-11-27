extends RigidBody2D

var vidas : int = 5
var tween1 : Tween

const PEZ = preload("res://Objetos/Pez_Vela_Camarada.tscn")

func _ready():
	tween1 = Tween.new()
	self.add_child(tween1)

func _on_obj_red_body_entered(body):
	if body.is_in_group("obj_player") && !tween1.is_active():
		
		if vidas > 0:
			tween1.interpolate_property(self,"modulate", Color("ffffff"), Color("ff0000"),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween1.start()
			
			tween1.interpolate_property(self,"modulate", Color("ff0000"), Color("ffffff"),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween1.start()
			yield(tween1,"tween_completed")
			vidas -= 1
		else:
			randomize()
			for i in rand_range(1,10):
				var new_pez = PEZ.instance()
				get_parent().get_parent().add_child(new_pez)
				new_pez.position = global_position
			queue_free()
