extends Node2D


var can_send_flower = false


var flower_num = 0:
	set(v):
		flower_num = v
		if flower_num == 3:
			game_pass()


func _ready() -> void:
	get_tree().paused = true
	$UI/Story/StoryAni.play("story")
	await $UI/Story/StoryAni.animation_finished
	get_tree().paused = false


func _process(delta: float) -> void:
	if can_send_flower and flower_num <3:
		if Input.is_action_just_pressed("pick"):
			$Player.flower_num -= 1
			%Flowers.get_child(0).queue_free()
			flower_num += 1


func _on_flower_basket_body_entered(body: Node2D) -> void:
	if flower_num >=3: return
	if body is Player:
		if not body.all_picked: return
		can_send_flower = true
		$FlowerBasket/MsgLabel.show()


func _on_flower_basket_body_exited(body: Node2D) -> void:
	$FlowerBasket/MsgLabel.hide()
	if flower_num >=3: return
	if body is Player:
		can_send_flower = false
		

func game_pass():
	$FlowerBasket/MsgLabel.hide()
	get_tree().paused = true
	$FlowerBasket/NPC.show()
	$FlowerBasket/NPC/NPCAni.play("show")
	await $FlowerBasket/NPC/NPCAni.animation_finished
	
	$FlowerBasket/NPC/MsgLabel.show()
	$FlowerBasket/NPC/NPC.play("talk")
	$FlowerBasket/NPC/NPCAni.play("talk")
	await $FlowerBasket/NPC/NPCAni.animation_finished
	
	$FlowerBasket/NPC/TaskItem.show()
	
	var tw = $FlowerBasket/NPC.create_tween()
	tw.tween_property($FlowerBasket/NPC/TaskItem, "global_position",  $Player.global_position, 3)
	await tw.finished
	
	get_tree().paused = false
	$UI/ChangePanel/Ani.play("change")
	await $UI/ChangePanel/Ani.animation_finished
	
	get_tree().change_scene_to_file("res://Scene/Level_2/level_2.tscn")
