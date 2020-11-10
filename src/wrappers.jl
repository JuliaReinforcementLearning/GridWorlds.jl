export StochasticEnv

#####
# StochasticEnv
#####

mutable struct StochasticEnv{E<:AbstractEnv, R<:AbstractRNG} <: AbstractEnv
    env::E
    rng::R
end

StochasticEnv(env::E; rng::R = MersenneTwister(123)) where {E<:AbstractEnv, R<:AbstractRNG} = StochasticEnv(env, rng)

# partial constructor to allow chaining
StochasticEnv(;rng::R = MersenneTwister(123)) where {R<:AbstractRNG} = env -> StochasticEnv(env, rng)

function (env::StochasticEnv)(args...; kwargs...)
    env.env(args...; kwargs...)
end

for f in vcat(ENV_API, MULTI_AGENT_ENV_API)
    @eval $f(x::StochasticEnv, args...; kwargs...) = $f(x.env, args...; kwargs...)
end
