clc; clear all; close all;

% Load
try
    load('build/data.mat')
catch
    ratings = load('build/data.txt');

    n_movies = 1682;
    n_users = 943;

    temp = importdata('build/movies.txt');
    titles = temp.textdata(:,2);
    genres = temp.data;

    f_genres = {'Unknown', 'Action', 'Adventure', 'Animation', 'Childrens', 'Comedy', ...
                 'Crime', 'Documentary', 'Drama', 'Fantasy', 'Film-Noir', 'Horror', ...
                 'Musical', 'Mystery', 'Romance', 'Sci-Fi', 'Thriller', 'War', 'Western'};

    save('build/data.mat', 'ratings', 'n_movies', 'n_users', 'titles', 'genres', 'f_genres')
end

