%> @file CU3.m
%> @brief Implements CU3 class
% ==============================================================================
%> @class CU3
%> @brief Controlled U3 gate.
%> 
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef CU3 < qclab.qgates.QControlledGate2
  properties (Access = protected)
    %> Property storing the 1-qubit U3 gate of this 2-qubit controlled gate.
    gate_(1,1)  qclab.qgates.U3
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Constructor for CU3 gates
    %>
    %> The CU3 class constructor supports 7 ways of constructing a 2-qubit
    %> CU3 gate:
    %>
    %> 1. CU3() : Default Constructor. Constructs an adjustable 2-qubit CU3 
    %>    gate with `control` set to 0, `target` to 1, `controlState` to 1 and 
    %>    \f$\theta = \phi = \lambda = 0\f$.
    %>
    %> 2. CU3(control) : Constructs an adjustable 2-qubit CU3 
    %>    gate with `control` set to `control`,`target` to 1, `controlState` to 
    %>    1 and \f$\theta = \phi = \lambda = 0\f$.
    %>
    %> 3. CU3(control, target) : Constructs an adjustable 2-qubit CU3 
    %>    gate with `control` set to `control`, `target` to `target`, 
    %>    `controlState` to 1 and  \f$\theta = \phi = \lambda = 0\f$.
    %>
    %> 4. CU2(control, target, controlState) : Constructs an adjustable 2-qubit
    %>    CU3 gate with `control` set to `control`, `target` to `target`, 
    %>    `controlState` to `controlState` and \f$\theta = \phi = \lambda = 0\f$.
    %>
    %> 5. CU3(control, target, controlState, angle_theta, angle_phi, 
    %>    angle_lambda, fixed) : Constructs an adjustable 2-qubit CU3 gate with
    %>    `control` set to `control`, `target` to `target`, `controlState` to 
    %>    `controlState`, the given quantum angles `angle_theta`, `angle_phi` 
    %>     and `angle_lambda` and the flag `fixed`. The default of `fixed` is 
    %>    false.
    %>
    %> 6. CU3(control, target, controlState, theta, phi, lambda, fixed) : 
    %>    Constructs an adjustable  2-qubit CU3 gate with the given quantum 
    %>    angles `angle_theta` = \f$\theta/2\f$, `angle_phi` = \f$\phi\f$, 
    %>    `angle_lambda` = \f$\lambda\f$ , and the flag `fixed`. 
    %>    The default of `fixed` is false.
    %>    
    %>
    %> 7. CU3(control, target, controlState, cos_theta, sin_theta, cos_phi,  
    %>    sin_phi, cos_lambda, sin_lambda, fixed) : Constructs an adjustable 
    %>    2-qubit CU3 gate with the given values cos_theta` = 
    %>    \f$\cos(\theta/2)\f$, `sin_theta` = \f$\sin(\theta/2)\f$, 
    %>    `cos_phi` = \f$\cos(\phi)\f$, `sin_phi` = 
    %>    \f$\sin(\phi)\f$ and `cos_lambda` = \f$\cos(\lambda)\f$,
    %>    `sin_lambda` = \f$\sin(\lambda)\f$, and the flag `fixed`.
    %>     The default of `fixed` is false.
    %>
    %> The global phase of the CU3 gate is always initialized to 0.
    % ==========================================================================
    function obj = CU3(control, target, controlState, varargin)
      if nargin == 0
        control = 0;
        target = 1;
        controlState = 1;
      elseif nargin == 1
        target = 1;
        controlState = 1;
      elseif nargin == 2
        controlState = 1;
      end
      obj@qclab.qgates.QControlledGate2(control, controlState ); 
      obj.gate_ = qclab.qgates.U3(target, varargin{:});
    end
    
    % fixed
    function [bool] = fixed(obj)
      bool = obj.gate_.fixed ;
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmCU3( fid, obj.control + offset, obj.target + offset, ...
                       obj.controlState, obj.theta, obj.phi, obj.lambda );      
      out = 0;
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other,'qclab.qgates.CU3') && ...
          (obj.controlState == other.controlState) && ...
          (obj.gate_ == other.gate_)
        bool = ((obj.control < obj.target) && (other.control < other.target))...
          || ((obj.control > obj.target) && (other.control > other.target)) ;
      end
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = ctranspose@qclab.qgates.QControlledGate2( obj );
      objprime.gate_ = obj.gate_';
    end
    
    %> Makes this controlled U3 gate fixed.
    function makeFixed(obj)
      obj.gate_.makeFixed();
    end
    
    %>  Makes this controlled U3 gate variable.
    function makeVariable(obj)
      obj.gate_.makeVariable();
    end
    
    %> @brief Returns the numerical value \f$\theta\f$ of this CU3 gate.
    function phi = theta(obj)
      phi = obj.gate_.theta ;
    end
    
    %>  @brief Returns the cosine \f$\cos(\theta)\f$ of this CU3 gate.
    function cos = cosTheta(obj)
      cos = obj.gate_.cosTheta ;
    end
    
    %> @brief Returns the sine \f$\sin(\theta)\f$ of this CU3 gate.
    function sin = sinTheta(obj)
      sin = obj.gate_.sinTheta ;
    end
    
    %> @brief Returns the numerical value \f$\phi\f$ of this CU3 gate.
    function phi = phi(obj)
      phi = obj.gate_.phi ;
    end
    
    %>  @brief Returns the cosine \f$\cos(\phi)\f$ of this CU3 gate.
    function cos = cosPhi(obj)
      cos = obj.gate_.cosPhi ;
    end
    
    %> @brief Returns the sine \f$\sin(\phi)\f$ of this CU3 gate.
    function sin = sinPhi(obj)
      sin = obj.gate_.sinPhi ;
    end
    
    %> @brief Returns the numerical value \f$\lambda\f$ of this CU3 gate.
    function lambda = lambda(obj)
      lambda = obj.gate_.lambda ;
    end
    
    %>  @brief Returns the cosine \f$\cos(\lambda)\f$ of this CU3 gate.
    function cos = cosLambda(obj)
      cos = obj.gate_.cosLambda ;
    end
    
    %> @brief Returns the sine \f$\sin(\lambda)\f$ of this CU3 gate.
    function sin = sinLambda(obj)
      sin = obj.gate_.sinLambda ;
    end
    
    %> @brief Returns the global phase of this CU3 gate.
    function alpha = globalPhase(obj)
      alpha = obj.gate_.globalPhase ;
    end
    
    %> @brief Sets the global phase of this CU3 gate to the unitary value `alpha`
    function setGlobalPhase(obj, alpha)
      obj.gate_.setGlobalPhase(alpha) ;
    end
    
     % ==========================================================================
    %> @brief Update this CU3 gate
    %>
    %> If the CU3 gate is not fixed, the update function is called on
    %> the quantum angles. 
    %>
    %> The update function supports 3 ways of updating a CU3 gate:
    %>
    %> 1. obj.update(angle_theta, angle_phi, angle_lambda) : updates to the 
    %>    given quantum angles `angle_theta`, `angle_phi` and `angle_lambda`.
    %>
    %> 2. obj.update(theta, phi, lambda) : updates with the given quantum angles 
    %>    `angle_theta` = \f$\theta/2\f$, `angle_phi` = \f$\phi\f$,
    %>    `angle_lambda` = \f$\lambda\f$.
    %>
    %> 3. obj.update( cos_theta, sin_theta, cos_phi, sin_phi, cos_lambda, 
    %>    sin_lambda) : updates with the given values cos_theta` = 
    %>    \f$\cos(\theta/2)\f$, `sin_theta` = \f$\sin(\theta/2)\f$,
    %>    `cos_phi` = \f$\cos(\phi)\f$, `sin_phi` = \f$\sin(\phi)\f$ and
    %>    `cos_lambda` = \f$\cos(\lambda)\f$, `sin_lambda` = \f$\sin(\lambda)\f$
    %>
    %> @param obj   2-qubit CU3 gate object
    %> @param varargin Variable input argument, being either:
    %>  - angle_theta angle_phi, angle_lambda : 3 QAngle objects
    %>  - theta, phi, lambda
    %>  - cos_theta, sin_theta, cos_phi, sin_phi, cos_lambda, sin_lambda
    % ==========================================================================
    function update(obj, varargin)
      obj.gate_.update(varargin{:}) ;
    end
    
    % target
    function [target] = target(obj)
      target = obj.gate_.qubit ;
    end
    
    %> Copy of 1-qubit gate of controlled rotation-Y gate
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