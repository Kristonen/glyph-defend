package main

import rl "vendor:raylib"

ENERGY_BUILDING_TIME :: 5.0

Spot_Type :: enum{
    Free, HQ, Energy, Test
}

Building :: struct{
    type : Spot_Type,
    hp : int,
    max_hp : int,
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
    Build_Data, Energy_Data
}

Build_Data :: struct{
    build_timer : f32
}

Energy_Data :: struct{

}

get_building_time :: proc(type : Spot_Type) -> f32{
    time : f32
    switch type{
        case .Energy: time = ENERGY_BUILDING_TIME

        case .Free:
        case .HQ:
        case .Test:
    }

    return time
}

set_type_data :: proc(spot : ^Spot){
    switch spot.type{
        case .Free:
        case .HQ:
        case .Energy:
            spot.data = Energy_Data{}
        case .Test:
    }
}

