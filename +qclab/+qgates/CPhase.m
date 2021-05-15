%> @file CPhase.m
%> @brief Implements CPhase class
% ==============================================================================
%> @class CPhase
%> @brief Controlled phase gate.
%> 
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef CPhase < qclab.qgates.QControlledGate2
  properties (Access = protected)
    %> Property storing the 1-qubit phase gate of this 2-qubit controlled gate.
    gate_(1,1)  qclab.qgates.Phase
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Contstructor for controlled phase gates
    %>
    %> The CPhase class constructor supports 7 ways of constructing a 2-qubit
    %> controlled phase gate:
    %>
    %> 1. CPhase() : Default Constructor. Constructs an adjustable 2-qubit  
    %>    controlled phase gate with `control` set to 0, `target` to 1,
    %>    `controlState` to 1 and \f$\theta = 0\f$.
    %>
    %> 2. CPhase(control) : Constructs an adjustable 2-qubit controlled phase 
    %>    gate with `control` set to `control`, `target` to 1, `controlState`  
    %>    to 1 and \f$\theta = 0\f$.
    %>
    %> 3. CPhase(control,target) : Constructs an adjustable 2-qubit controlled
    %>    phase gate with `control` set to `control`, `target` to `target`,
    %>    `controlState` to 1 and \f$\theta = 0\f$.
    %.
    %> 4. CPhase(control,target,controlState) : Constructs an adjustable
    %>    2-qubit controlled phase  gate with `control` set to `control`,
    %>    `target` to `target`, `controlState` to `controlState` and 
    %>    \f$\theta = 0\f$.
    %>
    %> 5. CPhase(control,target,controlState, angle, fixed) : Constructs an 
    %>    adjustable 2-qubit controlled phase gate with `control` set to 
    %>    `control`, `target` to `target`, `controlState` to `controlState` and
    %>    the given quantum angle `angle` and the flag `fixed`. The default of 
    %>    `fixed` is false.
    %>
    %> 6. CPhase(control,target,controlState, theta, fixed) : Constructs an 
    %>    adjustable 2-qubit controlled phase gate with `control` set to 
    %>    `control`, `target` to `target`, `controlState` to `controlState` and
    %>    the given quantum angle `angle` = \f$\theta\f$ and the flag `fixed`. 
    %>    The default of `fixed` is false.
    %> 
    %> 7. CPhase(control,target,controlState, cos,sin, fixed) : Constructs an 
    %>    adjustable 2-qubit controlled phase gate with `control` set to 
    %>    `control`, `target` to `target`, `controlState` to `controlState` with 
    %>    the given values `cos` = \f$\cos(\theta)\f$ and 
    %>    `sin` = \f$\sin(\theta)\f$ and the flag `fixed`. The default of 
    %>     `fixed` is false.
    %>
    %> If `fixed` is provided, it must be of `logical` type.
    %>
    %> @param control Control qubit index of controlled phase gate. Default: 0.
    %> @param target Target qubit index of controlled phase gate. Default: 1.
    %> @param controlState control state of contrlled phase gate. Default: 1.
    %> @param varargin Variable input argument, being either:
    %>  - empty
    %>  - angle, (fixed)
    %>  - theta, (fixed)
    %>  - cos, sin, (fixed)
    % ==========================================================================
    function obj = CPhase(control, target, controlState, varargin)
      if nargin == 0, control = 0; end
      if nargin < 1, target = 1; end
      if nargin < 2, controlState = 1; end
      obj@qclab.qgates.QControlledGate2(control, controlState ); 
      obj.gate_ = qclab.qgates.Phase(target, varargin{:});
    end
    
    % fixed
    function [bool] = fixed(obj)
      bool = obj.gate_.fixed ;
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      fprintf(fid,'cp(%.15f) q[%d], q[%d];\n', obj.theta, ...
        obj.control + offset, obj.target + offset);
      out = 0; 
    end
    
     % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other,'qclab.qgates.CPhase') && ...
          (obj.controlState == other.controlState) && ...
          (obj.gate_ == other.gate_)
        bool = ((obj.control < obj.target) && (other.control < other.target))...
          || ((obj.control > obj.target) && (other.control > other.target)) ;
      end
    end
    
    %> Returns a copy of the quantum angle \f$\theta\f$ of this controlled phase 
    %> gate.
    function angle = angleCopy(obj)
      angle = obj.gate_.angleCopy;
    end
    
    %> Returns the numerical value \f$\theta\f$ of this controlled phase gate.
    function theta = theta(obj)
      theta = obj.gate_.angleCopy.theta;
    end
    
    %>  Returns the cosine \f$\cos(\theta)\f$ of this controlled phase gate.
    function cos = cos(obj)
      cos = obj.gate_.angleCopy.cos;
    end
    
    %> Returns the sine \f$\sin(\theta)\f$ of this controlled phase gate.
    function sin = sin(obj)
      sin = obj.gate_.angleCopy.sin;
    end
    
    %> Updates the angle of this controlled phase gate
    function update(obj, varargin)
      obj.gate_.update(varargin{:});
    end
    
    % target
    function [target] = target(obj)
      target = obj.gate_.qubit ;
    end
    
    % gateCopy
    function [gate] = gateCopy(obj)
      gate = copy(obj.gate_);
    end
    
    % setTarget
    function setTarget(obj, target )
      assert( qclab.isNonNegInteger(target) ) ; 
      assert( target ~= obj.control() ) ;
      obj.gate_.setQubit( target );
    end
  end
end % CPhase
