module GenerativeModels

using POMDPs

export generate

function generate{S,A,O}(p::POMDP{S,A,O}, s::S, a::A, rng::AbstractRNG, sp::S=S(), o::O=O())
    td = transition(p, s, a)
    sp = rand(rng, td, sp)
    od = observation(p, s, a, sp)
    o = rand(rng, od, o)
    r = reward(p, s, a, sp)
    return (sp, o, r)
end

function generate{S,A}(p::MDP{S,A}, s::S, a::A, rng::AbstractRNG, sp::S=S())
    td = transition(p, s, a)
    sp = rand(rng, td, sp)
    r = reward(p, s, a, sp)
    return (sp, r)
end

end # module
