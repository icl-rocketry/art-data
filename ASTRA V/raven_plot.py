#%%
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import numpy as np



#%%
flight = "sustainer"

lr_fname = f"raven_{flight}_lr.csv"
hr_fname = f"raven_{flight}_hr.csv"

lr = pd.read_csv(lr_fname)
hr = pd.read_csv(hr_fname)

#%%
lr.head()
hr.head()