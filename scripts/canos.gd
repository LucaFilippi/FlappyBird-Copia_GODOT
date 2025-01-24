extends Area2D


var velocity = Vector2.ZERO
const speed = 90
const direction = Vector2.LEFT

signal scoreUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Singleton.isGamePlayed == true: 
		velocity = direction * speed
		position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("PlayerBird"):
		emit_signal("scoreUp")
