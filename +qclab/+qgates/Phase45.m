%> @file Phase45.m
%> @brief Implements Phase45 gate (T gate) class.
% ==============================================================================
%> @class Phase45
%> @brief 1-qubit Phase45 gate (T gate).
%>
%> 1-qubit Phase45 gate with matrix representation:
%>
%> \f[\begin{bmatrix} 1   &  0\\ 
%>                    0   & \exp(i \pi/4) \end{bmatrix}\f]
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef Phase45 < qclab.qgates.QGate1
  
  methods
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmPhase45( fid, obj.qubit + offset );
      out = 0;
    end
    
    % equals
    function [bool] = equals(~,other)
      bool = isa(other, 'qclab.qgates.Phase45');
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = qclab.qgates.Phase( obj.qubit, -pi/4 );
    end
  end
  
  
  methods (Static)
    % fixed
    function [bool] = fixed
      bool = true;
    end
    
    % matrix
    function [mat] = matrix
      sqrt2 = 1 / sqrt(2);
      mat = [1, 0; 
             0, sqrt2 + 1i*sqrt2];
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      label = 'T';
    end  
  end
end