extends Node2D



func _ready() -> void:
	pass



func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var ball = load("res://Scene/Level_2/ball.tscn").instantiate()
	add_child(ball)
	ball.position.x = randi_range(10, 3500)
	ball.add_constant_force(Vector2(1, 0), Vector2(0, 0))
