%> @file HandleGate1.m
%> @brief Implements HandleGate1 class
% ==============================================================================
%> @class HandleGate1
%> @brief 1-qubit gate storing a handle to another 1-qubit gate.
%
%> 
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef HandleGate1 < qclab.qgates.QGate1
  properties (Access = protected)
    %> Qubit offset of this 1-qubit handle gate.
    offset_(1,1) int32
    %> Gate handle of this 1-qubit handle gate.
    gate_(1,1) qclab.qgates.QGate1 = qclab.qgates.Identity
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Constructor for HandleGate1 objects
    %>
    %> Constructs a 1-qubit handle gate from the given gate handle `gate`
    %> and qubit offset `offset`. The default value of `offset` is 0.
    % ==========================================================================
    function [obj] = HandleGate1( gate, offset )
      if nargin == 1, offset = 0; end
      obj.offset_ = offset;
      obj.gate_ = gate;
    end
    
    % fixed
    function [bool] = fixed(obj)
      bool = obj.gate_.fixed ;
    end
    
    % qubit
    function [qubit] = qubit(obj)
      qubit = obj.gate_.qubit + obj.offset_ ;
    end
    
    % setQubit
    function setQubit(~, ~)
      assert( false );
    end
    
    % qubits
    function [qubits] = qubits(obj)
      qubits = [obj.qubit];
    end
    
    % setQubits
    function setQubits(~, ~)
      assert( false );
    end
    
    % matrix
    function [mat] = matrix(obj)
      mat = obj.gate_.matrix ;
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end        
      out = obj.gate_.toQASM( fid, obj.offset_ + offset );
    end
    
    % equals
    function [bool] = equals(obj, other)
      if isa(other, 'qclab.qgates.HandleGate1')
        bool = (other.gate_ == obj.gate_);
      else
        bool = (other == obj.gate_ );
      end
    end
    
    % ctranspose
    function [objprime] = ctranspose( obj )
      objprime = ctranspose@qclab.qgates.QGate1( obj );
      objprime.setGate( ctranspose( obj.gate_ ) );
    end
    
    % draw
    function [out] = draw(obj, fid, parameter, offset)
      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      out = obj.gate_.draw(fid, parameter, obj.offset_ + offset );
    end
    
    % toTex
    function [out] = toTex(obj, fid, parameter, offset)
      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      out = obj.gate_.toTex(fid, parameter, obj.offset_ + offset );
    end
    
    %> @brief Returns the qubit offset of this 1-qubit handle gate.
    function [offset] = offset(obj)
      offset = obj.offset_ ;
    end
    
    %> @brief Sets the qubit offset of this 1-qubit handle gate.
    function setOffset(obj, offset)
      obj.offset_ = offset ;
    end
    
    %> @brief Returns a handle to the gate of this 1-qubit handle gate.
    function [gate] = gateHandle(obj)
      gate = obj.gate_ ;
    end
    
    %> @brief Returns a copy of the gate of this 1-qubit handle gate.
    function [gate] = gate(obj)
      gate = copy(obj.gate_) ;
    end
    
    %> @brief Sets `gate` as the new handle
    function setGate(obj, gate)
      obj.gate_ = gate;
    end
    
  end
  
  methods ( Access = protected )
    
    %> @brief Override copyElement function to allow for correct deep copy of
    %> handle property.
    function cp = copyElement(obj)
      cp = copyElement@matlab.mixin.Copyable( obj );
      cp.gate_ = obj.gate() ;
    end
    
  end
  
end %HandleGate1
