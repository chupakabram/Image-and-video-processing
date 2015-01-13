% Octave code

%
% Image and video processing - Coursera - 2015
% Quiz 1 - question 13
%
% Write a computer program capable of reducing the number of intensity 
% levels in an image from 256 to 2, in integer powers of 2. The desired 
% number of intensity levels needs to be a variable input to your program.
%
% usage: answer = ReduceImageLevel( image_var, integer_var_in_range_0_256 )
%
% Returns the image with levels 
% Created: January 2015
% Version: 0.1
% Keywords: image level

function result = ReduceImageLevel(im, nl)
    result = uint8(floor((double(im))/(256/nl)))*(256/nl);
endfunction




