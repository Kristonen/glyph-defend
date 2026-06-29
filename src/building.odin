package main

import rl "vendor:raylib"

ENERGY_BUILDING_TIME :: 5.0
ENERGY_MAX_HP :: 50.0

FOOD_BUILDING_TIME :: 3.0
FOOD_MAX_HP :: 30.0

Spot_Type :: enum{
    Free, HQ, Energy, Food, Test
}

Building_State :: enum{
    Builded, Building, Upgrading
}

Building :: struct{
    type : Spot_Type,
    state : Building_State,
    hp : f32,
    max_hp : f32,
}

Build_Spot_State :: enum{
    None, Hovered, Clicking, Clicked
}

Spot :: struct{
    type : Spot_Type,
    building : Building,
    state : Build_Spot_State,

    data : Building_Data,
}

Building_Data :: union{
    Build_Data, Energy_Data, Food_Data
}

Build_Data :: struct{
    build_timer : f32
}

Energy_Data :: struct{

}

Food_Data :: struct{

}

get_building_time :: proc(type : Spot_Type) -> f32{
    time : f32
    switch type{
        case .Energy: time = ENERGY_BUILDING_TIME
        case .Food: time = FOOD_BUILDING_TIME
        case .Free:
        case .HQ:
        case .Test:
    }

    return time
}

get_building_max_hp :: proc(type : Spot_Type) -> f32{
    max_hp : f32
    switch type{
        case .Energy: max_hp = ENERGY_MAX_HP
        case .Food: max_hp = FOOD_MAX_HP
        case .Free:
        case .HQ:
        case .Test:
    }
    return max_hp
}

get_building_name :: proc(type : Spot_Type) -> string{
    name : string
    switch type{
        case .HQ: name = "Headquarter"
        case .Energy: name = "Energy"
        case .Food: name = "Food"

        case .Free:
        
        case .Test:
    }
    return name
}

set_type_data :: proc(spot : ^Spot){
    switch spot.type{
        
        case .HQ:
        case .Energy:
            spot.data = Energy_Data{}
        case .Food:
            spot.data = Food_Data{}
        case .Test:
        case .Free:
    }
}

