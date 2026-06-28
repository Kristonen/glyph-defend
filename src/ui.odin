package main

import rl "vendor:raylib"

SHOW_MENU_TIME :: 0.75

UI_State :: enum{
    Hidding, Focused, Showing, Visible, Hovered, Clicked
}

Building_Select_Spot :: struct{
    pos : rl.Vector2,
    state : UI_State,
}

Build_Menu :: struct{
    pos : rl.Vector2,
    state : UI_State,
    selection : [Spot_Type]Building_Select_Spot,
    hovered : ^Building_Select_Spot,
    gird_pos : Grid_Position,
    show_timer : f32,
    active : bool,
}