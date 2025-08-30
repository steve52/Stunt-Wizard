extends CanvasLayer

@onready var player = $"../Player"

@onready var style = $Style
@onready var mana_points = $Mana/ManaPoints
@onready var retry = $Retry
@onready var level_complete_msg = $LevelCompleteMsg
@onready var level_failed_msg = $LevelFailedMsg
var End = -7600
@onready var Player = %Player
@onready var air_jet = $"HBoxContainer/Air Jet"
@onready var water_jet = $"HBoxContainer/Water Jet"
@onready var leap = $HBoxContainer/Leap
@onready var explosion = $HBoxContainer/Explosion
@onready var portal = $HBoxContainer/Portal
@onready var lightning = $HBoxContainer/Lightning
@onready var shark = $HBoxContainer/Shark
@onready var flaming_ring = $"HBoxContainer/Flaming ring"

func updateMana(newVal):
	mana_points.text = str(newVal)

func setSpellManaValues():
	air_jet.text = "Air Jet (" + str(player.SPELLS.airjet.cost) + " MP)\n ←"
	water_jet.text = "Water Jet (" + str(player.SPELLS.waterjet.cost) + " MP)\n →"
	leap.text = "Leap (" + str(player.SPELLS.leap.cost) + " MP)\n ↑"
	explosion.text = "Explosion (" + str(player.SPELLS.explosion.cost) + " MP)\n ↓"
	portal.text = "Portal (" + str(player.SPELLS.portal.cost) + " MP)\n 1"
	lightning.text = "Lightning (" + str(player.SPELLS.lightning.cost) + " MP)\n 2"
	shark.text = "Shark (" + str(player.SPELLS.shark.cost) + " MP)\n 3"
	flaming_ring.text = "Flaming Ring (" + str(player.SPELLS.flamingring.cost) + " MP)\n 4"

func _ready():
	level_complete_msg.visible = false
	level_failed_msg.visible = false
	retry.visible = false
	setSpellManaValues()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (GameManager.isLevelFinished()):
		retry.visible = true
		if (GameManager.isPlayerAlive()):
			level_complete_msg.visible = true
		else:
			level_failed_msg.visible = true

	if player.manaPower < player.SPELLS.airjet.cost:
		air_jet.disabled = true
	if player.manaPower < player.SPELLS.waterjet.cost:
		water_jet.disabled = true
	if player.manaPower < player.SPELLS.leap.cost:
		leap.disabled = true
	if player.manaPower < player.SPELLS.explosion.cost:
		explosion.disabled = true
	if player.manaPower < player.SPELLS.portal.cost:
		portal.disabled = true
	if player.manaPower < player.SPELLS.lightning.cost:
		lightning.disabled = true
	if player.manaPower < player.SPELLS.shark.cost:
		shark.disabled = true
	if player.manaPower < player.SPELLS.flamingring.cost:
		flaming_ring.disabled = true
	
	$DistanceToEndLabel.text = "Distance to landing: " + str(roundi((Player.position.x- End)/10))

func _on_retry_pressed():
	GameManager.retryLevel()
	
func castSpell(spell):
	if (spell == 'airjet'):
		animateButton(air_jet)
	elif (spell == 'waterjet'):
		animateButton(water_jet)
	elif (spell == 'leap'):
		animateButton(leap)
	elif (spell == 'explosion'):
		animateButton(explosion)
	elif (spell == 'portal'):
		animateButton(portal)
	elif (spell == 'lightning'):
		animateButton(lightning)
	elif (spell == 'shark'):
		animateButton(shark)
	elif (spell == 'flamingring'):
		animateButton(flaming_ring)
	

# return the btn to normal
func _on_timer_timeout(btn) -> void:
	btn.remove_theme_stylebox_override("normal")
	btn.remove_theme_stylebox_override("hover")

func animateButton(btn):
	# duplicate the btn stylebox so we can modify it
	var activated_stylebox_theme: StyleBoxFlat = btn.get_theme_stylebox("normal").duplicate()
	activated_stylebox_theme.bg_color = Color.ORANGE
	
	# override the btn style
	btn.add_theme_stylebox_override("normal", activated_stylebox_theme)
	btn.add_theme_stylebox_override("hover", activated_stylebox_theme)
	
	# start a timer for returning to normal
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 1.0
	timer.start()
	timer.timeout.connect(_on_timer_timeout.bind(btn))



func _on_air_jet_pressed():
	player.castSpell('airjet')

func _on_water_jet_pressed():
	player.castSpell('waterjet')


func _on_leap_pressed():
	player.castSpell('leap')

func _on_explosion_pressed():
	player.castSpell('explosion')

func _on_portal_pressed():
	player.castSpell('portal')

func _on_lightning_pressed():
	player.castSpell('lightning')

func _on_shark_pressed():
	player.castSpell('shark')

func _on_flaming_ring_pressed():
	player.castSpell('flamingring')
