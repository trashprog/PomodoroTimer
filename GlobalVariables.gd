extends Node

var WorkTimerPaused = true
var BreakTimerPaused = true

var WorkTimerMinutes = 30: set = set_time
var BreakTimerMinutes =  floor(WorkTimerMinutes/4): get = get_break_time

func set_time(time):
	WorkTimerMinutes = max(20, time)
	BreakTimerMinutes = floor(WorkTimerMinutes/4)

func get_break_time():
	return BreakTimerMinutes
	

var Loop = -1
