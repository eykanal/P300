function vid = plotBlur( randImg1, randImg2, motion, sec )
% function vid = plotBlur( randImg1, randImg2, motion )
%
%   motion = struct containing:
%       .beg = directional motion onset
%       .end = directional motion offset
%
% Returns a series of frames depicting the convolution of the random noise
% images with optional directional motion. Currently displays for fixed
% time, relative to number of frames.

onset = GetSecs;
frame = 0;
len_t = size( randImg1, 1 );

% display for fixed duration
while onset + sec > GetSecs 
    
    % loop through video frames
    for n=1:len_t
        
        % One randImg will be shown in a constant direction. The other will
        % reverse as necessary, using the below code.
        
        %# TODO - set up so that direction of motion is uesr-controllable
        
        next_frame = 1;
        if n > motion.beg && n < motion.end
            next_frame = -1;
        end
        
        frame = frame + next_frame;
        if frame == 0
            frame = len_t;
        elseif frame == len_t
            frame = 0;
        end

        %# TODO
        % attempt to normalize the images. I don't think this is working.
        img = squeeze( randImg1( n, :, : ) ) + squeeze( randImg2( frame, :, : ) );
        img = img - mean( mean( img ) );
        imagesc( img );
        pause( 0.005 );
    end
end
