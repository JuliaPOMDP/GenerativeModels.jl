using GenerativeModels
import GenerativeModels: generate_o
using Base.Test

using POMDPs
import POMDPs: transition, reward, initial_state_distribution
type A <: POMDP{Int,Bool,Bool} end

@test_throws MethodError initial_state(A(), Base.GLOBAL_RNG)
@test_throws MethodError generate_s(A(), 1, true, Base.GLOBAL_RNG)

type B <: POMDP{Int, Bool, Bool} end

transition(b::B, s::Int, a::Bool) = Int[s+a]
@test method_exists(generate_s, Tuple{B, Int, Bool, MersenneTwister})
@test generate_s(B(), 1, false, Base.GLOBAL_RNG) == 1

reward(b::B, s::Int, a::Bool, sp::Int) = -1.0
@test generate_sr(B(), 1, false, Base.GLOBAL_RNG) == (1, -1.0)

generate_o(b::B, s::Int, a::Bool, sp::Int, rng::AbstractRNG) = sp
generate_sor(B(), 1, true, Base.GLOBAL_RNG) == (1, 2, -1.0)

initial_state_distribution(b::B) = Int[1,2,3]
@test initial_state(B(), Base.GLOBAL_RNG) in initial_state_distribution(B())
