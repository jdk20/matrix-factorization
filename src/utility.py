import numpy as np

def load():
    try:
        data = np.load('build/data.npy')
        data = data.item()

    except:
        data = {}

        data['ratings'] = np.loadtxt('build/data.txt', dtype = 'int32')
        data['ratings'][:,0:2] = data['ratings'][:,0:2] - 1

        data['n_movies'] = 1682
        data['n_users'] = 943

        data['titles'] = np.loadtxt('build/movies.txt', delimiter = '\t', usecols = (1,), dtype = 'str')
        data['genres'] = np.loadtxt('build/movies.txt', delimiter = '\t', usecols = range(2,21), dtype = 'int32')

        data['f_genres'] = np.array(['Unknown', 'Action', 'Adventure', 'Animation', 'Childrens', 'Comedy',
                                     'Crime', 'Documentary', 'Drama', 'Fantasy', 'Film-Noir', 'Horror',
                                     'Musical', 'Mystery', 'Romance', 'Sci-Fi', 'Thriller', 'War', 'Western'],
                                    dtype = 'str')

        np.save('build/data.npy', data)

    return data
