%> @file Identity.m
%> @brief 1-qubit Identity gate.
% ==============================================================================
%> @class Identity
%> @brief 1-qubit Identity gate.
%>
%> 1-qubit Identity gate with matrix representation:
%>
%> \f[\begin{bmatrix} 1 & 0\\ 
%>                    0 & 1 \end{bmatrix}\f]
%>
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef Identity < qclab.qgates.QGate1
  
  methods (Static)
    % fixed
    function [bool] = fixed
      bool = true;
    end
    
    % matrix
    function [mat] = matrix
      mat = eye(2);
    end
    
    % toQASM
    function [out] = toQASM
      % do nothing
      out = 0;
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      label = 'I';
    end
    
  end
  
  methods 
    % equals
    function [bool] = equals(~,other)
      bool = isa(other,'qclab.qgates.Identity');
    end
  end
end
