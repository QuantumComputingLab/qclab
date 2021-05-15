%> @file QRotationGate1.m
%> @brief Implements QRotationGate1 class.
% ==============================================================================
%> @class QRotationGate1
%> @brief Base class for 1-qubit rotation gates.
%>
%> Abstract base class for 1-qubit rotation gates.
%> Concrete subclasses have to implement:
%> - equals       % defined in qclab.QObject
%> - toQASM       % defined in qclab.QObject
%> - matrix       % defined in qclab.QObject
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef QRotationGate1 < qclab.qgates.QGate1 & ...
                          qclab.QRotation

  methods
    % Class constructor  =======================================================
    %> @brief Constructor for quantum rotations
    %>
    %> Calls constructors from:
    %> - qclab.qgates.QGate1
    %> - qclab.QRotation
    % ==========================================================================
    function obj = QRotationGate1(qubit, varargin)
      if nargin == 0
        qubit = 0;
      end
      if nargin < 2
        varargin = {};
      end
      obj@qclab.qgates.QGate1( qubit );
      obj@qclab.QRotation( varargin{:} );
    end
    
    %> @brief Checks if `other` is equal to this QRotationGate1.
    function [bool] = eq(obj,other)
      bool = obj.equals(other);
    end
    
    %> @brief Checks if `other` is different from this QRotationGate1.
    function [bool] = ne(obj,other)
      bool = ~eq(obj,other);
    end
    
  end
end % QRotationGate1
