%> @file turnoverSU2.m
%> @brief Implements a turnover operation on 3 quantum rotations that form SU(2)
% ==============================================================================
%> @brief Turnover for 3 quantum rotations that form SU(2).
%>
%> The 3 input rotations QRot1, QRot2, QRot3 are of type I, II, I, respectively.
%> The 3 output rotation QRotA, QRotB, QRotC are of type II, I, II, respectively
%> and implement the same transformation.
%>
%> @param QRot1 first quantum rotation (of type I)
%> @param QRot2 second quantum rotation (of type II)
%> @param QRot3 third quantum rotation (of type I)
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
function [QRotA, QRotB, QRotC] = turnoverSU2(QRot1, QRot2, QRot3)
  
  QRot1times3 = QRot1 * QRot3;
  QRot1div3 = QRot1 / QRot3;
  
  ar =  QRot2.cos * QRot1times3.cos;
  ai = -QRot2.sin * QRot1div3.cos;
  br =  QRot2.cos * QRot1times3.sin;
  bi = -QRot2.sin * QRot1div3.sin;
  
  % Compute B rotation
  cb = sqrt( ar^2 + ai^2 );
  sb = sqrt( br^2 + bi^2 );
  QRotB = qclab.QRotation( cb, sb );
  
  if cb ~= 0
    ar = ar/cb;
    ai = ai/cb;
  end
  if sb ~= 0
    br = br/sb;
    bi = bi/sb;
  end
  
  % Compute A rotation
  if (ar + br)^2 + (bi - ai)^2 >= (ai + bi)^2 + (br - ar)^2
    [ca, sa, ~] = qclab.rotateToZeroCS( ar + br, bi - ai );
  else
    [ca, sa, ~] = qclab.rotateToZeroCS( -ai - bi, br - ar ); 
  end
  QRotA = qclab.QRotation( ca, sa );
  
  % Compute C rotation
  if (bi - ai)^2 + (br - ar)^2 > (ar + br)^2 + (ai + bi)^2
    [cc, sc, ~] = qclab.rotateToZeroCS( bi - ai, br - ar );
  else
    [cc, sc, ~] = qclab.rotateToZeroCS( ar + br, -ai - bi ); 
  end
  
  % Check sign of C rotation
  if sign(ar) ~= sign( cb * ( ca * cc - sa * sc ) ) 
    cc = -cc;
    sc = -sc;
  end
  
  QRotC = qclab.QRotation( cc, sc );
  
  
end