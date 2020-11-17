extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vidas = 6
var offset_vidas = 50
var listas_vidas = []
export (PackedScene) var spr_vidas

# Called when the node enters the scene tree for the first time.
func _ready():
	crear_vidas()

func crear_vidas():
	for i in 3:
		var newVida : Sprite = spr_vidas.instance()
		get_tree().get_nodes_in_group("HUD")[0].add_child(newVida)
		newVida.global_position.x += offset_vidas * i
		listas_vidas.append(newVida)

func quitar_vida():
	if (vidas > 0):
		vidas -= 1
		#listas_vidas[corazones].queue_free()
		var vida_sprite : Sprite = listas_vidas[ round(vidas / 2)]
		vida_sprite.frame += 1
	
#func agregar_vida():
	#vidas_p += 1
	#var newVida = spr_vidas.intance()
	#get_tree().get_nodes_in_group("HUD")[0].add_child(newVida)
	#newVida.global_position.x += offset_vidas * (vidas_p - 1)
	#listas_vidas[vidas_p-1].append(newVida)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
