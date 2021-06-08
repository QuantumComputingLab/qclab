%> @file QAdjustable.m
%> @brief Implements QAdjustable class.
% ==============================================================================
%> @class QAdjustable
%> @brief Class for representing an adjustable quantum object.
%
%> 
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef QAdjustable < handle & ...
                       matlab.mixin.Copyable
                     
  properties (Access = private)
    fixed_ logical
  end
  
  methods
    % ==========================================================================
    %> @brief Constructs a quantum adjustable object with the given flag `fixed`.
    %>
    %> @param fixed logical true or false (default) for QAdjustable object.
    % ==========================================================================
    function obj = QAdjustable(fixed)
      if nargin < 1, fixed = false ; end
      obj.fixed_ = fixed ;
    end
    
    %> @brief Checks if this quantum adjustable object is fixed.
    function [bool] = fixed(obj)
      bool = obj.fixed_ ;
    end
    
    %> @brief Checks if this quantum adjustable object is variable.
    function [bool] = variable(obj)
      bool = ~obj.fixed_ ;
    end
    
    %> @brief Makes this quantum adjustable object fixed.
    function makeFixed(obj)
      obj.fixed_ = true ;
    end
    
    %> @brief Makes this quantum adjustable object variable.
    function makeVariable(obj)
      obj.fixed_ = false;
    end
  end
end % class QAdjustable
