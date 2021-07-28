%> @file QAngle.m
%> @brief Implements QAngle class.
% ==============================================================================
%> @brief Class for representing a quantum angle.
%
%>  This class stores the cosine and sine of a quantum angle.
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef QAngle < handle & ...
                  matlab.mixin.Copyable
  
  properties (Access = protected)
    %> Cosine value of this quantum angle
    cos_(1,1) double
    %> Sine value of this quantum angle
    sin_(1,1) double
  end
  
  methods
    
    % Class constructor  =======================================================
    %> @brief Constructor for quantum angle objects
    %>
    %> The QAngle class constructor supports 3 ways of constructing a quantum
    %> angle:
    %>
    %> 1. QAngle() : Default contructor. Constructs a quantum angle with 
    %>    \f$\theta = 0\f$.
    %>
    %> 2. QAngle(theta) : Constructs a quantum angle with the given value 
    %> `theta`.
    %>
    %> 3. QAngle(cos,sin) : Constructs a quantum angle with the given `cos` 
    %> and `sin` values.
    %>
    %> @param varargin Variable input argument, being either:
    %>  - empty
    %>  - theta
    %>  - cos, sin
    % ==========================================================================
    function obj = QAngle(varargin)
      if nargin == 0
        obj.cos_ = 1;
        obj.sin_ = 0;
      elseif nargin == 1
        obj.cos_ = cos(varargin{1});
        obj.sin_ = sin(varargin{1});
      else
        obj.cos_ = varargin{1};
        obj.sin_ = varargin{2};
      end
    end
    

    %> Returns the numerical value \f$\theta\f$ of this quantum angle.
    function theta = theta(obj)
      theta = atan2(obj.sin_, obj.cos_);
    end
    
    %> Returns the cosine \f$\cos(\theta)\f$ of this quantum angle.
    function cos = cos(obj)
      cos = obj.cos_;
    end
    
    %> Returns the sine \f$\sin(\theta)\f$ of this quantum angle.
    function sin = sin(obj)
      sin = obj.sin_;
    end
    
    % ==========================================================================
    %> @brief Update this quantum angle
    %>
    %> The update function supports 3 ways of updating a quantum angle:
    %> 1. `obj.update(other)` : where other is another quantum angle object, 
    % >    updates cosine and sine of obj to values of other
    %> 2. `obj.update(theta)` : updates cosine and sine based on `theta`
    %> 3. `obj.update(cos, sin)` : updates cosine and sine of obj with `cos`,
    %>     `sin` values
    %>
    %> @param obj QAngle object
    %> @param varargin Variable input argument, being either:
    %>  - QAngle object
    %>  - theta value
    %>  - cos, sin values
    % ==========================================================================
    function update(obj, varargin)
      if nargin == 2
        if isa(varargin{1},'qclab.QAngle')
          obj.cos_ = varargin{1}.cos_;
          obj.sin_ = varargin{1}.sin_;
        else
          obj.cos_ = cos(varargin{1});
          obj.sin_ = sin(varargin{1});
        end
      else
        obj.cos_ = varargin{1};
        obj.sin_ = varargin{2};
      end          
    end
    
    %> @brief Checks if `other` is equal to this quantum angle.
    function [bool] = eq(obj, other)
      bool = ((obj.cos_ == other.cos_) && (obj.sin_ == other.sin_));
    end
    
    %> @brief Checks if `other` is different from this quantum angle.
    function [bool] = ne(obj, other)
      bool = ((obj.cos_ ~= other.cos_) || (obj.sin_ ~= other.sin_));
    end
    
    %> @brief Computes sum of this and `other` quantum angle.
    function [out] = plus(obj, other)
      out = qclab.QAngle(obj.cos_ * other.cos_ - obj.sin_ * other.sin_, ...
                        obj.sin_ * other.cos_ + obj.cos_ * other.sin_);
    end
    
    %> @brief Computes difference of this and `other` quantum angle.
    function [out] = minus(obj, other)
      out = qclab.QAngle(obj.cos_ * other.cos_ + obj.sin_ * other.sin_, ...
                         obj.sin_ * other.cos_ - obj.cos_ * other.sin_);
      
    end
    
    %> @brief Unary minus of this quantum angle
    function [out] = uminus(obj)
      out = qclab.QAngle( obj.cos, -obj.sin ) ;
    end
    
  end
end % class QAngle
