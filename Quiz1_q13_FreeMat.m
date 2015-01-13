% FreeMat code

%
% Image and video processing - Coursera - 2015
% Quiz 1 - question 13

%
% Write a computer program capable of reducing the number of intensity 
% levels in an image from 256 to 2, in integer powers of 2. The desired 
% number of intensity levels needs to be a variable input to your program.
%

function quiz13_q1_main()
  
  do_test_1 = true;
  do_test_2 = true;
  do_test_3 = true;
  do_test_4 = true;
      
  %demo test 1
  if do_test_1
      fprintf('\nTest 1 - Reduce levels in image\n\n');
      I = imread('peppers.png');
      figure 1;
      for idx=(1:8)
          levels = 2^idx;
          Ir = ReduceImageLevel_local(I,levels);
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
  if do_test_2
      fprintf('\nTest 2 - Simple spatial average\n\n');
  
      I = imread('peppers.png');
      [nrows, ncols, nchan] = size(I);
      filter_dim = [3,10,20];
      figure 2;
  
      for idx=(1:3)
          m = double(I);
          fd = filter_dim(idx);
          Ifiltered = zeros(nrows,ncols, nchan);
          % create lowpass filters
          lowpass = ones(fd,fd)/(fd^2);
          % replicate border rows and columns
          for sep= (1:nchan)
              mc = m(:,:,sep);
              mc = [repmat(mc(:,1),[1,fd]) mc]; 
              mc = [mc repmat(mc(:,end),[1,fd])];
              mc = [repmat(mc(1,:),[fd,1]); mc];
              mc = [mc ; repmat(mc(end,:),[fd,1])];
              mc = uint8(conv2(mc,lowpass)(fd:nrows+fd-1,fd:ncols+fd-1));
              Ifiltered(:,:,sep) = mc;
          end
          subplot(1,3,idx);
          image(Ifiltered);
          title(sprintf('Lowpass %dx%d',fd,fd));
      end
  end
  
  %
  % Rotate the image by 45 and 90 degrees (Matlab provides simple command lines for doing this).
  %
  % http://stackoverflow.com/questions/19684617/image-rotation-by-matlab-without-using-imrotate
  % http://www.leptonica.com/rotation.html
  %
  
  %demo test 3
  if do_test_3
      fprintf('\nTest 3 - Image rotation\n\n');
          
      I = imread('peppers.png');
      [rowsi,colsi,nchan]= size(I); 
      thetas = [45,60,90,175];
      thetasr = thetas*2*pi/360;
  
      % calculating center of original and final image
      xo=ceil(rowsi/2);                                                            
      yo=ceil(colsi/2);
      
      figure 3;
      for idx=(1:size(thetas)(2))
          rads = thetasr(idx);
          % calculating array dimensions such that  rotated image gets fit in it exactly.
          % we are using absolute so that we get  positive value in any case ie.,any quadrant.
          rowsf=ceil(rowsi*abs(cos(rads))+colsi*abs(sin(rads)));                      
          colsf=ceil(rowsi*abs(sin(rads))+colsi*abs(cos(rads)));                     
  
          % define an array with calculated dimensions and fill the array  with zeros ie.,black
          Irotated=uint8(zeros([rowsf colsf nchan ]));
          
          midx=ceil(rowsf/2);
          midy=ceil(colsf/2);
          
          % in this loop we calculate corresponding coordinates of pixel of A 
          % for each pixel of C, and its intensity will be  assigned after checking
          % weather it lie in the bound of A (original image)
          for i=1:rowsf
              for j=1:colsf                                                       
          
                  x= (i-midx)*cos(rads)+(j-midy)*sin(rads);                                       
                  y= -(i-midx)*sin(rads)+(j-midy)*cos(rads);                             
                  x=round(x)+xo;
                  y=round(y)+yo;
          
                  if (x>=1 && y>=1 && x<=rowsi &&  y<=colsi ) 
                      Irotated(i,j,:)=I(x,y,:);  
                  end
          
              end
          end
          subplot(2,2,idx);
          image(Irotated);
          title(sprintf('Rotated %d degree',thetas(idx)));
      end
  end
  
  %
  % For every 3×3 block of the image (without overlapping), replace all corresponding 9 pixels 
  % by their average. This operation simulates reducing the image spatial resolution. Repeat this 
  % for 5×5 blocks and 7×7 blocks. If you are using Matlab, investigate simple command lines to do 
  % this important operation.
  
  %demo test 4
  if do_test_4
      fprintf('\nTest 4 - Image reducing\n\n');
      
      I = imread('peppers.png');
      [nrows, ncols, nchan] = size(I);
      filter_dim = [3,5,7];
      figure 4;
  
      for idx=(1:3)
          m = double(I);
          fd = filter_dim(idx);
          col_keep = (uint8(ceil(fd/2)):fd:ncols);
          row_keep = (uint8(ceil(fd/2)):fd:nrows);
          Ifiltered = zeros(size(row_keep)(2), size(col_keep)(2), nchan);
          % create lowpass filters
          lowpass = ones(fd,fd)/(fd^2);
          % replicate border rows and columns
          for sep= (1:nchan)
              mc = m(:,:,sep);
              mc = [repmat(mc(:,1),[1,fd]) mc]; 
              mc = [mc repmat(mc(:,end),[1,fd])];
              mc = [repmat(mc(1,:),[fd,1]); mc];
              mc = [mc ; repmat(mc(end,:),[fd,1])];
              mc = uint8(conv2(mc,lowpass)(fd:nrows+fd-1,fd:ncols+fd-1));
              Ifiltered(:,:,sep) = mc(row_keep, col_keep);
          end
          subplot(1,3,idx);
          image(Ifiltered);
          title(sprintf('Reduced by %dx%d',fd,fd));
      end
  end
  
  
end % function quiz13_q1_main()


% local function
function result = ReduceImageLevel_local(im, nl)
    result = uint8(floor((double(im))/(256/nl)))*(256/nl);
end
