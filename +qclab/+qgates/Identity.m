% Identity - 1-qubit Identity gate
% The Identity class implements a 1-qubit identity gate that performs no
% operation on the qubit.
%
% The matrix representation of the identity gate is:
%   Identity =
%     [ 1  0;
%       0  1 ]
%
% Creation
%   Syntax
%     G = qclab.qgates.Identity()
%       - Creates a 1-qubit identity gate acting on qubit 0.
%
%     G = qclab.qgates.Identity(qubit)
%       - Creates a 1-qubit identity gate acting on the specified qubit.
%
% Input Arguments
%     qubit - (optional) Non-negative integer specifying the qubit the gate
%             acts on.
%
% Output
%     G - A quantum object of type `Identity`, representing the 1-qubit
%         identity gate.
%
% Examples:
%   Create a 1-qubit identity gate acting on qubit 0 (default):
%     G = qclab.qgates.Identity();
%
%   Create a 1-qubit identity gate acting on qubit 3:
%     G = qclab.qgates.Identity(3);

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
