%> @file RotationY.m
%> @brief Implements RotationY class.
% ==============================================================================
%> @class RotationY
%> @brief 1-qubit rotation gate about the Y axis.
%>
%> 1-qubit Pauli-Y rotation gate with matrix representation:
%>
%> \f[\begin{bmatrix} c   &  -s\\ 
%>                    s & c \end{bmatrix},\f]
%> where \f$c = \cos(\theta/2), s = \sin(\theta/2)\f$.
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef RotationY < qclab.qgates.QRotationGate1
  
  methods
    
    % matrix
    function [mat] = matrix(obj)
      mat = [ obj.cos, -obj.sin; 
              obj.sin,  obj.cos ]; 
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      fprintf(fid,'ry(%.15f) q[%d];\n', obj.theta, obj.qubit_ + offset);
      out = 0;
    end
    
    % equalType
    function [bool] = equalType(~, other)
      bool = isa(other,'qclab.qgates.RotationY');
    end
    
    % label for draw function
    function [label] = label(obj, parameter)
      if nargin < 2, parameter = 'N'; end
      label = 'RY';        
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f)'], obj.theta);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f)'], obj.theta);
      end
    end
    
  end
end % RotationY
