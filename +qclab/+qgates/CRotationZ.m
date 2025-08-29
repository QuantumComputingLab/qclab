% CRotationZ - 2-qubit controlled rotation-Z gate
% The CRotationZ class implements a 2-qubit controlled rotation gate that
% performs a rotation by an angle θ around the Z axis on the target qubit,
% conditioned on the control qubit being in a specified state (default: 1).
%
% Creation
%   Syntax:
%     G = qclab.qgates.CRotationZ()
%       - Default constructor. Constructs an adjustable CRotationZ gate with
%         control = 0, target = 1, controlState = 1, and θ = 0.
%
%     G = qclab.qgates.CRotationZ(control)
%       - Constructs an adjustable CRotationZ gate with the given `control`
%         qubit, target = 1, θ = 0, controlState = 1.
%
%     G = qclab.qgates.CRotationZ(control, target)
%       - Constructs an adjustable CRotationZ gate on the specified `control`
%         and `target` qubits with θ = 0, controlState = 1.
%
%     G = qclab.qgates.CRotationZ(control, target, theta)
%       - Constructs an adjustable CRotationZ gate with the given rotation
%         angle θ (in radians).
%
%     G = qclab.qgates.CRotationZ(control, target, theta, controlState)
%       - Same as above, but with specified `controlState` (0 or 1).
%
%     G = qclab.qgates.CRotationZ(control, target, angle)
%       - Constructs a CRotationZ gate using a qclab.QAngle object `angle`.
%
%     G = qclab.qgates.CRotationZ(control, target, angle, controlState)
%       - Same as above, with specified `controlState`.
%
%     G = qclab.qgates.CRotationZ(control, target, cos_theta, sin_theta)
%       - Constructs a CRotationZ gate from trigonometric values of θ/2:
%         `cos_theta = cos(θ/2)`, `sin_theta = sin(θ/2)`
%
%     G = qclab.qgates.CRotationZ(control, target, cos_theta, sin_theta, controlState)
%       - Same as above, with specified `controlState`.
%
% Input Arguments:
%     control        - Index of the control qubit (non-negative integer)
%     target         - Index of the target qubit (non-negative integer)
%     theta          - Rotation angle θ in radians
%     angle          - QAngle object
%     cos_theta      - Cosine of θ/2
%     sin_theta      - Sine of θ/2
%     controlState   - Logical value (0 or 1) indicating control condition 
%                      (default: 1)
%
% Output:
%     G - A quantum object of type `CRotationZ`, representing a 2-qubit
%         controlled Z-rotation gate applied to the specified qubits.
%
% Examples:
%   Create a default CRotationZ gate:
%     G = qclab.qgates.CRotationZ();
%
%   Create a controlled Z-rotation with θ = π:
%     G = qclab.qgates.CRotationZ(0, 1, pi);
%
%   Create a fixed CRotationZ gate with controlState = 0:
%     G = qclab.qgates.CRotationZ(2, 3, pi/2, 0);


