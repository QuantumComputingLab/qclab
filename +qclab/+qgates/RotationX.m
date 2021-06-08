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
    
    % equalType
    function [bool] = equalType(~, other)
      bool = isa(other,'qclab.qgates.RotationX');
    end
    
    % label for draw function
    function [label] = label(obj, parameter)
      if nargin < 2, parameter = 'N'; end
      label = 'RX';        
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f)'], obj.theta);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f)'], obj.theta);
      end
    end
    
  end
end % RotationX
