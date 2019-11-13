extends Enemy

class_name Pumpkin

var pumpkin_coordinator = preload("res://enemies/pumpkin/pumpkin_coordinator.gd")

func _init():
	spritedir = ""
	knockdir_speed = 0

func _ready():
	puppet_pos = position
	puppet_anim = "idle"
	call_deferred("finalize_pumpkin")

func finalize_pumpkin():
	if is_scene_owner():
		var coordinator = pumpkin_coordinator.get_pumpkin_coordinator(room)
		if coordinator:
			coordinator.register_pumpkin(self)
			anim.connect("animation_finished", self, "pumpkin_attack")
			print("REGISTERED PUMPKIN")
		else:
			print("No coordinator")

func _physics_process(delta):
	if !is_scene_owner() || is_dead():
		return
	
	loop_movement()
	loop_damage()
	
	if is_on_wall():
		update_health(-health)
		check_for_death()

func pumpkin_attack(anim_name):
	if is_scene_owner() and anim_name == "levitate":
		var players = room.players.values()
		var player = players[randi() % players.size()]
		movedir = (player.global_position - global_position).normalized()
		anim_switch("attack")

func activate():
	print("activating pumpkin ", get_instance_id())
	anim_switch("levitate")

func puppet_update():
	if anim.current_animation != puppet_anim:
		anim.play(puppet_anim)

func _process(delta):
	loop_network()
