package main

import "core:fmt"
import rl "vendor:raylib"

MAX_ZOOM_IN :: 3.0
MAX_ZOOM_OUT :: 0.1

update_camera :: proc(){

    if game.input.is_dragging{
        game.camera.target.x -= game.input.mouse_delta.x / game.camera.zoom
        game.camera.target.y -= game.input.mouse_delta.y / game.camera.zoom
    }

    game.camera.target += game.input.move_dir * 500 * game.dt
    game.camera.zoom += game.input.mouse_wheel/10

    if game.camera.zoom < MAX_ZOOM_OUT do game.camera.zoom = MAX_ZOOM_OUT
    if game.camera.zoom > MAX_ZOOM_IN do game.camera.zoom = MAX_ZOOM_IN

    
}

update_build_menu :: proc(){
    spot, exist := game.spots[game.last_clicked_pos]
    if !exist && (game.build_menu.state == .Showing || game.build_menu.state == .Visible){
        game.build_menu.state = .Hidding
        return
    }
    if spot.type != .Free do return
    
    if game.input.released[.Build] && game.build_menu.state == .Hidding{
        game.build_menu.state = .Showing
        game.build_menu.show_timer = SHOW_MENU_TIME
        game.build_menu.spot_pos = game.last_clicked_pos
    }

    if game.build_menu.show_timer > 0{
        progress := 1.0 - game.build_menu.show_timer/SHOW_MENU_TIME
        y := (f32(rl.GetScreenHeight())*0.25)*progress
        game.build_menu.pos.y = f32(rl.GetScreenHeight())-y
        game.build_menu.show_timer -= game.dt
    }

    if game.build_menu.show_timer < 0 && game.build_menu.state == .Showing{
        game.build_menu.pos.y = f32(rl.GetScreenHeight())*0.75
        game.build_menu.state = .Visible
        game.build_menu.active = true
    }

    update_build_selection_spot()
}

update_build_selection_spot :: proc(){
    pos := rl.Vector2{game.build_menu.pos.x, game.build_menu.pos.y}
    for type in Spot_Type{
        if type == .Free || type == .Test || type == .HQ do continue
        selection := &game.build_menu.selection[type]
        selection.pos.x = pos.x + 15
        selection.pos.y = pos.y + 15

        pos.x += 64 + 15

        if selection.state == .Clicked{
            spot := &game.spots[game.build_menu.spot_pos]
            spot.type = type
            spot.data = Build_Data{
                build_timer = get_building_time(type)
            }//get_building_data(type)
            spot.building.max_hp = get_building_max_hp(type)
            spot.building.state = .Building
            game.build_menu.active = false
            game.build_menu.state = .Hidding
            selection.state = .Showing
        }
    }
}

update_free_spots :: proc(){
    for k, &v in game.spots{
        if v.type == .Free do continue
        north : Grid_Position = {k.x, k.y - 64}
        south : Grid_Position = {k.x, k.y + 64}
        east : Grid_Position = {k.x + 64, k.y}
        west : Grid_Position = {k.x - 64, k.y}

        update_free_spot(north)
        update_free_spot(south)
        update_free_spot(east)
        update_free_spot(west)

        // if game.input.released[.Build] || !game.build_menu.active{
        //     game.build_menu.state = .Showing
        //     game.build_menu.show_timer = SHOW_MENU_TIME
        //     game.build_menu.spot_pos = game.last_clicked_pos
        // }

        if data, ok := &v.data.(Build_Data); ok{
            if data.build_timer > 0{
                data.build_timer -= game.dt
                max_hp := get_building_max_hp(v.type)
                build_time := get_building_time(v.type)
                progress := 1.0-(data.build_timer/build_time)
                v.building.hp = max_hp*progress

            } else{
                set_type_data(&v)
                v.building.state = .Builded
            }
            
        }
    }
}

update_free_spot :: proc(pos : Grid_Position){
    spot, exist := &game.spots[pos]
    if !exist do game.spots[pos] = {type = .Free}
}