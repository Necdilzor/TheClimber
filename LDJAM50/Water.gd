extends Area2D


const SCROLL_SPEED = 30

export var is_scrolling = true

func _process(delta):
	if is_scrolling:
		position.y -= SCROLL_SPEED * delta

func _on_Water_body_entered(body):
	if body.is_in_group("player"):
		body.in_water = true
