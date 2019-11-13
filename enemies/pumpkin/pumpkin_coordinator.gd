extends Node2D

class_name PumpkinCoordinator

const room_to_coordinator = {}

static func get_pumpkin_coordinator(room: network.Room):
	return room_to_coordinator[room]

const ACTIVATE_TIME = 1.5

var pumpkins = []
var active_pumpkins = []
var room: network.Room

func _ready():
	room = network.get_room(position)
	room_to_coordinator[room] = self
	room.connect("first_player_entered", self, "start_timer")
	room.connect("last_player_exited", self, "stop_timer")
	$Timer.connect("timeout", self, "activate_pumpkin")
	$Timer.set_wait_time(ACTIVATE_TIME)
	call_deferred("start_timer")

func register_pumpkin(pumpkin):
	pumpkins.push_back(pumpkin)
	start_timer()

func start_timer():
	if $Timer.is_stopped() and pumpkins.size() > 0 and !room.players.empty():
		$Timer.start()

func stop_timer():
	$Timer.stop()

func activate_pumpkin():
	var pumpkin = pumpkins.pop_front()
	pumpkin.activate()
	active_pumpkins.push_back(pumpkin)
	if pumpkins.size() == 0:
		$Timer.stop()
