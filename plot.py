import numpy as np
import matplotlib.pyplot as plt

# python Pendulum\plot.py

data = np.loadtxt('Pendulum\\result.txt', delimiter=',', skiprows=1)
time  = data[:, 0]  # 第一欄: 時間   (秒)
theta = data[:, 1]  # 第二欄: 角度   (弧度 rad)
omega = data[:, 2]  # 第三欄: 角速度 (rad/s)
theta_deg = np.degrees(theta)
plt.figure(figsize=(10, 5))
plt.plot(time, theta_deg, label=r'$\theta$ (Degrees)', color='blue', linewidth=2)

# 裝飾圖表
plt.title('Nonlinear Pendulum Simulation (Velocity Verlet)', fontsize=14)
plt.xlabel('Time (seconds)', fontsize=12)
plt.ylabel('Angle (degrees)', fontsize=12)
plt.grid(True, linestyle='--', alpha=0.6)
plt.legend(fontsize=11)
plt.show()
