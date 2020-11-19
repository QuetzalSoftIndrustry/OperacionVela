extends RigidBody2D

#export(NodePath) var unionA : NodePath
#export(NodePath) var unionB : NodePath

func _ready():
	#$GrooveJoint2D.node_a = unionA
	#$GrooveJoint2D.node_b = unionB
	pass
