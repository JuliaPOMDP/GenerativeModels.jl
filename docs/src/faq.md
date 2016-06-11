# Frequently Asked Questions (FAQ)

## Which function(s) should I implement for my problem / use in my solver?

Generally, a problem implementer need only implement the simplest one or two of these functions (in addition to some of the functions from POMDPs.jl). That is, only `generate_s` is required from an MDP, and `generate_s` and `generate_o` from a POMDP. Because of the default implementations in `src/GenerativeModels.jl`, all functions will then be available for solvers to use.

If there is a convenient way for the problem to generate a combination of states, observations, and rewards simultaneously (for example, if there is a simulator written in another programming language that generates these from the same function, or if it is computationally convenient to generate `sp` and `o` simultaneously), then the problem writer may wish to directly implement one of the combination `generate_` functions, e.g. `generate_sor()` directly.

Solver writers should use the single function that generates everything that they need and nothing they don't. For example, if the solver needs access to the state, observation, and reward at every timestep, they should use `generate_sor()` rather than `generate_s()` and `generate_or()`, and if the solver needs access to the state and reward, they should use `generate_sr()` rather than `generate_sor()`. This will ensure the widest interoperability between solvers and problems.

