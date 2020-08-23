extends "res://Scripts/ISP.gd"

const spend_factor = 0.75

func spend_money(amount):
	var amt = int(spend_factor * amount)
	if money - reserved_money >= amt:
		money -= amt
		return true
	return false
