%> @file Phase90.m
%> @brief Implements Phase90 gate (S gate) class.
% ==============================================================================
%> @class Phase90
%> @brief 1-qubit Phase90 gate (S gate).
%>
%> 1-qubit Phase90 gate with matrix representation:
%>
%> \f[\begin{bmatrix} 1   &  0\\ 
%>                    0   & i \end{bmatrix}\f]
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef Phase90 < qclab.qgates.QGate1
   methods (Static)
    % fixed
    function [bool] = fixed
      bool = true;
    end
    
    % matrix
    function [mat] = matrix
      mat = [1, 0; 
             0, 1i];
    end
    
    % label for draw function
    function [label] = label(obj, parameter)
      label = 'S';
    end
    
   end
  
    methods
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      fprintf(fid, 's q[%d];\n', obj.qubit + offset);
      out = 0;
    end
    
    % equals
    function [bool] = equals(~,other)
      bool = isa(other, 'qclab.qgates.Phase90');
    end
  end
  
end