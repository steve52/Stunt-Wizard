extends Node

enum {NOT_STARTED, STARTED, FINISHED}
enum {ALIVE, DEAD}

var DevScoreUnlocked = false
var levelState = NOT_STARTED
var playerState = ALIVE

func enteredLandingZone():
	levelState = FINISHED

func enteredFallingZone():
	levelState = FINISHED
	playerState = DEAD

func isPlayerAlive():
	return playerState == ALIVE
	
func isLevelFinished():
	return levelState == FINISHED

func retryLevel():
	playerState = ALIVE
	levelState = NOT_STARTED
	get_tree().reload_current_scene()

func startGame():
	get_tree().change_scene_to_file("res://scenes/gap_jump_stunt.tscn")
