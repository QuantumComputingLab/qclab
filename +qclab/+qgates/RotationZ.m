% RotationZ - 1-qubit rotation gate about the Z axis
% The RotationZ class implements a 1-qubit rotation gate that performs a
% rotation by an angle θ around the Z axis of the Bloch sphere.
%
% The matrix representation of the RotationZ gate is:
%   Rz(θ) = [exp(-i·θ/2)     0;
%               0        exp(i·θ/2)]
%
% Creation
%   Syntax:
%     RZ = qclab.qgates.RotationZ()
%       - Default constructor. Constructs an adjustable Z-rotation gate on
%         qubit 0 with θ = 0.
%
%     RZ = qclab.qgates.RotationZ(qubit)
%       - Constructs an adjustable Z-rotation gate on the specified `qubit`
%         with θ = 0.
%
%     RZ = qclab.qgates.RotationZ(qubit, theta)
%       - Constructs an adjustable Z-rotation gate on `qubit` with rotation
%         angle `theta` (in radians).
%
%     RZ = qclab.qgates.RotationZ(qubit, theta, fixed)
%       - Constructs a Z-rotation gate with the given angle `theta` and
%         optional logical flag `fixed`. Set `fixed` to true for a
%         non-adjustable gate.
%
%     RZ = qclab.qgates.RotationZ(qubit, angle, fixed)
%       - Constructs a Z-rotation gate using a QAngle object `angle`.
%
%     RZ = qclab.qgates.RotationZ(qubit, cos_theta, sin_theta, fixed)
%       - Constructs a Z-rotation gate from trigonometric values of θ/2:
%         `cos_theta = cos(θ/2)`, `sin_theta = sin(θ/2)`
%
% Input Arguments:
%     qubit      - Target qubit (non-negative integer, default: 0)
%     theta      - Rotation angle in radians
%     angle      - QAngle object
%     cos_theta  - Cosine of θ/2
%     sin_theta  - Sine of θ/2
%     fixed      - Logical flag indicating whether the gate is adjustable 
%                  (default: false)
%
% Output:
%     RZ - A quantum object of type `RotationZ`, representing the 1-qubit
%          rotation gate about the Z axis applied to the specified qubit.
%
% Examples:
%   Create a default Z-rotation gate:
%     RZ = qclab.qgates.RotationZ();
%
%   Create a RotationZ gate on qubit 0 with θ = π/2:
%     RZ = qclab.qgates.RotationZ(0, pi/2);
%
%   Create a non-adjustable RotationZ gate using cosine and sine:
%     RZ = qclab.qgates.RotationZ(1, cos(pi/4), sin(pi/4), true);

%> @file RotationZ.m
%> @brief Implements RotationZ class.
% ==============================================================================
%> @class RotationZ
%> @brief 1-qubit rotation gate about the Z axis.
%>
%> 1-qubit Pauli-Z rotation gate with matrix representation:
%>
%> \f[\begin{bmatrix} c - is   &  0\\ 
%>                    0 & c + is \end{bmatrix},\f]
%> where \f$c = \cos(\theta/2), s = \sin(\theta/2)\f$.
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef RotationZ < qclab.qgates.QRotationGate1
  
  methods
    
    % matrix
    function [mat] = matrix(obj)
      mat = [ obj.cos - 1i*obj.sin, 0; 
              0, obj.cos + 1i*obj.sin ]; 
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmRotationZ( fid, obj.qubit + offset, obj.theta );
      out = 0;
    end
    
    % equalType
    function [bool] = equalType(~, other)
      bool = isa(other,'qclab.qgates.RotationZ');
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex)
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      if tex
        label = 'R_z';
      else
        label = 'RZ';
      end
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f)'], obj.theta);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f)'], obj.theta);
      end
    end
    
    %> convert Z rotation to X rotation with same parameters
    function G = qclab.qgates.RotationX( obj )
      G = qclab.qgates.RotationX( obj.qubits, obj.angle );
    end
    
    %> convert Z rotation to Y rotation with same parameters
    function G = qclab.qgates.RotationY( obj )
      G = qclab.qgates.RotationY( obj.qubits, obj.angle );
    end
    
  end
end % RotationZ
