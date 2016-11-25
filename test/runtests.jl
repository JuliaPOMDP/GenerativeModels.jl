using GenerativeModels
using Base.Test

using POMDPs
type A <: POMDP{Int,Bool,Bool} end

GenerativeModels.disable_default_implementations()

@test_throws MethodError initial_state(A(), Base.GLOBAL_RNG)
@test_throws MethodError generate_s(A(), 1, true, Base.GLOBAL_RNG)
