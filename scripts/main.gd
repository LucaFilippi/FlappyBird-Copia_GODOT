extends Node2D

signal Didtouch

var didStartGame: bool = false #checa se o jogo esta iniciado 
var spr_floor: Sprite2D
var score: int = 0
@onready var tutorial = $tutorial
@onready var GameOver_banner = $GameOver
@onready var game_floor = $Floor
@onready var restart_button = $restart_button
@onready var score_label = $Score
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spr_floor = game_floor.get_node("%spr_floor")
	spr_floor.material.set_shader_parameter("speed" , 0.28)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_touch_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("Didtouch")
		if didStartGame == false:
			didStartGame = true 
			Singleton.isGamePlayed = true
			StartGame()
			pipes_generator()
		
func StartGame(): 
	tutorial.visible = false
	
func GameOver():
	GameOver_banner.visible = true
	spr_floor.material.set_shader_parameter("speed" , 0.0)
	restart_button.visible = true
	Singleton.isGamePlayed = false


func _on_player_bird_justdied() -> void:
	GameOver()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
	
func pipes_generator():
	var pipe = preload("res://scenes/canos.tscn").instantiate()
	pipe.position = Vector2(320, randf_range(95, 305))
	pipe.connect("scoreUp", scoreUp)
	call_deferred("add_child", pipe) # Same as add_chield("pipe") | o mesmo que add_chield("pipe")
	pipe.z_index = -1
	timer.start()
	
func scoreUp ():
	score += 1
	score_label.text = str(score)


func _on_timer_timeout() -> void:
	if didStartGame: 
		pipes_generator()


func _on_canos_clear_area_entered(area: Area2D) -> void:
	area.queue_free()
