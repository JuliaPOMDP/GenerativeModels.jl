module GenerativeModels

using POMDPs

export generate_s,
       generate_o,
       generate_sr,
       generate_so,
       generate_or,
       generate_sor

function generate_s{S}(p::POMDP{S}, s, a, rng::AbstractRNG, sp::S=S())
    td = transition(p, s, a)
    return rand(rng, td, sp)
end

function generate_o{S,A,O}(p::POMDP{S,A,O}, s, a, sp, rng::AbstractRNG, o::O=O())
    od = observation(p, s, a, sp)
    return rand(rng, od, o)
end

function generate_sr{S}(p::POMDP{S}, s, a, rng::AbstractRNG, sp::S=S())
    sp = generate_s(p, s, a, rng)
    return sp, reward(p, s, a, sp)
end

function generate_so{S,A,O}(p::POMDP{S,A,O}, s, a, rng::AbstractRNG, sp::S=S(), o::O=O())
    sp = generate_s(p, s, a, rng, sp)
    return sp, generate_o(p, s, a, sp, rng, o)
end

function generate_or{S,A,O}(p::POMDP{S,A,O}, s, a, sp, rng::AbstractRNG, o::O=O())
    return generate_o(p, s, a, sp, rng, o), reward(p, s, a, sp)
end


function generate_sor{S,A,O}(p::POMDP{S,A,O}, s, a, rng::AbstractRNG, sp::S=S(), o::O=O())
    sp,o = generate_so(p, s, a, rng, sp, o)
    return sp, o, reward(p, s, a, sp)
end

end # module
