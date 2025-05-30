extends Node

signal on_crystal_added(crystal: Crystal)
signal on_crystal_matching
signal on_crystal_triggered(crystal: Crystal)
signal on_crystal_in_range(crystal: Crystal)
signal on_crystal_out_of_range(crystal: Crystal)
signal on_crystals_placed(total: int)
signal on_crystal_matched(is_match: bool, crystal: Crystal)
