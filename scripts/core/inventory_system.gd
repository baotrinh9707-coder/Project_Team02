extends Node
class_name InventorySystem

signal coin_changed(new_amount: int)
signal item_collected(item_type: String, amount: int)

var coins: int = 0
var keys: int = 0

func add_coin(amount: int) -> void:
	coins += amount
	coin_changed.emit(coins)
	item_collected.emit("coin", amount)

func add_key(amount: int):
	keys += amount
	print("Đã nhặt chìa khóa! Tổng chìa: ", keys)

func has_key() -> bool:
	return keys > 0

func use_key() -> bool:
	if has_key():
		keys -= 1
		return true
	return false
