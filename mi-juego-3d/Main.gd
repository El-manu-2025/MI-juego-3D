extends Node

@export var mob_scene: PackedScene


func _ready():
	if RenderingServer.get_current_rendering_method() == "gl_compatibility":
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)

		$DirectionalLight3D.sky_mode = DirectionalLight3D.SKY_MODE_SKY_ONLY
		var new_light: DirectionalLight3D = $DirectionalLight3D.duplicate()
		new_light.light_energy = 0.35
		new_light.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_ONLY
		add_child(new_light)


	$UserInterface/Retry.hide()


func _unhandled_input(event):
	if event.is_action_pressed(&"ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()

	
	var mob_spawn_location = get_node(^"SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)

	add_child(mob) 
	mob.squashed.connect($UserInterface/ScoreLabel._on_Mob_squashed)


func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
