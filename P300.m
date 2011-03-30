clear
close all

% define some noise
noiseSize = 400;
randNoise1 = randn(noiseSize);
randNoise2 = randn(noiseSize);

% set to 1 to have a movie recorded
takeVid = 0;

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
t = pi/180:pi/90:2*pi;
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
    randImg1(n,:,:) = conv2( randNoise1, squeeze(img(n,:,:)), 'same' );
    randImg2(n,:,:) = conv2( randNoise2, squeeze(img(len_t+1-n,:,:)), 'same' );
end



figure();
colormap(gray);
for m=1:3
    for n=1:len_t
        imagesc(squeeze(randImg1(n,:,:)) + squeeze(randImg2(n,:,:)));
        pause(0.005);
    end
end