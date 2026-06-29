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
    spot_pos : Grid_Position,
    show_timer : f32,
    active : bool,
}

Progress_Bar :: struct{
    rec : rl.Rectangle,
    value : f32,
    max_value : f32,
    min_value : f32,
}

create_progress_bar :: proc(rec : rl.Rectangle, value, max : f32, min : f32 = 0) -> Progress_Bar{
    return {
        rec = rec,
        value = value,
        max_value = max,
        min_value = min,
    }
}