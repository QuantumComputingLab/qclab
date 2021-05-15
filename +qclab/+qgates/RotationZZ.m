%> @file RotationZZ.m
%> @brief Implements RotationZZ class.
% ==============================================================================
%> @class RotationZZ
%> @brief 2-qubit rotation gate about the ZZ axis.
%>
%> 2-qubit Pauli rotation about ZZ axis with matrix representation:
%>
%> \f[\begin{bmatrix} c - is  &         &         &  \\ 
%>                            & c + is  &         &  \\
%>                            &         & c + is  &  \\
%>                            &         &         & c - is \end{bmatrix},\f]
%> where \f$c = \cos(\theta/2), s = \sin(\theta/2)\f$.
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef RotationZZ < qclab.qgates.QRotationGate2
  
  methods
    % matrix
    function [mat] = matrix(obj)
      c = obj.cos; s = 1i*obj.sin;
      mat = [c - s, 0,     0,     0;
             0,     c + s, 0,     0;
             0,     0,     c + s, 0;
             0,     0,     0,     c - s];
    end
    
    % toQASM
    function [out] = toQASM(obj,fid, offset)
      if nargin == 2, offset = 0; end
      fprintf(fid,'rzz(%.15f) q[%d], q[%d];', obj.theta, ... 
        obj.qubits_(1) + offset, obj.qubits_(2) + offset);
      out = 0;
    end
    
    % equals
    function [bool] = equals(obj,other)
      bool = false;
      if isa(other,'qclab.qgates.RotationZZ')
        bool = (obj.angle_ == other.angle_) ;
      end
    end
    
  end
end % RotationZZ
