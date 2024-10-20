# Домашнее задание_13

"""
1. Напишите функцию, которая загружает данные из API и фильтрует их по заданному
пользователем условию.
"""

import pandas as pd
import requests

# данные о погоде за две недели октября
url = "https://archive-api.open-meteo.com/v1/archive"
params = {
	"latitude": 53.55,
	"longitude": 27.33,
	"start_date": "2024-10-01",
	"end_date": "2024-10-14",
	"hourly": ["temperature_2m", "precipitation", "wind_speed_10m"]
}

response = requests.get(url, params=params)
#print(response.json())

weather = response.json()
#print(weather)

hourly = weather['hourly']
weather_df = pd.DataFrame({
        'Time': hourly['time'],
        'Temperature': hourly['temperature_2m'],
        'Precipitation': hourly['precipitation'],
        'Wind_speed_10m': hourly['wind_speed_10m']
    })
print(weather_df)

filtered_weather_df = weather_df[weather_df['Temperature']>10]
print(filtered_weather_df)



"""
2. Напишите программу, которая загружает данные из нескольких CSV-файлов, объединяет их,
сортирует по нескольким столбцам и сохраняет результат в новый файл.
"""

import pandas as pd

df_1 = pd.DataFrame(pd.read_csv ("File/file_1.csv"))
df_2 = pd.DataFrame(pd.read_csv ("File/file_2.csv"))

#print(df_1)
#print(df_2)

df = pd.concat([df_1, df_2], axis=0)
sorted_df = df.sort_values(by="Number", ascending = True)

#print(sorted_df)

df.to_csv("File/file_new.csv", index = False)