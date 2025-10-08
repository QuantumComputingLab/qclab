% RotationXX - 2-qubit rotation gate about the XX axis
% The RotationXX class implements a 2-qubit quantum gate that performs a
% rotation around the XX axis.
%
% The matrix representation of the RotationXX gate is:
%   RXX(θ) =
%     [ cos(θ/2)     0           0         -i·sin(θ/2);
%       0           cos(θ/2)   -i·sin(θ/2)   0;
%       0          -i·sin(θ/2)  cos(θ/2)     0;
%      -i·sin(θ/2)   0           0         cos(θ/2) ]
%
% Creation
%   Syntax
%     G = qclab.qgates.RotationXX()
%       - Default constructor. Creates a RotationXX gate with qubits [0, 1]
%         and angle θ = 0.
%
%     G = qclab.qgates.RotationXX(qubits)
%       - Creates a RotationXX gate on the given qubit pair `qubits` with
%         θ = 0. The argument `qubits` must be a 2-element vector of non-negative 
%         integers.
%
%     G = qclab.qgates.RotationXX(qubits, angle, fixed)
%       - Creates a RotationXX gate on `qubits` with the given quantum `angle`.
%         Set `fixed` to true to make the gate non-adjustable.
%
%     G = qclab.qgates.RotationXX(qubits, rotation, fixed)
%       - Creates a RotationXX gate on `qubits` with the given quantum `rotation`.
%         Set `fixed` to true to make the gate non-adjustable.
%
%     G = qclab.qgates.RotationXX(qubits, theta, fixed)
%       - Creates a RotationXX gate with the given angle θ (in radians).
%         Set `fixed` to true for a non-adjustable gate.
%
%     G = qclab.qgates.RotationXX(qubits, cos, sin, fixed)
%       - Creates a RotationXX gate with given cosine and sine values
%         of θ/2. Set `fixed` to true for a non-adjustable gate.
%
% Input Arguments
%     qubits    - 2-element vector specifying the two qubits the gate acts on
%     angle     - QAngle object
%     rotation  - QRotation object 
%     theta     - Rotation angle θ (in radians)
%     cos       - Cosine of θ/2
%     sin       - Sine of θ/2
%     fixed     - Logical flag indicating whether the gate is adjustable 
%                 (default: false)
%
% Output
%     G - A quantum object of type `RotationXX`, representing a 2-qubit
%         rotation around the XX axis on the specified qubit pair.
%
% Examples:
%   Create a default XX rotation gate on qubits 0 and 1:
%     G = qclab.qgates.RotationXX();
%
%   Create an XX rotation gate on qubits [1, 3] with angle π/2:
%     G = qclab.qgates.RotationXX([1, 3], pi/2);
%
%   Create a non-adjustable gate with given cosine and sine values:
%     G = qclab.qgates.RotationXX([0, 2], cos(pi/4), sin(pi/4), true);

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
      qclab.IO.qasmRotationXX( fid, obj.qubits + offset, obj.theta );
      out = 0;
    end
    
    % equalType
    function [bool] = equalType(~, other)
      bool = isa(other,'qclab.qgates.RotationXX');
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex)
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      if tex
        label = 'R_{xx}';        
      else
        label = 'RXX';
      end
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f)'], obj.theta);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f)'], obj.theta);
      end
    end
    
    %> convert XX rotation to YY rotation with same parameters
    function G = qclab.qgates.RotationYY( obj )
      G = qclab.qgates.RotationYY( obj.qubits, obj.angle );
    end
    
    %> convert XX rotation to ZZ rotation with same parameters
    function G = qclab.qgates.RotationZZ( obj )
      G = qclab.qgates.RotationZZ( obj.qubits, obj.angle );
    end
  end
  
  
end % RotationXX
