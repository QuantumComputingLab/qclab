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
  
  methods
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmPhase90( fid, obj.qubit + offset );
      out = 0;
    end
    
    % equals
    function [bool] = equals(~,other)
      bool = isa(other, 'qclab.qgates.Phase90');
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = qclab.qgates.Phase( obj.qubit, -pi/2 );
    end
  end
  
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
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      label = 'S';
    end
    
   end
end