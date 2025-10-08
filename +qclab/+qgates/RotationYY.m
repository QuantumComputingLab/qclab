% RotationYY - 2-qubit rotation gate about the YY axis
% The RotationYY class implements a 2-qubit quantum gate that performs a
% rotation around the YY axis.
%
% The matrix representation of the RotationYY gate is:
%   RYY(θ) =
%     [ cos(θ/2)     0           0          i·sin(θ/2);
%       0           cos(θ/2)   -i·sin(θ/2)   0;
%       0          -i·sin(θ/2)  cos(θ/2)     0;
%       i·sin(θ/2)   0           0         cos(θ/2) ]
%
% Creation
%   Syntax
%     G = qclab.qgates.RotationYY()
%       - Default constructor. Creates a RotationYY gate with qubits [0, 1]
%         and angle θ = 0.
%
%     G = qclab.qgates.RotationYY(qubits)
%       - Creates a RotationYY gate on the given qubit pair `qubits` with
%         θ = 0. The argument `qubits` must be a 2-element vector of non-negative 
%         integers.
%
%     G = qclab.qgates.RotationYY(qubits, angle, fixed)
%       - Creates a RotationYY gate on `qubits` with the given quantum `angle`.
%         Set `fixed` to true to make the gate non-adjustable.
%
%     G = qclab.qgates.RotationYY(qubits, rotation, fixed)
%       - Creates a RotationYY gate on `qubits` with the given quantum `rotation`.
%         Set `fixed` to true to make the gate non-adjustable.
%
%     G = qclab.qgates.RotationYY(qubits, theta, fixed)
%       - Creates a RotationYY gate with the given angle θ (in radians).
%         Set `fixed` to true for a non-adjustable gate.
%
%     G = qclab.qgates.RotationYY(qubits, cos, sin, fixed)
%       - Creates a RotationYY gate with given cosine and sine values
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
%     G - A quantum object of type `RotationYY`, representing a 2-qubit
%         rotation around the YY axis on the specified qubit pair.
%
% Examples:
%   Create a default YY rotation gate on qubits 0 and 1:
%     G = qclab.qgates.RotationYY();
%
%   Create a YY rotation gate on qubits [2, 3] with angle π/2:
%     G = qclab.qgates.RotationYY([2, 3], pi/2);
%
%   Create a non-adjustable gate with given cosine and sine values:
%     G = qclab.qgates.RotationYY([1, 4], cos(pi/6), sin(pi/6), true);


%> @file RotationYY.m
%> @brief Implements RotationYY class.
% ==============================================================================
%> @class RotationYY
%> @brief 2-qubit rotation gate about the YY axis.
%>
%> 2-qubit Pauli rotation about YY axis with matrix representation:
%>
%> \f[\begin{bmatrix} c   & 0   & 0   & is\\ 
%>                    0   & c   & -is & 0 \\
%>                    0   & -is & c   & 0 \\
%>                    is  & 0   & 0   & c \end{bmatrix},\f]
%> where \f$c = \cos(\theta/2), s = \sin(\theta/2)\f$.
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef RotationYY < qclab.qgates.QRotationGate2
  
  methods
    % matrix
    function [mat] = matrix(obj)
      c = obj.cos; s = 1i*obj.sin;
      mat = [c, 0, 0, s;
             0, c, -s, 0;
             0, -s, c, 0;
             s, 0, 0, c];
    end
    
    % toQASM
    function [out] = toQASM(obj,fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmRotationYY( fid, obj.qubits + offset, obj.theta );
      out = 0;
    end
    
    % equalType
    function [bool] = equalType(~, other)
      bool = isa(other,'qclab.qgates.RotationYY');
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex)
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      if tex
        label = 'R_{yy}';
      else
        label = 'RYY';
      end
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f)'], obj.theta);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f)'], obj.theta);
      end
    end
    
    %> convert YY rotation to XX rotation with same parameters
    function G = qclab.qgates.RotationXX( obj )
      G = qclab.qgates.RotationXX( obj.qubits, obj.angle );
    end
    
    %> convert YY rotation to ZZ rotation with same parameters
    function G = qclab.qgates.RotationZZ( obj )
      G = qclab.qgates.RotationZZ( obj.qubits, obj.angle );
    end
    
  end
end % RotationYY
