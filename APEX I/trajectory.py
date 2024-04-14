from mpl_toolkits import mplot3d

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import pandas as pd


# Helper functions
def Rx(theta):
    return np.matrix([[1, 0, 0],
                     [0, np.cos(theta), -np.sin(theta)],
                     [0, np.sin(theta), np.cos(theta)]])


def Ry(theta):
    return np.matrix([[np.cos(theta), 0, np.sin(theta)],
                     [0, 1, 0],
                     [-np.sin(theta), 0, np.cos(theta)]])


def Rz(theta):
    return np.matrix([[np.cos(theta), -np.sin(theta), 0],
                     [np.sin(theta), np.cos(theta), 0],
                     [0, 0, 1]])


def euler_angles_to_vector(phi, theta, psi):
    initial = np.array([0, 0, -1])
    R = Rz(psi) * Ry(theta) * Rx(phi)
    return np.dot(R, initial)

centre = np.array([0, 0, 0])
def draw_vector(i, j, k):
    pos = np.array([i, j, k])

    # start = centre - pos
    start = np.zeros((3,))
    end = centre + pos
    return np.vstack([start, end])


# Real stuff

df = pd.read_csv("geo_mag_vector.csv")

# Indices of the first and last rows of useful data
start = 2000
end = 3600
df = df[:][start:end]
df.reset_index(inplace=True)

starting_time = df["Time"][0]
vectors = []

# This isn't super duper accurate right now, because some readings are delayed
for i in range(len(df)):
    vec = euler_angles_to_vector(df["x"][i], df["y"][i], df["z"][i])
    vectors.append(vec)

print(len(vectors))

# Code to animate a 3d line
fig = plt.figure()
ax = plt.axes(projection='3d')

text = ax.text(0.5, 0.05, 0, "Time=0.00s", fontsize=14)

line = ax.plot([], [], [])[0]

def animate(i):
    time = (df["Time"][i] - starting_time) / 1000
    vec = vectors[i]
    arrow = draw_vector(vec[0, 0], vec[0, 1], vec[0, 2])
    
    line.set_data(arrow[:, :2].T)
    line.set_3d_properties(arrow[:, 2])
    text.set_text(f"Time={time:.02f}s")

    return line, text


# Setting the axes properties
ax.set(xlim3d=(-2, 2), xlabel='X')
ax.set(ylim3d=(-2, 2), ylabel='Y')
ax.set(zlim3d=(-2, 2), zlabel='Z')

ani = animation.FuncAnimation(
    fig, animate, len(vectors), interval=10, blit=True)

ani.save('geo_mag_vector.gif', fps=60)
