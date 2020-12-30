extends CanvasLayer

export (PackedScene) var scn_game

func _on_BotonOpciones_pressed():
	$FondoMenu.hide()
	$BotonOpciones.hide()
	$BotonStart.hide()
	$BotonSalir.hide()
	$Salir.hide()
	$Titulo.hide()
	$Opciones.hide()
	$FondoOpciones.show()
	$BotonAtras.show()
	$Atras.show()
	$BotonComoJugar.show()

func _on_BotonAtras_pressed():
	$FondoMenu.show()
	$BotonOpciones.show()
	$BotonStart.show()
	$BotonSalir.show()
	$Salir.show()
	$Jugar.show()
	$Titulo.show()
	$Opciones.show()
	$FondoOpciones.hide()
	$BotonAtras.hide()
	$Atras.hide()
	$BotonComoJugar.hide()
	
	$ColorRect.hide()
	$Controles.hide()
	$Vida.hide()
	$Basura.hide()
	$Amigos.hide()

func _on_BotonComoJugar_pressed():
	$BotonComoJugar.hide()
	
	$ColorRect.show()
	$Controles.show()
	$Vida.show()
	$Basura.show()
	$Amigos.show()

func _on_BotonStart_pressed():
	$FondoMenu.hide()
	$FondoMenu/TextureRect.hide()
	$BotonOpciones.hide()
	$BotonStart.hide()
	$BotonSalir.hide()
	$Salir.hide()
	$Titulo.hide()
	$Jugar.hide()
	$Opciones.hide()
	get_tree().change_scene_to(scn_game)

func _on_BotonSalir_pressed():
	get_tree().quit()
