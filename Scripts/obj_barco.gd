extends StaticBody2D

# Variables
export(bool) var tirar_basura : bool = true
export(float) var tiempo_crear_basura : float = 4
export(float) var esperar_para_crear : float = 1
export(int) var vida : int = 10
export(int) var velosidad : int = 100
export(int) var velosidad_Max: int = 200
var dir : int = 1
var aceleracion : int = 0
var tween1 : Tween
var player : KinematicBody2D = null
var collision
#timer_basura
var timer_basura : Timer
#obj_basura
const BASURA = preload("res://Objetos/obj_basura.tscn")
#obj_red
const REDD = preload("res://Objetos/obj_red.tscn")

func _ready():
	timer_basura = Timer.new()
	self.add_child(timer_basura)
	timer_basura.one_shot = false
	timer_basura.wait_time = tiempo_crear_basura
	timer_basura.connect("timeout",self, "_crear_basura")
	
	if (tirar_basura):
		yield(get_tree().create_timer(esperar_para_crear),"timeout")
		timer_basura.start()
	
	tween1 = Tween.new()
	self.add_child(tween1)

# Funcion main (loop)
func _physics_process(delta):
	# Limites de la rotacion
	if (vida > 0):
		if self.global_position.x < -192 || self.global_position.x > 1152 + 192:
			dir *= -1;
	
	# Rotar sprite
	if (dir == -1):
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	# Resivir daño del player
	if (player != null):
		_check_collision(player)
	
	# cambiar logia al perder la red
	if (get_tree().get_nodes_in_group("obj_red").size() == 0):
		velosidad = velosidad_Max
		tiempo_crear_basura = .3
		timer_basura.wait_time = tiempo_crear_basura
		
		$Area_de_dano/CollisionShape2D.disabled = false
	
	# Mover
	if (vida > 0):
		aceleracion = dir * velosidad * delta
		position = Vector2(position.x + aceleracion, position.y)
	else:
		$Sprite.flip_h = true
		aceleracion = -1 * velosidad * delta
		position = Vector2(position.x + aceleracion, position.y)
	

func _crear_basura():
	var nueva_basura : RigidBody2D
	nueva_basura = BASURA.instance();
	get_parent().add_child(nueva_basura)
	nueva_basura.global_position = $Spawner_position.global_position
	nueva_basura.apply_central_impulse(Vector2(100,0).rotated(rand_range(-2.5,1.5)))


func _check_collision(body):
	if body.is_in_group("obj_player") && !tween1.is_active() && body.estado == body.ESTADOS.ATACANDO:
		
		if vida > 1:
			tween1.interpolate_property(self,"modulate", Color("ffffff"), Color("ff0000"),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween1.start()
			
			tween1.interpolate_property(self,"modulate", Color("ff0000"), Color("ffffff"),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween1.start()
			yield(tween1,"tween_completed")
			vida -= 1
		elif vida == 1:
			$Sprite.flip_h = true
			dir = -1
			tween1.interpolate_property(self,"modulate", Color("ffffff"), Color("ff0000"),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween1.start()
			
			tween1.interpolate_property(self,"modulate", Color("ff0000"), Color("ffffff"),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			tween1.start()
			yield(tween1,"tween_completed")
			vida -= 1
			yield(get_tree().create_timer(3.0), "timeout")
			queue_free()

func _on_Area_de_dano_body_entered(body):
	if body.is_in_group("obj_player"):
		player = body

func _on_Area_de_dano_body_exited(body):
	if body.is_in_group("obj_player"):
		player = null
