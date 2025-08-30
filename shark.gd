extends Area2D

var JumpHeight = -50
var Velocity = Vector2(0,0)
var Gravity = 1
var StartHeight = 0
var WentUnderShark = false
var Summoned = false

func _ready():
	StartHeight = position.y
	Velocity.y = JumpHeight

func _physics_process(_delta):
	Velocity.y += Gravity
	Velocity.y = clamp(Velocity.y, -50, 50)
	position += Velocity
	if Velocity.y >= -5 and Velocity.y <= 5:
		$AnimatedSprite2D.frame = 1
	if Velocity.y > 5:
		$AnimatedSprite2D.frame = 2
	if position.y >= StartHeight and Summoned == true:
		if WentUnderShark == false:
			get_parent().get_node("Player").DodgedShark()
		queue_free()


func _on_body_entered(body):
	body.HitShark()
	self.queue_free()


func _on_under_shark_body_entered(body):
	await get_tree().create_timer(.2)
	body.UnderShark()
	monitoring = false
	$UnderShark.monitoring = false
	WentUnderShark = true

func SetStartHeight():
	StartHeight = position.y


func _on_timer_timeout():
	Summoned = true
