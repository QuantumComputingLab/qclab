%> @file QRotation.m
%> @brief Class for representing an adjustable quantum rotation.
% ==============================================================================
%> @class QRotation
%> @brief Class for representing an adjustable quantum rotation.
%>
%> This class stores the quantum angle \f$\theta/2\f$, i.e., the cosine and
%> sine of half the adjustable quantum rotation parameter \f$\theta\f$.
% 
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef QRotation < qclab.QAdjustable
  properties (Access = protected)
    %> Quantum angle of this quantum rotation.
    angle_(1,1)   qclab.QAngle
  end
  
  methods
   
    % Class constructor  =======================================================
    %> @brief Constructor for quantum rotations
    %>
    %> The QRotation class constructor supports 4 ways of constructing a quantum
    %> rotation:
    %>
    %> 1. QRotation() : Default Constructor. Constructs an adjustable quantum 
    %>     rotation with \f$\theta = 0\f$.
    %>
    %> 2. QRotation(angle, fixed) : Constructs an adjustable quantum rotation 
    %>     with the given quantum angle `angle` and the flag `fixed`. The 
    %>     default of `fixed` is false.
    %>
    %> 3. QRotation(theta, fixed) : Constructs an adjustable quantum rotation 
    %>     with the given quantum angle `angle` = \f$\theta/2\f$ and the flag 
    %>     `fixed`. The default of `fixed` is false.
    %>
    %> 3. QRotation(cos,sin, fixed) : Constructs an adjustable quantum rotation 
    %>    with the given values `cos` = \f$\cos(\theta/2)\f$ and 
    %>    `sin` = \f$\sin(\theta/2)\f$ and the flag `fixed`. The default of 
    %>     `fixed` is false.
    %>
    %> If `fixed` is provided, it must be of `logical` type.
    %>
    %> @param varargin Variable input argument, being either:
    %>  - empty
    %>  - angle, (fixed)
    %>  - theta, (fixed)
    %>  - cos, sin, (fixed)
    % ==========================================================================
    function obj = QRotation(varargin)
      obj@qclab.QAdjustable(false); 
      if nargin == 0 % empty default constructor
        obj.angle_ = qclab.QAngle();
      elseif nargin == 1 % either angle, or theta
        if isa(varargin{1},'qclab.QAngle')
          obj.angle_ = varargin{1} ;
        else
          obj.angle_ = qclab.QAngle(varargin{1}/2);
        end
      elseif nargin == 2 % either angle or theta + fixed, or cos and sin
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
      elseif nargin == 3 % cos, sin and fixed
        obj.angle_ = qclab.QAngle(varargin{1}, varargin{2});
        if varargin{3}, obj.makeFixed; end
      end
    end
    
    %> Returns a copy of the quantum angle \f$\theta/2\f$ of this quantum rotation.
    function angle = angle(obj)
      angle = copy(obj.angle_);
    end
    
    %> Returns the numerical value \f$\theta\f$ of this quantum rotation.
    function theta = theta(obj)
      theta = 2 * obj.angle_.theta;
    end
    
    %>  Returns the cosine \f$\cos(\theta/2)\f$ of this quantum rotation.
    function cos = cos(obj)
      cos = obj.angle_.cos;
    end
    
    %> Returns the sine \f$\sin(\theta/2)\f$ of this quantum rotation.
    function sin = sin(obj)
      sin = obj.angle_.sin;
    end
    
    % ==========================================================================
    %> @brief Update this quantum rotation
    %>
    %> If the quantum rotation is not fixed, the update function is called on
    %> the quantum angle. 
    %>
    %> The update function supports 3 ways of updating a quantum rotation:
    %> 1. `obj.update(angle)` : where angle is a quantum angle, updates
    %> cosine and sine of obj.angle_ to values of other
    %> 2. `obj.update(theta)` : updates cosine and sine of obj.anle_based on 
    %> `theta`
    %> 3. `obj.update(cos, sin)` : updates cosine and sine of obj.angle_ 
    %> with `cos`, `sin` values
    %>
    %> @param obj QRotation object
    %> @param varargin Variable input argument, being either:
    %>  - QAngle object
    %>  - theta value
    %>  - cos, sin values
    % ==========================================================================
    function update(obj, varargin)
      assert(~obj.fixed)
      if nargin == 2 && ~isa(varargin{1},'qclab.QAngle') %theta provided
        obj.angle_.update(varargin{1}/2);
      else
        obj.angle_.update(varargin{:});
      end
    end
    
    %> @brief Checks if `other` is equal to this quantum rotation.
    function [bool] = eq(obj, other)
      bool = (other.angle_ == obj.angle_);
    end
    
    %> @brief Checks if `other` is different from this quantum rotation.
    function [bool] = ne(obj, other)
      bool = (other.angle_ ~= obj.angle_);
    end
    
  end
end % class QRotation
