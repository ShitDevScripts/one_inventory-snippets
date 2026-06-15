-- ONE_INVENTORY
local ONE_ITEMS = {
    ['sludgie'] = {
        name = 'sludgie',
        label = 'Sludgie',
        weight = 350,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = 'prop_ld_can_01', pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = 'You quenched your thirst with a Coffee'
        }
    },
    ['ecola_light'] = {
        name = 'ecola_light',
        label = 'Ecola light',
        weight = 350,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = 'prop_ld_can_01', pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = 'You quenched your thirst with a Coffee'
        }
    },
    ['ecola'] = {
        name = 'ecola',
        label = 'Ecola',
        weight = 350,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = 'prop_ld_can_01', pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = 'You quenched your thirst with a Coffee'
        }
    },
    ['coffee'] = {
        name = 'coffee',
        label = 'Coffee',
        weight = 350,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = 'prop_ld_can_01', pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = 'You quenched your thirst with a Coffee'
        }
    },
    ['fries'] = {
        name = 'fries',
        label = 'Fries',
        weight = 350,
        client = {
            status = { hunger = 200000 },
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
            prop = { model = 'prop_food_cb_chips', pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
            usetime = 2500,
            notification = 'You eat Fries'
        }
    },
    ['pizza_ham'] = {
        name = 'pizza_ham',
        label = 'Pizza Ham',
        weight = 350,
        client = {
            status = { hunger = 200000 },
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
            prop = { model = 'prop_food_cb_chips', pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
            usetime = 2500,
            notification = 'You eat Fries'
        }
    },
    ['chips'] = {
        name = 'chips',
        label = 'Chips',
        weight = 350,
        client = {
            status = { hunger = 200000 },
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
            prop = { model = 'prop_food_cb_chips', pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
            usetime = 2500,
            notification = 'You eat Chips'
        }
    },
    ['donut'] = {
        name = 'donut',
        label = 'Donut',
        weight = 350,
        client = {
            status = { hunger = 200000 },
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
            prop = { model = 'prop_amb_donut', pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
            usetime = 2500,
            notification = 'You eat Donut'
        }
    },
    ['wire_cutter'] = {
        name = 'wire_cutter',
        label = 'cutter',
        weight = 100,
        stack = true,
        consume = 0,
        close = true,
    },
    ['cigarrete'] = {
        name = 'cigarrete',
        label = 'Cigarrete',
        weight = 100,
        stack = true,
        consume = 0,
        close = true,
    },
    ['screwdriver'] = {
        name = 'screwdriver',
        label = 'Screw Driver',
        weight = 100,
        stack = true,
        consume = 0,
        close = true,
    },
}

-- qb-inventory / qs-inventory / aj-inventory / lj-inventory / ps-inventory

local QB_ITEMS = {
    ['sprunk'] = {
        name = 'sprunk',
        label = 'Sprunk',
        weight = 100,
        type = 'item',
        image = 'sprunk.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    ['sludgie'] = {
        name = 'sludgie',
        label = 'Sludgie',
        weight = 100,
        type = 'item',
        image = 'sludgie.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    ['ecola_light'] = {
        name = 'ecola_light',
        label = 'Ecola light',
        weight = 100,
        type = 'item',
        image = 'ecola_light.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    ['ecola'] = {
        name = 'ecola',
        label = 'Ecola',
        weight = 100,
        type = 'item',
        image = 'ecola.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    ['coffee'] = {
        name = 'coffee',
        label = 'Coffee',
        weight = 100,
        type = 'item',
        image = 'ecola.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    ['water'] = {
        name = 'water',
        label = 'Water',
        weight = 100,
        type = 'item',
        image = 'water.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    ['fries'] = {
        name = 'fries',
        label = 'Fries',
        weight = 100,
        type = 'item',
        image = 'fries.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    ['pizza_ham'] = {
        name = 'pizza_ham',
        label = 'Pizza Ham',
        weight = 100,
        type = 'item',
        image = 'pizza_ham.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    ['chips'] = {
        name = 'chips',
        label = 'Chips',
        weight = 100,
        type = 'item',
        image = 'chips.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    ['donut'] = {
        name = 'donut',
        label = 'Donut',
        weight = 100,
        type = 'item',
        image = 'donut.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    ['cigarrete'] = {
        name = 'cigarrete',
        label = 'Cigarrete',
        weight = 100,
        type = 'item',
        image = 'cigarrete.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    ['wire_cutter'] = {
        name = 'wire_cutter',
        label = 'Wire cutter',
        weight = 100,
        type = 'item',
        image = 'wire_cutter.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
    ['screwdriver'] = {
        name = 'screwdriver',
        label = 'Screw Driver',
        weight = 100,
        type = 'item',
        image = 'screwdriver.png',
        unique = false,
        useable = true,
        shouldClose = true,
        combinable = nil,
    },
}
