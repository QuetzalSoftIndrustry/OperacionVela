extends KinematicBody2D

# Variables
export(int) var velosidad : int = 150
export(float) var v_rot : float = 2.5
export(float) var friccion : float = 5
export(float,0,15) var energia : float = 15
export(float) var tiempo_de_recarga : float = 2

var dir : int = 0
var mov : int = 0
var aceleracion : int = 0
var velosidad_reciduo : int = velosidad
var movimiento : Vector2 = Vector2()
const UP : Vector2 = Vector2(0,-1)
var limite
var tween1 : Tween
var timerEnergia 

enum ESTADOS {NORMAL, DANO, MUERTO, ATACANDO}
var estado = ESTADOS.NORMAL

var spr_muerto = preload("res://Sprites/spr_vel_Muerto.png")

func _ready():
	limite = get_viewport_rect().size
	tween1 = Tween.new()
	self.add_child(tween1)
	
	timerEnergia = Timer.new()
	self.add_child(timerEnergia)
	timerEnergia.one_shot = false
	timerEnergia.wait_time = tiempo_de_recarga
	timerEnergia.connect("timeout",self, "_agregar_energia")
	timerEnergia.start()

# Funcion main (loop)
func _physics_process(delta):
	# Inputs
	if (estado != ESTADOS.MUERTO && estado != ESTADOS.ATACANDO):
		_inputs(delta)
		
	# Limites
	_limites()
	# Animaciones
	_animacion()
	# Mover
	_mover(delta)
	

func _inputs(delta):
	# Detectar que tecla se pulso y asignarle un valor
	mov = -int(Input.is_action_pressed("Izquierda")) + int(Input.is_action_pressed("Derecha"))
	
	# Rotar
	if Input.is_action_pressed("Arriba"):
		self.rotate(-v_rot * dir * delta)
	if Input.is_action_pressed("Abajo"):
		self.rotate(v_rot * dir * delta)
	
	if Input.is_action_just_pressed("ui_accept"):
		if (energia > 3):
			estado = ESTADOS.ATACANDO
			movimiento = Vector2()
			energia -= 3
			get_parent().asignar_valor_energia_HUD(energia)
	pass

func _mover(delta):
	# Friccion
	if mov != 0:
		aceleracion = (mov * velosidad) * velosidad * delta
		velosidad_reciduo = velosidad
	else:
		aceleracion = (dir * velosidad_reciduo) * velosidad_reciduo * delta
		if (velosidad_reciduo > 0):
			velosidad_reciduo -= friccion
		elif (velosidad_reciduo < 0):
			velosidad_reciduo = 0
	
	movimiento = Vector2(aceleracion, 0).rotated(self.rotation)
	move_and_slide(movimiento, UP)

func _limites():
	# Limites de la rotacion
	if self.rotation < -1 : self.rotation = -1
	if self.rotation > 1 : self.rotation = 1
	
	#colisiones con los limites
	position.x = clamp(position.x,0,limite.x)
	position.y= clamp(position.y,240,limite.y)
	pass

func _animacion():
	# Girar sprite
	if mov == -1:
		if dir != -1:
			self.rotation *= -1
		dir = -1
		$Sprite.flip_h = false
	elif mov == 1:
		if dir != 1:
			self.rotation *= -1
		dir = 1
		$Sprite.flip_h = true
	
	# Animacion
	if (estado == ESTADOS.NORMAL):
		if mov == 0:
			$AnimationPlayer.play("anim_quieto")
		else:
			$AnimationPlayer.play("anim_nadando")
	
	if (estado == ESTADOS.DANO):
		tween1.interpolate_property($Sprite,"modulate", Color("ffffff"), Color("ff0000"),.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween1.start()
		
		tween1.interpolate_property($Sprite,"modulate", Color("ff0000"), Color("ffffff"),.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween1.start()
		
		yield(tween1,"tween_completed")
		estado = ESTADOS.NORMAL
	
	if (estado == ESTADOS.MUERTO):
		$Sprite.visible = false
		$Sprite_muerto.visible = true
	
	if (estado == ESTADOS.ATACANDO):
		tween1.interpolate_property($Sprite,"position", Vector2(0,0), Vector2(40*dir,0),.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween1.start()
		
		tween1.interpolate_property($Sprite,"position", Vector2(40*dir,0), Vector2(0,0),.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween1.start()
		
		yield(tween1,"tween_completed")
		estado = ESTADOS.NORMAL

func _agregar_energia():
	energia += 3
	get_parent().asignar_valor_energia_HUD(energia)
