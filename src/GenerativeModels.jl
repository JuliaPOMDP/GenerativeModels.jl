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
    generate_s{S}(p::Union{POMDP{S},MDP{S}}, s, a, rng::AbstractRNG, sp::S=create_state(p))

Return the next state `sp` given current state `s` and action taken `a`.
"""
function generate_s{S}(p::Union{POMDP{S},MDP{S}}, s, a, rng::AbstractRNG, sp::S=create_state(p))
    td = transition(p, s, a)
    return rand(rng, td, sp)
end

"""
    generate_o{S,A,O}(p::POMDP{S,A,O}, s, a, sp, rng::AbstractRNG, o::O=create_observation(p))

Return the next observation given current state `s`, action taken `a` and next state `sp`.

Usually the observation would only depend on the next state `sp`.
"""
function generate_o{S,A,O}(p::POMDP{S,A,O}, s, a, sp, rng::AbstractRNG, o::O=create_observation(p))
    od = observation(p, s, a, sp)
    return rand(rng, od, o)
end

"""
    generate_o{S,A,O}(p::POMDP{S,A,O}, s, rng::AbstractRNG, o::O=create_observation(p))

Returns the observation from the current state. This should be used to generate initial observations.
"""
POMDPs.@pomdp_func generate_o{S,A,O}(p::POMDP{S,A,O}, s::S, rng::AbstractRNG, o::O=create_observation(p))

"""
    generate_sr{S}(p::Union{POMDP{S},MDP{S}}, s, a, rng::AbstractRNG, sp::S=create_state(p))

Return the next state `sp` and reward for taking action `a` in current state `s`.
"""
function generate_sr{S}(p::Union{POMDP{S},MDP{S}}, s, a, rng::AbstractRNG, sp::S=create_state(p))
    sp = generate_s(p, s, a, rng, sp)
    return sp, reward(p, s, a, sp)
end

"""
    generate_so{S,A,O}(p::POMDP{S,A,O}, s, a, rng::AbstractRNG, sp::S=create_state(p), o::O=create_observation(p))

Return the next state `sp` and observation `o`.
"""
function generate_so{S,A,O}(p::POMDP{S,A,O}, s, a, rng::AbstractRNG, sp::S=create_state(p), o::O=create_observation(p))
    sp = generate_s(p, s, a, rng, sp)
    return sp, generate_o(p, s, a, sp, rng, o)
end

"""
    generate_or{S,A,O}(p::POMDP{S,A,O}, s, a, sp, rng::AbstractRNG, o::O=create_observation(p))

Return the observation `o` and reward for taking action `a` in current state `s` reaching state `sp`.
"""
function generate_or{S,A,O}(p::POMDP{S,A,O}, s, a, sp, rng::AbstractRNG, o::O=create_observation(p))
    return generate_o(p, s, a, sp, rng, o), reward(p, s, a, sp)
end

"""
    generate_sor{S,A,O}(p::POMDP{S,A,O}, s, a, rng::AbstractRNG, sp::S=create_state(p), o::O=create_observation(p))

Return the next state `sp`, observation `o` and reward for taking action `a` in current state `s`.
"""
function generate_sor{S,A,O}(p::POMDP{S,A,O}, s, a, rng::AbstractRNG, sp::S=create_state(p), o::O=create_observation(p))
    sp,o = generate_so(p, s, a, rng, sp, o)
    return sp, o, reward(p, s, a, sp)
end

"""
    initial_state{S}(p::Union{POMDP{S},MDP{S}}, rng::AbstractRNG, s::S=create_state(p))

Return the initial state for the problem `p`.

Usually the initial state is sampled from an initial state distribution.
"""
function initial_state{S}(p::Union{POMDP{S},MDP{S}}, rng::AbstractRNG, s::S=create_state(p))
    d = initial_state_distribution(p)
    return rand(rng, d, s)
end


end # module
