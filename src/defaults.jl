# default implementations for the functions in GenerativeModels
import POMDPs.implemented

# Yes, this could be cleaned up, but figuring out how the macro would work exactly took more thought

function implemented(f::typeof(generate_s), TT::Type)
    m = which(f, TT)
    if m.module == GenerativeModels && !implemented(transition, Tuple{TT.parameters[1:end-1]...})
        return false
    else # a more specific implementation exists
        return true
    end
end

@generated function generate_s{S, A}(p::Union{MDP{S,A},POMDP{S,A}}, s::S, a::A, rng::AbstractRNG)
    if implemented(transition, Tuple{p, s, a})
        return quote
            td = transition(p, s, a)
            return rand(rng, td)
        end
    else
        failed_synth_warning(generate_s)
        return :(throw(MethodError(generate_s, (p,s,a,rng))))
    end
end


function implemented(f::typeof(generate_sr), TT::Type)
    m = which(f, TT)
    if m.module == GenerativeModels && !implemented(generate_s, TT)
        return false
    else # a more specific implementation exists
        return true
    end
end

@generated function generate_sr{S, A}(p::Union{POMDP{S,A},MDP{S,A}}, s::S, a::A, rng::AbstractRNG)
    if implemented(generate_s, Tuple{p, s, a, rng})
        return quote
            sp = generate_s(p, s, a, rng)
            return sp, reward(p, s, a, sp)
        end
    else
        failed_synth_warning(generate_sr)
        return :(throw(MethodError(generate_sr, (p,s,a,rng))))
    end
end


function implemented(f::typeof(generate_o), TT::Type)
    m = which(f, TT)
    if m.module == GenerativeModels && !implemented(observation, Tuple{TT.parameters[1:end-1]...})
        return false
    else # a more specific implementation exists
        return true
    end
end

@generated function generate_o{S, A}(p::POMDP{S,A}, s::S, a::A, sp::S, rng::AbstractRNG)
    if implemented(observation, Tuple{p, s, a, sp})
        return quote
            od = observation(p, s, a, sp)
            return rand(rng, od)
        end
    else
        failed_synth_warning(generate_o)
        return :(throw(MethodError(generate_o, (p, s, a, sp, rng))))
    end
end


function implemented(f::typeof(generate_so), TT::Type)
    m = which(f, TT)
    reqs_met = implemented(generate_s, TT) && implemented(generate_o, Tuple{TT.parameters[1:end-1]..., TT.parameters[2], TT.parameters[end]})
    if m.module == GenerativeModels && !reqs_met
        return false
    else # a more specific implementation exists
        return true
    end
end

@generated function generate_so{S, A}(p::POMDP{S,A}, s::S, a::A, rng::AbstractRNG)
    if implemented(generate_s, Tuple{p, s, a, rng}) && implemented(generate_o, Tuple{p, s, a, s, rng})
        return quote
            sp = generate_s(p, s, a, rng)
            return sp, generate_o(p, s, a, sp, rng)
        end
    else
        failed_synth_warning(generate_so)
        return :(throw(MethodError(generate_so, (p,s,a,rng))))
    end
end


function implemented(f::typeof(generate_sor), TT::Type)
    m = which(f, TT)
    if m.module == GenerativeModels && !implemented(generate_so, TT)
        return false
    else # a more specific implementation exists
        return true
    end
end

@generated function generate_sor{S, A}(p::POMDP{S,A}, s::S, a::A, rng::AbstractRNG)
    if implemented(generate_so, Tuple{p, s, a, rng})
        return quote
            sp, o = generate_so(p, s, a, rng)
            return sp, o, reward(p, s, a, sp)
        end
    else
        failed_synth_warning(generate_sor)
        return :(throw(MethodError(generate_sor, (p,s,a,rng))))
    end
end



function implemented(f::typeof(generate_or), TT::Type)
    m = which(f, TT)
    if m.module == GenerativeModels && !implemented(generate_o, TT)
        return false
    else # a more specific implementation exists
        return true
    end
end

@generated function generate_or{S, A}(p::POMDP{S,A}, s::S, a::A, sp::S, rng::AbstractRNG)
    if implemented(generate_o, Tuple{p, s, a, sp, rng})
        return quote
            o = generate_o(p, s, a, sp, rng)
            return o, reward(p, s, a, sp)
        end
    else
        failed_synth_warning(generate_or)
        return :(throw(MethodError(generate_or, (p,s,a,sp,rng))))
    end
end


function implemented(f::typeof(initial_state), TT::Type)
    m = which(f, TT)
    if m.module == GenerativeModels && !implemented(initial_state_distribution, Tuple{TT.parameters[1]})
        return false
    else
        return true
    end
end

@generated function initial_state(p::Union{POMDP,MDP}, rng::AbstractRNG)
    if implemented(initial_state_distribution, Tuple{p})
        return quote
            d = initial_state_distribution(p)
            return rand(rng, d)
        end
    else
        failed_synth_warning(initial_state)
        return :(throw(MethodError(initial_state, (p, rng))))
    end
end

failed_synth_warning(func) = warn("""
GenerativeModels.jl: Could not find or synthesize $func(). Did you remember to explicitly import it? You may need to restart Julia if you were expecting $func to be automatically synthesized by combining other functions.
                                """)
