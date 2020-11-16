extends RigidBody2D

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_obj_basura_body_entered(body):
	if body.is_in_group("obj_player"):
		queue_free()
