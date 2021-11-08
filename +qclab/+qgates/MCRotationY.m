%> @file MCRotationY.m
%> @brief Implements MCRotationY class
% ==============================================================================
%> @class MCRotationY
%> @brief Multi-Controlled Rotation-Y gate.
%> 
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef MCRotationY < qclab.qgates.QMultiControlledGate
  properties (Access = protected)
    %> Property storing the 1-qubit Y-rotation of this multi-qubit controlled 
    %> gate.
    gate_(1,1)  qclab.qgates.RotationY
  end
  
  methods
    function obj = MCRotationY(controls, target, controlStates, varargin)
      if nargin < 3, controlStates = ones(size(controls)) ; end
      obj@qclab.qgates.QMultiControlledGate(controls, controlStates );
      obj.gate_ = qclab.qgates.RotationY( target, varargin{:} );
      
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
      if isa(other,'qclab.qgates.MCRotationY') && ...
         sum(obj.controlStates == other.controlStates) == ...
            length(obj.controlStates) && (obj.gate_ == other.gate_)
        bool = (sum(obj.controls < obj.target) == ...
                sum(other.controls < other.target)) && ...
               (sum(obj.controls > obj.target) == ...
                sum(other.controls > other.target)) ;
      end
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = ctranspose@qclab.qgates.QMultiControlledGate( obj );
      objprime.gate_ = obj.gate_';
    end
    
     %> Makes this multi-controlled rotation-Y gate fixed.
    function makeFixed(obj)
      obj.gate_.makeFixed();
    end
    
    %>  Makes this multi-controlled rotation-Y gate variable.
    function makeVariable(obj)
      obj.gate_.makeVariable();
    end
    
    %> Returns a copy of the quantum angle \f$\theta\f$ of this multi-controlled 
    %> rotation-Y gate.
    function angle = angle(obj)
      angle = obj.gate_.angle;
    end
    
    %> Returns the numerical value \f$\theta\f$ of this multi-controlled 
    %> rotation-Y gate.
    function theta = theta(obj)
      theta = obj.gate_.theta;
    end
    
    %> Returns the cosine \f$\cos(\theta)\f$ of this multi-controlled rotation-Y
    %> gate.
    function cos = cos(obj)
      cos = obj.gate_.cos;
    end
    
    %> Returns the sine \f$\sin(\theta)\f$ of this multi-controlled rotation-Y 
    %>gate.
    function sin = sin(obj)
      sin = obj.gate_.sin;
    end
    
    %> Updates the angle of this multi-controlled rotation-Y gate
    function update(obj, varargin)
      obj.gate_.update(varargin{:});
    end
    
     % target
    function [target] = target(obj)
      target = obj.gate_.qubit ;
    end
    
    %> Copy of 1-qubit gate of multi-controlled rotation-Y gate
    function [gate] = gate(obj)
      gate = copy(obj.gate_);
    end
    
    % setTarget
    function setTarget(obj, target)
      assert( qclab.isNonNegInteger(target) ) ; 
      controls = obj.controls() ;
      assert( ~(any(controls(:) == target) ) ) ;
      obj.gate_.setQubit( target );
    end
    
    % label for draw function
    function [label] = label(obj, parameter)
      if nargin < 2, parameter = 'N'; end
      label = obj.gate_.label( parameter );
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