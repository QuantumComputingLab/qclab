%> @file QRotation.m
%> @brief Class for representing a quantum rotation.
% ==============================================================================
%> @class QRotation
%> @brief Class for representing a quantum rotation.
%>
%> This class stores the quantum angle \f$\theta/2\f$, i.e., the cosine and
%> sine of half the quantum rotation parameter \f$\theta\f$.
%>
%> Where quantum angles can be added and substracted, quantum rotations can be
%> multiplied and divided with each other.
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef QRotation < handle & ...
                     matlab.mixin.Copyable
  
  properties (Access = protected)
    %> Quantum angle of this quantum rotation.
    angle_(1,1)   qclab.QAngle
  end
  
  methods
   
    % Class constructor  =======================================================
    %> @brief Constructor for quantum rotations
    %>
    %> The QRotation class constructor supports 5 ways of constructing a quantum
    %> rotation:
    %>
    %> 1. QRotation() : Default Constructor. Constructs a quantum 
    %>     rotation with \f$\theta = 0\f$.
    %>
    %> 2. QRotation( angle ) : Constructs a quantum rotation 
    %>     with the given quantum angle `angle`.
    %>
    %> 3. QRotation( rotation) : Constructs a quantum rotation 
    %>     with the given quantum rotation `rotation`.
    %>
    %> 4. QRotation( theta ) : Constructs a quantum rotation 
    %>     with the given quantum angle `angle` = \f$\theta/2\f$.
    %>
    %> 5. QRotation( cos, sin ) : Constructs a quantum rotation 
    %>    with the given values `cos` = \f$\cos(\theta/2)\f$ and 
    %>    `sin` = \f$\sin(\theta/2)\f$.
    %>
    %> @param varargin Variable input argument, being either:
    %>  - empty
    %>  - angle
    %>  - rotation
    %>  - theta
    %>  - cos, sin
    % ==========================================================================
    function obj = QRotation(varargin)
      if nargin == 0 % empty default constructor
        obj.angle_ = qclab.QAngle();
      elseif nargin == 1 % either angle, rotation or theta
        if isa(varargin{1},'qclab.QAngle') % QAngle
          obj.angle_ = varargin{1} ;
        elseif isa(varargin{1},'qclab.QRotation') % QRotation
          obj.angle_ = varargin{1}.angle ;
        else % theta
          obj.angle_ = qclab.QAngle(varargin{1}/2);
        end
      elseif nargin == 2 % cos, sin
        obj.angle_ = qclab.QAngle(varargin{1}, varargin{2});
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
    %>
    %> The update function supports 4 ways of updating a quantum rotation:
    %>
    %> 1. obj.update(angle) : where angle is a quantum angle, updates
    %>    cosine and sine of obj.angle_ to values of other.
    %>
    %> 2. obj.update(rotation) : where rotation is a quantum rotation, updates
    %>    cosine and sine of obj.angle_ to rotation.angle.
    %>
    %> 3. obj.update(theta) : updates cosine and sine of obj.anle_based on 
    %>    `theta`.
    %>
    %> 4. obj.update(cos, sin) : updates cosine and sine of obj.angle_ 
    %>    with `cos`, `sin` values.
    %>
    %> @param obj QRotation object
    %> @param varargin Variable input argument, being either:
    %>  - QAngle object
    %>  - theta value
    %>  - cos, sin values
    % ==========================================================================
    function update(obj, varargin)
      if nargin == 2
        if isa(varargin{1},'qclab.QAngle') % angle provided
          obj.angle_ = varargin{1} ;
        elseif isa(varargin{1},'qclab.QRotation') % rotation provided
          obj.angle_ = varargin{1}.angle ;
        else % theta provided
          obj.angle_.update(varargin{1}/2);
        end
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
    
    %> @brief Checks if `other` is a quantum rotation.
    function [bool] = equalType(~, other)
      bool = isa(other, 'qclab.QRotation');
    end
    
    %> @brief Product of two quantum rotations that results in a quantum 
    %> rotation `out`: -[ out ]- = -[ obj ]--[ other ]-
    function [out] = mtimes(obj,other)
      assert( obj.equalType(other) );
      out = copy( obj );
      out.update( obj.angle_ + other.angle_ ) ;
    end
    
    %> @brief Right division of two quantum rotations that results in a quantum
    %> rotation `out`: -[ out ]- = -[ obj ]--[ other ]'-
    function [out] = mrdivide(obj,other)
      assert( obj.equalType(other) );
      out = copy( obj );
      out.update( obj.angle_ - other.angle_ ) ;
    end
    
    %> @brief Left division of two quantum rotations that results in a quantum
    %> rotation `out`: -[ out ]- = -[ obj ]'--[ other ]-
    function [out] = mldivide(obj,other)
      assert( obj.equalType(other) );
      out = copy( obj ) ;
      out.update( other.angle_ - obj.angle_ ) ;
    end
    
    %> @brief Inverse of this quantum rotation that results in a quantum
    %> rotation `out`: -[ out ]- = -[ obj ]'-
    function [out] = inv(obj)
      out = copy( obj );
      out.update( -obj.angle_ );
    end
    
  end
  
  methods ( Access = protected )
    
    %> @brief Override copyElement function to allow for correct deep copy of
    %> handle
    function cp = copyElement(obj)
      cp = copyElement@matlab.mixin.Copyable( obj );
      cp.angle_ = obj.angle ;
    end
    
  end
end % class QRotation
