extends Enemy

func _init():
	TYPE = "TRAP"
	spritedir = ""

func _ready():
	pass

func _on_update_animation(value):
	rset_map("puppet_anim", value)

func puppet_update():
	if anim.current_animation != puppet_anim:
		anim.play(puppet_anim)

func _process(delta):
	loop_network()
