extends Node2D

@onready var label = $Label
@onready var timer = $Timer
@onready var break_time_sound = $BREAKTIME

func _ready():
	timer.wait_time = GlobalVariables.BreakTimerMinutes * 60
	label.text = "%02d:%02d" % [GlobalVariables.BreakTimerMinutes, 0]
	
func start_timer():
	if !GlobalVariables.BreakTimerPaused:
		timer.start()
	else:
		timer.stop()
		

#this function responds when the work timer finishes
func _on_work_timer_timeout() -> void:
	print("Work timer finished! Switching to break timer.")
	print("Before switch: WorkTimerPaused =", GlobalVariables.WorkTimerPaused, 
		  "BreakTimerPaused =", GlobalVariables.BreakTimerPaused)
	GlobalVariables.WorkTimerPaused = !GlobalVariables.WorkTimerPaused
	GlobalVariables.BreakTimerPaused = !GlobalVariables.BreakTimerPaused
	break_time_sound.play()
	start_timer()
	
	
func _time_left():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]


func _process(_delta):
	if GlobalVariables.BreakTimerPaused:
		label.text = "%02d:%02d" % [GlobalVariables.BreakTimerMinutes, 0]
	else:
		label.text = "%02d:%02d" % _time_left()
