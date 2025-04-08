A custom implementation of state machine AI framework.

## Parts of the State Machine framework
+ STATEManager -> manages state objects, both the simple state nodes and hierarchy state nodes.
+ STATEState -> a state object that executes its state logic when selected by either the STATEManager or STATEHierarchy as the current state.
+ STATEHierarchy -> manages both simple state nodes and other state hierarchy and executes its own state logic, all while selected as the current state.
+ STATEHierarchyNode -> a flexible state machine object that can function as etiher a StateManager, SubState, or HierarchyState, depending on the node's presence of parent and children nodes. Can't be used with aforementioned state objects other than STATEHierarchyNodes.

## Demo
Included in this project is a demo about a playable character in a dangerous area where roaming fungants and spitting flowers reign over the boglands. This demo displays both the player's and npc's current state when performing actions. To control the player, use arrow keys to move in 8 directions, press ctrl key to roll, and space/enter to attack enemies with a sword.

---
![state_mach1](https://github.com/user-attachments/assets/882222bb-4abd-42b6-95f2-a09ff865c329)
---
![state_mach2](https://github.com/user-attachments/assets/4c72baed-eab5-4206-8600-81d58ad4fa81)
---
