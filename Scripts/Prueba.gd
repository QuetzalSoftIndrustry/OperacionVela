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
		if (vidas == 0):
			get_tree().get_nodes_in_group("obj_player")[0].estado = get_tree().get_nodes_in_group("obj_player")[0].ESTADOS.MUERTO
			get_tree().get_nodes_in_group("obj_player")[0]._animacion()
			get_tree().paused = true
			get_node("AnimationGameOver").play("GameOverAnimation")  

func asignar_valor_energia_HUD(energia):
	$HUD/BarraEnergia.value = energia
