extends Area2D


func _on_dodge_area_body_entered(body):
	self.monitoring = false


func _on_body_entered(body):
	body.LightningHit()
	self.queue_free()


func _on_timer_timeout():
	get_parent().get_node("Player").DodgeLightning()
	self.queue_free()


func _on_animated_sprite_2d_frame_changed():
	$CollisionShape2D.disabled = false
