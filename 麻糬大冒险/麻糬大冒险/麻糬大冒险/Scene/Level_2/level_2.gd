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
			
			var flower:Area2D = load("res://Scene/Level_2/flower.tscn").instantiate()
			add_child(flower)
			flower.is_picked = true
			flower.global_position.x = $NPCArea/NPC1.global_position.x
			flower.global_position.y = $NPCArea/NPC1.global_position.y - 300
			
			var tw = flower.create_tween()
			tw.tween_property(flower, "global_position", $NPCArea/NPC1.global_position, 0.5)
			await tw.finished
			flower_num += 1
			

func _on_flower_basket_body_entered(body: Node2D) -> void:
	if flower_num >=3: return
	if body is Player:
		if not body.all_picked: return
		can_send_flower = true
		$NPCArea/MsgLabel.show()


func _on_flower_basket_body_exited(body: Node2D) -> void:
	$NPCArea/MsgLabel.hide()
	if flower_num >=3: return
	if body is Player:
		can_send_flower = false
		

func game_pass():
	get_tree().paused = true
	
	$NPCArea/Help.hide()
	$NPCArea/NPC1.hide()
	$NPCArea/Water.hide()
	$NPCArea/MsgLabel.hide()
	
	$NPCArea/NPC.show()
	$NPCArea/NPC/NPCAni.play("show")
	await $NPCArea/NPC/NPCAni.animation_finished
	
	$NPCArea/NPC/MsgLabel.show()
	$NPCArea/NPC/NPC.play("talk")
	$NPCArea/NPC/NPCAni.play("talk")
	$NPCArea/NPC/Audio.play()
	await $NPCArea/NPC/NPCAni.animation_finished
	
	$NPCArea/NPC/TaskItem.show()
	
	var tw = $NPCArea/NPC.create_tween()
	tw.tween_property($NPCArea/NPC/TaskItem, "global_position",  $Player.global_position, 3)
	await tw.finished
	
	get_tree().paused = false
	$UI/ChangePanel/Ani.play("change")
	await $UI/ChangePanel/Ani.animation_finished
	
	get_tree().change_scene_to_file("res://Scene/Level_3/level_3.tscn")
