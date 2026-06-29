package main

import "core:fmt"
import rl "vendor:raylib"
import "core:math"

check_collision_building_spot :: proc(){

    if old_spot, exist := &game.spots[game.last_hovered_pos]; exist{
        old_spot.state = .None
    }

    current_pos := game.input.mouse_grid_snap

    if game.build_menu.active && game.build_menu.state != .Hovered && game.input.released[.Build] && !game.was_dragging_this_frame{
        game.build_menu.active = false
        game.build_menu.state = .Hidding
    }

    if current_spot, exist := &game.spots[current_pos]; exist{
        game.last_hovered_pos = current_pos

        if game.input.is_dragging{
            current_spot.state = .None
        } else if game.input.down[.Build]{
            current_spot.state = .Clicking
        } else if game.input.released[.Build] && !game.was_dragging_this_frame{
            current_spot.state = .Clicked
            game.last_clicked_pos = current_pos
        } else{
            if game.build_menu.state == .Hovered do return
            if game.build_menu.hovered != nil do return
            current_spot.state = .Hovered
        }
    }
}

check_collision_build_menu :: proc(){
    rec := rl.Rectangle{
        x = game.build_menu.pos.x,
        y = game.build_menu.pos.y,
        width = f32(rl.GetScreenWidth()),
        height = f32(rl.GetScreenHeight()) - game.build_menu.pos.y,
    }
    if game.build_menu.active && rl.CheckCollisionPointRec(rl.GetMousePosition(), rec){
        game.build_menu.state = .Hovered
    } else if game.build_menu.active{
        game.build_menu.state = .Visible
    }
}

check_collision_selection_spot :: proc(){
    game.build_menu.hovered = nil
    if !game.build_menu.active do return
    for &selection in game.build_menu.selection{
        selection.state = .Showing
        rec := rl.Rectangle{selection.pos.x, selection.pos.y, 64, 64}
        if rl.CheckCollisionPointRec(rl.GetMousePosition(), rec){
            selection.state = .Hovered
            if game.input.released[.Build]{
                selection.state = .Clicked
            }
        }
    }
}