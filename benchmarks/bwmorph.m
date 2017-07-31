## Copyright (C) 2017  Arslan Khan <arslankhan52@gmail.com>, Muhammad Talha <m.talha.imran01@gmail.com>
##
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## gradMag = bwmorph(image)
## where image is the binary image, and grad image is the morphological operation
##
## This function implements a minimum implementation of bwmorph enough to carry 
## out benchmarking. This helper API performs Morphological operations on 
## binary images

## The first output @var{gradMag} returns image skeleton
##
## @end deftypefn

function [gradMag] = bwmorph (img)
    gradMag=zeros(size(img));
    for x=1:size(img)(1)
    for y=1:size(img)(2)
        if (x-1>1 && y-1>1)
        gradMag(x,y) = img(x,y) - img(x-1,y-1);
        end
    end
    end

endfunction

