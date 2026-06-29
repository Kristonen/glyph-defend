package main

import "core:strings"
import "core:fmt"
import rl "vendor:raylib"

// draw_buildings :: proc(){
//     for k, v in game.buildings{
//         rl.DrawRectangleV({f32(k.x), f32(k.y)}, {TEXTURE_SIZE, TEXTURE_SIZE}, rl.PURPLE)
//     }
// }

draw_spots :: proc(){
    src_rec := rl.Rectangle{0, 0, 64, 64}
    for k, v in game.spots{
        color := v.state == .Hovered ? rl.RED : v.state == .Clicked ? rl.BROWN : rl.WHITE
        dest_rec := rl.Rectangle{f32(k.x), f32(k.y), 50, 50}
        tex := get_texture(v.type)
        rl.DrawTexturePro(tex^, src_rec, dest_rec, {}, 0, color)

        if data, ok := v.data.(Build_Data); ok{
            progress := data.build_timer/get_building_time(v.type)
            rec := rl.Rectangle{
                x = f32(k.x),
                y = f32(k.y),
                width = dest_rec.width,
                height = dest_rec.height*progress
            }
            rl.DrawRectangleRec(rec, {0, 0, 0, 100})
        }
    }
}

draw_build_menu :: proc(){
    if game.build_menu.state == .Hidding do return
    // if !game.build_menu.active do return
    rec := rl.Rectangle{
        x = game.build_menu.pos.x,
        y = game.build_menu.pos.y,
        width = f32(rl.GetScreenWidth()),
        height = f32(rl.GetScreenHeight()) - game.build_menu.pos.y,
    }

    start := rl.Vector2{0, game.build_menu.pos.y}
    end := rl.Vector2{f32(rl.GetScreenWidth()), game.build_menu.pos.y}
    rl.DrawLineEx(start, end, 5, rl.RED)
    rec.y += 2.5
    rl.DrawRectangleRec(rec, {100, 100, 100, 100})
    pos := rl.Vector2{game.build_menu.pos.x + 15, game.build_menu.pos.y + 15}
    for i in 0..<len(Spot_Type){
        type := Spot_Type(i)
        if type == .Free || type == .Test || type == .HQ do continue
        name := strings.clone_to_cstring(get_building_name(type))
        defer delete(name)
        width := rl.MeasureText(name, 10)/2
        selection := game.build_menu.selection[type]
        tex := get_texture(type)
        color := selection.state == .Hovered ? rl.RED : rl.WHITE
        rl.DrawTextureV(tex^, selection.pos, color)
        rl.DrawText(name, i32(selection.pos.x) + width, i32(selection.pos.y) + tex.height + 5, 10, rl.WHITE)

        // pos.x += 15 + 64
    }
    
}

draw_hovered_info :: proc(){
    for k, v in game.spots{
        if v.state != .Hovered || v.type == .Free do continue
        x := f32(rl.GetScreenWidth()) * 0.80
        rec := rl.Rectangle{
            x = x,
            y = 50,
            width = f32(rl.GetScreenWidth()) - x - 10,
            height = 30,
        }
        name := strings.clone_to_cstring(get_building_name(v.type))
        defer delete(name)
        rl.DrawText(name, i32(rec.x + rec.width/2) - 35, 25, 20, rl.WHITE)
        bar := create_progress_bar(rec, v.building.hp, v.building.max_hp)
        rl.DrawRectangleRec(rec, rl.MAROON)
        fill_rec := rec
        fill_rec.width *= v.building.hp/v.building.max_hp
        rl.DrawRectangleRec(fill_rec, rl.RED)
        rl.DrawRectangleLinesEx(rec, 5, rl.GRAY)
        hp_show := fmt.tprintf("%0.0f/%0.0f", v.building.hp, v.building.max_hp)
        hp_text := strings.clone_to_cstring(hp_show)
        defer delete(hp_text)
        rl.DrawText(hp_text, i32(rec.x + rec.width/2) - 10, i32(rec.y + rec.height/2) - 10, 20, rl.WHITE)
    }
}