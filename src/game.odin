package main 

import rl "vendor:raylib"

game : Game
texture_Manager : Texture_Manager

CELL_SIZE :: 64
TEXTURE_SIZE :: 50

Grid_Position :: struct{
    x : int,
    y : int,
}

Texture_Manager :: struct{
    hq_text : rl.Texture2D,
    free_text : rl.Texture2D,
    energy_text : rl.Texture2D,
}

Game :: struct{

    spots : map[Grid_Position]Spot,
    last_hovered_pos : Grid_Position,
    last_clicked_pos : Grid_Position,

    input : Input_State,
    was_dragging_this_frame : bool,

    build_menu : Build_Menu,

    camera : rl.Camera2D,
    dt : f32,
}

get_texture :: proc(type : Spot_Type) -> ^rl.Texture2D{
    texture : ^rl.Texture2D
    switch type{
        case .Free:
            texture = &texture_Manager.free_text
        case .HQ:
            texture = &texture_Manager.hq_text
        case .Energy:
            texture = &texture_Manager.energy_text
        case .Test:
    }
    return texture
}