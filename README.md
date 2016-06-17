# GenerativeModels

[![Build Status](https://travis-ci.org/JuliaPOMDP/GenerativeModels.jl.svg?branch=master)](https://travis-ci.org/JuliaPOMDP/GenerativeModels.jl)

## Description

This package extends POMDPs.jl by providing a small collection of functions that makes implementing and solving problems with generative models easier.

The functions are:
```julia
generate_s{S}(p::POMDP{S}, s, a, rng::AbstractRNG) -> sp::S
generate_o{S,A,O}(p::POMDP{S,A,O}, s, a, sp, rng::AbstractRNG) -> o::O
generate_sr{S}(p::POMDP{S}, s, a, rng::AbstractRNG) -> (s::S, r)
generate_so{S,A,O}(p::POMDP{S,A,O}, s, a, rng::AbstractRNG) -> (s::S, o::O)
generate_or{S,A,O}(p::POMDP{S,A,O}, s, a, sp, rng::AbstractRNG) -> (o::O, r)
generate_sor{S,A,O}(p::POMDP{S,A,O}, s, a, rng::AbstractRNG) -> (s::S, o::O, r)
initial_state{S}(p::POMDP{S}, rng::AbstractRNG) -> s::S
```

The functions that do not deal with observations are defined for `MDP`s as well as `POMDP`s.

The `generate_` functions should return the appropriate combination of a sampled next state, `sp`, sampled observation, `o`, and reward `r`. Many solvers, for example MCTS and its derivatives such as POMCP, only require a generative model and never require explicit distributions. If these solvers use only `generate_` functions, the problem writer may implement `generate_...()` **instead of** `transition()` and `observation()`.

A problem writer will generally only have to implement one or two of these functions for all solvers to work (see below).

`initial_state()` should return a suitable initial state for the problem. By overriding this, the problem-writer can avoid the need to create distribution types.

## Installation

```julia
Pkg.clone("https://github.com/JuliaPOMDP/GenerativeModels.jl.git")
```

## Other details

The function `generate()` also has optional trailing arguments for preallocated states and observations similar to the other functions in POMDPs.jl

The full method signatures are
```julia
generate_s{S}(p::POMDP{S}, s, a, rng::AbstractRNG, sp::S=S())
generate_o{S,A,O}(p::POMDP{S,A,O}, s, a, sp, rng::AbstractRNG, o::O=O())
generate_sr{S}(p::POMDP{S}, s, a, rng::AbstractRNG, sp::S=S())
generate_so{S,A,O}(p::POMDP{S,A,O}, s, a, rng::AbstractRNG, sp::S=S(), o::O=O())
generate_or{S,A,O}(p::POMDP{S,A,O}, s, a, sp, rng::AbstractRNG, o::O=O())
generate_sor{S,A,O}(p::POMDP{S,A,O}, s, a, rng::AbstractRNG, sp::S=S(), o::O=O())
```

Default implementations of the functions are provided in `src/GenerativeModels.jl` so that, if the problem implementer has implemented `transition()`, `observation()`, and `rand()` appropriately, the `generate_` functions will be automatically available for solvers to use, though this implementation is potentially inefficient because a new distribution is allocated every time a state is generated.

## Which function(s) should I implement for my problem / use in my solver?

Generally, a problem implementer need only implement the simplest one or two of these functions (in addition to some of the functions from POMDPs.jl). That is, only `generate_s` is required from an MDP, and `generate_s` and `generate_o` from a POMDP. Because of the default implementations in `src/GenerativeModels.jl`, all functions will then be available for solvers to use.

If there is a convenient way for the problem to generate a combination of states, observations, and rewards simultaneously (for example, if there is a simulator written in another programming language that generates these from the same function, or if it is computationally convenient to generate `sp` and `o` simultaneously), then the problem writer may wish to directly implement one of the combination `generate_` functions, e.g. `generate_sor()` directly.

Solver writers should use the single function that generates everything that they need and nothing they don't. For example, if the solver needs access to the state, observation, and reward at every timestep, they should use `generate_sor()` rather than `generate_s()` and `generate_or()`, and if the solver needs access to the state and reward, they should use `generate_sr()` rather than `generate_sor()`. This will ensure the widest interoperability between solvers and problems.
