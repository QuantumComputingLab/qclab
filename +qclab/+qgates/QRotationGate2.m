%> @file QRotationGate2.m
%> @brief Implements QRotationGate2 class.
% ==============================================================================
%> @class QRotationGate2
%> @brief Base class for 2-qubit rotation gates.
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef QRotationGate2 < qclab.qgates.QGate2 & ...
                          qclab.QRotation
                        
  properties (Access = protected)
    %> Qubits of this 2-qubit rotation gate
    qubits_(1,2) int32
  end
  methods
    
    % Class constructor  =======================================================
    %> @brief Constructor for 2-qubit quantum rotation gates
    %>
    %> Calls constructor from:
    %> - qclab.QRotation
    %> 
    %> The QRotationGate2 constructor supports 6 ways of constructing a 2-qubit
    %> quantum rotation gate:
    %>
    %> 1. QRotationGate2() : Rotation gate with `qubits` set to [0, 1] and 
    %>    \f$\theta = 0\f$.
    %>
    %> 2. QRotationGate2(qubits) : Rotation gate with `qubits` set to `qubits` 
    %>    and \f$\theta = 0\f$.
    %>
    %> 3. QRotationGate2(qubits, angle, fixed) : Rotation gate with `qubits` set
    %>    to `qubits` and with the given quantum angle `angle` and the 
    %>    flag `fixed`. The default of `fixed` is false.
    %>
    %> 4. QRotationGate2(qubits, rotation, fixed) : Rotation gate with `qubits`
    %>    set to `qubits` and with the given quantum rotation `rotation` and the 
    %>    flag `fixed`. The default of `fixed` is false.
    %>
    %> 5. QRotationGate2(qubits, theta, fixed) : Rotation gate with `qubits` set 
    %>    to `qubits` and with the given quantum angle `angle` = \f$\theta/2\f$
    %>    and the flag `fixed`. The default of `fixed` is false.
    %>
    %> 6. QRotationGate2(qubits, cos, sin, fixed) : Rotation gate with `qubits`
    %>    set to `qubits` and with the given values `cos` = \f$\cos(\theta/2)\f$ 
    %>    and `sin` = \f$\sin(\theta/2)\f$ and the flag `fixed`. The default of 
    %>     `fixed` is false.
    %>
    %> If `fixed` is provided, it must be of `logical` type.
    %>
    %> @param qubits Qubits input argument.
    %> @param varargin Variable input argument, being either:
    %>  - empty
    %>  - angle, (fixed)
    %>  - rotation, fixed
    %>  - theta, (fixed)
    %>  - cos, sin, (fixed)
    % ==========================================================================
    function obj = QRotationGate2(qubits, varargin)
      if nargin == 0
        qubits = [0, 1];
      end
      if nargin < 2
        varargin = {};
      end
      obj@qclab.QRotation( varargin{:} );
      obj.setQubits( qubits );
    end
    
    % qubit
    function [qubit] = qubit(obj)
      qubit = obj.qubits_(1);
    end
    
    % qubits
    function [qubits] = qubits(obj)
      qubits = obj.qubits_ ;
    end
    
    % setQubits
    function setQubits(obj, qubits)
      assert(qclab.isNonNegIntegerArray(qubits));
      assert(qubits(1) ~= qubits(2));
      obj.qubits_ = sort(qubits(1:2)) ;
    end
    
    % equals
    function [bool] = equals(obj,other)
      bool = false;
      if obj.equalType(other)
        bool = (obj.angle_ == other.angle_) ;
      end
    end
    
    %> @brief Checks if `other` is equal to this QRotationGate2.
    function [bool] = eq(obj,other)
      bool = obj.equals(other);
    end
    
    %> @brief Checks if `other` is different from this QRotationGate2.
    function [bool] = ne(obj,other)
      bool = ~obj.equals(other);
    end
    
    %> @brief Multiplication of two QRotationGate1 objects of equal type
    %> on same qubits:  -[ out ]- = -[ obj ]--[ other ]-
    function [out] = mtimes(obj,other)
      assert( isequal(obj.qubits, other.qubits) );
      out = mtimes@qclab.QRotation(obj, other) ;
    end
    
    %> @brief Right division of two QRotationGate1 objects of equal type
    %> on same qubits: -[ out ]- = -[ obj ]--[ other ]'-
    function [out] = mrdivide(obj,other)
      assert( isequal(obj.qubits, other.qubits) );
      out = mrdivide@qclab.QRotation(obj, other) ;
    end
    
    %> @brief Left division of two QRotationGate1 objects of equal type
    %> on same qubits: -[ out ]- = -[ obj ]'--[ other ]-
    function [out] = mldivide(obj,other)
      assert( isequal(obj.qubits, other.qubits) );
      out = mldivide@qclab.QRotation(obj, other) ;
    end
    
  end
  
  methods (Static)
    
    % controlled
    function [bool] = controlled
      bool = false;
    end
    
  end
  
  methods (Abstract)
    
    %> checks if other is of the same type as this
    [bool] = equalType(obj, other)
    
  end
                        
end % QRotationGate2
