extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const AIR_RESISTANCE = 4
var gravity = 490
var SpellsAvailable = false
var manaPower = 200
var Started = false
var stylePoints = 0
var End = -7600
const PORTAL = preload("res://scenes/portal.tscn")
const LIGHTNING = preload("res://scenes/lightning.tscn")
const FLAMING_RING = preload("res://scenes/flaming_ring.tscn")
const SHARK = preload("res://shark.tscn")

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
			"dodge": 350,
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
	if SpellsAvailable == true:
		if (spell == 'airjet'):
			if manaPower >= SPELLS.airjet.cost:
				velocity.x += -1.5 * SPEED
				manaPower -= SPELLS.airjet.cost
				$AnimatedSprite2D.animation = "AirJet"
				$SpellEnd.start()
				ui.castSpell(spell)
				%AirJetSound.pitch_scale = randf_range(.95, 1.1)
				%AirJetSound.play()
		if (spell == 'leap'):
			if manaPower >= SPELLS.leap.cost:
				if velocity.y <= 0:
					velocity.y += 1 * JUMP_VELOCITY
				else:
					velocity.y = 1 * JUMP_VELOCITY
				$AnimatedSprite2D.play("Leap")
				manaPower -= SPELLS.leap.cost
				$SpellEnd.start()
				ui.castSpell(spell)
				%LeapSound.pitch_scale = randf_range(.95, 1.1)
				%LeapSound.play()
		if (spell == 'waterjet'):
			if manaPower >= SPELLS.waterjet.cost:
				velocity.x += 1 * SPEED
				manaPower -= SPELLS.waterjet.cost
				$AnimatedSprite2D.animation = "WaterJet"
				$SpellEnd.start()
				ui.castSpell(spell)
				%WaterJetSound.pitch_scale = randf_range(.95, 1.1)
				%WaterJetSound.play()
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
				ui.castSpell(spell)
				%ExplosionSound.pitch_scale = randf_range(.95, 1.1)
				%ExplosionSound.play()
				stylePoints += SPELLS.explosion.style
		if (spell == 'portal'):
			if manaPower >= SPELLS.portal.cost:
				SpawnPortal()
				$AnimatedSprite2D.animation = "Portal"
				$SpellEnd.start()
				ui.castSpell(spell)
				manaPower -= SPELLS.portal.cost
				%PortalSound.play()
		if (spell == 'lightning'):
			if manaPower >= SPELLS.lightning.cost:
				print("lightning")
				$AnimatedSprite2D.animation = "Lightning"
				SpawnLightning()
				$SpellEnd.start()
				ui.castSpell(spell)
				manaPower -= SPELLS.lightning.cost
				%LightningSound.play()
		if (spell == 'shark'):
			if manaPower >= SPELLS.shark.cost:
				print("shark")
				$AnimatedSprite2D.animation = "Shark"
				SpawnShark()
				$SpellEnd.start()
				ui.castSpell(spell)
				manaPower -= SPELLS.shark.cost
				%SharkSound.play()
		if (spell == 'flamingring'):
			if manaPower >= SPELLS.flamingring.cost:
				print("flamingring")
				SpawnFlamingRing()
				$AnimatedSprite2D.animation = "FlamingRing"
				$SpellEnd.start()
				ui.castSpell(spell)
				manaPower -= SPELLS.flamingring.cost
				%FlamingRingSound.play()
		ui.updateMana(manaPower)

func launch():
	if Started == false:
		velocity.x = -3.5 * SPEED
		velocity.y = 2 * JUMP_VELOCITY
		$AnimatedSprite2D.frame = 1
		SpellsAvailable = true
		%JumpStartSound.play()
		Started = true

func getInput():
	if (GameManager.isLevelFinished()):
		return
	if (Input.is_action_just_pressed("A")):
		velocity.y += 1000
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
	ui.updateStyle(stylePoints)
	if manaPower < 7:
		print(position.x)
	if (velocity.x < 0):
		velocity.x += AIR_RESISTANCE
	elif (velocity.x > 0):
		velocity.x -= AIR_RESISTANCE
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	getInput()
	move_and_slide()

func SpawnFlamingRing():
	var Ring = FLAMING_RING.instantiate()
	var RingX = position.x - 300
	var RingY = position.y + randf_range(-50, 50)
	get_parent().add_child(Ring)
	Ring.position = Vector2(RingX, RingY)

func DodgedFlamingRing():
	print("Dodged Ring")
	stylePoints += SPELLS.flamingring.style.dodge

func HitFlamingRing():
	velocity.x = 100
	velocity.y = 100
	$AnimatedSprite2D.animation = "Fall"
	$SpellEnd.start()
	%HitObstacleSound.play()
	stylePoints += SPELLS.flamingring.style.fail

func WentThroughFlamingRing():
	print("Went through the ring!!!")
	stylePoints += SPELLS.flamingring.style.special
	#Add special score here when adding score points

func SpawnShark():
	var Shark = SHARK.instantiate()
	var SharkX = position.x - 550
	var SharkY = position.y + 900
	get_parent().add_child(Shark)
	Shark.position = Vector2(SharkX, SharkY)
	Shark.SetStartHeight()

func HitShark():
	velocity.x = -50
	velocity.y = 100
	$AnimatedSprite2D.animation = "Fall"
	%HitObstacleSound.play()
	stylePoints += SPELLS.shark.style.fail

func UnderShark():
	print("Under The Shark!!!!")
	stylePoints += SPELLS.shark.style.special
	#Special score here

func DodgedShark():
	stylePoints += SPELLS.shark.style.dodge
	print("Dodged Shark")

func SpawnLightning():
	var Lightning = LIGHTNING.instantiate()
	var LightningX = position.x + velocity.x * .6
	var LightningY = position.y - 100
	get_parent().add_child(Lightning)
	Lightning.position.x = LightningX
	Lightning.position.y = LightningY
	print(Lightning.position)
	print(position)

func DodgeLightning():
	print("Dodged Lightning")
	stylePoints += SPELLS.lightning.style.dodge

func LightningHit():
	velocity.y = 100
	velocity.x /= 2
	$AnimatedSprite2D.animation = "Fall"
	$SpellEnd.start()
	%HitObstacleSound.play()
	stylePoints += SPELLS.lightning.style.fail

func SpawnPortal():
	var Portal = PORTAL.instantiate()
	var PortalPositionX = position.x - 300
	var PortalPositionY = position.y + randf_range(-50, 50)
	get_parent().add_child(Portal)
	Portal.position.x = PortalPositionX
	Portal.position.y = PortalPositionY

func PortalDodge():
	print("Dodged Portal")
	stylePoints += SPELLS.portal.style.dodge

func EnterPortal():
	position.y = position.y + 300
	velocity.y = -1 * velocity.x
	velocity.x = 0
	$AnimatedSprite2D.play("PortalExit")
	$SpellEnd.start()
	%EnterPortalSound.play()
	stylePoints += SPELLS.portal.style.fail

func _on_spell_end_timeout():
	$AnimatedSprite2D.animation = "WizardBase"


func _on_static_body_2d_body_entered(body):
	velocity.y = 1000
	velocity.x = 0
	SpellsAvailable = false

func Landed():
	$AnimatedSprite2D.play("Win")
	stylePoints += 1000
