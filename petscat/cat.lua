return {
    next_actions = {
        idle = { "idle", "walk", "walk_left", "run", "run_left" },
        walk = { "walk", "idle", "run", "walk_left" },
        walk_left = { "walk_left", "idle", "run_left", "walk" },
        run = { "run", "walk", "run_left", "idle" },
        run_left = { "run_left", "walk_left", "run", "idle" },
    },
    idle_actions = { "idle" },
    first_action = "idle",
    movements = {
        right = {
            normal = { "walk" },
            fast = { "run" },
            slow = { "walk" },
        },
        left = {
            normal = { "walk_left" },
            fast = { "run_left" },
            slow = { "walk_left" },
        },
    },
}
