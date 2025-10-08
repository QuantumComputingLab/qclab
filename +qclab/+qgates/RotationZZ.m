% RotationZZ - 2-qubit rotation gate about the ZZ axis
% The RotationZZ class implements a 2-qubit quantum gate that performs a
% rotation around the ZZ axis.
%
% The matrix representation of the RotationZZ gate is:
%   RZZ(θ) =
%     [ cos(θ/2) - i·sin(θ/2)     0                   0                   0;
%       0                   cos(θ/2) + i·sin(θ/2)     0                   0;
%       0                   0                   cos(θ/2) + i·sin(θ/2)     0;
%       0                   0                   0                   cos(θ/2) - i·sin(θ/2) ]
%
% Creation
%   Syntax
%     G = qclab.qgates.RotationZZ()
%       - Default constructor. Creates a RotationZZ gate with qubits [0, 1]
%         and angle θ = 0.
%
%     G = qclab.qgates.RotationZZ(qubits)
%       - Creates a RotationZZ gate on the given qubit pair `qubits` with
%         θ = 0. The argument `qubits` must be a 2-element vector of non-negative 
%         integers.
%
%     G = qclab.qgates.RotationZZ(qubits, angle, fixed)
%       - Creates a RotationZZ gate on `qubits` with the given quantum `angle`.
%         Set `fixed` to true to make the gate non-adjustable.
%
%     G = qclab.qgates.RotationZZ(qubits, rotation, fixed)
%       - Creates a RotationZZ gate on `qubits` with the given quantum `rotation`.
%         Set `fixed` to true to make the gate non-adjustable.
%
%     G = qclab.qgates.RotationZZ(qubits, theta, fixed)
%       - Creates a RotationZZ gate with the given angle θ (in radians).
%         Set `fixed` to true for a non-adjustable gate.
%
%     G = qclab.qgates.RotationZZ(qubits, cos, sin, fixed)
%       - Creates a RotationZZ gate with given cosine and sine values
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
%     G - A quantum object of type `RotationZZ`, representing a 2-qubit
%         rotation around the ZZ axis on the specified qubit pair.
%
% Examples:
%   Create a default ZZ rotation gate on qubits 0 and 1:
%     G = qclab.qgates.RotationZZ();
%
%   Create a ZZ rotation gate on qubits [1, 2] with angle π:
%     G = qclab.qgates.RotationZZ([1, 2], pi);
%
%   Create a non-adjustable gate with cosine and sine input:
%     G = qclab.qgates.RotationZZ([0, 3], cos(pi/4), sin(pi/4), true);

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
      qclab.IO.qasmRotationZZ( fid, obj.qubits + offset, obj.theta );
      out = 0;
    end
    
    % equalType
    function [bool] = equalType(~, other)
      bool = isa(other,'qclab.qgates.RotationZZ');
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex)
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      if tex
        label = 'R_{zz}';
      else
        label = 'RZZ';
      end
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f)'], obj.theta);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f)'], obj.theta);
      end
    end
    
    %> convert ZZ rotation to XX rotation with same parameters
    function G = qclab.qgates.RotationXX( obj )
      G = qclab.qgates.RotationXX( obj.qubits, obj.angle );
    end
    
    %> convert ZZ rotation to YY rotation with same parameters
    function G = qclab.qgates.RotationYY( obj )
      G = qclab.qgates.RotationYY( obj.qubits, obj.angle );
    end
    
    
  end
end % RotationZZ
