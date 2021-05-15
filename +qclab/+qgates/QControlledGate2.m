%> @file QControlledGate2.m
%> @brief Implements QControlledGate2 class
% ==============================================================================
%> @class QControlledGate2
%> @brief Base class for 2-qubit gates of controlled 1-qubit gates.
%
%> 
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef QControlledGate2 < qclab.qgates.QGate2
  properties (Access = protected)
    %> Control qubit of this 2-qubit gate.
    control_(1,1) int32
    %> Control state of this 2-qubit gate.
    controlState_(1,1) int32
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Constructor for  2-qubit gates of controlled 1-qubit gates.
    %>
    %> Constructs a 2-qubit gate with the given control qubit `qubit` on the 
    %> control state `controlState`. The default control state is 1.
    %>
    %> @param control control qubit index
    %> @param controlState (optional) control state for controlled gate: 0 or 1
    % ==========================================================================
    function obj = QControlledGate2(control, controlState)
      if nargin < 2, controlState = 1; end
      
      obj.control_ = control ;
      obj.controlState_ = controlState;
      
      assert( qclab.isNonNegInteger(control) ); 
      assert((controlState == 0) || (controlState == 1)) ;
    end
    
    % qubit
    function [qubit] = qubit(obj)
      qubit = min(obj.control_, obj.target) ;
    end
    
    % qubits
    function [qubits] = qubits(obj)
      qubits = sort([obj.control_, obj.target]);
    end
    
    % setQubits
    function setQubits(obj, qubits)
      assert( qclab.isNonNegIntegerArray(qubits) ) ;
      assert( qubits(1) ~= qubits(2) ) ;
      obj.control_ = qubits(1) ;
      obj.setTarget( qubits(2) ) ;
    end
    
    % matrix
    function [mat] = matrix(obj)
      E0 = [1 0; 0 0]; E1 = [0 0; 0 1];
      I1 = qclab.qId(1);
      CG = obj.gateCopy.matrix;
      if ( obj.controlState_ == 0 )
        if (obj.control_ < obj.target)
          mat = kron(E0, CG) + kron(E1, I1);
        else
          mat = kron(CG, E0) + kron(I1, E1);
        end
      else
        if (obj.control_ < obj.target)
          mat = kron(E0, I1) + kron(E1, CG);
        else
          mat = kron(I1, E0) + kron(CG, E1);
        end
      end
    end
    
    % ==========================================================================
    %> @brief Apply the QControlledGate2 to a matrix `mat`
    %>
    %> @param obj instance of QControlledGate2 class.
    %> @param side 'L' or 'R' for respectively left or right side of application
    %>              (in quantum circuit ordering)
    %> @param op 'N', 'T' or 'C' for respectively normal, transpose or conjugate
    %>           transpose application of QControlledGate2
    %> @param qsz qubit size of `mat`
    %> @param mat matrix to which QControlledGate2 is applied
    % ==========================================================================
    function [mat] = apply(obj, side, op, qsz, mat)
      assert( qsz >= 2 );
      if strcmp(side,'L')
        assert( size(mat,2) == 2^qsz );
      else
        assert( size(mat,1) == 2^qsz );
      end
      qubits = obj.qubits;
      assert( qubits(1) < qsz ); assert( qubits(2) < qsz );
      % nearest neighbor qubits
      if qubits(1) + 1 == qubits(2) 
        mat = apply@qclab.qgates.QGate2( obj, side, op, qsz, mat );
        return
      end
      E0 = [1 0; 0 0]; E1 = [0 0; 0 1];
      I1 = qclab.qId(1);
      % operation
      if strcmp(op, 'N') % normal
        mat1 = obj.gateCopy.matrix;
      elseif strcmp(op, 'T') % transpose
        mat1 = obj.gateCopy.matrix.';
      else % conjugate transpose
        mat1 = obj.gateCopy.matrix';
      end
      % linear combination of Kronecker products
      s = qubits(2) - qubits(1) + 1;
      Imid =  qclab.qId(s-2);
      if obj.controlState_ == 0
        if (obj.control_ < obj.target)
          mats = kron(kron(E0, Imid), mat1) + kron(kron(E1, Imid), I1) ;
        else
          mats = kron(kron(mat1, Imid), E0) + kron(kron(I1, Imid), E1) ;
        end
      else
        if (obj.control_ < obj.target)
          mats = kron(kron(E0, Imid), I1) + kron(kron(E1, Imid), mat1) ;
        else
          mats = kron(kron(I1, Imid), E0) + kron(kron(mat1, Imid), E1) ;
        end
      end
      % kron(Ileft, mats, Iright)
      if ( qubits(1) == 0 && qubits(2) == qsz - 1)
        matn = mats;
      elseif ( qubits(1) == 0 )
        matn = kron(mats, qclab.qId(qsz - s));
      elseif ( qubits(2) == qsz - 1 )
        matn = kron(qclab.qId(qsz - s), mats);
      else
        matn = kron(kron(qclab.qId(qubits(1)),mats),qclab.qId(qsz - qubits(2) - 1));
      end
      % side
      if strcmp(side, 'L') % left
        mat = mat * matn ;
      else % right
        mat = matn * mat ;
      end
    end
    
    %> @brief Returns the control qubit of this 2-qubit gate.
    function [control] = control(obj)
      control = obj.control_ ;
    end
    
    %> @brief Returns the control state of this 2-qubit gate.
    function [controlState] = controlState(obj)
      controlState = obj.controlState_ ;
    end
    
    %> @brief Sets the control of this controlled gate to the given `control`.
    function setControl(obj, control )
      assert( qclab.isNonNegInteger(control) ) ; 
      assert( control ~= obj.target() ) ;
      obj.control_ = control ;
    end
    
    %> @brief Sets the control state of this controlled gate to `controlState`.
    function setControlState(obj, controlState)
      assert( (controlState == 0) || (controlState == 1)) ;
      obj.controlState_ = controlState ;
    end
    
  end
  
  methods (Static) 
    % controlled
    function [bool] = controlled
      bool = true;
    end
  end
  
  methods (Abstract)
    %> @brief Returns a copy of the controlled 1-qubit gate of this 2-qubit gate.
    [gate] = gateCopy(obj)
    %> @brief Returns the target qubit of this 2-qubit gate.
    [target] = target(obj) ;
    %> @brief Sets the target of this controlled gate to the given `target`.
    setTarget(obj, target) ;
  end
end
