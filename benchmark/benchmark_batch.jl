import GridWorlds as GW
import ReinforcementLearningBase as RLBase
import BenchmarkTools as BT
import Dates

const STEPS_PER_RESET = 100
const NUM_RESETS = 100
const NUM_ENVS = 64

const information = Dict()

ENVS = [GW.ModuleSingleRoomUndirectedBatch.SingleRoomUndirectedBatch]

function run_random_policy!(env, num_resets, steps_per_reset)
    num_envs = size(env.tile_map, 1)
    action = Array{eltype(RLBase.action_space(env))}(undef, num_envs)
    for _ in 1:num_resets
        RLBase.reset!(env, force = true)
        for _ in 1:steps_per_reset
            state = RLBase.state(env)
            for i in 1:num_envs
                action[i] = rand(RLBase.action_space(env))
            end
            env(action)
            is_terminated = RLBase.is_terminated(env)
            reward = RLBase.reward(env)
        end
    end

    return nothing
end

function format_benchmark(str::String)
    l = split(str, "\n")
    deleteat!(l, (1, 4, 9))
    return strip.(l)
end

function write_benchmarks(information, file)
    io = open(file, "w")

    write(io, "Date: " * Dates.format(Dates.now(), "yyyy_mm_dd_HH_MM_SS") * "\n")
    write(io, "# List of Environments\n")

    for Env in ENVS
        name = Env.body.body.body.name.name
        write(io, "  1. [$(String(name))](#$(lowercase(String(name))))\n")
    end

    write(io, "\n")
    write(io, "# Benchmarks\n\n")

    for Env in ENVS
        name = Env.body.body.body.name.name
        env_benchmark = information[name]

        write(io, "# $(String(name))\n\n")

        write(io, "#### Run uniformly random policy, NUM_ENVS = $(NUM_ENVS), NUM_RESETS = $(NUM_RESETS), STEPS_PER_RESET = $(STEPS_PER_RESET), TOTAL_STEPS = $(NUM_RESETS * STEPS_PER_RESET)\n\n")
        for line in format_benchmark(repr("text/plain", env_benchmark[:run_random_policy]))
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
    env = Env(num_envs = NUM_ENVS)
    run_random_policy!(env, NUM_RESETS, STEPS_PER_RESET)
end

@info "First run (for compilation) is complete"

for Env in ENVS

    env = Env(num_envs = NUM_ENVS)

    env_benchmark = Dict()

    env_benchmark[:run_random_policy] = BT.@benchmark run_random_policy!($(Ref(env))[], $(Ref(NUM_RESETS))[], $(Ref(STEPS_PER_RESET))[])

    env_benchmark[:instantiation] = BT.@benchmark $(Ref(Env))[](num_envs = $(NUM_ENVS)[])

    env_benchmark[:reset!] = BT.@benchmark RLBase.reset!($(Ref(env))[], force = true)
    env_benchmark[:state] = BT.@benchmark RLBase.state($(Ref(env))[])
    env_benchmark[:action_space] = BT.@benchmark RLBase.action_space($(Ref(env))[])
    env_benchmark[:is_terminated] = BT.@benchmark RLBase.is_terminated($(Ref(env))[])
    env_benchmark[:reward] = BT.@benchmark RLBase.reward($(Ref(env))[])

    action_info = Dict()
    for action in RLBase.action_space(env)
        actions = fill(action, NUM_ENVS)
        action_info[Symbol(action)] = BT.@benchmark $(Ref(env))[]($(Ref(actions))[])
    end
    env_benchmark[:action_info] = action_info

    name = Env.body.body.body.name.name
    information[name] = env_benchmark

    @info "$(name) benchmark complete"
end

write_benchmarks(information, "benchmark_multi_threaded.md")
