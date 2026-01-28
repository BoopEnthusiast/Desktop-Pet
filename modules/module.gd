@abstract
class_name Module
extends Window


## The method used for scaling
enum ScalingMode {
	## Doesn't do any scaling, it's up to you
	NO_SCALING,
	## Covers all screens as a rectangle. This includes areas not available on the screens
	ALL_SCREENS,
	## Makes the window cover the full [member screen] excluding the taskbar
	USABLE,
	## Stick to the bottom of the [member screen]
	BOTTOM,
	## Stick to the top of the [member screen]
	TOP,
	## Stick to the left of the [member screen]
	LEFT,
	## Stick to the right of the [member screen]
	RIGHT,
}

## The name of the module in the system
@export var module_title: String = "New Module Title"
## The list of settings you want to appear on the settings page in the main screen
@export var module_settings: Array[ModuleSetting]
@export_group("Scaling", "scaling_")
## The way it changes the size of the window automatically. This assumes [member Window.unresizable] is true
@export var scaling_mode: ScalingMode = ScalingMode.NO_SCALING
## Which screen to use [member scaling_mode] if the mode uses it.[br]
## [br]
## The constants [constant DisplayServer.SCREEN_OF_MAIN_WINDOW],
## [constant DisplayServer.SCREEN_OF_MAIN_WINDOW],
## [constant DisplayServer.SCREEN_PRIMARY], 
## [constant DisplayServer.SCREEN_WITH_MOUSE_FOCUS],
## or [constant DisplayServer.SCREEN_WITH_KEYBOARD_FOCUS]
## are also available to be used.
@export_range(-4, 3, 1.0, "or_greater") var scaling_screen: int = -1


func _init() -> void:
	close_requested.connect(update_window)
	focus_entered.connect(update_window)
	focus_exited.connect(update_window)
	mouse_entered.connect(update_window)
	mouse_exited.connect(update_window)
	ready.connect(update_window)
	size_changed.connect(update_window)


func _ready() -> void:
	Config.updated_video_config.connect(_on_updated_video_config)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		Nodes.menu.show_self()


func _on_updated_video_config() -> void:
	msaa_2d = Config.video_config_file.get_value("Video", "msaa", msaa_2d)
	screen_space_aa = Config.video_config_file.get_value("Video", "ssaa", screen_space_aa)


## Called during
## [signal Window.close_requested],
## [signal Window.focus_entered],
## [signal Window.focus_exited],
## [signal Window.mouse_entered],
## [signal Window.mouse_exited],
## and [signal Node.ready].[br]
## It updates the size of the window when it could be needed.
func update_window() -> void:
	# Update the window
	match scaling_mode:
		ScalingMode.ALL_SCREENS:
			pass
		ScalingMode.USABLE:
			size = DisplayServer.screen_get_usable_rect(scaling_screen).size
		ScalingMode.BOTTOM:
			pass
		ScalingMode.TOP:
			pass
		ScalingMode.LEFT:
			pass
		ScalingMode.RIGHT:
			pass
