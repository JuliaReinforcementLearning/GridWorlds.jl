import BenchmarkTools as BT
import DataStructures as DS
import Dates
import GridWorlds as GW
import ReinforcementLearningBase as RLBase
import Statistics

const STEPS_PER_RESET = 100
const NUM_RESETS = 100
const NUM_ENVS = 64

ENVS = [GW.ModuleSingleRoomUndirectedBatch.SingleRoomUndirectedBatch]

function run_random_policy!(env, num_resets, steps_per_reset)
    num_envs = size(env.tile_map, 4)
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

function compile_envs(Envs)
    for Env in Envs
        env = Env(num_envs = NUM_ENVS)
        run_random_policy!(env, NUM_RESETS, STEPS_PER_RESET)
    end

    @info "Compiled and ran all environments"

    return nothing
end

function benchmark_batch_env(Env, num_resets, steps_per_reset, num_envs)
    benchmark = DS.OrderedDict()

    parent_module = parentmodule(Env)

    env = Env(num_envs = num_envs)

    benchmark[:random_policy] = BT.@benchmark run_random_policy!($(Ref(env))[], $(Ref(num_resets))[], $(Ref(steps_per_reset))[])
    benchmark[:reset] = BT.@benchmark RLBase.reset!($(Ref(env))[], force = true)
    benchmark[:state] = BT.@benchmark RLBase.state($(Ref(env))[])

    for action in RLBase.action_space(env)
        action_name = parent_module.ACTION_NAMES[action]
        batch_action = fill(action, NUM_ENVS)
        benchmark[action_name] = BT.@benchmark $(Ref(env))[]($(Ref(batch_action))[])
    end

    benchmark[:action_space] = BT.@benchmark RLBase.action_space($(Ref(env))[])
    benchmark[:is_terminated] = BT.@benchmark RLBase.is_terminated($(Ref(env))[])
    benchmark[:reward] = BT.@benchmark RLBase.reward($(Ref(env))[])

    @info "$(nameof(Env)) benchmarked"

    return benchmark
end

function benchmark_batch_envs(Envs, num_resets, steps_per_reset, num_envs)
    benchmarks = DS.OrderedDict()

    for Env in Envs
        benchmarks[nameof(Env)] = benchmark_batch_env(Env, num_resets, steps_per_reset, num_envs)
    end

    @info "All benchmarks complete"

    return benchmarks
end

function get_summary(trial::BT.Trial)
    median_trial = BT.median(trial)
    memory = BT.prettymemory(median_trial.memory)
    median_time = BT.prettytime(median_trial.time)
    return memory, median_time
end

function get_table(benchmark)
    title = "|"
    separator = "|"
    data = "|"

    for key in keys(benchmark)
        title = title * String(key) * "|"
        separator = separator * ":---:|"
        memory, median_time = get_summary(benchmark[key])
        data = data * "$(memory)<br>$(median_time)|"
    end

    return title, separator, data
end

function generate_benchmark_file_batch_envs(Envs, num_resets, steps_per_reset, num_envs, file_name = nothing)
    date = Dates.format(Dates.now(), "yyyy_mm_dd_HH_MM_SS")

    if isnothing(file_name)
        file_name = date * ".md"
    end

    io = open(file_name, "w")

    benchmarks = benchmark_batch_envs(Envs, num_resets, steps_per_reset, num_envs)

    println(io, "Date: $(date)")
    println(io, "## List of Environments")

    for Env in ENVS
        name_string = String(nameof(Env))
        println(io, "  1. [$(name_string)](#$(lowercase(name_string)))")
    end

    println(io)

    for key in keys(benchmarks)
        println(io, "### " * String(key))
        title, separator, data = get_table(benchmarks[key])
        println(io, title)
        println(io, separator)
        println(io, data)
        println(io)
    end

    close(io)

    return nothing
end
