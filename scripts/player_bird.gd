extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -350.0

signal Justdied #dispara o sinal para alertar que o passaro morreu

var didStartGame: bool = false #checa se o jogo esta iniciado 
var isDead: bool = false #checa se o jogador esta morto ou vivo
@onready var anime = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# verifica colisão do player com chão ou cano para matar o player
	if get_slide_collision_count() != 0:
		die()
	# Add the gravity.
	if not is_on_floor() and didStartGame:
		velocity += get_gravity() * delta
	move_and_slide()
	rotate_bird()
	

func jump():
	velocity.y = JUMP_VELOCITY
	
func die():
	if isDead == false:
		isDead = true 
		anime.stop()
		emit_signal("Justdied")
		set_collision_mask_value(2, false)
	


func _on_main_didtouch() -> void:
	handleTouch()
	
func handleTouch():
	if not didStartGame:
		didStartGame = true #inicia o jogo caso ele ainda nn estivesse iniciado, a partir do toque na tela
	if isDead == false: #permite o jogador pular apenas se estiver vivo (faz sentido, não?) 
		rotation = 0
		jump()

func rotate_bird():
	#rotação de queda
	if velocity.y > 0 and rad_to_deg(rotation) < 90:
		rotation += 2 * deg_to_rad(1.4)
	#rotação quando está subindo
	elif velocity.y < 0 and rad_to_deg(rotation) > -30:
		rotation -= 2 * deg_to_rad(1.2)
	
