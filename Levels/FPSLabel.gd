extends Label

func _process(_delta) -> void:
	set_text("FPS " + str(Engine.get_frames_per_second()))
