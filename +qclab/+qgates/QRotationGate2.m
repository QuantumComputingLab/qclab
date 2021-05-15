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
    
    %> @brief Checks if `other` is equal to this QRotationGate2.
    function [bool] = eq(obj,other)
      bool = obj.equals(other);
    end
    
    %> @brief Checks if `other` is different from this QRotationGate2.
    function [bool] = ne(obj,other)
      bool = ~eq(obj,other);
    end
    
  end
  
  methods (Static)
    
    % controlled
    function [bool] = controlled
      bool = false;
    end
    
  end
                        
end % QRotationGate2
