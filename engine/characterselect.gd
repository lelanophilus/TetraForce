extends Panel

onready var selected: int = settings.get_pref("skin")
onready var player_name: String = settings.get_pref("display_name")

var options = {
	"Chain": "res://player/player.png",
	"Knot": "res://player/player2.png",
}

func _ready():
	$back.connect("pressed", self, "back_pressed")
	$forward.connect("pressed", self, "forward_pressed")
	
	$name.text = player_name
	update_skin(settings.get_pref("skin"))

func update_skin(new_selection: int):
	selected = wrapi(new_selection, 0, options.size())
	
	$preview.texture = load(options.values()[selected])
	network.my_player_data.skin = options.values()[selected]
	
	settings.set_pref("skin", selected)
	
	if settings.get_pref("display_name").length() == 0:
		player_name = options.keys()[selected]
		$name.text = player_name
	
func back_pressed():
	update_skin(selected - 1)

func forward_pressed():
	update_skin(selected + 1)

func _on_name_text_changed(new_name: String):
	if new_name.length() == 0:
		player_name = options.keys()[selected]
	else:
		player_name = new_name
		
	settings.set_pref("display_name", new_name)
