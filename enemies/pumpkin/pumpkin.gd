extends Enemy

class_name Pumpkin

func _init():
	spritedir = ""
	knockdir_speed = 0

func _physics_process(delta):
	if !is_scene_owner() || is_dead():
		return
	
	loop_movement()
	loop_damage()
	
	if is_on_wall():
		update_health(-health)
		check_for_death()

func _ready():
	if is_scene_owner():
		var coordinator = get_pumpkin_coordinator(room)
		coordinator.register_pumpkin(self)
		anim.connect("animation_finished", self, "pumpkin_attack")
	puppet_pos = position
	puppet_anim = "idle"
	anim_switch("idle")

func pumpkin_attack(anim_name):
	if is_scene_owner() and anim_name == "levitate":
		print("is scene owner")
		var players = room.players.values()
		var player = players[randi() % players.size()]
		movedir = (player.global_position - global_position).normalized()

func activate():
	print("activating pumpkin ", get_instance_id())
	anim_switch("levitate")

func puppet_update():
	if anim.current_animation != puppet_anim:
		anim.play(puppet_anim)

func _process(delta):
	loop_network()


# Pumpkin Coordinator Coordinator 
const room_to_coordinator = {}

func get_pumpkin_coordinator(room: network.Room):
	if !room_to_coordinator.has(room):
		room_to_coordinator[room] = PumpkinCoordinator.new(room)
	var coordinator = room_to_coordinator[room]
	get_tree().get_root().add_child(coordinator)
	return coordinator


const ACTIVATE_TIME = 1.5

class PumpkinCoordinator extends Node2D:
	var pumpkins = []
	var active_pumpkins = []
	
	var timer = Timer.new()
	
	func _init(room: network.Room):
		room.connect("first_player_entered", self, "start_timer")
		room.connect("last_player_exited", self, "stop_timer")
		timer.connect("timeout", self, "activate_pumpkin")
		timer.set_wait_time(ACTIVATE_TIME)
		add_child(timer)
		if !room.players.empty():
			call_deferred("start_timer")
	
	func register_pumpkin(pumpkin: Pumpkin):
		pumpkins.push_back(pumpkin)
	
	func start_timer():
		if pumpkins.size() > 0:
			timer.start()
	
	func stop_timer():
		timer.stop()
	
	func activate_pumpkin():
		var pumpkin = pumpkins.pop_front()
		pumpkin.activate()
		active_pumpkins.push_back(pumpkin)
		if pumpkins.size() == 0:
			timer.stop()
