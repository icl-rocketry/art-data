#%%
import pandas as pd
import plotly.express as px
import plotly.io as pio
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
lr["Baro_Altitude_AGL_(feet)"] = lr["Baro_Altitude_AGL_(feet)"] * ft_to_m

col_map = {"Temperature_(F)": "Temperature", 
           "Baro_Altitude_ASL_(feet)": "Baro_Altitude_ASL", 
           "Baro_Altitude_AGL_(feet)": "Baro_Altitude_AGL"}

lr = lr.rename(columns=col_map)

#%%
# plot baro alt

fig = px.line(lr, x="Flight_Time_(s)", 
              y="Baro_Altitude_AGL", 
              title=f"{flight} baro altitude AGL")

fig.update_traces(line_color="#285943")

apogee_index = lr["Baro_Altitude_AGL"].idxmax()
    
t_start = lr["Flight_Time_(s)"].iloc[0]
t_apogee = lr["Flight_Time_(s)"].iloc[apogee_index]
alt_apogee = lr["Baro_Altitude_AGL"].iloc[apogee_index]
t_end = lr["Flight_Time_(s)"].iloc[-1]



# Add vertical line
fig.add_shape(type="line",
              x0=t_apogee, y0=0,
              x1=t_apogee, y1=alt_apogee,
              line=dict(color="#4C1A57", width=2, dash="dot"),
              name='Apogee Time',
              showlegend=False)

# Add horizontal line
fig.add_shape(type="line",
              x0=t_start, y0=alt_apogee,
              x1=t_end, y1=alt_apogee,
              line=dict(color="#4C1A57", width=2, dash="dot"),
              name='Apogee Altitude',
              showlegend=False)

# Add annotation for the maximum value
fig.add_annotation(x=t_end-10, y=alt_apogee-50, 
                   text=f'Apogee: {alt_apogee:.2f}m at {t_apogee:.2f}s', 
                   showarrow=False, font=dict(size=16, color="#4C1A57"))

fig.update_layout(xaxis_title='Time (s)', yaxis_title='Altitude AGL (m)')
fig.show()

pio.write_image(fig, f"raven_{flight}_baro_altitude_agl.png")
# %%
