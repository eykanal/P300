function vid = plotBlur( randImg1, randImg2, motion, sec )
% function vid = plotBlur( randImg1, randImg2, motion, sec )
%
%   motion = struct containing:
%       dir = motion direction (1 = right, 2 = left)
%       beg = directional motion onset (seconds)
%       end = directional motion offset (seconds)
%       sec = length of display (in seconds, 0 for infinite)
%
% Returns a series of frames depicting the convolution of the random noise
% images with optional directional motion. Currently displays for fixed
% time, relative to number of frames.

onset           = GetSecs;
static_frame    = 0;
dynamic_frame   = 0;
len_t           = size( randImg1, 1 );
colormap('gray');

% display for fixed duration
while onset + sec > GetSecs 
    
    % One randImg will be shown in a constant direction. The other will
    % reverse as necessary, using the below code.
    next_frame = 1;
    if (GetSecs > (onset + motion.beg) ) && (GetSecs < (onset + motion.end) )
        next_frame = -1;
    end

    dynamic_frame = dynamic_frame + next_frame;
    static_frame  = static_frame + 1;
    if dynamic_frame <= 0
        dynamic_frame = len_t;
    elseif dynamic_frame >= len_t + 1
        dynamic_frame = 1;
    end
    if static_frame >= len_t
        static_frame = 1;
    end

    % directionality
    if motion.dir == 1
        l_frame = static_frame;
        r_frame = dynamic_frame;
    else
        l_frame = dynamic_frame;
        r_frame = static_frame;
    end
    
    %# TODO
    % attempt to normalize the images
    img = squeeze( randImg1( l_frame, :, : ) ) + squeeze( randImg2( r_frame, :, : ) );
    img = img - mean( mean( img ) );
    imagesc( img );
    drawnow;

end
