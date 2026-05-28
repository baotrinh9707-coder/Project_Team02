extends Node
class_name InvetorySystem

signal coin_changed(new_amount: int)
signal item_collected(item_type: String, amount: int)

var coins: int = 0
var keys: int = 0

func _ready() -> void:
	pass
	
func add_coin(amount: int) -> void:
	coins += amount
	coin_changed.emit(coins)
	item_collected.emit("coin", amount)
	print("Collected ", amount, " coins. Total: ", coins)
	
func add_key(_amount: int = 1) -> void:
	#TODO: Implement key collection
	pass
	
func use_key() -> bool:
	#TODO: Implement key usage
	return false

func has_key() -> bool:
	return keys > 0	

func get_gold() -> int:
	return coins

func get_keys() -> int:
	return keys
