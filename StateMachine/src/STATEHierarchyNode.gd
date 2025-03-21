@icon("res://StateMachine/icons/statehierarchynode.svg")
extends Node
class_name STATEHierarchyNode

## AN INDEPENDENT, FLEXIBLE STATE NODE THAT CAN BE USED FOR HIERARCHICAL FINITE STATE MACHINES, INTENDED ONLY FOR USE WITH OTHER INSTANCES OF ITSELF
# SETS ITSELF AS SUBSTATE BY DEFAULT. AUTOMATICALLY SETS ITSELF AS STATE MANAGER OR SUPERSTATE IF IT HAS CHILDREN OF HIERARCHY NODES

enum Hierarchy {
	MANAGER,
	SUPERSTATE,
	SUBSTATE
	}
var hierarchy_node_type: Hierarchy = Hierarchy.SUBSTATE

var curr_state: String = ""
var previous_state: String = ""
var state_list: Dictionary

var _is_initialized := false

@onready var parent_node = get_parent()




#THESE ARE THE 4 OVERRIDABLE FUNCTIONS FOR THE HIERARCHY NODES TO FUNCTION.

# USED BY MANAGERS AND SUPERSTATES; Defines transition of states. 
func transition_logic() -> String: 
	#IMPLEMENTATION LOGIC
	#if condition is true:
	#	return "stateName"
	#return ""
	return ""

# USED BY SUBSTATES AND SUPERSTATES; Contains state instructions.
func execute_state_logic(delta: float):
	pass

# These 2 functions, only usable by managers and superstates, are often used for animations, tweens and timers.
func enter_state(newState: String, oldState: String): pass
func exit_state(oldState: String, newState: String): pass








# NEVER OVERRIDE THESE FUNCTIONS FOR THE STATE MACHINE TO FUNCTION PROPERLY.
# START OF NON_OVERRIDABLE FUNCTIONS


# MAIN FUNCTION EXCLUSIVE FOR STATE MANAGERS: CALL THIS IN GAME LOOP TO START THE STATE MACHINE!
func update_state_machine(delta: float):
	if hierarchy_node_type == Hierarchy.MANAGER:
		_hierarchy_state_logic(delta)




# Implements state transitions and substate executions of managers and superstates.
func _hierarchy_state_logic(delta: float): 
	if hierarchy_node_type == Hierarchy.SUPERSTATE:
		execute_state_logic(delta)
	if hierarchy_node_type == Hierarchy.MANAGER || hierarchy_node_type == Hierarchy.SUPERSTATE:
		var transition_state = transition_logic()
		if transition_state != "":
			_set_state(transition_state)
		if curr_state != "":
			_implement_state(delta)

# Calls functions depending on node type.
func _implement_state(delta: float): 
	if state_list[curr_state].hierarchy_node_type == Hierarchy.SUPERSTATE:
		state_list[curr_state].hierarchy_state_logic(delta)
	elif state_list[curr_state].hierarchy_node_type == Hierarchy.SUBSTATE:
		state_list[curr_state].execute_state_logic(delta)

# Transitions states.
func _set_state(new_state: String): 
	previous_state = curr_state
	curr_state = new_state
	
	if new_state != previous_state:
		if previous_state != "":
			exit_state(previous_state, new_state)
		if new_state != "":
			enter_state(new_state, previous_state)




# METHODS USED IN INITIALIZING THE HIERARCHY NODE

func _ready():
	_initialize()

func _initialize():
	_get_states()
	_set_hierarchy_type()
	_is_initialized = true

# Adds all child state nodes into the stateList.
func _get_states(): 
	state_list.clear()
	for state in get_children():
		if (state is STATEHierarchyNode):
			var states_name = state.name;
			state_list[states_name] = state

# Sets node's hierarchy type, depending on its parent and children.
func _set_hierarchy_type(): 
	if not (parent_node is STATEHierarchyNode):
		if state_list.size() > 0:
			hierarchy_node_type = Hierarchy.MANAGER
		elif state_list.size() <= 0:
			push_error("HFSM should have states to manage.")
			assert(state_list.size() > 0,"HFSM should have states to manage.")
	elif parent_node is STATEHierarchyNode:
		if state_list.size() > 0:
			hierarchy_node_type = Hierarchy.SUPERSTATE
		elif state_list.size() <= 0:
			hierarchy_node_type = Hierarchy.SUBSTATE


# END OF NON-OVERRIDEABLE FUNCTIONS
