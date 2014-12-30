import pandas as pd

data_path       = 'D:/workspace/pyDataAnalysis_working/pydata-book-master/ch02/movielens'
user_file       = data_path + '/users.dat'
ratings_file    = data_path + '/ratings.dat'
movies_file     = data_path + '/movies.dat'

unames  = ['user_id', 'gender', 'age', 'occupation', 'zip']
users   = pd.read_table(user_file, sep = '::', header=None, names=unames)

rnames  = ['user_id', 'movie_id', 'rating', 'timestamp']
ratings = pd.read_table(ratings_file, sep = '::', header=None, names=rnames)

mnames  = ['movie_id', 'title', 'genres']
movies = pd.read_table(movies_file, sep = '::', header=None, names=mnames)

print movies[:5]