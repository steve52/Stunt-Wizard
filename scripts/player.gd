extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const AIR_RESISTANCE = 2
var gravity = 490

var manaPower = 1000000
var stylePoints = 0



@onready var ui = get_parent().get_node("UI")

const SPELLS = {
	"airjet": {
		"cost": 80
	},
	"shark": {
		"cost": 100, 
		"style": {
			"dodge": 300,
			"fail": -100,
			"special": 400
		}
	},
	"explosion": {
		"cost": 70,
		"style": 100
	},
	"lightning": {
		"cost": 100,
		"style": {
			"dodge": 300,
			"fail": -100,
			"special": 300
		}
	},
	"waterjet": {
		"cost": 70
	},
	"portal": {
		"cost": 100,
		"style": {
			"dodge": 350,
			"fail": -100,
			"special": 350
		}
	},
	"leap": {
		"cost": 80
	},
	"flamingring": {
		"cost": 110,
		"style": {
			"dodge": 0,
			"fail": -150,
			"special": 500
		}
	}
}

func castSpell(spell):
	if (spell == 'airjet'):
		if manaPower >= SPELLS.airjet.cost:
			velocity.x = -2.5 * SPEED
			manaPower -= SPELLS.airjet.cost
			
	if (spell == 'leap'):
		if manaPower >= SPELLS.leap.cost:
			velocity.y = 1 * JUMP_VELOCITY
			manaPower -= SPELLS.leap.cost
			
	ui.updateMana(manaPower)
		
func launch():
	velocity.x = -3.5 * SPEED
	velocity.y = 2 * JUMP_VELOCITY
	
func getInput():
	if (GameManager.isLevelFinished()):
		return
		
	if (Input.is_action_just_pressed("airjet")):
		castSpell('airjet')
	if (Input.is_action_just_pressed("leap")):
		castSpell('leap')
	if (Input.is_key_pressed(KEY_ENTER)):
		launch()

	
func _physics_process(delta):
	if (velocity.x < 0):
		velocity.x += AIR_RESISTANCE
	elif (velocity.x > 0):
		velocity.x -= AIR_RESISTANCE
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	getInput()
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	move_and_slide()
