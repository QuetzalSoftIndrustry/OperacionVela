extends RigidBody2D

#sprites
var sprs_basura := [
	"res://Sprites/basura.png",
	"res://Sprites/basura (bote).png",
	"res://Sprites/basura (botella).png",
	"res://Sprites/basura (llanta).png"]

var tween
var agua : bool = false

func _ready():
	
	tween = Tween.new()
	tween.interpolate_property(self,"modulate", Color("ffffff"), Color("00ffffff"),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	self.add_child(tween)
	
	randomize()
	$Sprite.texture = load(sprs_basura[rand_range(0,4)])
	
	yield(get_tree().create_timer(6),"timeout")
	tween.start()
	yield(get_tree().create_timer(1),"timeout")
	queue_free()

func _process(delta):
	if self.position.y > 240 && !agua:
		linear_velocity -= Vector2(0,+100)
		self.gravity_scale = .2
		$Particles2D.emitting = true
		agua = true

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_obj_basura_body_entered(body):
	if body.is_in_group("obj_player"):
		body.estado = body.ESTADOS.DANO
		get_parent().quitar_vida()
		queue_free()
