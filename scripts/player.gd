extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const AIR_RESISTANCE = 4
var gravity = 490
var SpellsAvailable = true
var manaPower = 1000000
var stylePoints = 0

const PORTAL = preload("res://scenes/portal.tscn")
const LIGHTNING = preload("res://scenes/lightning.tscn")

@onready var ui = get_parent().get_node("UI")

const SPELLS = {
	"airjet": {
		"cost": 8
	},
	"shark": {
		"cost": 10, 
		"style": {
			"dodge": 300,
			"fail": -100,
			"special": 400
		}
	},
	"explosion": {
		"cost": 7,
		"style": 100
	},
	"lightning": {
		"cost": 10,
		"style": {
			"dodge": 300,
			"fail": -100,
			"special": 300
		}
	},
	"waterjet": {
		"cost": 7
	},
	"portal": {
		"cost": 10,
		"style": {
			"dodge": 350,
			"fail": -100,
			"special": 350
		}
	},
	"leap": {
		"cost": 8
	},
	"flamingring": {
		"cost": 11,
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
			velocity.x += -1.5 * SPEED
			manaPower -= SPELLS.airjet.cost
			$AnimatedSprite2D.animation = "AirJet"
			$SpellEnd.start()
	if (spell == 'leap'):
		if manaPower >= SPELLS.leap.cost:
			if velocity.y <= 0:
				velocity.y += 1 * JUMP_VELOCITY
			else:
				velocity.y = 1 * JUMP_VELOCITY
			$AnimatedSprite2D.play("Leap")
			manaPower -= SPELLS.leap.cost
			$SpellEnd.start()
	if (spell == 'waterjet'):
		if manaPower >= SPELLS.waterjet.cost:
			velocity.x += 1 * SPEED
			manaPower -= SPELLS.waterjet.cost
			$SpellEnd.start()
	if (spell == 'explosion'):
		if manaPower >= SPELLS.explosion.cost:
			if velocity.y <= 0:
				velocity.y += randf_range(1.25, 1.75) * JUMP_VELOCITY
			else:
				velocity.y = randf_range(1.25, 1.75) * JUMP_VELOCITY
			velocity.x += randf_range(-2.75, -2.25) * SPEED
			manaPower -= SPELLS.explosion.cost
			$AnimatedSprite2D.play("Explosion")
			$SpellEnd.start()
	if (spell == 'portal'):
		if manaPower >= SPELLS.portal.cost:
			SpawnPortal()
			$AnimatedSprite2D.animation = "Portal"
			$SpellEnd.start()
	if (spell == 'lightning'):
		if manaPower >= SPELLS.lightning.cost:
			print("lightning")
			$AnimatedSprite2D.animation = "Lightning"
			SpawnLightning()
			$SpellEnd.start()
	if (spell == 'shark'):
		if manaPower >= SPELLS.shark.cost:
			print("shark")
			$AnimatedSprite2D.animation = "Shark"
			$SpellEnd.start()
	if (spell == 'flamingring'):
		if manaPower >= SPELLS.flamingring.cost:
			print("flamingring")
			$AnimatedSprite2D.animation = "FlamingRing"
			$SpellEnd.start()
	ui.updateMana(manaPower)

func launch():
	velocity.x = -3.5 * SPEED
	velocity.y = 2 * JUMP_VELOCITY
	$AnimatedSprite2D.frame = 1
func getInput():
	if (GameManager.isLevelFinished()):
		return
		
	if (Input.is_action_just_pressed("airjet")):
		castSpell('airjet')
	if (Input.is_action_just_pressed("leap")):
		castSpell('leap')
	if (Input.is_action_just_pressed("waterjet")):
		castSpell('waterjet')
	if (Input.is_action_just_pressed("explosion")):
		castSpell('explosion')
	if (Input.is_action_just_pressed("portal")):
		castSpell('portal')
	if (Input.is_action_just_pressed("lightning")):
		castSpell('lightning')
	if (Input.is_action_just_pressed("shark")):
		castSpell('shark')
	if (Input.is_action_just_pressed("flamingring")):
		castSpell('flamingring')
	if (Input.is_key_pressed(KEY_ENTER)):
		launch()

	
func _physics_process(delta):
	if (velocity.x < 0):
		velocity.x += AIR_RESISTANCE
	elif (velocity.x > 0):
		velocity.x -= AIR_RESISTANCE
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	getInput()
	move_and_slide()

func SpawnLightning():
	var Lightning = LIGHTNING.instantiate()
	var LightningX = position.x + velocity.x * .5
	var LightningY = position.y - 100
	get_parent().add_child(Lightning)
	Lightning.position.x = LightningX
	Lightning.position.y = LightningY
	print(Lightning.position)
	print(position)

func DodgeLightning():
	print("Dodged Lightning")

func LightningHit():
	velocity.y = 100
	velocity.x /= 2

func SpawnPortal():
	var Portal = PORTAL.instantiate()
	var PortalPositionX = position.x - 300
	var PortalPositionY = position.y + randf_range(-100, 100)
	get_parent().add_child(Portal)
	Portal.position.x = PortalPositionX
	Portal.position.y = PortalPositionY

func PortalDodge():
	print("Dodged Portal")

func EnterPortal():
	position.y = position.y + 300
	velocity.y = -1 * velocity.x
	velocity.x = 0
	$AnimatedSprite2D.animation = "PortalExit"
	$SpellEnd.start()

func _on_spell_end_timeout():
	$AnimatedSprite2D.animation = "WizardBase"
