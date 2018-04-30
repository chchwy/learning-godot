extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var screen_size
var pad_size
var direction = Vector2(1.0, 0.0)

const INITIAL_SPEED = 80 # in pixel/second
var ball_speed = INITIAL_SPEED
var ball_node

const PAD_SPEED = 100

var is_game_over = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	screen_size = get_viewport_rect().size
	print("ScreenSize=", screen_size)
	pad_size = get_node("left/left_pallete").texture.get_size()
	print("PadSize=", pad_size)
	ball_node = get_node("ball")
	set_process(true)

func _process(delta):
#	# Called every frame. Delta is time since last frame.
	if (is_game_over):
		return
	
	var ball_pos = ball_node.position
	var left_rect = Rect2(get_node("left").position - pad_size * 0.5 , pad_size)
	var right_rect = Rect2(get_node("right").position - pad_size * 0.5, pad_size)

	#print(ball_pos, left_rect, right_rect)

	if ((ball_pos.y < 0 and direction.y < 0) or (ball_pos.y > screen_size.y and direction.y > screen_size.y)):
		direction.y = -direction.y

	if (direction.x < 0):  # going left
		if (left_rect.has_point(ball_pos)):
			direction.x = -direction.x * 1.1
			direction.y += (randf() * 2 - 1) * 0.5

	if (direction.x > 0):
		if (right_rect.has_point(ball_pos)):
			direction.x = -direction.x * 1.1
			direction.y += (randf() * 2 - 1) * 0.5

	ball_pos += direction * ball_speed * delta
	ball_node.position = ball_pos
	
	var left_up = Input.is_action_pressed("left_pad_up")
	if (left_up and get_node("left").position.y > 0):
		get_node("left").position.y -= (PAD_SPEED * delta)
		
	var left_down = Input.is_action_pressed("left_pad_down")
	if (left_down and get_node("left").position.y < screen_size.y):
		get_node("left").position.y += (PAD_SPEED * delta)
		
	var right_up = Input.is_action_pressed("right_pad_up")
	if (right_up and get_node("left").position.y > 0):
		get_node("right").position.y -= (PAD_SPEED * delta)
		
	var right_down = Input.is_action_pressed("right_pad_down")
	if (right_down and get_node("left").position.y < screen_size.y):
		get_node("right").position.y += (PAD_SPEED * delta)
		
	# game over check
	if (ball_node.position.x < 0 or ball_node.position.x > screen_size.x):
		get_node("PopupMenu").visible = true
		print("Game Over!")
		is_game_over = true
