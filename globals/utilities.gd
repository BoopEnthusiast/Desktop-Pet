extends Node


## Checks if the given rect is inside any monitor.[br]
## [br]
## If it is inside a monitor it'll add the DisplayServer's screen index to the returned array.[br]
func monitors_rect_is_touching(rect: Rect2i) -> Array[int]:
	var monitors_inside: Array[int] = []
	for i: int in range(DisplayServer.get_screen_count()):
		var screen_usable_rect = DisplayServer.screen_get_usable_rect(i)
		if (
				rect.position.x < screen_usable_rect.end.x 
				and rect.end.x > screen_usable_rect.position.x 
				and rect.position.y < screen_usable_rect.end.y 
				and rect.end.y > screen_usable_rect.position.y
		):
			monitors_inside.append(i)
	return monitors_inside


## Checks if the given rect is inside a monitor.[br]
## [br]
## If it is inside a monitor, it'll return the monitor it is inside of.[br]
## [br]
## This is different to [method monitors_rect_is_touching] in that it must be wholly inside of a monitor, instead of just partially inside it.[br]
func monitor_rect_is_inside(rect: Rect2i) -> int:
	for i: int in range(DisplayServer.get_screen_count()):
		var screen_usable_rect = DisplayServer.screen_get_usable_rect(i)
		if (
				rect.end.x < screen_usable_rect.end.x 
				and rect.position.x > screen_usable_rect.position.x 
				and rect.end.y < screen_usable_rect.end.y 
				and rect.position.y > screen_usable_rect.position.y
		):
			return i
	return -1


## Returns true if the rect is inside a single monitor[br]
func is_inside_single_monitor(rect: Rect2i) -> bool:
	return true if monitor_rect_is_inside(rect) >= 0 else false
