%> @file RotationZ.m
%> @brief Implements RotationZ class.
% ==============================================================================
%> @class RotationZ
%> @brief 1-qubit rotation gate about the Z axis.
%>
%> 1-qubit Pauli-Z rotation gate with matrix representation:
%>
%> \f[\begin{bmatrix} c - is   &  0\\ 
%>                    0 & c + is \end{bmatrix},\f]
%> where \f$c = \cos(\theta/2), s = \sin(\theta/2)\f$.
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef RotationZ < qclab.qgates.QRotationGate1
  
  methods
    
    % matrix
    function [mat] = matrix(obj)
      mat = [ obj.cos - 1i*obj.sin, 0; 
              0, obj.cos + 1i*obj.sin ]; 
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      fprintf(fid,'rz(%.15f) q[%d];\n', obj.theta, obj.qubit_ + offset);
      out = 0;
    end
    
    % equals
    function [bool] = equals(obj,other)
      bool = false;
      if isa(other,'qclab.qgates.RotationZ')
        bool = (obj.angle_ == other.angle_) ;
      end
    end
  end
end % RotationZ
