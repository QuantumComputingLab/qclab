%> @file rotateToZero.m
%> @brief Compute a complex rotation matrix to introduce a zero in a vector of
%> length 2.
%>
%> If [c,s,r] = rotateToZero(x,y,'L'), then G * [x; y] = [r; 0].
%> If [c,r] = rotateToZero(x,y,'R'), then [y, x] * G = [0, r].
%>
%> Implementation based on Chapter 1 of:
%>    "Core-Chasing Algorithms for the Eigenvalue Problem",  Jared L. Aurentz , 
%>     Thomas Mach , Leonardo Robol , Raf Vandebril and David S. Watkins (2018)
%> 
%> @param x first entry of vector
%> @param y second entry of vector that is set to zero
%> @param side 'L' or 'R' side on which the rotation matrix acts. Default: 'L'
%>
%> @retval c cosine
%> @retval s sine
%> @retval r two-norm of [x, y]
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
function [c,s,r] = rotateToZeroCS(x,y)
  if (y == 0)
    c = abs(x)/x; s = 0; r = abs(x);
  else
    if (abs(x) >= abs(y))
      theta=conj(sign(x));
      t = y/x; r = sqrt(1 + abs(t)^2);
      c = theta/r;
      s = conj(t)*c;
      r = theta*x*r;
    else
      theta=conj(sign(y));
      t = x/y; r = sqrt(1 + abs(t)^2 );
      s = theta/r;
      c = conj(t)*s;
      r = theta*y*r;
    end
  end  
end