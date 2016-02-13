function varargout = imshowpair(varargin)
%IMSHOWPAIR Compare differences between images.
%   H = IMSHOWPAIR(A,B) creates a visualization of the differences between
%   images A and B.  If A and B are different sizes, the smaller dimensions are
%   padded with zeros such that the 2 image are the same size before
%   display. H is a handle to the HG image object created by imshowpair.
%
%   H = IMSHOWPAIR(A,RA,B,RB) displays the differences between images
%   A and B using the spatial referencing information provided in RA and
%   RB. RA and RB are spatial referencing objects of class imref2d.
%
%   IMSHOWPAIR(...,METHOD) displays the differences between images A and B
%   using the visualization style specified by METHOD.  Values of METHOD
%   can be:
%
%      'falsecolor' : Create a composite RGB image showing A and B overlayed
%                     in different color bands. This is the default.
%      'blend'      : Overlay A and B using alpha blending.
%      'diff'       : Difference image created from A and B.
%      'montage'    : Put A and B next to each other in the same image.
%
%   IMSHOWPAIR(...,PARAM1,VAL1,PARAM2,VAL2,...) display the images,
%   specifying parameters and corresponding values that control various
%   aspects of display and blending.  Parameter name case does not matter.
%
%   Parameters include:
%
%   'Scaling'       Both images are converted to a common data type before
%                   being displayed.  Additional scaling of image data is
%                   controled by the 'Scaling' parameter of IMSHOWPAIR.
%
%                   Valid 'Scaling' values are:
%                      'independent' :  Images are scaled independently from
%                                       each other.
%                      'joint'       :  Images are scaled as a single data set.
%                                       This option can be useful when
%                                       visualizing registrations of
%                                       monomodal images in which one image
%                                       has a large amount of fill values
%                                       outside the dynamic range of your
%                                       images.
%                      'none'        :  No additional scaling.
%
%                                       Default value: 'independent'
%
%   'ColorChannels' Assign each image to specific color channels in the
%                   output image.  This method can only be used with the
%                   'falsecolor' method.
%
%                   Valid 'ColorChannels' values are:
%                      [R G B]         :  A three element vector that
%                                         specifies which image to assign
%                                         to the red, green, and blue
%                                         channels.  The R, G, and B values
%                                         must be 1 (for the first input
%                                         image), 2 (for the second input
%                                         image), and 0 (for neither image).
%                      'red-cyan'      :  A shortcut for the vector [1 2 2],
%                                         which is suitable for red/cyan
%                                         stereo anaglyphs.
%                      'green-magenta' :  A shortcut for the vector [2 1 2],
%                                         which is a high contrast option
%                                         ideal for people with many kinds
%                                         of color blindness.
%
%                                         Default value: 'green-magenta'
%
%   Tips
%   ----
%   Use imfuse to create composite visualizations that you can save to a
%   file.  Use imshowpair to display composite visualizations to the
%   screen.
%
%   Examples
%   --------
%   % Two images with a rotation offset
%   A = imread('cameraman.tif');
%   B = imrotate(A,5,'bicubic','crop');
%   % display a transparent overlay
%   imshowpair(A,B,'blend','Scaling','joint');
%   % display a difference image
%   figure;
%   imshowpair(A,B,'diff');
%
%   % Two spatially referenced images with different display ranges
%   A = dicomread('CT-MONO2-16-ankle.dcm');
%   B = double(imrotate(A,10,'bicubic','crop'));
%   B = B * 0.2;
%   % We know that the resolution of images A and B is 0.2mm
%   RA = imref2d(size(A),0.2,0.2);
%   RB = imref2d(size(B),0.2,0.2);
%   figure;
%   imshowpair(A,RA,B,RB,'Scaling','independent');
%
%   See also IMFUSE, IMREF2D, IMREGISTER, IMSHOW, IMTRANSFORM.

%   Copyright 2011-2012 The MathWorks, Inc.
%   $Revision: 1.1.6.8 $  $Date: 2012/10/08 03:21:23 $

[result, R_ref] = imfuse(varargin{:});
h = imshow(result,R_ref);

if nargout > 0
    varargout{1} = h;
end







