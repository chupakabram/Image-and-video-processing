% Octave code

%
% Image and video processing - Coursera - 2015
% Quiz 1 - question 13

%
% Write a computer program capable of reducing the number of intensity 
% levels in an image from 256 to 2, in integer powers of 2. The desired 
% number of intensity levels needs to be a variable input to your program.
%

%demo test 1
fprintf('\nTest 1 - Reduce levels in image\n\n');
I = imread('peppers.png');
figure 1;
for idx=(1:8)
    levels = 2^idx;
    Ir = ReduceImageLevel(I,levels);
    lv_actual = size(unique(Ir(:,:,:)))(1);
    if (size(unique(Ir(:,:,:)))(1) > levels )
        fprintf('Error : the actual levels number is %d, expected no more than %d\n', lv_actual, levels );
    else
        fprintf('OK: The actual levels number is %d, expected no more than %d\n', lv_actual, levels );
        subplot(3,3,idx)
        image(Ir);
        title(sprintf('Levels = %d' ,levels));
    end
end

%
% Using any programming language you feel comfortable with (it is though recommended 
% to use the provided free Matlab), load an image and then perform a simple spatial 3x3 
% average of image pixels. In other words, replace the value of every pixel by the 
% average of the values in its 3x3 neighborhood. If the pixel is located at (0,0), 
% this means averaging the values of the pixels at the positions 
% (-1,1), (0,1), (1,1), (-1,0), (0,0), (1,0), (-1,-1), (0,-1), and (1,-1). 
% Be careful with pixels at the image boundaries. Repeat the process for a 10x10 
% neighborhood and again for a 20x20 neighborhood. Observe what happens to the image 
% (we will discuss this in more details in the very near future, about week 3).
%

%demo test 2
fprintf('\nTest 2 - Simple spatial average\n\n');

% create lowpass filters
lowpass3x3 = ones(3,3)/(3^2);
lowpass10x10 = ones(10,10)/(10^2);
lowpass20x20 = ones(20,20)/(20^2);

If3 = uint8(imfilter(double(I), lowpass3x3,'replicate'));
If10 = uint8(imfilter(double(I), lowpass10x10,'replicate'));
If20 = uint8(imfilter(double(I), lowpass20x20,'replicate'));

figure 2;
subplot(1,3,1)
image(If3);
title(sprintf('Lowpass 3x3'));
subplot(1,3,2)
image(If10);
title(sprintf('Lowpass 10x10'));
subplot(1,3,3)
image(If20);
title(sprintf('Lowpass 20x20'));

%
% Rotate the image by 45 and 90 degrees (Matlab provides simple command lines for doing this).
%

%demo test 3
fprintf('\nTest 3 - Image rotation\n\n');

Ir45=imrotate(I,45);
Ir90=imrotate(I,90);

figure 3;
subplot(2,1,1)
image(Ir45);
title(sprintf('Rotated 45 degree'));
subplot(2,1,2)
image(Ir90);
title(sprintf('Rotated 90 degree'));

%
% For every 3×3 block of the image (without overlapping), replace all corresponding 9 pixels 
% by their average. This operation simulates reducing the image spatial resolution. Repeat this 
% for 5×5 blocks and 7×7 blocks. If you are using Matlab, investigate simple command lines to do 
% this important operation.

%demo test 4
fprintf('\nTest 4 - Image spatial resolution reducing\n\n');

[nrows, ncols, nchan] = size(I);

col_keep = (uint8(ceil(3/2)):3:ncols);
row_keep = (uint8(ceil(3/2)):3:nrows);
filter = ones(3,3)/(3^2);
Ired3 = uint8(imfilter(double(I), filter,'replicate'))(row_keep, col_keep,:);

col_keep = (uint8(ceil(5/2)):5:ncols);
row_keep = (uint8(ceil(5/2)):5:nrows);
filter = ones(5,5)/(5^2);
Ired5 = uint8(imfilter(double(I), filter,'replicate'))(row_keep, col_keep,:);

col_keep = (uint8(ceil(7/2)):7:ncols);
row_keep = (uint8(ceil(7/2)):7:nrows);
filter = ones(7,7)/(7^2);
Ired7 = uint8(imfilter(double(I), filter,'replicate'))(row_keep, col_keep,:);

figure 4;
subplot(1,3,1)
image(Ired3);
title(sprintf('Reduced by 3x3'));
subplot(1,3,2)
image(Ired5);
title(sprintf('Reduced by 5x5'));
subplot(1,3,3)
image(Ired7);
title(sprintf('Reduced by 7x7'));

