extends Area2D


func _on_FinalArea_body_entered(body):
	if body.is_in_group("player"):
		body.in_final_area = true
