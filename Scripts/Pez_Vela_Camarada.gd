extends KinematicBody2D


var velosidad : int = 130
var limite : Vector2

var mov : int = 0
var aceleracion : int = 0
var movimiento : Vector2 = Vector2()
const UP : Vector2 = Vector2(0,-1)

func _ready():
	limite = get_viewport_rect().size
	randomize()
	while(mov == 0):
		mov = floor(rand_range(-1,2))
	
	rotation = rand_range(-.5, .5)
	
	if mov == -1:
		$Sprite.flip_h = false

func _physics_process(delta):
	#colisiones con los limites
	position.x = clamp(position.x, - 100, limite.x + 100)
	position.y = clamp(position.y, 240, limite.y + 100)
	
	_mover(delta)

func _mover(delta):
	# Friccion
	aceleracion = (mov * velosidad) * velosidad * delta
	
	movimiento = Vector2(aceleracion, 0).rotated(self.rotation)
	move_and_slide(movimiento, UP)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
