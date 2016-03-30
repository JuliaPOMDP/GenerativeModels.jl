# GenerativeModels

[![Build Status](https://travis-ci.org/zsunberg/GenerativeModels.jl.svg?branch=master)](https://travis-ci.org/zsunberg/GenerativeModels.jl)

## Description

Note: this package is designed to be used only with the "parametric" version of POMDPs (i.e. a version that exports POMDP{S,A,O} rather than POMDP).

This package extends POMDPs.jl by providing a single interface function that makes implementing and solving problems with generative models easier.

For POMDPs, this function is
```julia
generate{S,A,O}(p::POMDP{S,A,O}, s::S, a::A, rng::AbstractRNG) -> (sp::S, o::O, r)
```
and, for MDPs, it is
```julia
generate{S,A}(p::MDP{S,A}, s::S, a::A, rng::AbstractRNG) -> (sp::S, r)
```
(see below for more details (i.e. optional arguments, etc.))

This function should return a sample next state, `sp`, observation, `o`, and reward `r`. Many solvers, for example MCTS and its derivatives such as POMCP, only require a generative model and never require explicit distributions. If these solvers use the `generate` function, the problem writer may implement `generate()` *instead of* `transition()` and `observation()`

## Installation

```julia
Pkg.clone("https://github.com/JuliaPOMDP/GenerativeModels.jl.git")
```

## Other details

The function `generate()` also has optional trailing arguments for preallocated states and observations similar to the other functions in POMDPs.jl

The full method signatures are
```julia
generate{S,A,O}(p::POMDP{S,A,O}, s::S, a::A, rng::AbstractRNG, sp::S=S(), o::O=O()
```
and
```julia
generate{S,A}(p::MDP{S,A}, s::S, a::A, rng::AbstractRNG, sp::S=S())
```

The following default implementation is provided for problems that don't implement a specialized version of `generate()`. This is inefficient because new distributions are allocated at each timestep. A more efficient solution may be added in the future.

```julia
function generate{S,A,O}(p::POMDP{S,A,O}, s::S, a::A, rng::AbstractRNG, sp::S=S(), o::O=O())
    td = transition(p, s, a)
    sp = rand(rng, td, sp)
    od = observation(p, s, a, sp)
    o = rand(rng, od, o)
    r = reward(p, s, a, sp)
    return (sp, o, r)
end
```
