import matplotlib.pyplot as plt
import time
import numpy as np
from compecon import qnwnorm, qnwlogn
from numba import jit, prange,config, njit, threading_layer
import quantecon as qe
from math import exp
import os
from sys import exit

# Aiyagari Model
# Set parameter values
start_time = time.time()

r = 0.04
sigma = 0.5
β = 0.96
a_min = 1e-10  # Exogenous states
a_max = 15
a_size = 30
h_max = 30
h_min = 0
h_size = 10
z_size = 3
dist = 100
δ = 0.08
α = 0.36
γ = 0.5
A = 1.0
ξ = 0.8
τ = 0.1
Q = 0.01

ubar = np.log(1 + np.log(1 + a_max - a_min))
a_grid = np.linspace(a_min, ubar, a_size)
h_grid = np.linspace(h_min, h_max, h_size)
for i in range(a_size):
    a_grid[i] = a_min + (a_max - a_min) * ((1 + 0.01) ** i - 1) / ((1 + 0.01) ** a_size - 1)
for i in range(h_size):
    h_grid[i] = h_min + (h_max - h_min) * ((1 + 0.01) ** i - 1) / ((1 + 0.01) ** h_size - 1)

n, mu, var = 3, 0, 0.1
# Discretize the distribution
ζ, p = qnwlogn(n, mu, var)


# Specify the utility form
@jit(nopython=True)
def utility(sigma, c):
    if sigma == 1:
        u = np.log(c)
    else:
        if c > 0:
            u = (c ** (1 - 1 / sigma)) / (1 - 1 / sigma)
        elif c <= 0:
            u = -9999999999999
    return u


@jit(nopython=True)
def earnings(w, h, ξ, ad):
    E = w * (h ** ξ) * ad + 1.01
    if E < 0:
        print(E)
    return E


@jit(nopython=True)
def investments(h_new, Q, γ, ζζζ):
    e = (h_new / exp(ζζζ) * Q ** (1 - γ)) ** (1 / γ)
    return e


# Specify the budget constraint and receive consumption
@jit(nopython=True)
def budget_constraint(w, h, ξ, ζζζ, r, a, Q, a_next, h_next, ad):
    c = (1 - τ) * earnings(w, h, ξ, ad) + a - (a_next / (1 + r)) - investments(h_next, Q, γ, ζζζ)
    return c


@jit(nopython=True, parallel=True)
def Time_invariant_utility(a_grid, z_vals, r, w, sigma, ξ, Q, h_grid, ζ):
    V = np.empty((a_size, h_size, a_size, h_size, z_size, z_size))
    for zzz in prange(z_size):
        for k in prange(z_size):
            for i in prange(a_size):
                for d in prange(h_size):
                    for j in prange(a_size):
                        for dd in prange(h_size):
                            c_1 = budget_constraint(w, h_grid[d], ξ, z_vals[k], r, a_grid[i], Q, a_grid[j], h_grid[dd],
                                                    ζ[zzz])
                            U = utility(sigma, c_1)
                            V[i, d, j, dd, k, zzz] = U
    return V


@jit(nopython=True, parallel=True)
def Households(r, w):
    U_temp = np.zeros((a_size, h_size), dtype=np.float64)
    V_temp = np.zeros((a_size, h_size, z_size, z_size), dtype=np.float64)
    # a_policy = np.zeros((a_size, h_size, z_size, z_size), dtype=np.float64)
    # h_policy = np.zeros((a_size, h_size, z_size, z_size), dtype=np.float64)
    Ind = np.zeros((a_size, h_size, z_size, z_size), dtype=np.float64)
    V_static = Time_invariant_utility(a_grid, z_vals, r, w, sigma, ξ, Q, h_grid, ζ)
    V_new = np.zeros((a_size, h_size, z_size, z_size), dtype=np.float64)
    dist = 100
    V_next1 = np.empty((z_size))
    V_next = np.empty((z_size))
    while dist > 1e-05:
        for k in prange(z_size):
            for kk in prange(z_size):
                for i in prange(a_size):
                    for n in prange(h_size):
                        for j in prange(a_size):
                            for h in prange(h_size):
                                for d in prange(z_size):
                                    for dd in prange(z_size):
                                        V_next1[dd] = p[dd] * V_new[j, h, d, dd]
                                    V_next[d] = β * Π[k, d] * sum(V_next1)
                                    V_next1 = np.empty(z_size)
                                U_temp[j, h] = V_static[i, n, j, h, k, kk] + sum(V_next)
                                V_next = np.empty(z_size)
                        V_temp[i, n, k, kk] = np.amax(U_temp)
                        Ind[i, n, k, kk] = np.argmax(U_temp)
                        U_temp = np.empty((a_size, h_size))
        V_temp2 = np.reshape(V_temp, a_size * h_size * z_size * z_size)
        V_new_2 = np.reshape(V_new, a_size * h_size * z_size * z_size)
        dist = np.linalg.norm(V_temp2 - V_new_2)  # -> (nx, ny) distances
        print(dist)
        V_new = V_temp
        V_temp = np.empty((a_size, h_size, z_size, z_size))
        U_temp = np.empty((a_size, h_size))
    return V_new, Ind


