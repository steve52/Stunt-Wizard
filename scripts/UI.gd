extends CanvasLayer



@onready var player = $"../Player"
@onready var style = $Style
@onready var mana_points = $Mana/ManaPoints
@onready var retry = $Retry
@onready var level_complete_msg = $LevelCompleteMsg
@onready var level_failed_msg = $LevelFailedMsg
var GioScore = 8300
var SteveScore = 0
var End = -7600
var Won = false
@onready var Player = %Player
@onready var air_jet = $"HBoxContainer/Air Jet"
@onready var water_jet = $"HBoxContainer/Water Jet"
@onready var leap = $HBoxContainer/Leap
@onready var explosion = $HBoxContainer/Explosion
@onready var portal = $HBoxContainer/Portal
@onready var lightning = $HBoxContainer/Lightning
@onready var shark = $HBoxContainer/Shark
@onready var flaming_ring = $"HBoxContainer/Flaming ring"
@onready var style_point_indicator = $StylePointIndicator

const SPELL_ICON_STYLEBOX = preload("res://spell_icon_stylebox.tres")

func updateMana(newVal):
	mana_points.text = str(newVal)

func updateStyle(newVal):
	$StyleBoard/EndStyle.text = str(newVal)
	$Style.text = "Style: " + str(newVal)
	#if newVal >= GioScore or newVal >= SteveScore:
	if newVal >= GioScore:
		GameManager.DevScoreUnlocked = true
	if GameManager.DevScoreUnlocked == true:
		print('dev unlocked')
		$StyleBoard/StyleTiers.animation = "DevTimeUnlocked"
	if newVal >= 3000:
		Won = true

func setSpellManaValues():
	air_jet.text = "💨 (" + str(player.SPELLS.airjet.cost) + " MP)\n ←"
	water_jet.text = "💦 (" + str(player.SPELLS.waterjet.cost) + " MP)\n →"
	leap.text = "🤾🏻 (" + str(player.SPELLS.leap.cost) + " MP)\n ↑"
	explosion.text = "💥 (" + str(player.SPELLS.explosion.cost) + " MP)\n ↓"
	portal.text = "🟣 (" + str(player.SPELLS.portal.cost) + " MP)\n 1"
	lightning.text = "⚡️ (" + str(player.SPELLS.lightning.cost) + " MP)\n 2"
	shark.text = "🦈 (" + str(player.SPELLS.shark.cost) + " MP)\n 3"
	flaming_ring.text = "🔥 (" + str(player.SPELLS.flamingring.cost) + " MP)\n 4"

func _ready():
	level_complete_msg.visible = false
	level_failed_msg.visible = false
	retry.visible = false
	setSpellManaValues()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (GameManager.isLevelFinished()):
		retry.visible = true
		$Retry.position.y = 447
		if Won == true:
			$StyleBoard/Label.visible = true
		if GameManager.DevScoreUnlocked == true:
			$"StyleBoard/Dev Scores". visible = true
		if (GameManager.isPlayerAlive()):
			$StyleBoard.visible = true
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
	btn.add_theme_stylebox_override("normal", SPELL_ICON_STYLEBOX)
	btn.add_theme_stylebox_override("hover", SPELL_ICON_STYLEBOX)
	btn.add_theme_stylebox_override("pressed", SPELL_ICON_STYLEBOX)
	btn.add_theme_stylebox_override("focus", SPELL_ICON_STYLEBOX)
	#btn.remove_theme_stylebox_override("normal")
	#btn.remove_theme_stylebox_override("hover")

func animateButton(btn):
	# duplicate the btn stylebox so we can modify it
	var activated_stylebox_theme: StyleBoxFlat = btn.get_theme_stylebox("normal").duplicate()
	activated_stylebox_theme.bg_color = Color.ORANGE
	
	# override the btn style
	btn.add_theme_stylebox_override("normal", activated_stylebox_theme)
	btn.add_theme_stylebox_override("hover", activated_stylebox_theme)
	btn.add_theme_stylebox_override("pressed", activated_stylebox_theme)
	btn.add_theme_stylebox_override("focus", activated_stylebox_theme)
	
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


func displayStylePoints(value: int):
	var isPositive: bool = value >= 0
	var sign = "+" if isPositive else ""
	
	var label = Label.new()
	label.global_position = style_point_indicator.global_position
	label.text = sign + str(value)
	label.z_index = 5
	label.label_settings = LabelSettings.new()
	
	var color = "#0F0" if isPositive else "#F00"
	
	label.label_settings.font_color = color
	label.label_settings.font_size = 18
	label.label_settings.outline_color = "000"
	label.label_settings.outline_size = 1

	call_deferred("add_child", label)
	await label.resized
	
	label.pivot_offset = Vector2(label.size/2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		label, "position:y", label.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		label, "position:y", label.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		label, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	
	label.queue_free()
