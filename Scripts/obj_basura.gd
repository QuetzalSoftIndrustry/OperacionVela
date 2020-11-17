extends RigidBody2D

#sprites
var sprs_basura := [
	"res://Sprites/basura.png",
	"res://Sprites/basura (bote).png",
	"res://Sprites/basura (botella).png",
	"res://Sprites/basura (llanta).png"]

var tween

func _ready():
	tween = Tween.new()
	self.add_child(tween)
	tween.interpolate_property(self,"modulate", Color("ffffff"), Color("00ffffff"),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	
	randomize()
	$Sprite.texture = load(sprs_basura[rand_range(0,4)])
	
	yield(get_tree().create_timer(6),"timeout")
	tween.start()
	yield(get_tree().create_timer(1),"timeout")
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_obj_basura_body_entered(body):
	if body.is_in_group("obj_player"):
		get_parent().quitar_vida()
		queue_free()
