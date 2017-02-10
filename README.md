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
using POMDPs
POMDPs.add("GenerativeModels")
```
or
```julia
Pkg.clone("https://github.com/JuliaPOMDP/GenerativeModels.jl.git")
```

## Other details

Default implementations of the functions are provided in `src/defaults.jl` so that, if the problem implementer has implemented `transition()`, `observation()`, `reward()`, and `rand()` appropriately, the `generate_` functions will be automatically available for solvers to use.

## Which function(s) should I implement for my problem / use in my solver?

### Problem Writers

Generally, a problem implementer need only implement the simplest one or two of these functions, and the rest are automatically synthesized at runtime.

If there is a convenient way for the problem to generate a combination of states, observations, and rewards simultaneously (for example, if there is a simulator written in another programming language that generates these from the same function, or if it is computationally convenient to generate `sp` and `o` simultaneously), then the problem writer may wish to directly implement one of the combination `generate_` functions, e.g. `generate_sor()` directly.

Use the following logic to determine which functions to implement:
- If you are implementing the problem from scratch in Julia, implement `generate_s` and `generate_o`.
- Otherwise, if your external simulator returns *x*, where *x* is one of *sr*, *so*, *or*, or *sor*, implement `generate_x`. (you may also have to implement `generate_s` separately for use in particle filters).

### Solver and Simulator Writers

Solver writers should use the single function that generates everything that they need and nothing they don't. For example, if the solver needs access to the state, observation, and reward at every timestep, they should use `generate_sor()` rather than `generate_s()` and `generate_or()`, and if the solver needs access to the state and reward, they should use `generate_sr()` rather than `generate_sor()`. This will ensure the widest interoperability between solvers and problems.

In other words, if you need access to *x* where *x* is *s*, *o*, *sr*, *so*, *or*, or *sor* at a certain point in your code, use `generate_x`.
