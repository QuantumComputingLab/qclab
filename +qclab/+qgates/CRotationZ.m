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
    
  end
end