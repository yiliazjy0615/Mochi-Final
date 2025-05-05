extends Area2D



@export var is_picked = false
@export var can_pick = false

var player


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if is_picked: return
	if can_pick:
		if Input.is_action_pressed("pick"):
			$Msg/MsgAni.speed_scale = 10.0
			$Prog.value += 1
		if Input.is_action_just_released("pick"):
			$Msg/MsgAni.speed_scale = 0.0
			$Prog.value = 0


func _on_body_entered(body: Node2D) -> void:
	if is_picked: return
	if body is Player:
		$Msg.show()
		$Prog.show()
		can_pick = true
		player = body
		


func _on_body_exited(body: Node2D) -> void:
	$Prog.hide()
	$Msg.hide()
	can_pick = false
	$Prog.value = 0
	

func pick_up():
	is_picked = true
	show()
	$Audio.play()
	await flash()
	
	reparent(player.get_parent().get_node("UI"))
	var pos = get_viewport().canvas_transform * global_position
	position = pos
	
	# 获取 Control 节点的全局位置（基于视口）
	var target_node = player.get_parent().get_node("%Flowers")
	var target_position:Vector2 = target_node.global_position  # 取中心点

	var tw = create_tween()
	tw.tween_property(self, "position", target_position, 0.5)
	await tw.finished
	player.flower_num += 1
	queue_free()


func flash():
	$AnimationPlayer.play("flash")
	await $AnimationPlayer.animation_finished


func _on_prog_value_changed(value: float) -> void:
	if is_picked: return
	if value == $Prog.max_value:
		$Msg.hide()
		$Prog.hide()
		pick_up()
