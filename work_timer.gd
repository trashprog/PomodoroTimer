extends Node2D

@onready var label = $Label
@onready var timer = $Timer
@onready var GET_BACK_TO_WORK = $GETBACKTOWORK

func _ready():
	timer.wait_time = GlobalVariables.WorkTimerMinutes * 60
	label.text = "%02d:%02d" % [GlobalVariables.WorkTimerMinutes, 0]

func start_timer():
	if !GlobalVariables.WorkTimerPaused:
		timer.start()
	else:
		timer.stop()

#this function responds when the break timer finishes
func _on_break_timer_timeout() -> void:
	print("Break timer finished! Switching to work timer.")
	print("Before switch: WorkTimerPaused =", GlobalVariables.WorkTimerPaused, 
		  "BreakTimerPaused =", GlobalVariables.BreakTimerPaused)
	GlobalVariables.WorkTimerPaused = !GlobalVariables.WorkTimerPaused
	GlobalVariables.BreakTimerPaused = !GlobalVariables.BreakTimerPaused
	GET_BACK_TO_WORK.play()
	start_timer()
	

func _time_left():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]
	
func update_timer():
	timer.wait_time = GlobalVariables.WorkTimerMinutes * 60
	
func _process(_delta):
	if GlobalVariables.WorkTimerPaused:
		label.text = "%02d:%02d" % [GlobalVariables.WorkTimerMinutes, 0]
	else:
		label.text = "%02d:%02d" % _time_left()
	
