import pandas as pd
from scipy.spatial.transform import Rotation

df = pd.read_csv("APEXI-jul02-custom_parsed.csv", delimiter=", ")

quat_df = df[["Rot_vec_i", "Rot_vec_j", "Rot_vec_k", "Rot_vec_w"]]

rot = Rotation.from_quat(quat_df)
rot_euler = rot.as_euler('xyz', degrees=True)
euler_df = pd.DataFrame(data=rot_euler, columns=['x', 'y', 'z'])

euler_df.insert(0, "Time", df["Time (ms)"])

euler_df.to_csv("rot_vector.csv", index=False)