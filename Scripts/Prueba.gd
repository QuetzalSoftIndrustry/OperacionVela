extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vidas_p = 3
var offset_vidas = 50
var listas_vidas = []
export (PackedScene) var spr_vidas

# Called when the node enters the scene tree for the first time.
func _ready():
	crear_vidas()

func crear_vidas():
	for i in vidas_p:
		var newVida = spr_vidas.instance()
		get_tree().get_nodes_in_group("HUD")[0].add_child(newVida)
		newVida.global_position.x += offset_vidas * i
		listas_vidas.append(newVida)

func quitar_vida():
	vidas_p -= 1
	listas_vidas[vidas_p].queue_free()
	
#func agregar_vida():
	#vidas_p += 1
	#var newVida = spr_vidas.intance()
	#get_tree().get_nodes_in_group("HUD")[0].add_child(newVida)
	#newVida.global_position.x += offset_vidas * (vidas_p - 1)
	#listas_vidas[vidas_p-1].append(newVida)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
