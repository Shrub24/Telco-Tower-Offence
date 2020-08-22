extends "res://Scripts/ISP.gd"

func get_operation_cost(town):
	return town.get_ISP_town_info(self).tower.operation_cost/2
