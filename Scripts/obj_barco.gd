extends StaticBody2D

# Variables
export(bool) var tirar_basura : bool = true
export(float) var tiempo_crear_basura : float = 4
export(float) var esperar_para_crear : float = 1

export(int) var vida : int = 10

export(int) var velosidad : int = 100
var dir : int = 1
var aceleracion : int = 0

#obj_basura
const BASURA = preload("res://Objetos/obj_basura.tscn")

#timer_basura
var timer_basura : Timer

func _ready():
	timer_basura = Timer.new()
	self.add_child(timer_basura)
	timer_basura.one_shot = false
	timer_basura.wait_time = 2
	timer_basura.connect("timeout",self, "_crear_basura")
	
	if (tirar_basura):
		yield(get_tree().create_timer(esperar_para_crear),"timeout")
		timer_basura.start()


# Funcion main (loop)
func _physics_process(delta):
	# Limites de la rotacion
	if self.global_position.x < -192 || self.global_position.x > 1152 + 192:
		dir *= -1;
	
	# Rotar sprite
	if (dir == -1):
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	# Mover
	aceleracion = dir * velosidad * delta
	self.global_position += Vector2(aceleracion, 0)

func _crear_basura():
	var nueva_basura : RigidBody2D
	nueva_basura = BASURA.instance();
	get_parent().add_child(nueva_basura)
	nueva_basura.global_position = $Spawner_position.global_position
	nueva_basura.apply_central_impulse(Vector2(200,0).rotated(rand_range(-2.5,1.5)))
