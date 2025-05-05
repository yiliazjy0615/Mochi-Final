extends Control


func _ready() -> void:
	pass



func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	$ChangePanel/Ani.play("change")
	await $ChangePanel/Ani.animation_finished
	get_tree().change_scene_to_file("res://Scene/Level_1/Level _1.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
