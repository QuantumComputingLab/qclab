%> @file RotationX.m
%> @brief Implements RotationX class.
% ==============================================================================
%> @class RotationX
%> @brief 1-qubit rotation gate about the X axis.
%>
%> 1-qubit Pauli-X rotation gate with matrix representation:
%>
%> \f[\begin{bmatrix} c   &  -is\\ 
%>                    -is & c \end{bmatrix},\f]
%> where \f$c = \cos(\theta/2), s = \sin(\theta/2)\f$.
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef RotationX < qclab.qgates.QRotationGate1
  
  methods
    
    % matrix
    function [mat] = matrix(obj)
      mat = [ obj.cos,     -1i*obj.sin; 
              -1i*obj.sin, obj.cos ]; 
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      fprintf(fid,'rx(%.15f) q[%d];\n', obj.theta, obj.qubit_ + offset);
      out = 0;
    end
    
    % equals
    function [bool] = equals(obj,other)
      bool = false;
      if isa(other,'qclab.qgates.RotationX')
        bool = (obj.angle_ == other.angle_) ;
      end
    end
  end
end % RotationX
