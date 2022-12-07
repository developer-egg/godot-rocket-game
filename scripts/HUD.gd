extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	
	# wait till the message timer is done
	yield($MessageTimer, "timeout")
	
	show_message("Starting Again!\nGet Ready!")
	
	# create a timer for 1 second
	yield(get_tree().create_timer(1), "timeout")
	
	emit_signal("start_game")
	
func initial_start():
	show_message("Get Ready!")

func update_score(score):
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed():
	$StartButton.hide()
	$Message.hide()
	$ControlsMessage.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$Message.hide()
