@icon("res://StateMachine/icons/statehierarchy.svg")
extends Node
class_name STATEHierarchy

var curr_state: String = ""
var previous_state: String = ""
var state_list: Dictionary

var _is_initialized := false


# START OF OVERRIDABLE FUNCTIONS

# Executes state logic of the hierarchy state
func execute_state_logic(delta: float): pass

# Defines state transition logic
func transition_logic() -> String: 
	#IMPLEMENTATION LOGIC
	#if condition is true:
	#	return "stateName"
	#return ""
	return ""

# These 2 functions are often used for animations, tweens and timers.
func enter_state(newState: String, oldState: String): pass
func exit_state(oldState: String, newState: String): pass

# START OF OVERRIDABLE FUNCTIONS





# START OF NON-OVERRIDABLE HIDDEN FUNCTIONS

# Method to be called by the State Manager to run the hierarchy state.
func update_hierarchy(delta): 
	execute_state_logic(delta)
	var transition_state = transition_logic()
	if transition_state != "":
		_set_state(transition_state)
	if curr_state != "":
		_implement_state(delta)

# Adds all child state nodes into the stateList.
func _get_states():
	state_list.clear()
	for state in get_children():
		if state is STATEState or state is STATEHierarchy:
			if state is STATEHierarchy:
				state._get_states()
				state._is_initialized = true
			var states_name = state.get_state_name()
			state_list[states_name] = state
	if state_list.size() <= 0:
		push_error("State Hierarchy should have states to manage.")
		assert(state_list.size() > 0,"State Hierarchy should have states to manage.")

# Implements transition of states
func _set_state(new_state: String):
	previous_state = curr_state
	curr_state = new_state
	
	if new_state != previous_state:
		if previous_state != "":
			exit_state(previous_state, new_state)
		if new_state != "":
			enter_state(new_state, previous_state)

# Executes state instructions.
func _implement_state(delta: float):
	if state_list[curr_state] is STATEState:
		state_list[curr_state].execute_state_logic(delta)
	elif state_list[curr_state] is STATEHierarchy:
		state_list[curr_state].update_hierarchy(delta)


# END OF NON-OVERRIDABLE HIDDEN FUNCTIONS
