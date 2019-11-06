extends Enemy

class_name Pumpkin

const room_to_pumpkins = {}

func _init():
	spritedir = ""

func _ready():
	if is_scene_owner():
		register_pumpkin()
	puppet_pos = position
	puppet_anim = "idle"
	anim_switch("idle")
	connect("update_animation", self, "_on_update_animation")

func register_pumpkin():
	var room: network.Room = network.get_room(position)
	if !room_to_pumpkins.has(room):
		room_to_pumpkins[room] = {}
		room.connect("first_player_entered", self, "arm")
		room.connect("last_player_exited", self, "disarm")
	var pumpkins: Dictionary = room_to_pumpkins[room]
	pumpkins[get_instance_id()] = true

func arm():
	print("arming ")
	pass

func disarm():
	print("disarming ")
	pass

func _on_update_animation(value):
	rset_map("puppet_anim", value)

func puppet_update():
	if anim.current_animation != puppet_anim:
		anim.play(puppet_anim)

func _process(delta):
	loop_network()
