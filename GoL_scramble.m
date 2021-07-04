clear;
clc;
close all;

rng(10000);

% X = imread('cameraman.tif');

X_rgb = imread('lena256.png');
X = X_rgb(:,:,1);


X = imresize(X,[64,64]);
height = size(X,1);
width  = size(X,2);
Y = zeros(height, width); %scrambled image initialization

r = 1; %plain image index // height
c = 1; %plain image index // width

num_gen = 30; %number of generations

% A = zeros(height, width, m+1); %m+1 because the first is the initial A0

A(:,:,1) = (randi(2, height, width)-1 ) * 7; %zeros or sevens

figure;imagesc(X);colorbar;

for m = 2:num_gen+1
    [A(:,:,m), mis] = Async_GoL(A(:,:,m-1));
%     figure;imagesc(A(:,:,m));colorbar;
    if(m==2) % after first generation
        [row, column, ~] = find(A(:,:,m)==7);
        index = [row column];
        for n=1:length(row)
            Y(row(n), column(n)) = X(r,c);
        end
    else
        
        [row7, column7, ~] = find((A(:,:,m)==7)); 
        count = zeros(size(A,1),size(A,2));
        for ki=1:size(A,1)
            for kj=1:size(A,2)
                for p=1:m-1
                    if(A(ki,kj,p)==0)
                        count(ki,kj) = count(ki,kj) + 1;
                    end
                end
            end
        end
        
        [rin, colin] = find(count==max(max(count)));
        row = [row7;rin];
        column = [column7; colin];
        for n=1:length(row)
            Y(row(n), column(n)) = X(r,c);
        end
    end
    
    if(r < height)
        r = r + 1;
    else
        c = c + 1;
        r = 1;
    end  
%     figure;imagesc(Y);colorbar;
    n = norm(A(:,:,1)-A(:,:,m));
end

mis
count_0 = zeros(height, width);
for i=1:height
    for j=1:width
        for m=2:num_gen+1
            if (A(i,j,m)==0)
                count_0(i,j) = count_0(i,j)+1;
            end
        end
    end
end
            
[all_row,all_col] = find(count_0 == max(max(count_0)));         

for o=1:length(all_row)
    for v=r:size(X,1)
        for b=c:size(X,2)         
            Y(all_row(o),all_col(o)) = X(v, b);
        end
    end
end
figure;imagesc(Y);colorbar;

GDD = GrayDifferenceDegree(X,Y)

