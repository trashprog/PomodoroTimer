extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -450.0

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var work_timer = $"../WorkTimer"
@onready var break_timer = $"../BreakTimer"
@onready var sword_swing_sound = $"AudioStreamPlayer2D-SwordSwing"
@onready var sword_start_timer = $"AudioStreamPlayer2D-SwordStartTimer"
@onready var sword_edit_timer = $"AudioStreamPlayer2D-SwordEditTimer"
@onready var start_timer_animation = $"../StartStopTimer/AnimatedSprite2D"
@onready var increase_timer_animation = $"../IncreaseWorkTimer/AnimatedSprite2D"
@onready var decrease_timer_animation = $"../DecreaseWorkTimer/AnimatedSprite2D"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#check if start timer is hit and other stuff
var start_timer_hit = false
var increase_timer_destroyed = false
var decrease_timer_destroyed = false

#attacking
var isatk = false
	
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction (input_axis) and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_axis = Input.get_axis("ui_left", "ui_right")
	if input_axis:
		velocity.x = input_axis * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("attack") && !isatk:
		var overlapping_objects = $Attack2D.get_overlapping_areas()
		if overlapping_objects == []:
			sword_swing_sound.play()
		else:
			for area in overlapping_objects:
				#var parent = area.get_parent()
				if area.name == "StartStopTimer":
					sword_start_timer.play()
					GlobalVariables.WorkTimerPaused = !GlobalVariables.WorkTimerPaused
					GlobalVariables.BreakTimerPaused = true
					work_timer.call("start_timer")
					break_timer.call("start_timer")
					start_timer_hit = true
				elif area.name in ["IncreaseWorkTimer", "DecreaseWorkTimer"]:
					sword_edit_timer.play()
					var change = 5 if area.name == "IncreaseWorkTimer" else -5
					
					if !GlobalVariables.WorkTimerPaused:
						GlobalVariables.WorkTimerPaused = true
						GlobalVariables.BreakTimerPaused = true
						work_timer.call("start_timer")
						break_timer.call("start_timer")
						
					GlobalVariables.WorkTimerMinutes += change
					work_timer.call("update_timer")
					break_timer.call("start_timer")
					
					if area.name == "IncreaseWorkTimer":
						increase_timer_animation.play("destroyed")
						increase_timer_destroyed = true
					elif area.name == "DecreaseWorkTimer":
						decrease_timer_animation.play("destroyed")
						decrease_timer_destroyed = true
						
		animated_sprite_2d.play("attack")
		isatk=true

	move_and_slide()
	update_animations(input_axis)
	
	#reset_player_position()
	
#func reset_player_position():
	## used only for demonstration purposes.
	#if global_position.y > 500:
		#animated_sprite_2d.play("hurt")
		#global_position = Vector2(100, 100)


func update_animations(input_axis):
	if isatk:
		return
	if increase_timer_destroyed:
		increase_timer_animation.play("Restored")
		increase_timer_destroyed = false
	if decrease_timer_destroyed:
		decrease_timer_animation.play("Restored")
		decrease_timer_destroyed = false
	if start_timer_hit:
		start_timer_animation.play()
		start_timer_hit = false
	if input_axis < 0:
		animated_sprite_2d.flip_h = true
		$Attack2D.scale.x = -1
	elif input_axis > 0:
		animated_sprite_2d.flip_h = false
		$Attack2D.scale.x = 1
	
		
	if is_on_floor():
		if input_axis != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	else:	# is on air
		if velocity.y > 0:
			animated_sprite_2d.play("fall")
		else:
			animated_sprite_2d.play("jump")
	
func _on_attacking_animation_finished() -> void:
	if animated_sprite_2d.animation == "attack":
		isatk = false  # Reset attack state	
