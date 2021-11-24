%> @file Phase.m
%> @brief Implements Phase gate class.
% ==============================================================================
%> @class Phase
%> @brief 1-qubit phase gate.
%>
%> 1-qubit phase gate with matrix representation:
%>
%> \f[\begin{bmatrix} 1   &  0 \\ 
%>                    0 & c + is \end{bmatrix},\f]
%>
%> where \f$c = \cos(\theta), s = \sin(\theta)\f$.
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef Phase < qclab.qgates.QGate1 & qclab.QAdjustable
  
  properties (Access = protected)
    %> The quantum angle of this Phase gate.
    angle_(1,1)   qclab.QAngle
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Constructor for phase gates
    %>
    %> The Phase class constructor supports 5 ways of constructing a 1-qubit
    %> phase gate:
    %>
    %> 1. Phase() : Default Constructor. Constructs an adjustable 1-qubit phase 
    %>    gate with `qubit` set to 0 and \f$\theta = 0\f$.
    %>
    %> 2. Phase(qubit) : Constructs an adjustable 1-qubit phase 
    %>    gate with `qubit` set to `qubit` and \f$\theta = 0\f$.
    %>
    %> 3. Phase(qubit, angle, fixed) : Constructs an adjustable 1-qubit phase 
    %>    gate with the given quantum angle `angle` and the flag `fixed`. The 
    %>    default of `fixed` is false.
    %>
    %> 4. Phase(qubit, theta, fixed) : Constructs an adjustable 1-qubit phase 
    %>    gate with the given quantum angle `angle` = \f$\theta\f$ and the flag 
    %>    `fixed`. The default of `fixed` is false.
    %>
    %> 5. Phase(qubit, cos,sin, fixed) : Constructs an adjustable 1-qubit phase
    %>    gate with the given values `cos` = \f$\cos(\theta)\f$ and 
    %>    `sin` = \f$\sin(\theta)\f$ and the flag `fixed`. The default of 
    %>     `fixed` is false.
    %>
    %> If `fixed` is provided, it must be of `logical` type.
    %>
    %> @param qubit Qubit index of phase gate
    %> @param varargin Variable input argument, being either:
    %>  - empty
    %>  - angle, (fixed)
    %>  - theta, (fixed)
    %>  - cos, sin, (fixed)
    % ==========================================================================
    function obj = Phase(qubit, varargin)
      if nargin == 0
        qubit = 0;
      end
      obj@qclab.qgates.QGate1( qubit );
      obj@qclab.QAdjustable(false); 
      if nargin < 2 % empty default constructor
        obj.angle_ = qclab.QAngle();
      elseif nargin == 2 % either angle, or theta
        if isa(varargin{1},'qclab.QAngle')
          obj.angle_ = varargin{1} ;
        else
          obj.angle_ = qclab.QAngle(varargin{1});
        end
      elseif nargin == 3 % either angle or theta + fixed, or cos and sin
        if isa(varargin{2},'logical') % second is logical
         if isa(varargin{1},'qclab.QAngle') % first is angle
            obj.angle_ = varargin{1} ;
          else
            obj.angle_ = qclab.QAngle(varargin{1});
         end
          if varargin{2}, obj.makeFixed; end
        else
          obj.angle_ = qclab.QAngle(varargin{1}, varargin{2});
        end
      elseif nargin == 4 % cos, sin and fixed
        obj.angle_ = qclab.QAngle(varargin{1}, varargin{2});
        if varargin{3}, obj.makeFixed; end
      end
    end
    
    % matrix
    function [mat] = matrix(obj)
      mat = [1, 0;
             0, obj.cos + 1i *obj.sin ];
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmPhase( fid, obj.qubit + offset, obj.theta );
      out = 0;
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other,'qclab.qgates.Phase')
        bool = (obj.angle_ == other.angle_) ;
      end
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = ctranspose@qclab.qgates.QGate1( obj );
      objprime.update( -obj.angle );
    end
    
    %> @brief Returns a copy of the quantum angle \f$\theta\f$ of this phase gate.
    function angle = angle(obj)
      angle = copy(obj.angle_);
    end
    
    %> @brief Returns the numerical value \f$\theta\f$ of this phase gate.
    function theta = theta(obj)
      theta = obj.angle_.theta;
    end
    
    %>  @brief Returns the cosine \f$\cos(\theta)\f$ of this phase gate.
    function cos = cos(obj)
      cos = obj.angle_.cos;
    end
    
    %> @brief Returns the sine \f$\sin(\theta)\f$ of this phase gate.
    function sin = sin(obj)
      sin = obj.angle_.sin;
    end
    
    % ==========================================================================
    %> @brief Update this phase gate
    %>
    %> If the phase gate is not fixed, the update function is called on
    %> the quantum angle. 
    %>
    %> The update function supports 3 ways of updating a phase gate:
    %> 1. obj.update(angle) : where angle is a quantum angle, updates
    %>    cosine and sine of obj.angle_ to values of other
    %> 2. obj.update(theta) : updates cosine and sine of obj.anle_based on 
    %>    `theta`
    %> 3. obj.update(cos, sin) : updates cosine and sine of obj.angle_ 
    %>    with `cos`, `sin` values
    %>
    %> @param obj   1-qubit phase gate object
    %> @param varargin Variable input argument, being either:
    %>  - QAngle object
    %>  - theta
    %>  - cos, sin
    % ==========================================================================
    function update(obj, varargin)
      assert(~obj.fixed)
      if nargin == 2 && ~isa(varargin{1},'qclab.QAngle') %theta provided
        obj.angle_.update(varargin{1});
      else
        obj.angle_.update(varargin{:});
      end
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      if nargin < 2, parameter = 'N'; end
      label = 'P';        
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f)'], obj.theta);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f)'], obj.theta);
      end
    end
    
  end
  
  methods ( Access = protected )
    
    %> @brief Override copyElement function to allow for correct deep copy of
    %> handle property.
    function cp = copyElement(obj)
      cp = copyElement@matlab.mixin.Copyable( obj );
      cp.angle_ = obj.angle() ;
    end
    
  end
end % Phase
