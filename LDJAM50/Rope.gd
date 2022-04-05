extends Area2D


func _on_Rope_body_entered(body):
	if body.is_in_group("player"):
		body.in_rope = !body.in_rope


func _on_Rope_body_exited(body):
	if body.is_in_group("player"):
		body.in_rope = !body.in_rope
