%> @file RotationXX.m
%> @brief Implements RotationXX class.
% ==============================================================================
%> @class RotationXX
%> @brief 2-qubit rotation gate about the XX axis.
%>
%> 2-qubit Pauli rotation about XX axis with matrix representation:
%>
%> \f[\begin{bmatrix} c   & 0   & 0   & -is\\ 
%>                    0   & c   & -is & 0 \\
%>                    0   & -is & c   & 0 \\
%>                    -is & 0   & 0   & c \end{bmatrix},\f]
%> where \f$c = \cos(\theta/2), s = \sin(\theta/2)\f$.
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef RotationXX < qclab.qgates.QRotationGate2
  
  methods
    % matrix
    function [mat] = matrix(obj)
      c = obj.cos; s = -1i*obj.sin;
      mat = [c, 0, 0, s;
             0, c, s, 0;
             0, s, c, 0;
             s, 0, 0, c];
    end
    
    % toQASM
    function [out] = toQASM(obj,fid, offset)
      if nargin == 2, offset = 0; end
      fprintf(fid,'rxx(%.15f) q[%d], q[%d];', obj.theta, ... 
        obj.qubits_(1) + offset, obj.qubits_(2) + offset);
      out = 0;
    end
    
    % equals
    function [bool] = equals(obj,other)
      bool = false;
      if isa(other,'qclab.qgates.RotationXX')
        bool = (obj.angle_ == other.angle_) ;
      end
    end
    
  end
end % RotationXX
