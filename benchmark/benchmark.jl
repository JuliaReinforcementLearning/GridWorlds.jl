import GridWorlds
import GridWorlds: GW
import ReinforcementLearningBase
import ReinforcementLearningBase: RLBase
import BenchmarkTools
const BT = BenchmarkTools
import Random

const MAX_STEPS = 3000
const SEED = 0

rng = Random.MersenneTwister(SEED)
information = Dict()

ENVS = [GW.EmptyRoom, GW.GridRooms, GW.SequentialRooms, GW.GoToDoor, GW.DoorKey, GW.CollectGems, GW.DynamicObstacles, GW.Sokoban]

function format_benchmark(str::String)
    l = split(str, "\n")
    deleteat!(l, (1, 4, 9))
    return strip.(l)
end

function write_benchmarks!(information; file = "benchmark.md")
    io = open(file, "w")

    write(io, "# List of Environments\n")

    for Env in ENVS
        write(io, "  1. [$(Symbol(Env))](#$(Symbol(Env)))\n")
    end

    write(io, "\n")
    write(io, "# Benchmarks\n\n")

    for Env in ENVS
        env_benchmark = information[Symbol(Env)]

        write(io, "# $(String(Symbol(Env)))\n\n")

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

for Env in ENVS

    env_benchmark = Dict()

    env_benchmark[:instantiation] = BT.@benchmark $Env(rng = $rng)

    env = Env(rng = rng)

    env_benchmark[:reset!] = BT.@benchmark RLBase.reset!($env)
    env_benchmark[:state] = BT.@benchmark RLBase.state($env)
    env_benchmark[:action_space] = BT.@benchmark RLBase.action_space($env)
    env_benchmark[:is_terminated] = BT.@benchmark RLBase.is_terminated($env)
    env_benchmark[:reward] = BT.@benchmark RLBase.reward($env)

    action_info = Dict()
    for action in RLBase.action_space(env)
        action_info[Symbol(action)] = BT.@benchmark $env($action)
    end
    env_benchmark[:action_info] = action_info

    information[Symbol(Env)] = env_benchmark
end

write_benchmarks!(information)

