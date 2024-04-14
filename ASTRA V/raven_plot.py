#%%
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import numpy as np


# say no to freedom units
ft_to_m = 0.3048

def toCelsius(f):
    return (f - 32) * 5/9

#%%
flight = "sustainer"

lr_fname = f"raven_{flight}_lr.csv"
hr_fname = f"raven_{flight}_hr.csv"

lr = pd.read_csv(lr_fname)
hr = pd.read_csv(hr_fname)

#%%

lr["Temperature_(F)"] = lr["Temperature_(F)"].apply(toCelsius)
lr["Baro_Altitude_ASL_(feet)"] = lr["Baro_Altitude_ASL_(feet)"] * ft_to_m
lr["GPS_Altitude_AGL_(feet)"] = lr["GPS_Altitude_AGL_(feet)"] * ft_to_m

col_map = {"Temperature_(F)": "Temperature", 
           "Baro_Altitude_ASL_(feet)": "Baro_Altitude_ASL", 
           "Baro_Altitude_AGL_(feet)": "Baro_Altitude_AGL"}

lr = lr.rename(columns=col_map)
