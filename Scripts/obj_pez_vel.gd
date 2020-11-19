extends KinematicBody2D

# Variables
export(int) var velosidad : int = 150
export(float) var v_rot : float = 2.5
export(float) var friccion : float = 5

var dir : int = 0
var mov : int = 0
var aceleracion : int = 0
var velosidad_reciduo : int = velosidad
var movimiento : Vector2 = Vector2()
const UP : Vector2 = Vector2(0,-1)
var limite

enum ESTADOS {NORMAL, DANO, MUERTO}
var estado = ESTADOS.NORMAL

var spr_muerto = preload("res://Sprites/spr_vel_Muerto.png")


func _ready():
	limite = get_viewport_rect().size
	#$sprite.vframes = 4
	#$sprite.hframes = 2

# Funcion main (loop)
func _physics_process(delta):
	# Inputs
	if (estado != ESTADOS.MUERTO):
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
	position.y= clamp(position.y,0,limite.y)
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
	if (estado != ESTADOS.MUERTO):
		if mov == 0:
			$AnimationPlayer.play("anim_quieto")
		else:
			$AnimationPlayer.play("anim_nadando")
			
	if (estado == ESTADOS.DANO):
		var tween1 : Tween = Tween.new()
		var tween2 : Tween = Tween.new()
		self.add_child(tween1)
		tween1.interpolate_property(self,"modulate", Color("ffffff"), Color("ff0000"),.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween1.start()
		
		#yield(tween1,"tween_completed")
		tween1.interpolate_property(self,"modulate", Color("ff0000"), Color("ffffff"),.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween1.start()
		yield(tween1,"tween_completed")
		estado = ESTADOS.NORMAL
	if (estado == ESTADOS.MUERTO):
		#$sprite.vframes = 0
		#$sprite.hframes = 0
		#$sprite.texture = spr_muerto
		$Sprite.visible = false
		$Sprite_muerto.visible = true
