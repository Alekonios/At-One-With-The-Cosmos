extends Node

var special_condition: bool = false
#var current_scene

var Station_Floor_0
var Station_Bridge = preload("res://scenes/locations/StationBridge/Station - Bridge.tscn") as PackedScene

var Station_Floor_1
var Station_Generators

var Station_Floor_2
var Station_Storage

var Station_Floor_3
var Station_Crew_Quaters


func load_scene(level):
	get_tree().change_scene_to_packed(level)
