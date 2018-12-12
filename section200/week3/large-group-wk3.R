library(tidyverse)
library(spotifyr)
library(knitr)
library(magrittr)
library(dplyr)

load_dot_env(file = '.env')
Sys.setenv(SPOTIFY_CLIENT_ID = '') # add from .env file
Sys.setenv(SPOTIFY_CLIENT_SECRET = '') # add from .env file

df <- get_artist_audio_features('Ariana Grande', access_token = get_spotify_access_token())

#1.
str(df)
# The dimensions are 85x23
colnames(df)

# 2.
df %>%
  select(album_name) %>%
  group_by(album_name) %>%
  summarise()
# 6 albums published so far
# Yours Truly (LatAm Version) is the second longest title

# 3. 
df %>%
  select(album_name) %>%
  group_by(album_name) %>%
  summarise(tracks = n())
# My Everything has the most number of tracks

# 4. 
df %>%
  select(album_name, duration_ms) %>%
  group_by(album_name) %>%
  summarise(mean_time = mean(duration_ms))

# 5.
df %>%
  select(album_name, album_popularity)