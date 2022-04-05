extends CanvasLayer

var next_scene = preload("res://Main.tscn")

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene_to(next_scene)
