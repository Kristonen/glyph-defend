package main

import "core:fmt"
import rl "vendor:raylib"

init_texture :: proc(){
    texture_Manager.hq_text = rl.LoadTexture("assets/hq.png")
    texture_Manager.free_text = rl.LoadTexture("assets/free_spot.png")
    texture_Manager.energy_text = rl.LoadTexture("assets/energy.png")
    texture_Manager.food_text = rl.LoadTexture("assets/food.png")
}