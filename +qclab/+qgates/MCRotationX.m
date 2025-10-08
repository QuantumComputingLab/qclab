% MCRotationX - Multi-Controlled Rotation-X gate
% The MCRotationX class implements a multi-controlled rotation gate about
% the X axis. It applies an RX(θ) operation to the target qubit if all 
% control qubits are in the specified control states.
%
% Creation
%   Syntax
%     G = qclab.qgates.MCRotationX(controls, target)
%       - Creates an MCRotationX gate with control qubits `controls` 
%         (array of indices), target qubit `target`, and default angle θ = 0 
%
%     G = qclab.qgates.MCRotationX(controls, target, controlStates)
%       - Creates an MCRotationX gate with control qubits `controls`, 
%         target qubit `target`, and an array `controlStates` specifying the 
%         required control state (0 or 1) for each control qubit.
%
%     G = qclab.qgates.MCRotationX(controls, target, controlStates, theta)
%       - Additionally specifies the rotation angle θ (in radians) for the RX 
%         rotation.
%
%     G = qclab.qgates.MCRotationX(controls, target, controlStates, angle)
%       - Alternatively, specify the rotation via a QAngle object `angle`.
%
%     G = qclab.qgates.MCRotationX(controls, target, controlStates, cos, sin)
%       - Construct the gate from the cosine and sine of the rotation angle θ/2.
%
% Input Arguments
%     controls       - Array of non-negative integers specifying control qubits
%     target         - Non-negative integer specifying the target qubit
%     controlStates  - Binary array (0 or 1), same length as `controls` 
%                      (default: all 1)
%     theta          - Rotation angle θ in radians
%     angle          - QAngle object
%     cos, sin       - Cosine and sine of θ/2
%
% Output
%     G - A quantum object of type `MCRotationX`, representing the multi-controlled
%         rotation-X gate acting on the specified qubits.
%
% Examples:
%   Create an MCRotationX gate with controls [0,1], target 2, and rotation θ = π/2:
%     G = qclab.qgates.MCRotationX([0,1], 2, [1,1], pi/2);
%
%   Create an adjustable MCRotationX gate using cosine and sine values:
%     G = qclab.qgates.MCRotationX([0,3], 4, [1,0], cos(pi/4), sin(pi/4));

%> @file MCRotationX.m
%> @brief Implements MCRotationX class
% ==============================================================================
%> @class MCRotationX
%> @brief Multi-Controlled Rotation-X gate.
%> 
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef MCRotationX < qclab.qgates.QMultiControlledGate
  properties (Access = protected)
    %> Property storing the 1-qubit X-rotation of this multi-qubit controlled 
    %> gate.
    gate_(1,1)  qclab.qgates.RotationX
  end
  
  methods
    function obj = MCRotationX(controls, target, controlStates, varargin)
      if nargin < 3, controlStates = ones(size(controls)) ; end
      obj@qclab.qgates.QMultiControlledGate(controls, controlStates );
      obj.gate_ = qclab.qgates.RotationX( target, varargin{:} );
      
      assert( qclab.isNonNegInteger(target) ) ; 
      assert( ~(any(controls(:) == target) ) ) ;
    end
    
    % fixed
    function [bool] = fixed(obj)
      bool = obj.gate_.fixed ;
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      out = -1;
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false ;
      if isa(other,'qclab.qgates.MCRotationX') && ...
         sum(obj.controlStates == other.controlStates) == ...
            length(obj.controlStates) && (obj.gate_ == other.gate_)
        bool = (sum(obj.controls < obj.targets) == ...
                sum(other.controls < other.targets)) && ...
               (sum(obj.controls > obj.targets) == ...
                sum(other.controls > other.targets)) ;
      end
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = ctranspose@qclab.qgates.QMultiControlledGate( obj );
      objprime.gate_ = obj.gate_';
    end
    
     %> Makes this multi-controlled rotation-X gate fixed.
    function makeFixed(obj)
      obj.gate_.makeFixed();
    end
    
    %>  Makes this multi-controlled rotation-X gate variable.
    function makeVariable(obj)
      obj.gate_.makeVariable();
    end
    
    %> Returns a copy of the quantum angle \f$\theta\f$ of this multi-controlled 
    %> rotation-X gate.
    function angle = angle(obj)
      angle = obj.gate_.angle;
    end
    
    %> Returns the numerical value \f$\theta\f$ of this multi-controlled 
    %> rotation-X gate.
    function theta = theta(obj)
      theta = obj.gate_.theta;
    end
    
    %> Returns the cosine \f$\cos(\theta)\f$ of this multi-controlled rotation-X
    %> gate.
    function cos = cos(obj)
      cos = obj.gate_.cos;
    end
    
    %> Returns the sine \f$\sin(\theta)\f$ of this multi-controlled rotation-X 
    %> gate.
    function sin = sin(obj)
      sin = obj.gate_.sin;
    end
    
    %> Updates the angle of this multi-controlled rotation-X gate
    function update(obj, varargin)
      obj.gate_.update(varargin{:});
    end
    
     % targets
    function [targets] = targets(obj)
      targets = obj.gate_.qubit ;
    end

    % setTargets
    function setTargets(obj, target)
      assert( qclab.isNonNegInteger(target) ) ; 
      controls = obj.controls() ;
      assert( ~(any(controls(:) == target) ) ) ;
      obj.gate_.setQubit( target );
    end
    
    %> Copy of 1-qubit gate of multi-controlled rotation-X gate
    function [gate] = gate(obj)
      gate = copy(obj.gate_);
    end    
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      label = obj.gate_.label( parameter, tex );
    end
    
    % setQubits
    function setQubits(obj, qubits)
      assert( qclab.isNonNegIntegerArray(qubits) ) ;
      assert( length(qubits) == length(unique(qubits)) );
      obj.controls_ = sort(qubits(1:end-1)) ;
      obj.setTargets( qubits(end) ) ;
    end
  end
  
  methods ( Access = protected )
    
    %> @brief Override copyElement function to allow for correct deep copy of
    %> handle property
    function cp = copyElement(obj)
      cp = copyElement@matlab.mixin.Copyable( obj );
      cp.gate_ = obj.gate() ;
    end
    
  end
end