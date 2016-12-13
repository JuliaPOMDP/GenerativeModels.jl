__precompile__()


module GenerativeModels

using POMDPs

export generate_s,
       generate_o,
       generate_sr,
       generate_so,
       generate_or,
       generate_sor,
       initial_state

"""
    generate_s{S,A}(p::Union{POMDP{S,A},MDP{S,A}}, s::S, a::A, rng::AbstractRNG)

Return the next state given current state `s` and action taken `a`.
"""
function generate_s end

"""
    generate_o{S,A,O}(p::POMDP{S,A,O}, s::S, a::A, sp::S, rng::AbstractRNG)

Return the next observation given current state `s`, action taken `a` and next state `sp`.

Usually the observation would only depend on the next state `sp`.

    generate_o{S,A,O}(p::POMDP{S,A,O}, s::S, rng::AbstractRNG)

Return the observation from the current state. This should be used to generate initial observations.
"""
function generate_o end

"""
    generate_sr{S}(p::Union{POMDP{S},MDP{S}}, s, a, rng::AbstractRNG)

Return the next state `sp` and reward for taking action `a` in current state `s`.
"""
function generate_sr end

"""
    generate_so{S,A,O}(p::POMDP{S,A,O}, s::S, a::A, rng::AbstractRNG)

Return the next state `sp` and observation `o`.
"""
function generate_so end

"""
    generate_or{S,A,O}(p::POMDP{S,A,O}, s::S, a::A, sp::S, rng::AbstractRNG)

Return the observation `o` and reward for taking action `a` in current state `s` reaching state `sp`.
"""
function generate_or end

"""
    generate_sor{S,A,O}(p::POMDP{S,A,O}, s::S, a::A, rng::AbstractRNG)

Return the next state `sp`, observation `o` and reward for taking action `a` in current state `s`.
"""
function generate_sor end

"""
    initial_state{S}(p::Union{POMDP{S},MDP{S}}, rng::AbstractRNG)

Return the initial state for the problem `p`.

Usually the initial state is sampled from an initial state distribution.
"""
function initial_state end


#=
function generate_s{S,A}(p::Union{POMDP{S,A},MDP{S,A}}, s::S, a::A, rng::AbstractRNG)
    td = transition(p, s, a)
    return rand(rng, td)
end

function generate_o{S,A,O}(p::POMDP{S,A,O}, s::S, a::A, sp, rng::AbstractRNG)
    od = observation(p, s, a, sp)
    return rand(rng, od)
end

function generate_sr{S,A}(p::Union{POMDP{S,A},MDP{S,A}}, s::S, a::A, rng::AbstractRNG)
    sp = generate_s(p, s, a, rng)
    return sp, reward(p, s, a, sp)
end

function generate_so{S,A,O}(p::POMDP{S,A,O}, s::S, a::A, rng::AbstractRNG)
    sp = generate_s(p, s, a, rng)
    return sp, generate_o(p, s, a, sp, rng)
end

function generate_or{S,A,O}(p::POMDP{S,A,O}, s::S, a::A, sp::S, rng::AbstractRNG)
    return generate_o(p, s, a, sp, rng), reward(p, s, a, sp)
end

function generate_sor{S,A,O}(p::POMDP{S,A,O}, s::S, a::A, rng::AbstractRNG)
    sp,o = generate_so(p, s, a, rng)
    return sp, o, reward(p, s, a, sp)
end

function initial_state{S}(p::Union{POMDP{S},MDP{S}}, rng::AbstractRNG)
    d = initial_state_distribution(p)
    return rand(rng, d)
end
=#

end # module
