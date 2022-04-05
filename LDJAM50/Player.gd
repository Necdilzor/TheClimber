extends KinematicBody2D

const WALK_FORCE = 600
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1600
const JUMP_SPEED = 200
const CLIMBING_SPEED = 150
const CELL_SIZE = 64


export var is_climbing = false
export var is_jumping = false
export var is_walking = true
export var in_ladder = false
export var in_rope = false
export var in_water = false
export var in_final_area = false
export var can_clip = false


onready var camera = get_node("/root/Main/Camera2D")
onready var screen_size = get_viewport_rect().size
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var next_scene = preload("res://GameOver.tscn")
var velocity = Vector2()


func _physics_process(delta):
	if in_water || in_final_area:
		queue_free()
		get_tree().change_scene_to(next_scene)
		return
	

	var walk = WALK_FORCE * (Input.get_action_strength("right") - Input.get_action_strength("left"))
	if abs(walk) < WALK_FORCE * 0.2:
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		velocity.x += walk * delta
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	
	
	if in_ladder || in_rope:
		if Input.is_action_pressed("up"):
			is_climbing = true
			if in_ladder:
				$AnimatedSprite.animation = "ladder"
			if in_rope:
				$AnimatedSprite.animation = "rope"
			position.x = int(position.x/CELL_SIZE)*CELL_SIZE+CELL_SIZE/2
		if Input.is_action_just_pressed("jump"):
			is_climbing = false
			is_jumping = true
	else:
		is_climbing = false
		position.x = clamp(position.x, 0, screen_size.x)
	
	if is_climbing:
		velocity.x = 0
		velocity.y = 0
		if Input.is_action_pressed("up"):
			velocity.y -= CLIMBING_SPEED
		if Input.is_action_pressed("down"):
			velocity.y += CLIMBING_SPEED
		if velocity.y != 0:
			$AnimatedSprite.play()
		else:
			$AnimatedSprite.stop()
	else:
		is_walking = true
		$AnimatedSprite.animation = "walk"
		if Input.is_action_pressed("left"):
			$AnimatedSprite.flip_h = true
		elif Input.is_action_pressed("right"):
			$AnimatedSprite.flip_h = false
		if velocity.x != 0:
			$AnimatedSprite.play()
		else:
			$AnimatedSprite.stop()
		velocity.y += gravity * delta

	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
	
	if is_climbing || is_on_floor():
		is_jumping = false
		velocity.y = 0
	
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		is_jumping = true
		velocity.y = -JUMP_SPEED
		
	if can_clip:
		position.y = clamp(position.y, camera.position.y-screen_size.y, camera.position.y+screen_size.y/2)
	else:
		position.y = clamp(position.y, camera.position.y-screen_size.y/2, camera.position.y+screen_size.y/2)
