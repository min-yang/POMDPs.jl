# POMDP model functions
"""
Abstract base type for a partially observable Markov decision process.

    S: state type
    A: action type
    O: observation type
"""
abstract type POMDP{S,A,O} end

"""
Abstract base type for a fully observable Markov decision process.

    S: state type
    A: action type
"""
abstract type MDP{S,A} end

"""
    n_states(problem::POMDP)
    n_states(problem::MDP)

Return the number of states in `problem`. Used for discrete models only.
"""
function n_states end

"""
    n_actions(problem::POMDP)
    n_actions(problem::MDP)

Return the number of actions in `problem`. Used for discrete models only.
"""
function n_actions end

"""
    n_observations(problem::POMDP)

Return the number of observations in `problem`. Used for discrete models only.
"""
function n_observations end

"""
    discount(problem::POMDP)
    discount(problem::MDP)

Return the discount factor for the problem.
"""
discount(::Union{MDP,POMDP}) = 1.0

"""
    transition{S,A,O}(problem::POMDP{S,A,O}, state::S, action::A)
    transition{S,A}(problem::MDP{S,A}, state::S, action::A)

Return the transition distribution from the current state-action pair
"""
function transition end

"""
    observation{S,A,O}(problem::POMDP{S,A,O}, statep::S)

Return the observation distribution for a state (this method can only be
implemented when the observation does not depend on the action)
"""
function observation end

"""
    observation{S,A,O}(problem::POMDP{S,A,O}, action::A, statep::S)

Return the observation distribution for the a-s' tuple (action and next state)
"""
observation{S,A,O}(problem::POMDP{S,A,O}, a::A, sp::S) = observation(problem, sp)
@impl_dep {P<:POMDP,S,A} observation(::P,::A,::S) observation(::P,::S)

"""
    observation{S,A,O}(problem::POMDP{S,A,O}, state::S, action::A, statep::S)

Return the observation distribution for the s-a-s' tuple (state, action, and next state)
"""
observation{S,A,O}(problem::POMDP{S,A,O}, s::S, a::A, sp::S) = observation(problem, a, sp)
@impl_dep {P<:POMDP,S,A} observation(::P,::S,::A,::S) observation(::P,::A,::S)

"""
    reward{S,A,O}(problem::POMDP{S,A,O}, state::S, action::A)
    reward{S,A}(problem::MDP{S,A}, state::S, action::A)

Return the immediate reward for the s-a pair
"""
function reward end

"""
    reward{S,A,O}(problem::POMDP{S,A,O}, state::S, action::A, statep::S)
    reward{S,A}(problem::MDP{S,A}, state::S, action::A, statep::S)

Return the immediate reward for the s-a-s' triple
"""
reward(problem, s, a, sp) = reward(problem, s, a)
@impl_dep {P<:Union{POMDP,MDP},S,A} reward(::P,::S,::A,::S) reward(::P,::S,::A)

"""
    isterminal_obs{S,A,O}(problem::POMDP{S,A,O}, observation::O)

Check if an observation is terminal.
"""
isterminal_obs{S,A,O}(problem::POMDP{S,A,O}, observation::O) = false

"""
    isterminal{S,A,O}(problem::POMDP{S,A,O}, state::S)
    isterminal{S,A}(problem::MDP{S,A}, state::S)

Check if state s is terminal
"""
isterminal{S,A}(problem::Union{POMDP{S,A},MDP{S,A}}, state::S) = false

"""
    state_index{S,A,O}(problem::POMDP{S,A,O}, s::S)
    state_index{S,A}(problem::MDP{S,A}, s::S)

Return the integer index of state `s`. Used for discrete models only.
"""
function state_index end

"""
    action_index{S,A,O}(problem::POMDP{S,A,O}, a::A)
    action_index{S,A}(problem::MDP{S,A}, a::A)

Return the integer index of action `a`. Used for discrete models only.
"""
function action_index end

"""
    obs_index{S,A,O}(problem::POMDP{S,A,O}, o::O)

Return the integer index of observation `o`. Used for discrete models only.
"""
function obs_index end

"""
    convert_s(::Type{V}, s, problem::Union{MDP,POMDP}) where V <: AbstractArray
    convert_s(::Type{S}, vec::V, problem::Union{MDP,POMDP}) where {S,V} <: AbstractArray

Convert a state to vectorized form or vice versa.
"""
function convert_s end

convert_s(T::Type{A1}, s::A2, problem::Union{MDP, POMDP}) where {A1<:AbstractArray, A2<:AbstractArray} = convert(T, s)

convert_s(::Type{A}, s::Number, problem::Union{MDP,POMDP}) where A<:AbstractArray{F} where F<:Number = F[s]
convert_s(::Type{N}, v::AbstractArray{F}, problem::Union{MDP, POMDP}) where {N<:Number, F<:Number} = convert(N, first(v))


"""
    convert_a(::Type{V}, a, problem::Union{MDP,POMDP}) where V <: AbstractArray
    convert_a(::Type{A}, vec::V, problem::Union{MDP,POMDP}) where {A,V} <: AbstractArray

Convert an action to vectorized form or vice versa.
"""
function convert_a end

convert_a(T::Type{A1}, s::A2, problem::Union{MDP, POMDP}) where {A1<:AbstractArray, A2<:AbstractArray} = convert(T, s)

convert_a(::Type{A}, s::Number, problem::Union{MDP,POMDP}) where A<:AbstractArray{F} where F<:Number = F[s]
convert_a(::Type{N}, v::AbstractArray{F}, problem::Union{MDP, POMDP}) where {N<:Number, F<:Number} = convert(N, first(v))


"""
    convert_o(::Type{V}, o, problem::Union{MDP,POMDP}) where V <: AbstractArray
    convert_o(::Type{O}, vec::V, problem::Union{MDP,POMDP}) where {O,V} <: AbstractArray

Convert an observation to vectorized form or vice versa.
"""
function convert_o end

convert_o(T::Type{A1}, s::A2, problem::Union{MDP, POMDP}) where {A1<:AbstractArray, A2<:AbstractArray} = convert(T, s)

convert_o(::Type{A}, s::Number, problem::Union{MDP,POMDP}) where A<:AbstractArray{F} where F<:Number = F[s]
convert_o(::Type{N}, v::AbstractArray{F}, problem::Union{MDP, POMDP}) where {N<:Number, F<:Number} = convert(N, first(v))



# XXX DEPRECATED - remove in version 0.7
function Base.convert(T::Type, x::X, problem::Union{MDP,POMDP}) where X
    Base.depwarn("POMDPs.convert is deprecated. Please use convert_s, convert_a, or convert_o.", :convert)
    return convert_s(T, x, problem)
end
#=
"""
    convert{S}(::Type{V}, s::S, problem::Union{MDP,POMDP}) where V <: AbstractArray
    convert{S}(::Type{S}, vec::V, problem::Union{MDP,POMDP}) where V <: AbstractArray

Convert a state or observaton to vectorized form of floats or convert
an array of floats back to a problem specific state or observation.
"""
Base.convert

Base.convert(T::Type{A1}, s::A2, problem::Union{MDP, POMDP}) where {A1<:AbstractArray, A2<:AbstractArray} = convert(T, s)

Base.convert(::Type{A}, s::Number, problem::Union{MDP,POMDP}) where A<:AbstractArray{F} where F<:Number = F[s]
Base.convert(::Type{N}, v::AbstractArray{F}, problem::Union{MDP, POMDP}) where {N<:Number, F<:Number} = convert(N, first(v))
=#
