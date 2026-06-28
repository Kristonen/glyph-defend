package main

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
    }
}

draw_build_menu :: proc(){
    if game.build_menu.state == .Hidding do return
    rec := rl.Rectangle{
        x = game.build_menu.pos.x,
        y = game.build_menu.pos.y,
        width = f32(rl.GetScreenWidth()),
        height = f32(rl.GetScreenHeight()) - game.build_menu.pos.y,
    }

    start := rl.Vector2{0, game.build_menu.pos.y}
    end := rl.Vector2{f32(rl.GetScreenWidth()), game.build_menu.pos.y}
    rl.DrawLineEx(start, end, 5, rl.RED)
    pos := rl.Vector2{game.build_menu.pos.x + 15, game.build_menu.pos.y + 15}
    for i in 0..<len(Spot_Type){
        type := Spot_Type(i)
        if type == .Free do continue
        if type == .Test do continue
        width := rl.MeasureText("Test", 10)
        selection := game.build_menu.selection[type]
        tex := get_texture(type)
        color := selection.state == .Hovered ? rl.RED : rl.WHITE
        rl.DrawTextureV(tex^, selection.pos, color)
        rl.DrawText("Test", i32(selection.pos.x) + width, i32(selection.pos.y) + tex.height + 5, 10, rl.WHITE)

        // pos.x += 15 + 64
    }
    
}