# @jit(nopython=False, parallel=True)
def Households2(r, w, v):
    U_temp = np.zeros((a_size, h_size), dtype=np.float64)
    V_temp = np.zeros((a_size, h_size, z_size, z_size), dtype=np.float64)
    a_policy = np.zeros((a_size, h_size, z_size, z_size), dtype=np.float64)
    h_policy = np.zeros((a_size, h_size, z_size, z_size), dtype=np.float64)
    c_policy = np.zeros((a_size, h_size, z_size, z_size), dtype=np.float64)
    Ind = np.zeros((a_size, h_size, z_size, z_size), dtype=np.float64)
    V_static = Time_invariant_utility(a_grid, z_vals, r, w, sigma, ξ, Q, h_grid, ζ)
    V_new = v
    dist = 100
    V_next1 = np.empty((z_size))
    V_next = np.empty((z_size))
    while dist > 1e-05:
        for k in prange(z_size):
            for kk in prange(z_size):
                for i in prange(a_size):
                    for n in prange(h_size):
                        for j in prange(a_size):
                            for h in prange(h_size):
                                for d in prange(z_size):
                                    for dd in prange(z_size):
                                        V_next1[dd] = p[dd] * V_new[j, h, d, dd]
                                    V_next[d] = β * Π[k, d] * sum(V_next1)
                                    V_next1 = np.empty(z_size)
                                U_temp[j, h] = V_static[i, n, j, h, k, kk] + sum(V_next)
                                V_next = np.empty(z_size)
                        V_temp[i, n, k, kk] = np.amax(U_temp)
                        ind = np.unravel_index(np.argmax(U_temp, axis=None), U_temp.shape)
                        a_policy[i, n, k, kk] = a_grid[ind[0]]
                        h_policy[i, n, k, kk] = h_grid[ind[1]]
                        c_policy[i, n, k, kk] = budget_constraint(w, h_grid[n], ξ, z_vals[kk], r, a_grid[i], Q,
                                                                  a_policy[i, n, k, kk], h_policy[i, n, k, kk],
                                                                  ζ[k])
                        U_temp = np.empty((a_size, h_size))
        V_temp2 = np.reshape(V_temp, a_size * h_size * z_size * z_size)
        V_new_2 = np.reshape(V_new, a_size * h_size * z_size * z_size)
        dist = np.linalg.norm(V_temp2 - V_new_2)  # -> (nx, ny) distances
        print(dist)
        V_new = V_temp
        V_temp = np.empty((a_size, h_size, z_size, z_size))
        U_temp = np.empty((a_size, h_size))
    return V_new, a_policy, h_policy, c_policy


@jit(nopython=True, parallel=True)
def stationary_markov(Pi, tol=1E-14):
    # start with uniform distribution over all states
    n = Pi.shape[0]
    pi = np.full(n, 1 / n)

    # update distribution using Pi until successive iterations differ by less than tol
    for _ in prange(10_000):
        pi_new = Pi.T @ pi
        if np.max(np.abs(pi_new - pi)) < tol:
            return pi_new
        pi = pi_new


w = 1

rho = 0.6
sigma2 = (0.04 * (1 - rho ** 2)) ** 0.5
ybar = 0
z = qe.markov.approximation.rouwenhorst(z_size, ybar, sigma2, rho)
Π = z.P
Π = np.array(Π)
π = stationary_markov(Π)
z_vals = np.array(z.state_values)
# z_vals = np.exp(z_vals)

[V_new, Index] = Households(r, w)
[V_new, a_policy, h_policy, c_policy] = Households2(r, w, V_new)
print("--- %s seconds ---" % (time.time() - start_time))
for i in range(z_size):
    plt.plot(a_grid, V_new[:, 0, i, 0])
    plt.ylabel('Value function')
    plt.xlabel('Wealth')
plt.show()

for i in range(z_size):
    plt.plot(a_grid, a_policy[:, 0, i, 0])
    plt.ylabel('Policy_next')
    plt.xlabel('Wealth')
plt.show()

for i in range(z_size):
    plt.plot(a_grid, c_policy[:, 0, i, 0])
    plt.ylabel('Policy_c')
    plt.xlabel('Wealth')
plt.show()

for i in range(z_size):
    plt.plot(a_grid, h_policy[:, 0, i, 0])
    plt.ylabel('Policy_h')
    plt.xlabel('Wealth')
plt.show()
