@icon("res://StateMachine/icons/statemanager.svg")
extends Node
class_name STATEManager

var curr_state: String = ""
var previous_state: String = ""
var state_list: Dictionary

var _is_initialized := false


#MAIN METHOD: NEVER OVERRIDE THIS! CALL THIS IN GAME LOOP TO START THE STATE MACHINE!
func update_state_machine(delta: float): 
	if not _is_initialized:
		_get_states()
		_is_initialized = true
	
	var transition_state = transition_logic()
	if transition_state != "":
		_set_state(transition_state)
	if curr_state != "":
		_implement_state(delta)






#THESE ARE THE OVERRIDABLE FUNCTIONS FOR THE STATE MANAGER: transition_logic(), enter_state() and exit_state()

# Defines state transition logic, must be overriden for the state machine to function
func transition_logic() -> String:
	#IMPLEMENTATION LOGIC
	#if condition is true:
	#	return "stateName"
	#return ""
	return ""

# These 2 functions are often used for animations, tweens and timers.
func enter_state(new_state: String, old_state: String): pass
func exit_state(old_state: String, new_state: String): pass





# NON-OVERRIDABLE HIDDEN METHODS START HERE

# Adds all child state nodes into the stateList.
func _get_states(): 
	state_list.clear()
	for state in get_children():
		if state is STATEState or state is STATEHierarchy:
			if state is STATEHierarchy:
				state._get_states()
				state._is_initialized = true
			var states_name = state.name
			state_list[states_name] = state
	if state_list.size() <= 0:
		var message: String = "State manager should have states to manage.";
		push_error(message)
		assert(state_list.size() > 0, message)

# Implements transition of states.
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

# NON-OVERRIDABLE HIDDEN METHODS ENDS HERE
