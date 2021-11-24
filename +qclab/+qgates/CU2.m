%> @file CU2.m
%> @brief Implements CU2 class
% ==============================================================================
%> @class CU2
%> @brief Controlled U2 gate.
%> 
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef CU2 < qclab.qgates.QControlledGate2
  properties (Access = protected)
    %> Property storing the 1-qubit U2 gate of this 2-qubit controlled gate.
    gate_(1,1)  qclab.qgates.U2
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Constructor for controlled U2 gates
    %>
    %> The CU2 class constructor supports 7 ways of constructing a 2-qubit
    %> CU2 gate:
    %>
    %> 1. CU2() : Default Constructor. Constructs an adjustable 2-qubit CU2 
    %>    gate with `control` set to 0, `target` to 1, `controlState` to 1
    %>    and \f$\phi = \lambda = 0\f$.
    %>
    %> 2. CU2(control) : Constructs an adjustable 2-qubit CU2 
    %>    gate with `control` set to `control`, `target` to 1, `controlState` 
    %>    to 1 and \f$\phi = \lambda = 0\f$.
    %>
    %> 3. CU2(control, target) : Constructs an adjustable 2-qubit CU2 
    %>    gate with `control` set to `control`, `target` to `target`, 
    %>    `controlState` to 1 and \f$\phi = \lambda = 0\f$.
    %>
    %> 4. CU2(control, target, controlState) : Constructs an adjustable 2-qubit
    %>    CU2 gate with `control` set to `control`, `target` to `target`, 
    %>    `controlState` to `controlState` and \f$\phi = \lambda = 0\f$.
    %>
    %> 5. CU2(control, target, controlState, angle_phi, angle_lambda, fixed) : 
    %>    Constructs an adjustable 2-qubit CU2 gate with `control` set to  
    %>    `control`, `target` to `target`, `controlState` to `controlState`, the  
    %>    given quantum angles `angle_phi` and `angle_lambda` and the flag 
    %>    `fixed`.  The default of `fixed` is false.
    %>
    %> 6. CU2(control, target, controlState, phi, lambda, fixed) : Constructs an 
    %>    adjustable 2-qubit CU2 gate with the given quantum angles 
    %>    `angle_phi` = \f$\phi\f$, `angle_lambda` = \f$\lambda\f$, and the 
    %>    flag `fixed`. The default of `fixed` is false.
    %>
    %> 7. CU2(control, target, controlState, cos_phi, sin_phi, cos_lambda, 
    %>        sin_lambda, fixed) :
    %     Constructs an adjustable 2-qubit CU2 gate with the given values
    %>    `cos_phi` = \f$\cos(\phi)\f$, `sin_phi` = \f$\sin(\phi)\f$ and
    %>    `cos_lambda` = \f$\cos(\lambda)\f$, `sin_lambda` = \f$\sin(\lambda)\f$
    %>     and the flag `fixed`. The default of `fixed` is false.
    % ==========================================================================
    function obj = CU2(control, target, controlState, varargin)
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
      obj.gate_ = qclab.qgates.U2(target, varargin{:});
    end
    
    % fixed
    function [bool] = fixed(obj)
      bool = obj.gate_.fixed ;
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmCU2( fid, obj.control + offset, obj.target + offset, ...
                       obj.controlState, obj.phi, obj.lambda );      
      out = 0;
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other,'qclab.qgates.CU2') && ...
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
    
     %> Makes this controlled U2 gate fixed.
    function makeFixed(obj)
      obj.gate_.makeFixed();
    end
    
    %>  Makes this controlled U2 gate variable.
    function makeVariable(obj)
      obj.gate_.makeVariable();
    end
    
    %> @brief Returns a copy of the quantum angles \f$\phi\f$ and \f$\lambda\f$ 
    %> of this U2 gate.
    function angles = angles(obj)
      angles = obj.gate_.angles;
    end
    
    %> @brief Returns the numerical value \f$\phi\f$ of this CU2 gate.
    function phi = phi(obj)
      phi = obj.gate_.phi ;
    end
    
    %>  @brief Returns the cosine \f$\cos(\phi)\f$ of this CU2 gate.
    function cos = cosPhi(obj)
      cos = obj.gate_.cosPhi ;
    end
    
    %> @brief Returns the sine \f$\sin(\phi)\f$ of this CU2 gate.
    function sin = sinPhi(obj)
      sin = obj.gate_.sinPhi ;
    end
    
    %> @brief Returns the numerical value \f$\lambda\f$ of this CU2 gate.
    function lambda = lambda(obj)
      lambda = obj.gate_.lambda ;
    end
    
    %>  @brief Returns the cosine \f$\cos(\lambda)\f$ of this CU2 gate.
    function cos = cosLambda(obj)
      cos = obj.gate_.cosLambda ;
    end
    
    %> @brief Returns the sine \f$\sin(\lambda)\f$ of this CU2 gate.
    function sin = sinLambda(obj)
      sin = obj.gate_.sinLambda ;
    end
    
    % ==========================================================================
    %> @brief Update this CU2 gate
    %>
    %> If the CU2 gate is not fixed, the update function is called on
    %> the quantum angles. 
    %>
    %> The update function supports 3 ways of updating a CU2 gate:
    %>
    %> 1. obj.update(angle_phi, angle_lambda) : updates to the given quantum
    %>    angles `angle_phi` and `angle_lambda`.
    %>
    %> 2. obj.update(phi, lambda) : updates with the given quantum angles 
    %>    `angle_phi` = \f$\phi\f$,`angle_lambda` = \f$\lambda\f$
    %>
    %> 3. obj.update(cos_phi, sin_phi, cos_lambda, sin_lambda) : updates with 
    %>    the given values
    %>    `cos_phi` = \f$\cos(\phi)\f$, `sin_phi` = \f$\sin(\phi)\f$ and
    %>    `cos_lambda` = \f$\cos(\lambda)\f$, `sin_lambda` = \f$\sin(\lambda)\f$
    %>
    %> @param obj   2-qubit CU2 gate object
    %> @param varargin Variable input argument, being either:
    %>  - angle_phi, angle_lambda : 2 QAngle objects
    %>  - phi, lambda
    %>  - cos_phi, sin_phi, cos_lambda, sin_lambda
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