extends CharacterBody2D
class_name Player

@export var limit_right:int = 3500


const SPEED = 250.0
const JUMP_VELOCITY = -500.0


var flower_num = 0:
	set(v):
		if v <= 3:
			flower_num = v
			for i in flower_num:
				%Flowers.get_children()[i].self_modulate = "ffffff"
			if flower_num == 3:
				all_picked = true
				

var all_picked = false


func _ready() -> void:
	$Camera2D.limit_right = limit_right


func _physics_process(delta: float) -> void:
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		$Audio.play()
		velocity.y = JUMP_VELOCITY
		if velocity.x >0:
			$Animation.flip_h = true
		elif  velocity.x <0:
			$Animation.flip_h = false

	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
		if velocity.x >0:
			$Animation.flip_h = true
		elif  velocity.x <0:
			$Animation.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
