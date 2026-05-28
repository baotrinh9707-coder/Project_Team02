extends Node
class_name InventorySystem

signal coin_changed(new_amount: int)
signal item_collected(item_type: String, amount: int)

var coins: int = 0
var keys: int = 0

func _ready() -> void:
	pass


func add_coin(amount: int) -> void:
	if amount <= 0:
		return

	coins += amount
	coin_changed.emit(coins)
	item_collected.emit("coin", amount)
	print("Collected ", amount, " coins. Total: ", coins)


func add_key(amount: int = 1) -> void:
	if amount <= 0:
		return

	keys += amount
	item_collected.emit("key", amount)
	print("Collected ", amount, " key. Total keys: ", keys)


func use_key() -> bool:
	if keys <= 0:
		print("No key available")
		return false

	keys -= 1
	item_collected.emit("key", -1)
	print("Used 1 key. Remaining keys: ", keys)
	return true


func has_key() -> bool:
	return keys > 0


func get_gold() -> int:
	return coins


func get_keys() -> int:
	return keys
