extends Camera2D

const SCROLL_SPEED = 30

onready var end_scroll = get_node("/root/Main/EndScroll")
onready var water = get_node("/root/Main/Water")
onready var player = get_node("/root/Main/Player")
onready var screen_size = get_viewport_rect().size

func _process(delta):
	if position.y-int(screen_size.y/2) > end_scroll.position.y:
		position.y -= SCROLL_SPEED * delta
	elif water.is_scrolling:
		water.is_scrolling = false
		player.can_clip = true
