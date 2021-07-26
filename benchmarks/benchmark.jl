import BenchmarkTools as BT
import DataStructures as DS
import Dates
import GridWorlds as GW
import ReinforcementLearningBase as RLBase

function run_random_policy!(env, num_resets, steps_per_reset)
    for reset_number in 1 : num_resets
        RLBase.reset!(env)
        for step_number in 1 : steps_per_reset
            state = RLBase.state(env)
            action = rand(RLBase.action_space(env))
            env(action)
            is_terminated = RLBase.is_terminated(env)
            reward = RLBase.reward(env)
        end
    end

    return nothing
end

function benchmark(Env, num_resets, steps_per_reset)
    benchmark = DS.OrderedDict()

    env = GW.RLBaseEnv(Env())

    benchmark[:random_policy] = BT.@benchmark run_random_policy!($(Ref(env))[], $(Ref(num_resets))[], $(Ref(steps_per_reset))[])
    benchmark[:reset] = BT.@benchmark RLBase.reset!($(Ref(env))[])
    benchmark[:state] = BT.@benchmark RLBase.state($(Ref(env))[])

    action_names = GW.get_action_names(env.env)

    for action in RLBase.action_space(env)
        benchmark[action_names[action]] = BT.@benchmark $(Ref(env))[]($(Ref(action))[])
    end

    benchmark[:is_terminated] = BT.@benchmark RLBase.is_terminated($(Ref(env))[])
    benchmark[:reward] = BT.@benchmark RLBase.reward($(Ref(env))[])

    @info "$(nameof(Env)) benchmark complete"

    return benchmark
end

function benchmark(Envs::Vector, num_resets, steps_per_reset)
    benchmarks = DS.OrderedDict()

    for Env in Envs
        benchmarks[nameof(Env)] = benchmark(Env, num_resets, steps_per_reset)
    end

    @info "Benchmarks complete"

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

function generate_benchmark_file(; Envs = GW.ENVS, num_resets = 100, steps_per_reset = 100, file_name = nothing)
    date = Dates.format(Dates.now(), "yyyy_mm_dd_HH_MM_SS")

    if isnothing(file_name)
        file_name = date * ".md"
    end

    io = open(file_name, "w")

    benchmarks = benchmark(Envs, num_resets, steps_per_reset)

    println(io, "Date: $(date) (yyyy_mm_dd_HH_MM_SS)")
    println(io)
    println(io, "**Note:** The time in benchmarks is the median time. While benchmarking the random policy, each environment was run for $(num_resets) episodes of $(steps_per_reset) steps each, that is, a total of $(num_resets * steps_per_reset) steps.")
    println(io)
    println(io, "## List of Environments")

    for Env in Envs
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