%> @file CRotationZ.m
%> @brief Implements CRotationZ class
% ==============================================================================
%> @class CRotationZ
%> @brief Controlled Rotation-Z gate.
%> 
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef CRotationZ < qclab.qgates.QControlledGate2
  properties (Access = protected)
    %> Property storing the 1-qubit Z-rotation of this 2-qubit controlled gate.
    gate_(1,1)  qclab.qgates.RotationZ
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Contstructor for controlled rotation-Z gates
    %>
    %> The CRotationZ class constructor supports 6 ways of constructing a 
    %> 2-qubit controlled rotation-Z gate:
    %>
    %> 1. CRotationZ() : Default Constructor. Constructs an adjustable 2-qubit  
    %>    controlled rotation-Z gate with `control` set to 0, `target` to 1,
    %>    control state to 1 and \f$\theta = 0\f$.
    %>
    %> 2. CRotationZ(control) : Constructs an adjustable 2-qubit controlled
    %>    rotation-Z gate with `control` set to `control`, `target` to 1, 
    %>    control state to 1 and \f$\theta = 0\f$.
    %>
    %> 3. CRotationZ(control,target) : Constructs an adjustable 2-qubit 
    %>    controlled rotation-Z gate with `control` set to `control`, `target` 
    %>    to `target`, control state to 1 and \f$\theta = 0\f$.
    %>
    %> 4. CRotationZ(control,target, angle, controlState=1) : Constructs an 
    %>    adjustable 2-qubit controlled rotation-Z gate with `control` set to 
    %>    `control`, `target` to `target`, the angle based on the given 
    %>    quantum angle `angle` = \f$\theta/2\f$, and control state to 
    %>    `controlState`. The default control state is 1.
    %>
    %> 5. CRotationZ(control,target, theta, controlState=1) : Constructs an 
    %>    adjustable 2-qubit controlled rotation-Z gate with `control` set to 
    %>    `control`, `target` to `target`, the given quantum angle 
    %>    `angle` = \f$\theta\f$ and the flag `fixed` and control state
    %>    `controlState`. The default control state is 1.
    %> 
    %> 6. CRotationZ(control,target, cos, sin, controlState=1) : Constructs an 
    %>    adjustable 2-qubit controlled rotation-Z gate with `control` set to 
    %>    `control`, `target` to `target`, the angle determined by 
    %>    the given values `cos` = \f$\cos(\theta/2)\f$ and 
    %>    `sin` = \f$\sin(\theta/2)\f$ and control state to `controlState`.
    %>     The default control state is 1.
    %>
    %> Use `makeFixed` and `makeVariable` to change the created CRotationZ gate 
    %> from fixed to variable
    %>
    %> @param control Control qubit index of controlled rotation-Z gate. 
    %>        The default control qubit is 0.
    %> @param target Target qubit index of controlled rotation-Z gate. 
    %>        The default target qubit is 1.
    %> @param varargin Variable input argument, being either:
    %>  - empty
    %>  - angle, (controlState)
    %>  - theta, (controlState)
    %>  - cos, sin, (controlState)
    % ==========================================================================
    function obj = CRotationZ(control, target, varargin)
      if nargin == 0
        control = 0;
        target = 1;
        controlState = 1;
      elseif nargin == 1
        target = 1;
        controlState = 1;
      elseif nargin == 2
        controlState = 1;
      else
        if nargin == 3 || (nargin == 4 && ~isa(varargin{1},'qclab.QAngle') && ...
          abs(1 - abs(varargin{1})^2 - abs(varargin{2})^2) < 10*eps)
          controlState = 1; 
        else
          controlState = varargin{end};
          varargin = varargin(1:end-1);
        end
      end
      obj@qclab.qgates.QControlledGate2(control, controlState ); 
      obj.gate_ = qclab.qgates.RotationZ(target, varargin{:});
    end
    
    % fixed
    function [bool] = fixed(obj)
      bool = obj.gate_.fixed ;
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmCRotationZ( fid, obj.control + offset, obj.target + offset, ...
                       obj.controlState, obj.theta );      
      out = 0;
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other,'qclab.qgates.CRotationZ') && ...
          (obj.controlState == other.controlState) && ...
          (obj.gate_ == other.gate_)
        bool = ((obj.control < obj.target) && (other.control < other.target))...
          || ((obj.control > obj.target) && (other.control > other.target)) ;
      end
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = ctranspose@qclab.qgates.QControlledGate2( obj );
      objprime.update( -obj.angle );
    end
    
    %> Makes this controlled rotation-Z gate fixed.
    function makeFixed(obj)
      obj.gate_.makeFixed();
    end
    
    %>  Makes this controlled rotation-Z gate variable.
    function makeVariable(obj)
      obj.gate_.makeVariable();
    end
    
    %> Returns a copy of the quantum angle \f$\theta\f$ of this controlled 
    %> rotation-Z gate.
    function angle = angle(obj)
      angle = obj.gate_.angle;
    end
    
    %> Returns the numerical value \f$\theta\f$ of this controlled rotation-Z
    %> gate.
    function theta = theta(obj)
      theta = obj.gate_.theta;
    end
    
    %> Returns the cosine \f$\cos(\theta)\f$ of this controlled rotation-Z
    %> gate.
    function cos = cos(obj)
      cos = obj.gate_.cos;
    end
    
    %> Returns the sine \f$\sin(\theta)\f$ of this controlled rotation-Z gate.
    function sin = sin(obj)
      sin = obj.gate_.sin;
    end
    
    %> Updates the angle of this controlled rotation-Z gate
    function update(obj, varargin)
      obj.gate_.update(varargin{:});
    end
    
    % target
    function [target] = target(obj)
      target = obj.gate_.qubit ;
    end
    
    %> Copy of 1-qubit gate of controlled rotation-Z gate
    function [gate] = gate(obj)
      gate = copy(obj.gate_);
    end
    
    % setTarget
    function setTarget(obj, target )
      assert( qclab.isNonNegInteger(target) ) ; 
      assert( target ~= obj.control() ) ;
      obj.gate_.setQubit( target );
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      label = obj.gate_.label( parameter, tex );
    end
    
  end
  
  methods ( Access = protected )
    
    %> @brief Override copyElement function to allow for correct deep copy of
    %> handle property.
    function cp = copyElement(obj)
      cp = copyElement@matlab.mixin.Copyable( obj );
      cp.gate_ = obj.gate() ;
    end
    
    %> Property groups
    function groups = getPropertyGroups(obj)
      import matlab.mixin.util.PropertyGroup
      props = struct();
      props.nbQubits = obj.nbQubits;
      props.Control = obj.control;
      props.Target = obj.target;
      props.Theta = obj.theta; 
      props.Sin = obj.sin; 
      props.Cos = obj.cos;
      groups = PropertyGroup(props);
    end
  end
end