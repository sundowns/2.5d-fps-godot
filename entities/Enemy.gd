extends Entity
class_name Enemy

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var death_effect_scene: PackedScene = preload("res://effects/EnemyDeathEffect.tscn")

var player_node: Player

func _ready():
# warning-ignore:return_value_discarded
	connect("dead", self, "_on_death")

func _physics_process(delta):
	apply_gravity(delta)
	apply_movement()
	
	if player_node:
		look_at(Vector3(player_node.global_transform.origin.x, global_transform.origin.y, player_node.global_transform.origin.z), Vector3.UP)

func _process(_delta):
	# This is kinda trash but probably good enough...
	if player_node == null:
		player_node = get_tree().current_scene.find_node("Player", true, false)

# warning-ignore:unused_argument
func on_gun_hit(damage: float, knockback: Vector3, is_headshot: bool):
	.update_health(-damage)
	.push(knockback)
	animation_player.play("Hurt")

func _on_death():
	spawn_death_particles()
	queue_free()

func spawn_death_particles():
	var new_particles = death_effect_scene.instance()
	Global.world_node.add_effect(new_particles)
	new_particles.global_transform.origin = global_transform.origin
