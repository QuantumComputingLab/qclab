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
    %> @brief Constructor for 1-qubit quantum rotation gates
    %>
    %> Calls constructors from:
    %> - qclab.qgates.QGate1
    %> - qclab.QRotation
    %> 
    %> The QRotationGate1 constructor supports 6 ways of constructing a 1-qubit
    %> quantum rotation gate:
    %>
    %> 1. QRotationGate1() : Rotation gate with `qubit` set to 0 and 
    %>    \f$\theta = 0\f$.
    %>
    %> 2. QRotationGate1(qubit) : Rotation gate with `qubit` set to `qubit` and 
    %>    \f$\theta = 0\f$.
    %>
    %> 3. QRotationGate1(qubit, angle, fixed) : Rotation gate with `qubit` set
    %>    to `qubit` and with the given quantum angle `angle` and the 
    %>    flag `fixed`. The default of `fixed` is false.
    %>
    %> 4. QRotationGate1(qubit, rotation, fixed) : Rotation gate with `qubit` set
    %>    to `qubit` and with the given quantum rotation `rotation` and the 
    %>    flag `fixed`. The default of `fixed` is false.
    %>
    %> 5. QRotationGate1(qubit, theta, fixed) : Rotation gate with `qubit` set 
    %>    to `qubit` and with the given quantum angle `angle` = \f$\theta/2\f$
    %>    and the flag `fixed`. The default of `fixed` is false.
    %>
    %> 6. QRotationGate1(qubit, cos, sin, fixed) : Rotation gate with `qubit`
    %>    set to `qubit` and with the given values `cos` = \f$\cos(\theta/2)\f$ 
    %>    and `sin` = \f$\sin(\theta/2)\f$ and the flag `fixed`. The default of 
    %>     `fixed` is false.
    %>
    %> If `fixed` is provided, it must be of `logical` type.
    %>
    %> @param qubit Qubit input argument.
    %> @param varargin Variable input argument, being either:
    %>  - empty
    %>  - angle, (fixed)
    %>  - rotation, fixed
    %>  - theta, (fixed)
    %>  - cos, sin, (fixed)
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
    
    % equals
    function [bool] = equals(obj,other)
      bool = false;
      if obj.equalType(other)
        bool = (obj.angle_ == other.angle_) ;
      end
    end
    
    %> @brief Checks if `other` is equal to this QRotationGate1.
    function [bool] = eq(obj,other)
      bool = obj.equals(other);
    end
    
    %> @brief Checks if `other` is different from this QRotationGate1.
    function [bool] = ne(obj,other)
      bool = ~obj.equals(other);
    end
    
    %> @brief Multiplication of two QRotationGate1 objects of equal type
    %> on same qubits: -[ out ]- = -[ obj ]--[ other ]-
    function [out] = mtimes(obj,other)
      assert( obj.equalType(other) && obj.qubit == other.qubit );
      out = mtimes@qclab.QRotation(obj, other) ;
    end
    
    %> @brief Right division of two QRotationGate1 objects of equal type
    %> on same qubits: -[ out ]- = -[ obj ]--[ other ]'-
    function [out] = mrdivide(obj,other)
      assert( obj.equalType(other) && obj.qubit == other.qubit );
      out = mrdivide@qclab.QRotation(obj, other) ;
    end
    
    %> @brief Left division of two QRotationGate1 objects of equal type
    %> on same qubits: -[ out ]- = -[ obj ]'--[ other ]-
    function [out] = mldivide(obj,other)
      assert( obj.equalType(other) && obj.qubit == other.qubit );
      out = mldivide@qclab.QRotation(obj, other) ;
    end
    
  end
  
  methods (Abstract)
    
    %> checks if other is of the same type as this
    [bool] = equalType(obj, other)
    
  end
  
end % QRotationGate1
