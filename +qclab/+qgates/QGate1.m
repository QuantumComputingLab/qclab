%> @file QGate1.m
%> @brief Implements QGate1 class
% ==============================================================================
%> @class QGate1
%> @brief Base class for 1-qubit gates.
%
%>  This class implements functionalities that are shared between different
%>  types of 1-qubit gates.
%> 
%>  Abstract base class for 1-qubit gates.
%>  Concrete subclasses have to implement:
%>  - equals      % defined in qclab.QObject
%>  - toQASM      % defined in qclab.QObject
%>  - matrix      % defined in qclab.QObject
%>  - fixed       % defined in qclab.QObject
%> 
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef QGate1 < qclab.QObject
  properties (Access = protected)
    %> Qubit of this 1-qubit gate.
    qubit_(1,1)  int32
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Constructor for 1-qubit quantum gate objects
    %>
    %> The QGate1 constructor can be used in two ways:
    %> 
    %> 1. `QGate1()` : default constructor, sets to qubit_ to 0.
    %> 2. `QGate1(qubit)` : sets the qubit_ to qubit.
    % ==========================================================================
    function obj = QGate1(qubit)
      if nargin == 0, qubit = 0; end
      assert( qclab.isNonNegInteger( qubit ) ) ;
      obj.qubit_ = qubit ;
    end
    
    % qubit
    function [qubit] = qubit(obj)
      qubit = obj.qubit_;
    end
    
    % setQubit
    function setQubit(obj,qubit)
      assert( qclab.isNonNegInteger( qubit ) );
      
      obj.qubit_ = qubit ;
    end
    
    % qubits
    function [qubits] = qubits(obj)
      qubits = [obj.qubit_];
    end
    
    % setQubits
    function setQubits(obj,qubits)
      assert(qclab.isNonNegInteger( qubits(1) ) );
      obj.qubit_ = qubits(1) ;
    end
    
    % ==========================================================================
    %> @brief Apply the QGate1 to a matrix
    %>
    %> @param obj instance of QGate1 class.
    %> @param side 'L' or 'R' side application in quantum circuit
    %> @param op 'N', 'T' or 'C' for normal, transpose or conjugate transpose
    %>           application of QGate1
    %> @param qsz qubit size of system
    %> @param mat matrix to which QGate1 is applied
    % ==========================================================================
    function [mat] = apply(obj, side, op, qsz, mat)
      assert( qsz >= 1);
      if strcmp(side,'L') % left
        assert( size(mat,2) == 2^qsz);
      else % right
        assert( size(mat,1) == 2^qsz);
      end
      % operation
      if strcmp(op, 'N') % normal
        mat1 = obj.matrix;
      elseif strcmp(op, 'T') % transpose
        mat1 = obj.matrix.';
      else % conjugate transpose
        mat1 = obj.matrix';
      end
      % kron(Ileft, mat1, Iright)  
      if (qsz == 1)
        matn = mat1 ;
      elseif ( obj.qubit_ == 0 )
        matn = kron(mat1, qclab.qId(qsz-1)) ;
      elseif ( obj.qubit_ == qsz-1)
        matn = kron(qclab.qId(qsz-1), mat1);
      else
        matn = kron(kron(qclab.qId(obj.qubit_), mat1), qclab.qId(qsz-obj.qubit_-1)) ;
      end
      % side
      if strcmp(side, 'L') % left
        mat = mat * matn ;
      else % right
        mat = matn * mat ;
      end
    end
    
  end
  
  methods (Static)
    % nbQubits
    function [nQ] = nbQubits
      nQ = int32(1);
    end
    
     % controlled
    function [bool] = controlled
      bool = false;
    end
  end
   
end % class QGate1
