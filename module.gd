class_name Module
extends Window


func _init() -> void:
	print("Initialized module")


func _ready() -> void:
	Config.updated_video_config.connect(_on_updated_video_config)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		Nodes.menu.visible = true


func _on_updated_video_config() -> void:
	msaa_2d = Config.video_config_file.get_value("Video", "msaa", msaa_2d)
	screen_space_aa = Config.video_config_file.get_value("Video", "ssaa", screen_space_aa)
