function [randImg1 randImg2] = createRandMotion( numFrames, matSize )
% function [randImg1 randImg2] = createRandMotion( numFrames, matSize )
%
% Create two numFrames x matSize x matSize directional noise matrices. The
% two matrices correspond to left and right motion.


% define some noise, limit to within 2 sd
randNoise1 = randn(matSize);
randNoise2 = randn(matSize);

% tested - requires only betwee 3-5 iterations to complete each loop
while sum( sum( randNoise1 >= 2 ) ) ~= 0
    randNoise1( randNoise1 >= 2 ) = randn([ 1 length( find( randNoise1 >= 2 ) ) ]);
end

while sum( sum( randNoise2 >= 2 ) ) ~= 0
    randNoise2( randNoise2 >= 2 ) = randn([ 1 length( find( randNoise2 >= 2 ) ) ]);
end

% generate gaussian mesh
[Cx Cy] = meshgrid(-3:0.3:3);
G = 1/sqrt(2*pi)*exp(-((Cx.^2/2)+(Cy.^2/2)));
G = G/max(max(G));

% generate gabor plots, scale them
Gd  = diff(G,1,2);
Gd  = Gd/max(max(Gd));
Gdd = diff(Gd,1,2);
Gdd = Gdd/min(min(Gdd));

% fix matrix sizes to be equal
Gd  = Gd (1:size(Gd ,1)-2,1:size(Gd,2)-1);
Gdd = Gdd(2:size(Gdd,1)-1,:);

% combine plots using eq 1 of paper, convolve with noise
t = linspace( pi/180, 2*pi, numFrames );
len_t = length(t);
img = zeros([len_t, size(Gdd)]);
for n=1:len_t
    img(n,:,:) = cos(t(n))*Gdd + sin(t(n))*Gd;
end

% convolve with random noise
randImg1 = zeros([len_t size(randNoise1)]);
randImg2 = randImg1;
for n=1:len_t
    % we need motion in both directions; randNoise1 goes left, randNoise2
    % goes right
    img1 = conv2( randNoise1, squeeze(img(n,:,:)), 'same' );
    img2 = conv2( randNoise2, squeeze(img(len_t+1-n,:,:)), 'same' );
    
    randImg1(n,:,:) = img1;
    randImg2(n,:,:) = img2;
end
