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
    %> Qubit offset of this quantum circuit.
    offset_(1,1)  int32
    %> Gates of this quantum circuit.
    gates_      qclab.QObject
  end
  
  methods
    %> @brief Constructs a quantum circuit with `nbQubits` qubits starting at
    %> qubit `offset`. The default value for `offset` is 0.
    function obj = QCircuit( nbQubits, offset )
      if nargin == 1, offset = 0; end
      assert(qclab.isNonNegInteger(nbQubits-1)) ;
      assert(qclab.isNonNegInteger(offset)) ;
      obj.nbQubits_ = nbQubits ;
      obj.offset_ = offset ;
    end
    
    % nbQubits
    function [nbQubits] = nbQubits(obj)
      nbQubits = obj.nbQubits_;
    end
    
    % qubit
    function [qubit] = qubit(obj)
      qubit = obj.offset_;
    end
    
    % qubits
    function [qubits] = qubits(obj)
      qubits = obj.offset_:obj.nbQubits_+obj.offset_-1;
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
    %> @param nbQubits qubit size of `mat`
    %> @param mat matrix to which QCircuit is applied
    %> @param offset offset applied to qubit
    % ==========================================================================
    function [mat] = apply(obj, side, op, nbQubits, mat, offset )
      assert( nbQubits >= obj.nbQubits_ );
      if nargin == 5, offset = 0; end
      if strcmp(op, 'N')
        if strcmp(side,'L') % Left + NoTrans
          for i = length(obj.gates_):-1:1
            mat = apply(obj.gates_(i), side, op, nbQubits, mat, ...
                        obj.offset_ + offset );
          end
        else % Right + NoTrans
          for i = 1:length(obj.gates_)
            mat = apply(obj.gates_(i), side, op, nbQubits, mat, ...
                        obj.offset_ + offset );
          end
        end
      else
        if strcmp(side,'L') % Left + [Conj]Trans
          for i = 1:length(obj.gates_)
            mat = apply(obj.gates_(i), side, op, nbQubits, mat, ...
                        obj.offset_ + offset );
          end
        else % Right + [Conj]Trans
          for i = length(obj.gates_):-1:1
            mat = apply(obj.gates_(i), side, op, nbQubits, mat, ...
                        obj.offset_ + offset );
          end
        end
      end
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      for i = 1:length(obj.gates_)
        [out] = obj.gates_(i).toQASM( fid, obj.offset_ + offset ) ;
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
    
    %> Returns the qubit offset of this quantum circuit.
    function [offset] = offset(obj)
      offset = obj.offset_ ;
    end
    
    %> Sets the qubit offset of this quantum circuit.
    function setOffset(obj, offset)
      assert(qclab.isNonNegInteger(offset));
      obj.offset_ = offset ;
    end
    
    % ctranspose
    function circprime = ctranspose( obj )
      circprime = copy( obj );
      myGates = circprime.gates ;
      nbGates = circprime.nbGates ;
      for i = 1 : nbGates
        circprime.gates_( i ) = ctranspose( myGates( nbGates - i + 1 ) );
      end
    end
    
    %
    % Element Access : 
    %
    
    %> @brief Returns array of handles to the gates of this quantum circuit at
    %> postions `pos`. Default for `pos` is all gates.
    function [gates] = gateHandles( obj, pos )
      if nargin == 1
        gates = obj.gates_ ;
      else
        assert(qclab.isNonNegIntegerArray( pos - 1 ));
        gates = obj.gates_( pos );
      end
    end
    
    %> @brief Returns a copy of the gates of this quantum circuit at positions 
    %> `pos`. Default for `pos` is all gates.
    function [gates] = gates( obj, pos )
      if nargin == 1
        gates = copy(obj.gates_) ;
      else
        assert(qclab.isNonNegIntegerArray( pos - 1 ));
        gates = copy(obj.gates_( pos ));
      end
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
    
    %> @brief Inserts `gates` at unique positions `pos` in this quantum circuit.
    function insert(obj, pos, gates)
      assert( qclab.isNonNegIntegerArray( pos - 1 ) );
      assert( length(pos) == length(gates) );
      assert( obj.canInsert(gates) );
      totalGates =  length(obj.gates_) + length(gates);
      newGates(1,totalGates) = qclab.qgates.Identity; % initialize array
      newGates(pos) = gates;
      j = 1;
      for i = 1:totalGates
        if ~ismember(i, pos) % i not in pos
          newGates(i) = obj.gates_(j);
          j = j + 1;
        end
      end
      obj.gates_ = newGates ;
    end
    
    %> @brief Erases the gates at positions `pos` from this quantum circuit.
    function erase(obj, pos)
      assert( qclab.isNonNegIntegerArray( pos - 1 ) ) ;
      assert( max( pos ) <= obj.nbGates );   
      obj.gates_( pos ) = [] ;      
    end

    %> @brief Replace the gate at position `pos` with `gate`
    function replace( obj, pos, gate )
      assert( qclab.isNonNegInteger( pos - 1 ) );
      assert( pos <= obj.nbGates );
      assert( length(gate) == 1 );
      assert( obj.canInsert( gate ) );
      obj.gates_( pos ) = gate ;
    end
      
    %> @brief Add a gate to the end of this quantum circuit.
    function push_back( obj, gate )
      assert( obj.canInsert( gate ) && isscalar( gate ) );
      obj.gates_(end+1) = gate ;
    end
    
    %> @brief Remove the last gate of this quantum circuit.
    function pop_back( obj )
      obj.gates_(end) = [];
    end
    
    %> @brief Checks if the gates in `gates` can be inserted into this quantum 
    %> circuit.
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
    
    % ==========================================================================
    %> @brief Draw a quantum circuit.
    %>
    %> @param obj quantum circuit object.
    %> @param fid  file id to draw to:
    %>              - 0  : return cell array with ascii characters as `out`
    %>              - 1  : draw to command window (default)
    %>              - >1 : draw to (open) file id
    %> @param parameter 'N' don't print parameter (default), 'S' print short 
    %>                  parameter, 'L' print long parameter.
    %> @param offset offset applied to qubit
    %>
    %> @retval out if fid > 0 then out == 0 on succesfull completion, otherwise
    %>             out contains a cell array with the drawing info.
    % ==========================================================================
    function [out] = draw(obj, fid, parameter, offset)
      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      qclab.drawCommands ; % load draw commands
      
      circuitCell = cell(3*obj.nbQubits,1); % cell array to store all strings
      circuitCell(:) = {''};
      charIndex = ones(obj.nbQubits, 1);    % most right character index for  
                                            % every qubit                                                                   
                                                                                      
      for i = 1:obj.nbGates
        
        % Get the qubits and draw strings for the current gate
        thisQubits = obj.gates_( i ).qubits ;
        thisQubits = min(thisQubits):max(thisQubits);
        thisGateCell = obj.gates_( i ).draw( 0, parameter, 0 );
        
        % left-most character thisGateCell can be drawn on
        thisChar = max( charIndex( thisQubits + 1 ) ); 
        
        % fill up other qubits to thisChar index if required
        for q = thisQubits
          diffChar = thisChar - charIndex( q + 1 );
          if diffChar > 0
            circuitCell{ 3*q + 1 } = strcat( circuitCell{ 3*q + 1 }, ...
                                       repmat( space, 1, diffChar ) );
            circuitCell{ 3*q + 2 } = strcat( circuitCell{ 3*q + 2 }, ...
                                       repmat( h, 1, diffChar ) );
            circuitCell{ 3*q + 3 } = strcat( circuitCell{ 3*q + 3 }, ...
                                       repmat( space, 1, diffChar ) );
            % update charIndex on q + 1
            charIndex( q + 1 ) = charIndex( q + 1)  + diffChar ; 
          end
        end
        
        % add thisGateCell to circuitCell
        for q = thisQubits
          thisq = q - thisQubits(1);
          circuitCell{ 3*q + 1 }  = strcat( circuitCell{ 3*q + 1}, ...
                                            thisGateCell{ 3*thisq + 1 } );
          circuitCell{ 3*q + 2 }  = strcat( circuitCell{ 3*q + 2}, ...
                                            thisGateCell{ 3*thisq + 2 } );
          circuitCell{ 3*q + 3 }  = strcat( circuitCell{ 3*q + 3 }, ...
                                            thisGateCell{ 3*thisq + 3 } );
        end
        
        % update the charIndex on thisQubits
        thisWidth = count( thisGateCell{1}, '\x' ); % charwidth of thisGate
        charIndex( thisQubits + 1 ) = charIndex( thisQubits + 1 ) + thisWidth;
                                 
      end % all gates added to circuitCell --
      
      % fill all qubits to same maxChar to complete circuit
      maxChar = max( charIndex );
      for q = 0:obj.nbQubits_ - 1
        diffChar = maxChar - charIndex( q + 1 );
        if diffChar > 0
            circuitCell{ 3*q + 1 } = strcat( circuitCell{ 3*q + 1 }, ...
                                             repmat( space, 1, diffChar ) );
            circuitCell{ 3*q + 2 } = strcat( circuitCell{ 3*q + 2 }, ...
                                             repmat( h, 1, diffChar ) );
            circuitCell{ 3*q + 3 } = strcat( circuitCell{ 3*q + 3 }, ...
                                             repmat( space, 1, diffChar ) );
        end
      end
      
      if fid > 0
        qclab.drawCellArray( fid, circuitCell, obj.qubits + offset );
        out = 0;
      else
        out = circuitCell ;
      end
        
    end
    
    % ==========================================================================
    %> @brief Save a quantum circuit to a TeX file.
    %>
    %> @param obj quantum circuit object.
    %> @param fid  file id to draw to:
    %>              - 0  : return cell array with ascii characters as `out`
    %>              - 1  : draw to command window (default)
    %>              - >1 : draw to (open) file id
    %> @param parameter 'N' don't print parameter (default), 'S' print short 
    %>                  parameter, 'L' print long parameter.
    %> @param offset offset applied to qubit
    %>
    %> @retval out if fid > 0 then out == 0 on succesfull completion, otherwise
    %>             out contains a cell array with the drawing info.
    % ==========================================================================
    function [out] = toTex(obj, fid, parameter, offset)
      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      circuitCell = cell(obj.nbQubits,1); % cell array to store all strings
      circuitCell(:) = {''};
      tabIndex = ones(obj.nbQubits, 1);    % most right tab index for  
                                           % every qubit
                                           
      for i = 1:obj.nbGates
        % Get the qubits and TeX strings for the current gate
        thisQubits = obj.gates_( i ).qubits ;
        thisQubits = min(thisQubits):max(thisQubits);
        thisGateCell = obj.gates_( i ).toTex( 0, parameter, 0 );
        
        % left-most character thisGateCell can be drawn on
        thisTab = max( tabIndex( thisQubits + 1 ) ); 
        
         % fill up other qubits to thisTab index if required
        for q = thisQubits
          diffTab = thisTab - tabIndex( q + 1 );
          if diffTab > 0
            circuitCell{ q + 1 } = strcat( circuitCell{ q + 1 }, ...
                                           repmat( '&\t\\qw\t', 1, diffTab ) );
            % update charIndex on q + 1
            tabIndex( q + 1 ) = tabIndex( q + 1 )  + diffTab ; 
          end
        end
        
        % add thisGateCell to circuitCell
        for q = thisQubits
          thisq = q - thisQubits(1);
          circuitCell{ q + 1 }  = strcat( circuitCell{ q + 1 }, ...
                                            thisGateCell{ thisq + 1 } );
        end
        
        % update tabIndex
        thisWidth = count(thisGateCell{1},'&');
        tabIndex( thisQubits + 1 ) = tabIndex( thisQubits + 1 ) + thisWidth;
      end % all gates added to circuitCell --
      
      % fill all qubits to same maxTab to complete circuit
      maxTab = max( tabIndex );
      for q = 0:obj.nbQubits_ - 1
        diffTab = maxTab - tabIndex( q + 1 );
        if diffTab > 0
            circuitCell{ q + 1 } = strcat( circuitCell{ q + 1 }, ...
                                           repmat( '&\t\\qw\t', 1, diffTab ) );
        end
      end
      
       if fid > 0
        qclab.toTexCellArray( fid, circuitCell, obj.qubits + offset );
        out = 0;
      else
        out = circuitCell ;
      end
    end
  end
  
  methods (Static)
    % controlled
    function [bool] = controlled
      bool = false;
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
  
  methods ( Access = protected )
    
    %> @brief Override copyElement function to allow for correct deep copy of
    %> handles.
    function cp = copyElement(obj)
      cp = copyElement@matlab.mixin.Copyable( obj );
      cp.gates_ = obj.gates() ;
    end
    
  end
end % class QCircuit
