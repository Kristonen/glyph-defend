package main

import "core:math"
import rl "vendor:raylib"

Input_State :: struct{
    move_dir : rl.Vector2,

    mouse_world : rl.Vector2,
    mouse_grid_snap : Grid_Position,
    mouse_wheel : f32,

    mouse_delta : rl.Vector2,
    is_dragging : bool,

    down : [Input_Action]bool,
    pressed : [Input_Action]bool,
    released : [Input_Action]bool,
}

Input_Action :: enum{
    Build, Cancel, Demolish, Pause, Tab
}

handle_input :: proc(){
    inp := &game.input

    inp.mouse_world = rl.GetScreenToWorld2D(rl.GetMousePosition(), game.camera)
    inp.mouse_wheel = rl.GetMouseWheelMove()
    inp.mouse_delta = rl.GetMouseDelta()

    snap_x := int(math.floor(inp.mouse_world.x/64))*64
    snap_y := int(math.floor(inp.mouse_world.y/64))*64
    inp.mouse_grid_snap = {snap_x, snap_y}

    inp.move_dir = {0, 0}
    if rl.IsKeyDown(.W) || rl.IsKeyDown(.UP)    do inp.move_dir.y -= 1
    if rl.IsKeyDown(.S) || rl.IsKeyDown(.DOWN)  do inp.move_dir.y += 1
    if rl.IsKeyDown(.A) || rl.IsKeyDown(.LEFT)  do inp.move_dir.x -= 1
    if rl.IsKeyDown(.D) || rl.IsKeyDown(.RIGHT) do inp.move_dir.x += 1

    if inp.move_dir != {0, 0}{
        inp.move_dir = rl.Vector2Normalize(inp.move_dir)
    }

    inp.pressed[.Build] = rl.IsMouseButtonPressed(.LEFT)
    inp.down[.Build] = rl.IsMouseButtonDown(.LEFT)
    inp.released[.Build] = rl.IsMouseButtonReleased(.LEFT)

    inp.pressed[.Tab] = rl.IsKeyPressed(.TAB)

    if inp.down[.Build] && (inp.mouse_delta.x != 0 || inp.mouse_delta.y != 0){
        inp.is_dragging = true
    }

    if inp.released[.Build]{
        game.was_dragging_this_frame = inp.is_dragging
        inp.is_dragging = false
        game.last_clicked_pos = game.input.mouse_grid_snap
        // spot, exist := game.spots[game.input.mouse_grid_snap]
        // if exist do game.last_clicked_spot = game.input.mouse_grid_snap
    } else{
        game.was_dragging_this_frame = false
    }

    if inp.pressed[.Tab]{
        game.camera.target = {0, 0}
    }
}