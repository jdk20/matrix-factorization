clc; clear all; close all;

% load MovieLens dataset
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

% basic visualizations
c = [0.5 0.5 0.5];
fa = 0.2;
lw = 1.25;

figure(1)
subplot(131)
r = ratings(:,3);
p = histcounts(r,5);
p = p./sum(p);

box off; hold on;
bar(1:5, p, 1, 'EdgeColor',c,'FaceColor',c,'FaceAlpha',fa,'linewidth',lw);
ylim([0 1]);
xlim([0 6]);
set(gca, 'XTick', 1:5, 'YTick', 0:0.2:1);
xlabel('Movie Rating')
ylabel('Probability')
h1 = legend('All Movies','Location','NorthWest');
set(h1, 'box', 'off')

subplot(132)
m = zeros(1682,1);
for i = 1:size(ratings,1)
    m(ratings(i,2)) = m(ratings(i,2)) + 1;
end
[~,index] = sort(m,'descend');

temp = [];
index = index(1:10);
for i = 1:length(index)
    temp = [temp; ratings(ratings(:,2) == index(i), 3)];
end
p2 = histcounts(temp,5);
p2 = p2./sum(p2);

box off; hold on;
bar(1:5, p, 1, 'EdgeColor',c,'FaceColor',c,'FaceAlpha',fa,'linewidth',lw);
bar(1:5, p2, 0.5, 'EdgeColor',[0 0.447 0.741],'FaceColor',[0 0.447 0.741],'FaceAlpha',fa,'linewidth',lw);
ylim([0 1]);
xlim([0 6]);
set(gca, 'XTick', 1:5, 'YTick', 0:0.2:1);
xlabel('Movie Rating')
h1 = legend('All Movies','Top 10 Most Popular Movies','Location','NorthWest');
set(h1, 'box', 'off')

subplot(133)
n = zeros(1682,1);
for i = 1:size(ratings,1)
    n(ratings(i,2)) = n(ratings(i,2)) + ratings(i,3);
end
[~,index] = sort(n./m,'descend');

temp = [];
index = index(1:10);
for i = 1:length(index)
    temp = [temp; ratings(ratings(:,2) == index(i), 3)];
end
p3 = histcounts(temp, 1:6);
p3 = p3./sum(p3);

box off; hold on;
bar(1:5, p, 1, 'EdgeColor',c,'FaceColor',c,'FaceAlpha',fa,'linewidth',lw);
bar(5, p3(end), 0.5, 'EdgeColor',[0.85 0.325 0.098],'FaceColor',[0.85 0.325 0.098],'FaceAlpha',fa,'linewidth',lw);
ylim([0 1]);
xlim([0 6]);
set(gca, 'XTick', 1:5, 'YTick', 0:0.2:1);
xlabel('Movie Rating')
h1 = legend('All Movies','Top 10 Highest Rated Movies','Location','NorthWest');
set(h1, 'box', 'off')

% genres Film-Noir, Horror, Western - 11, 12, 19 
figure(2)
g1 = ratings(logical(genres(:,11)),3);
g1 = histcounts(g1,5);
g1 = g1./sum(g1);

g2 = ratings(logical(genres(:,12)),3);
g2 = histcounts(g2,5);
g2 = g2./sum(g2);

g3 = ratings(logical(genres(:,19)),3);
g3 = histcounts(g3,5);
g3 = g3./sum(g3);

subplot(131)
box off; hold on;
bar(1:5, p, 1, 'EdgeColor',c,'FaceColor',c,'FaceAlpha',fa,'linewidth',lw);
bar(1:5, g1, 0.5, 'EdgeColor',[0.466 0.674 0.188],'FaceColor',[0.466 0.674 0.188],'FaceAlpha',fa,'linewidth',lw);
ylim([0 0.5]);
xlim([0 6]);
set(gca, 'XTick', 1:5, 'YTick', 0:0.1:1);
xlabel('Movie Rating')
ylabel('Probability')
h1 = legend('All Movies','Film-Noir','Location','NorthWest');
set(h1, 'box', 'off')

subplot(132)
box off; hold on;
bar(1:5, p, 1, 'EdgeColor',c,'FaceColor',c,'FaceAlpha',fa,'linewidth',lw);
bar(1:5, g2, 0.5, 'EdgeColor',[0.635 0.078 0.184],'FaceColor',[0.635 0.078 0.184],'FaceAlpha',fa,'linewidth',lw);
ylim([0 0.5]);
xlim([0 6]);
set(gca, 'XTick', 1:5, 'YTick', 0:0.1:1);
xlabel('Movie Rating')
h1 = legend('All Movies','Horror','Location','NorthWest');
set(h1, 'box', 'off')

subplot(133)
box off; hold on;
bar(1:5, p, 1, 'EdgeColor',c,'FaceColor',c,'FaceAlpha',fa,'linewidth',lw);
bar(1:5, g3, 0.5, 'EdgeColor',[0.929 0.694 0.125],'FaceColor',[0.929 0.694 0.125],'FaceAlpha',fa,'linewidth',lw);
ylim([0 0.5]);
xlim([0 6]);
set(gca, 'XTick', 1:5, 'YTick', 0:0.1:1);
xlabel('Movie Rating')
h1 = legend('All Movies','Western','Location','NorthWest');
set(h1, 'box', 'off')

set(figure(1),'PaperPosition',[0 0 11 5.5]);
print(figure(1),'-r600','-dtiff','Basic_1.tiff')

set(figure(2),'PaperPosition',[0 0 11 5.5]);
print(figure(2),'-r600','-dtiff','Basic_2.tiff')
