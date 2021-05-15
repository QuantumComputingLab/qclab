%> @file QCircuit.m
%> @brief Implements QCircuit class.
% ==============================================================================
%> @class QCircuit
%> @brief Class for representing a quantum circuit.
%
%> This class stores the gates and sub-circuits of a quantum circuit.
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef QCircuit < qclab.QObject & qclab.QAdjustable
  properties (Access = protected)
    %> Number of qubits of this quantum circuit.
    nbQubits_(1,1)  int32
    %> Gates of this quantum circuit.
    gates_      qclab.QObject
  end
  
  methods
    %> @brief Constructs a quantum circuit with number of  `size`
    function obj = QCircuit( nbQubits )
      assert(qclab.isNonNegInteger(nbQubits)) ;
      obj.nbQubits_ = nbQubits ;
    end
    
    % nbQubits
    function [nbQubits] = nbQubits(obj)
      nbQubits = obj.nbQubits_;
    end
    
    % qubits
    function [qubits] = qubits(obj)
      qubits = 0:obj.nbQubits_-1;
    end
    
    % matrix
    function [mat] = matrix(obj)
      mat = qclab.qId(obj.nbQubits_);
      for i = 1:length(obj.gates_)
        mat = apply(obj.gates_(i), 'R', 'N', obj.nbQubits_, mat) ;
      end
    end
    
    % ==========================================================================
    %> @brief Apply the quantum circuit to a matrix `mat`
    %>
    %> @param obj instance of QCircuit class.
    %> @param side 'L' or 'R' for respectively left or right side of application 
    %>             (in quantum circuit ordering)
    %> @param op 'N', 'T' or 'C' for respectively normal, transpose or conjugate 
    %>           transpose application of QCircuit
    %> @param qsz qubit size of `mat`
    %> @param mat matrix to which QCircuit is applied
    % ==========================================================================
    function [mat] = apply(obj, side, op, qsz, mat)
      assert( qsz >= obj.nbQubits_ );
      if strcmp(side,'L') % left
        assert( size(mat,2) == 2^qsz);
      else % right
        assert( size(mat,1) == 2^qsz);
      end
      % operation
      if strcmp(op, 'N') % normal
        mats = obj.matrix;
      elseif strcmp(op, 'T') % transpose
        mats = obj.matrix.';
      else % conjugate transpose
        mats = obj.matrix';
      end
      % kron(Ileft, mats, Iright)
      if ( qsz == obj.nbQubits_ )
        matn = mats;
      else
        matn = kron(mats, qclab.qId(qsz - obj.nbQubits_)) ;
      end
      if strcmp(side, 'L') % left
        mat = mat * matn ;
      else % right
        mat = matn * mat ;
      end
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      for i= 1:length(obj.gates_)
        [out] = obj.gates_(i).toQASM( fid, offset ) ;
        if ( out ~= 0 ), return; end
      end
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other, 'qclab.QObject')
        bool = isequal( other.matrix, obj.matrix );
      end
    end
    
    %
    % Element Access : 
    %
    
    %> @brief Returns array of handles to the gates of this quantum circuit.
    function [gates] = gatesHandle( obj )
      gates = obj.gates_ ;
    end
    
    %> @brief Returns a copy of the gates of this quantum circuit.
    function [gates] = gatesCopy( obj )
      gates = copy(obj.gates_) ;
    end
    
    %> @brief Returns a handle to the gate at `pos` of this quantum circuit.
    function [gate] = gateHandle(obj, pos )
      assert( qclab.isNonNegInteger( pos ) );
      gate = obj.gates_( pos );
    end
    
    %> @brief Returns a copy of the gate at `pos` of this quantum circuit.
    function [gate] = gateCopy(obj, pos )
      assert( qclab.isNonNegInteger( pos ) );
      gate = copy(obj.gates_( pos ));
    end
    
    %
    % Capacity 
    %
    
    %> @brief Checks if this quantum circuit is empty.
    function [bool] = isempty(obj)
      bool = isempty(obj.gates_);
    end
    
    %> @brief Returns the number of gates in this quantum circuit.
    function [nbGates] = nbGates(obj)
      nbGates = length(obj.gates_);
    end
    
    %
    % Modifiers
    %
    
    %> @brief Clears the gates of this quantum circuit.
    function clear(obj)
      obj.gates_ = qclab.QObject.empty;
    end
    
    %> @brief Inserts gates at positions `pos` in this quantum circuit.
    function insert(obj, pos, gates)
      assert( qclab.isNonNegIntegerArray( pos - 1 ) );
      assert( length(pos) == length(gates) );
      assert( canInsert(gates) );
      newGates(1, length(obj.gates_) + length(obj.gates)) = ...
        qclab.qgates.Identity;
      newGates(pos) = gates;
      newGates(newGates == qclab.qgates.Identity) = obj.gates_ ;
      obj.gates_ = newGates ;
    end
    
    %> @brief Erases the gates at positions `pos` from this quantum circuit.
    function erase(obj, pos)
      assert( qclab.isNonNegIntegerArray( pos - 1 ) ) ;
      assert( max(pos) <= length(obj.gates_) );   
      obj.gates_(pos) = [] ;      
    end
      
    %> @brief Add a gate to the end of this quantum circuit.
    function push_back( obj, gate )
      assert( obj.canInsert( gate ) );
      obj.gates_(end+1) = gate ;
    end
    
    %> @brief Remove the last gate of this quantum circuit.
    function pop_back( obj )
      obj.gates_(end) = [];
    end
    
    %> @brief Checks if the gates in `gates` can be inserted into this quantum circuit.
    function [bool] = canInsert(obj, gates)
      bool = true;
      for i = 1: length(gates)
        qubits = gates(i).qubits;
        if max(qubits) >= obj.nbQubits_ 
          bool = false; 
          return
        end
      end
    end
  end
  
  methods (Static)
    % controlled
    function [bool] = controlled
      bool = false;
    end
    
    % qubit
    function [qubit] = qubit
      qubit = int32(0);
    end
    
    % setQubit
    function setQubit(~)
      assert( false );
    end
    
    % setQubits
    function setQubits(~)
      assert( false );
    end
  end
end % class QCircuit
