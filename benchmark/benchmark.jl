import GridWorlds
import GridWorlds: GW
import ReinforcementLearningBase
import ReinforcementLearningBase: RLBase
import BenchmarkTools
const BT = BenchmarkTools
import Random
import Dates

const STEPS_PER_RESET = 100
const NUM_RESETS = 100
const SEED = 0

const rng = Random.MersenneTwister(SEED)
const information = Dict()

ENVS = [GW.EmptyRoomDirected,
        GW.EmptyRoomUndirected,
        GW.GridRoomsDirected,
        GW.GridRoomsUndirected,
        GW.SequentialRoomsDirected,
        GW.SequentialRoomsUndirected,
        GW.MazeDirected,
        GW.MazeUndirected,
        GW.GoToTargetDirected,
        GW.GoToTargetUndirected,
        GW.DoorKeyDirected,
        GW.DoorKeyUndirected,
        GW.CollectGemsDirected,
        GW.CollectGemsUndirected,
        GW.DynamicObstaclesDirected,
        GW.DynamicObstaclesUndirected,
        GW.SokobanDirected,
        GW.SokobanUndirected,
        GW.Snake,
        GW.Catcher,
        GW.TransportDirected,
        GW.TransportUndirected,
       ]

function run_experiment(rng, Env, num_resets, steps_per_reset)
    env = Env(rng = rng)

    for _ in 1:num_resets
        RLBase.reset!(env)
        total_reward = 0
        for _ in 1:steps_per_reset
            state = RLBase.state(env)
            action = rand(RLBase.action_space(env))
            env(action)
            is_terminated = RLBase.is_terminated(env)
            reward = RLBase.reward(env)
            total_reward += reward
        end
    end

    return nothing
end

function format_benchmark(str::String)
    l = split(str, "\n")
    deleteat!(l, (1, 4, 9))
    return strip.(l)
end

function write_benchmarks(information; file = "benchmark.md")
    io = open(file, "w")

    write(io, "Date: " * Dates.format(Dates.now(), "yyyy_mm_dd_HH_MM_SS") * "\n")
    write(io, "# List of Environments\n")

    for Env in ENVS
        name = Env.body.body.name.name
        write(io, "  1. [$(String(name))](#$(lowercase(String(name))))\n")
    end

    write(io, "\n")
    write(io, "# Benchmarks\n\n")

    for Env in ENVS
        name = Env.body.body.name.name
        env_benchmark = information[name]

        write(io, "# $(String(name))\n\n")

        write(io, "#### Run uniformly random policy, NUM_RESETS = $(NUM_RESETS), STEPS_PER_RESET = $(STEPS_PER_RESET), TOTAL_STEPS = $(NUM_RESETS * STEPS_PER_RESET)\n\n")
        for line in format_benchmark(repr("text/plain", env_benchmark[:run_experiment]))
            write(io, line * "\n\n")
        end

        write(io, "#### $(String(Symbol(Env)))()\n\n")
        for line in format_benchmark(repr("text/plain", env_benchmark[:instantiation]))
            write(io, line * "\n\n")
        end

        write(io, "#### RLBase.reset!(env)\n\n")
        for line in format_benchmark(repr("text/plain", env_benchmark[:reset!]))
            write(io, line * "\n\n")
        end

        write(io, "#### RLBase.state(env)\n\n")
        for line in format_benchmark(repr("text/plain", env_benchmark[:state]))
            write(io, line * "\n\n")
        end

        write(io, "#### RLBase.action_space(env)\n\n")
        for line in format_benchmark(repr("text/plain", env_benchmark[:action_space]))
            write(io, line * "\n\n")
        end

        write(io, "#### RLBase.is_terminated(env)\n\n")
        for line in format_benchmark(repr("text/plain", env_benchmark[:is_terminated]))
            write(io, line * "\n\n")
        end

        write(io, "#### RLBase.reward(env)\n\n")
        for line in format_benchmark(repr("text/plain", env_benchmark[:reward]))
            write(io, line * "\n\n")
        end

        for action in keys(env_benchmark[:action_info])
            write(io, "#### env($action)\n\n")
            for line in format_benchmark(repr("text/plain", env_benchmark[:action_info][action]))
                write(io, line * "\n\n")
            end
        end

    end

    close(io)
end

# compile everything once
for Env in ENVS
    run_experiment(rng, Env, NUM_RESETS, STEPS_PER_RESET)
end

@info "First run (for compilation) is complete"

for Env in ENVS

    env_benchmark = Dict()

    env_benchmark[:run_experiment] = BT.@benchmark run_experiment($(Ref(rng))[], $(Ref(Env))[], $(Ref(NUM_RESETS))[], $(Ref(STEPS_PER_RESET))[])

    env_benchmark[:instantiation] = BT.@benchmark $(Ref(Env))[](rng = $(Ref(rng))[])

    env = Env(rng = rng)

    env_benchmark[:reset!] = BT.@benchmark RLBase.reset!($(Ref(env))[])
    env_benchmark[:state] = BT.@benchmark RLBase.state($(Ref(env))[])
    env_benchmark[:action_space] = BT.@benchmark RLBase.action_space($(Ref(env))[])
    env_benchmark[:is_terminated] = BT.@benchmark RLBase.is_terminated($(Ref(env))[])
    env_benchmark[:reward] = BT.@benchmark RLBase.reward($(Ref(env))[])

    action_info = Dict()
    for action in RLBase.action_space(env)
        action_info[Symbol(action)] = BT.@benchmark $(Ref(env))[]($(Ref(action))[])
    end
    env_benchmark[:action_info] = action_info

    name = Env.body.body.name.name
    information[name] = env_benchmark

    @info "$(name) benchmark complete"
end

write_benchmarks(information)
