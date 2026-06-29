package main

import "core:fmt"
import rl "vendor:raylib"
import "core:mem"
import "core:mem/virtual"

main :: proc(){
    rl.InitWindow(1920, 1080, "RasterWar")
    rl.SetTargetFPS(1000)
    

    track : mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)
    arena : virtual.Arena
    err := virtual.arena_init_growing(&arena)
    map_allocator := virtual.arena_allocator(&arena)
    defer{
        for _, entry in track.allocation_map{
            fmt.eprintf("%v leaked %v bytes\n", entry.location, entry.size)
        }
        for entry in track.bad_free_array{
            fmt.eprintf("%v bad free\n", entry.location)
        }
        mem.tracking_allocator_destroy(&track)
        virtual.arena_free_all(&arena)
    }
    defer cleanup_game()
    

    

    game.spots[{0, 0}] = {
        type = .HQ,
        building = {
            hp = 100,
            max_hp = 100,
        }
    }
    game.camera = {
        zoom = 1,
        target = {0, 0},
        offset = {f32(rl.GetScreenWidth()/2), f32(rl.GetScreenHeight()/2)}
    }

    init_game()


    for !rl.WindowShouldClose(){
        game.dt = rl.GetFrameTime()
        game.camera.offset = {f32(rl.GetScreenWidth()/2), f32(rl.GetScreenHeight()/2)}
        input_game()
        update_game()
        check_collision()

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.BeginMode2D(game.camera)
        draw_game()
        rl.EndMode2D()
        draw_build_menu()
        draw_hovered_info()
        rl.DrawFPS(20, 20)
        rl.EndDrawing()
    }
}

init_game :: proc(){
    init_texture()
}

input_game :: proc(){
    handle_input()
}

update_game :: proc(){
    update_camera()
    update_free_spots()
    update_build_menu()
}

check_collision :: proc(){
    check_collision_building_spot()
    check_collision_build_menu()
    check_collision_selection_spot()
}

draw_game :: proc(){
    draw_spots()
}

cleanup_game :: proc(){
    delete_map(game.spots)

    rl.UnloadTexture(texture_Manager.free_text)
    rl.UnloadTexture(texture_Manager.hq_text)
    rl.UnloadTexture(texture_Manager.energy_text)

    rl.CloseWindow()
}