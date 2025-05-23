% QCircuit - stores objects of a quantum circuit
% QCircuit is a class to store and modify the objects of a quantum circuit.
%
% Creation
%   Syntax
%     obj = qclab.QCircuit( nbQubits )
%     obj = qclab.QCircuit( nbQubits, offset )
%
%   Input Arguments
%     nbQubits - number of qubits (positive integer)
%     offset   - (optional) offset of the quantum circuit
%                (default: 0)
%
%   Output:
%     obj - A quantum object of type `QCircuit`.
%
%   Example:
%   Create an empty quantum circuit with 3 qubits:
%     circuit = qclab.QCircuit(3);
%
% Object Functions
%   <a href="matlab:help qclab.QCircuit.draw">draw</a>            - Draw the quantum circuit in the command window.
%   <a href="matlab:help qclab.QCircuit.toTex">toTex</a>           - Save the quantum circuit to a TeX file.
%   <a href="matlab:help qclab.QCircuit.push_back">push_back</a>       - Add an object to the end of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.nbQubits">nbQubits</a>        - Return the number of qubits of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.qubit">qubit</a>           - Return the first qubit of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.qubits">qubits</a>          - Return the qubits of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.ctranspose">ctranspose</a>      - Return conjugate transpose of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.block">block</a>           - Return the block drawing property of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.asBlock">asBlock</a>         - Set block drawing property of this quantum circuit to true.
%   <a href="matlab:help qclab.QCircuit.unBlock">unBlock</a>         - Set block drawing property of this quantum circuit to false.
%   <a href="matlab:help qclab.QCircuit.toQASM">toQASM</a>          - Writes the QASM code of this quantum circuit to a given file id.
%   <a href="matlab:help qclab.QCircuit.apply">apply</a>           - Applies this quantum circuit to a given input.
%   <a href="matlab:help qclab.QCircuit.simulate">simulate</a>        - Simulate this quantum circuit by applying it to a vector.
%   <a href="matlab:help qclab.QCircuit.measurements">measurements</a>    - Return the measurements of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.matrix">matrix</a>          - Return the unitary matrix corresponding to this quantum object.
%   <a href="matlab:help qclab.QCircuit.equals">equals</a>          - Checks if this quantum circuit is equal to another quantum object.
%   <a href="matlab:help qclab.QCircuit.offset">offset</a>          - Return the offset of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.setOffset">setOffset</a>       - Set the offset of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.objectHandles">objectHandles</a>   - Return array of handles of the objects of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.objects">objects</a>         - Return a copy of the objects of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.objectsFlattend">objectsFlattend</a> - Return a copy of the objects of this quantum circuit where subcircuits are resolved.
%   <a href="matlab:help qclab.QCircuit.isempty">isempty</a>         - Check if this quantum circuit is empty.
%   <a href="matlab:help qclab.QCircuit.nbObjects">nbObjects</a>       - Return the number of objects in this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.clear">clear</a>           - Clear the objects of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.insert">insert</a>          - Insert objects to unique positions in this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.erase">erase</a>           - Erases objects at a certain position from this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.replace">replace</a>         - Replace the object at a certain position with an object.
%   <a href="matlab:help qclab.QCircuit.barrier">barrier</a>         - Add a barrier over all qubits to the end of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.pop_back">pop_back</a>        - Remove the last object of this quantum circuit.
%   <a href="matlab:help qclab.QCircuit.canInsert">canInsert</a>       - Check if objects can be inserted into this quantum circuit.

%> @file QCircuit.m
%> @brief Implements QCircuit class.
% ==============================================================================
%> @class QCircuit
%> @brief Class for representing a quantum circuit.
%
%> This class stores the objects of a quantum circuit.
%
% (C) Copyright Daan Camps, Sophia Keip and Roel Van Beeumen 2025.
% ==============================================================================
classdef QCircuit < qclab.QObject & qclab.QAdjustable
  properties (Access = protected)
    %> Number of qubits of this quantum circuit.
    nbQubits_(1,1)  int64
    %> Qubit offset of this quantum circuit.
    offset_(1,1)  int64
    %> Objects of this quantum circuit.
    objects_  qclab.QObject
    %> Draw property of this quantum circuit.
    block_ logical = false
    %> Label of this quantum circuit.
    label_ char = ''
    %> Number of measurement in the circuit.
    nbMeasurements_(1,1) int64
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
      % nbQubits - Return the number of qubits in the quantum circuit.
      %
      % Syntax:
      %   qubits = obj.nbQubits()
      %
      % Outputs:
      %   qubits - Number of qubits in the circuit (int64).
      nbQubits = obj.nbQubits_;
    end

    % qubit
    function [qubit] = qubit(obj)
      % qubit - Return the first qubit of the quantum circuit.
      %
      % Syntax:
      %   q = obj.qubit()
      %
      % Outputs:
      %   q - The index of the first qubit (int64).
      qubit = obj.offset_;
    end

    % qubits
    function [qubits] = qubits(obj)
      % qubits - Return the qubits of the quantum circuit.
      %
      % Syntax:
      %   qubits = obj.qubits()
      %
      % Outputs:
      %   qubits - array of indices of qubits used in the circuit (int64 array).
      qubits = obj.offset_:obj.nbQubits_+obj.offset_-1;
    end

    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      label = [' ',obj.label_,' '];
    end

    % qubits
    function [nbMeasurements] = nbMeasurements(obj)
      % qubits - Return the number of measurements of the quantum circuit.
      %
      % Syntax:
      %   nbMeasurements = obj.nbMeasurements()
      %
      % Outputs:
      %   nbMeasurements - Number of measurements in the circuit (int64).
      nbMeasurements = obj.nbMeasurements_;
    end


    % matrix
    function [mat] = matrix(obj)
      % matrix - Return the unitary matrix corresponding to this quantum circuit.
      %          Does not work for circuits which include measurements
      %
      % Works only on circuits without measurements.
      %
      % Syntax:
      %   mat = obj.matrix()
      %
      % Outputs:
      %   mat - Unitary matrix representing the quantum circuit (double).
      assert(obj.nbMeasurements == 0)
      issparse = qclab.isSparse(obj.nbQubits_);
      mat = qclab.qId(obj.nbQubits, issparse);
      for i = 1:length(obj.objects_)
        mat = apply(obj.objects_(i), 'R', 'N', obj.nbQubits, mat) ;
      end
    end

    % simulate
    function [simulation] = simulate(obj, v, seed)
      % simulate - Simulate the quantum circuit on a given input state. If
      % the circuit does not contain measurements, it is assumed that all
      % qubits are measured at the end of the circuit.
      %
      % Syntax:
      %   simulation = obj.simulate(v)
      %   simulation = obj.simulate(v, seed)
      %
      % Inputs:
      %   v - Initial state, either as a (state)vector or bitstring.
      %   seed - (optional) Random seed (default: 1)
      %
      % Outputs:
      %   simulation - A QSimulate object.
      %
      %See also: qclab.QSimulate
      if nargin == 2
        seed = 1;
      end
      if isa(v, 'char')
        i = bin2dec(v);
        v = zeros( 2^strlength(v),1 );
        v(i+1) = 1;
      end
      nbQubits = obj.nbQubits_;
      assert(size(v,1) == 2^nbQubits);
      for i = 1:length(obj.objects_)
        v = apply(obj.objects_(i), 'R', 'N', nbQubits, v);
      end
      % no measurements
      if isa(v,"double")
        w = v;
        v = struct;
        v.states = {w};
        v.res = dec2bin(0:length(w)-1);
        v.res = v.res(w ~= 0,:);
        v.res = cellstr(v.res);
        v.prob = abs(w).^2;
        v.prob = v.prob(w ~= 0);
        meas = [arrayfun(@(x) qclab.Measurement(x), 0:obj.nbQubits-1)];
        measMid = [];
        measEnd = [arrayfun(@(x) qclab.Measurement(x), 0:obj.nbQubits-1)];
      
      simulation = qclab.QSimulate(v.states, v.res, v.prob, ...
        {meas, measMid, measEnd}, seed);
      % with measurements
      else
        [meas, measMid, measEnd] = obj.measurements;
        simulation = qclab.QSimulate(v.states, v.res, v.prob, ...
        {meas, measMid, measEnd}, seed);
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
    %> @param nbQubits qubit size of `current`
    %> @param current current state to which QCircuit is applied
    %> @param offset offset applied to qubit
    % ==========================================================================
    function [current] = apply(obj, side, op, nbQubits, current, offset )
      % apply - Apply the quantum circuit to an input vector or state.
      %
      % Syntax:
      %   current = obj.apply(side, op, nbQubits, current)
      %   current = obj.apply(side, op, nbQubits, current, offset)
      %
      % Inputs:
      %   side     - 'L' or 'R' for respectively left or right side of
      %               application (in quantum circuit ordering)
      %   op       - 'N', 'T' or 'C' for respectively normal, transpose or
      %              conjugate transpose application of the circuit
      %   nbQubits - qubit size of `current`.
      %   current  - Input matrix or struct of state vectors.
      %   offset   - Qubit offset (default: 0).
      %
      % Outputs:
      %   current - Updated state after applying the circuit (struct or double).
      assert( nbQubits >= obj.nbQubits );
      if nargin == 5, offset = 0; end
      if strcmp(op, 'N')
        if strcmp(side,'L') % Left + NoTrans
          for i = length(obj.objects_):-1:1
            current = apply(obj.objects_(i), side, op, nbQubits, current, ...
              obj.qubit + offset );
          end
        else % Right + NoTrans
          for i = 1:length(obj.objects_)
            current = apply(obj.objects_(i), side, op, nbQubits, current, ...
              obj.qubit + offset );
          end
        end
      else
        if strcmp(side,'L') % Left + [Conj]Trans
          for i = 1:length(obj.objects_)
            current = apply(obj.objects_(i), side, op, nbQubits, current, ...
              obj.qubit + offset );
          end
        else % Right + [Conj]Trans
          for i = length(obj.objects_):-1:1
            current = apply(obj.objects_(i), side, op, nbQubits, current, ...
              obj.qubit + offset );
          end
        end
      end
    end

    % measurements
    function [meas, meas_mid, meas_end] = measurements(obj)
      % measurements - Return the measurements of the quantum circuit.
      %
      % Syntax:
      %   [meas, meas_mid, meas_end] = obj.measurements()
      %
      % Outputs:
      %   meas      - All measurements of the circuit (qclab.Measurement).
      %   meas_mid  - Mid-circuit measurements (qclab.Measurement).
      %   meas_end  - End-circuit measurements (qclab.Measurement).

      % Initializing
      meas = [];
      meas_end = [];
      % first_time is needed to change meas and meas_end to a
      % qclab.Measurement object in order to add measurements
      first_time = true;
      for i = 1:length(obj.objectsFlattend)
        % Deleting measurements from end circuit measurement, if another
        % object is applied to the measurements qubit.
        qubits_meas_end = arrayfun(@(measurement) measurement.qubit, meas_end);
        indicesToDelete = ismember(qubits_meas_end, ...
          obj.objectsFlattend(i).qubits);
        meas_end(indicesToDelete) = [];
        % Add object to meas and meas_end if it is a Measurement
        if isa(obj.objectsFlattend(i), 'qclab.Measurement')
          if first_time
            meas = qclab.Measurement.empty;
            meas_end = qclab.Measurement.empty;
            first_time = false;
          end
          meas(end+1) = obj.objectsFlattend(i);
          meas_end(end+1) = obj.objectsFlattend(i);
        end
      end
      % getting meas_mid by deleting meas_end from meas
      meas_mid = meas;
      for i = 1:length(meas_end)
        index = find(arrayfun(@(x) x == meas_end(i),meas_mid),1,'last');
        meas_mid(index) = [];
      end
      if isempty(meas_mid)
        meas_mid = [];
      end
      if isempty(meas_end)
        meas_end = [];
      end
    end

    % toQASM
    function [out] = toQASM(obj, fid, offset)
      % toQASM - Writes the QASM code of this quantum object to the given file id.
      %
      % Syntax:
      %   obj.toQASM(fid)
      %   obj.toQASM(fid, offset)
      %
      % Inputs:
      %   fid    - File ID to write the QASM code.
      %   offset - Offset applied to the qubits (default: 0).
      if nargin == 2, offset = 0; end
      fprintf( fid, '\n\nQASM output:\n\n' );
      fprintf( fid, 'OPENQASM 2.0;\ninclude "qelib1.inc";\n\n');
      fprintf( fid, 'qreg q[%d];\n',obj.nbQubits);
      for i = 1:length(obj.objects_)
        [out] = obj.objects_(i).toQASM( fid, obj.offset_ + offset ) ;
        if ( out ~= 0 ), return; end
      end
    end

    % equals
    function [bool] = equals(obj, other)
      % equals - Check if this quantum circuit is equal to another.
      %
      % Syntax:
      %   bool = obj.equals(other)
      %
      % Inputs:
      %   other - Another QCircuit object to compare with.
      %
      % Outputs:
      %   bool - True if the circuits are equal, false otherwise.
      bool = false;
      if isa(other, 'qclab.QObject')
        meas = obj.measurements;
        meas_o = other.measurements;
        % if no measurements, just compare the matrices
        if isempty(meas) && isempty(meas_o)
          bool = isequal( other.matrix, obj.matrix );
        else
          measQubits = arrayfun(@(x) x.qubit, meas);
          basisChangeMatrices = arrayfun(@(x) x.matrix, meas, ...
            'UniformOutput', false);
          measQubits_o = arrayfun(@(x) x.qubit, meas_o);
          basisChangeMatrices_o = arrayfun(@(x) x.matrix, meas_o, ...
            'UniformOutput', false);
          [meas_sort, sortIdx] = sort(measQubits);
          basisChangeMatrix_sort = basisChangeMatrices(sortIdx);
          [meas_sort_o, sortIdx_o] = sort(measQubits_o);
          basisChangeMatrix_sort_o = basisChangeMatrices_o(sortIdx_o);
          % Check if all measurements are equal (same qubits and basis
          % changes)
          if isequal(meas_sort, meas_sort_o) && ...
              isequal(basisChangeMatrix_sort, basisChangeMatrix_sort_o)
            bool = true;
            % Check if all sub matrices between a layer of measurements and
            % the layers of measurements are the same
            rest_objects_comb = {obj.objectsFlattend, other.objectsFlattend};
            while (~isempty(rest_objects_comb{1}) || ...
                ~isempty(rest_objects_comb{2})) && bool == true
              subcircuits = {qclab.QCircuit(obj.nbQubits_),
                qclab.QCircuit(other.nbQubits_)};
              measure_layers = {[], []};
              remove_indices = {[], []};
              for k = 1:2
                n = length(rest_objects_comb{k});
                % add gates to subcircuit
                for i = 1:n
                  if ~isa(rest_objects_comb{k}(i), 'qclab.Measurement')
                    % only add gate, of no measurement occured on its
                    % qubits
                    if isempty(intersect(measure_layers{k}, ...
                        rest_objects_comb{k}(i).qubits))
                      subcircuits{k}.push_back(rest_objects_comb{k}(i));
                      remove_indices{k}(end+1) = i;
                    end
                  else
                    % add qubit of the measurement to the current measure
                    % layer
                    measure_layers{k}(end+1) = rest_objects_comb{k}(i).qubit;
                    remove_indices{k}(end+1) = i;
                  end
                end
                % remove objects
                rest_objects_comb{k}(remove_indices{k}) = [];
              end
              submatrices = {subcircuits{1}.matrix, subcircuits{2}.matrix};
              % compare submatrices and measure layers
              bool = max(abs(submatrices{1}(:) - submatrices{2}(:))) < ...
                5*eps && isequal(measure_layers{1}, measure_layers{2});
            end
          end
        end
      end
    end

    %> Returns the qubit offset of this quantum circuit.
    function [offset] = offset(obj)
      % offset - Return the qubit offset of the quantum circuit.
      %
      % Syntax:
      %   offset = obj.offset()
      %
      % Outputs:
      %   offset - offset of the quantum circuit (int64).
      offset = obj.offset_ ;
    end

    %> Sets the qubit offset of this quantum circuit.
    function setOffset(obj, offset)
      % setOffset - Set the qubit offset of the quantum circuit.
      %
      % Syntax:
      %   obj.setOffset(offset)
      %
      % Inputs:
      %   offset - offset to be set (int64).
      assert(qclab.isNonNegInteger(offset));
      obj.offset_ = offset ;
    end

    % ctranspose
    function circprime = ctranspose( obj )
      % ctranspose - Return the conjugate transpose of this quantum circuit.
      %
      % Syntax:
      %   circPrime = obj.ctranspose()
      %
      % Outputs:
      %   circPrime - The conjugate transpose of the quantum circuit
      %               (QCircuit object).
      circprime = copy( obj );
      myObjects = circprime.objects ;
      nbObjects = circprime.nbObjects ;
      for i = 1 : nbObjects
        circprime.objects_( i ) = ctranspose( myObjects( nbObjects - i + 1 ) );
      end
    end

    %
    % Element Access :
    %

    %> @brief Returns array of handles to the objects of this quantum circuit at
    %> postions `pos`. Default for `pos` is all objects.
    function [objects] = objectHandles( obj, pos )
      % objectHandles - Return an array of handles to the objects of this
      %                 quantum circuit.
      %
      % Syntax:
      %   handles = obj.objectHandles()
      %
      % Outputs:
      %   handles - Array of handles to the quantum objects in the circuit.
      if nargin == 1
        objects = obj.objects_ ;
      else
        assert(qclab.isNonNegIntegerArray( pos - 1 ));
        objects = obj.objects_( pos );
      end
    end

    %> @brief Returns a copy of the objects of this quantum circuit at positions
    %> `pos`. Default for `pos` is all objects.
    function [objects] = objects( obj, pos )
      % objects - Return a copy of the objects of the quantum circuit.
      %
      % Syntax:
      %   objects = obj.objects()
      %
      % Outputs:
      %   objects - Array of quantum objects in the circuit (copied).
      if nargin == 1
        objects = copy(obj.objects_) ;
      else
        assert(qclab.isNonNegIntegerArray( pos - 1 ));
        objects = copy(obj.objects_( pos ));
      end
    end

    % objectsFlattend
    function [objectsFlattend] = objectsFlattend( obj, pos )
      % objectsFlattend - Return a copy of objects where subcircuits are resolved.
      %
      % Syntax:
      %   objectsFlattend = obj.objectsFlattend()
      %
      % Outputs:
      %   objectsFlattend - Array of quantum objects where subcircuits are resolved.
      objectsFlattend = obj.objects;
      i = 1;
      while i <= length(objectsFlattend)
        if isa(objectsFlattend(i), 'qclab.QCircuit')
          sub_circuit = objectsFlattend(i);
          sub_objects = sub_circuit.objectsFlattend;
          offset = sub_circuit.offset;
          for j = 1:length(sub_objects)
            sub_objects(j).setQubits(sub_objects(j).qubits + offset);
          end
          objectsFlattend = [objectsFlattend(1:i-1), sub_objects, ...
            objectsFlattend(i+1:end)];
          i = i + length(sub_objects);
        else
          i = i + 1;
        end
      end
      if nargin == 2
        assert(qclab.isNonNegIntegerArray( pos - 1 ));
        objectsFlattend = objectsFlattend( pos );
      end
    end

    %
    % Capacity
    %

    %> @brief Checks if this quantum circuit is empty.
    function [bool] = isempty(obj)
      % isempty - Check if the quantum circuit is empty.
      %
      % Syntax:
      %   bool = obj.isempty()
      %
      % Outputs:
      %   bool - True if the circuit is empty, false otherwise.
      bool = isempty(obj.objects_);
    end

    %> @brief Returns the number of objects in this quantum circuit.
    function [nbObjects] = nbObjects(obj)
      % nbObjects - Return the number of objects in the quantum circuit.
      %
      % Syntax:
      %   num = obj.nbObjects()
      %
      % Outputs:
      %   num - Number of quantum objects in the circuit (int64).
      nbObjects = length(obj.objects_);
    end

    %
    % Modifiers
    %

    %> @brief Clears the objects of this quantum circuit.
    function clear(obj)
      % clear - Clear all objects in this quantum circuit.
      %
      % Syntax:
      %   obj.clear()
      obj.objects_ = qclab.QObject.empty;
      obj.nbMeasurements_ = 0;
    end

    %> @brief Inserts `objects` at unique positions `pos` in this quantum circuit.
    function insert(obj, pos, objects)
      % insert - Insert objects at unique positions in the circuit.
      %
      % Syntax:
      %   obj.insert(pos, objects)
      %
      % Inputs:
      %   pos     - Position(s) where the object should be inserted.
      %   objects - Quantum objects to insert at the specified positions.
      assert( qclab.isNonNegIntegerArray( pos - 1 ) );
      assert( length(pos) == length(objects) );
      assert( obj.canInsert(objects) );
      for i = 1:length(objects)
        if isa(objects( i ), 'qclab.Measurement')
          obj.nbMeasurements_ = obj.nbMeasurements_ + 1;
        elseif isa(objects( i ), 'qclab.QCircuit')
          obj.nbMeasurements_ = obj.nbMeasurements_ + ...
            objects( i ).nbMeasurements_;
        end
      end
      totalObjects =  length(obj.objects_) + length(objects);
      newObjects(1,totalObjects) = qclab.qgates.Identity; % initialize array
      newObjects(pos) = objects;
      j = 1;
      for i = 1:totalObjects
        if ~ismember(i, pos) % i not in pos
          newObjects(i) = obj.objects_(j);
          j = j + 1;
        end
      end
      obj.objects_ = newObjects ;
    end

    %> @brief Erases the objects at positions `pos` from this quantum circuit.
    function erase(obj, pos)
      % erase - Erase objects from a given positions.
      %
      % Syntax:
      %   obj.erase(pos)
      %
      % Inputs:
      %   pos - Position(s) of the object(s) to erase.
      assert( qclab.isNonNegIntegerArray( pos - 1 ) ) ;
      assert( max( pos ) <= obj.nbObjects );
      for i = 1:length( pos )
        if isa(obj.objects_( pos(i) ), 'qclab.Measurement')
          obj.nbMeasurements_ = obj.nbMeasurements_ - 1;
        elseif isa(obj.objects_( pos(i) ), 'qclab.QCircuit')
          obj.nbMeasurements_ = obj.nbMeasurements_ - ...
            obj.objects_( pos ).nbMeasurements_;
        end
      end
      obj.objects_( pos ) = [] ;
    end

    %> @brief Replace the object at position `pos` with `object`
    function replace( obj, pos, object )
      % replace - Replace the object at a specific position with a new one.
      %
      % Syntax:
      %   obj.replace(pos, object)
      %
      % Inputs:
      %   pos    - Position to replace.
      %   object - The new quantum object to insert at position `pos`.
      assert( qclab.isNonNegInteger( pos - 1 ) );
      assert( pos <= obj.nbObjects );
      assert( length(object) == 1 );
      assert( obj.canInsert( object ) );
      if isa(obj.objects_( pos ), 'qclab.Measurement')
        obj.nbMeasurements_ = obj.nbMeasurements_ - 1;
      elseif isa(obj.objects_( pos ), 'qclab.QCircuit')
        obj.nbMeasurements_ = obj.nbMeasurements_ - ...
          obj.objects_( pos ).nbMeasurements_;
      end
      obj.objects_( pos ) = object ;
      if isa(object, 'qclab.Measurement')
        obj.nbMeasurements_ = obj.nbMeasurements_ + 1;
      elseif isa(object, 'qclab.QCircuit')
        obj.nbMeasurements_ = obj.nbMeasurements_ + object.nbMeasurements_;
      end
    end

    %> @brief Add an object to the end of this quantum circuit.
    function push_back( obj, object )
      % push_back - Add an object to the end of this quantum circuit.
      %
      % Syntax:
      %   obj.push_back(object)
      %
      % Inputs:
      %   object - The quantum object to add (Can be a gate (qclab.qgates),
      %            a measurement (see qclab.Measurement) or a subcircuit
      %            (see qclab.QCircuit)).
      assert( obj.canInsert( object ) && isscalar( object ) );
      obj.objects_(end+1) = object ;
      if isa(object, 'qclab.Measurement')
        obj.nbMeasurements_ = obj.nbMeasurements_ + 1;
      elseif isa(object, 'qclab.QCircuit')
        obj.nbMeasurements_ = obj.nbMeasurements_ + object.nbMeasurements_;
      end
    end

    %> @brief Remove the last gate of this quantum circuit.
    function pop_back( obj )
      % pop_back - Remove the last object of this quantum circuit.
      %
      % Syntax:
      %   obj.pop_back()
      if isa(obj.objects_( end ), 'qclab.Measurement')
        obj.nbMeasurements_ = obj.nbMeasurements_ - 1;
      elseif isa(obj.objects_( end ), 'qclab.QCircuit')
        obj.nbMeasurements_ = obj.nbMeasurements_ - ...
          obj.objects_( end ).nbMeasurements_;
      end
      obj.objects_(end) = [];
    end

    % barrier
    function barrier(obj, visibility)
      % barrier - Add a barrier over all qubits to the end of the circuit.
      %
      % Syntax:
      %   obj.barrier()
      %   obj.barrier(visibility)
      %
      % Inputs:
      %   visibility - Set the visibility of the barrier (default: false).
      %
      % See also: qclab.Barrier
      if nargin == 1, visibility = false; end
      obj.objects_(end+1) = qclab.Barrier(obj.qubits, visibility);
    end

    %> @brief Checks if the objects in `objects` can be inserted into this
    %> quantum circuit.
    function [bool] = canInsert(obj, objects)
      % canInsert - Check if an object can be inserted into this quantum circuit.
      %
      % Syntax:
      %   bool = obj.canInsert(objects)
      %
      % Inputs:
      %   objects - Array of quantum objects to check.
      %
      % Outputs:
      %   bool - True if the objects can be inserted, false otherwise.
      bool = true;
      for i = 1: length(objects)
        qubits = objects(i).qubits;
        if max(qubits) >= obj.nbQubits_
          bool = false;
          return
        end
      end
    end

    %
    % drawing & drawing properties
    %

    % block
    function [bool] = block(obj)
      % block - Return the block drawing property of the quantum circuit.
      %
      % Syntax:
      %   bool = obj.block()
      %
      % Outputs:
      %   bool - Logical value indicating whether the block drawing is enabled
      %          (true) or not (false).
      bool = obj.block_;
    end

    % asBlock
    function asBlock(obj, label)
      % asBlock - Set the block drawing property of the circuit to true.
      %
      % Syntax:
      %   obj.asBlock()
      %   obj.asBlock(label)
      %
      % Inputs:
      %   label - Label for the block (default: 'circuit').
      if nargin == 1, label = 'circuit'; end
      obj.block_ = true;
      obj.label_ = label;
    end

    % unBlock
    function unBlock(obj, recursive)
      % unBlock - Set the block drawing property to false.
      % Optionally, unblock all subcircuits as well.
      %
      % Syntax:
      %   obj.unBlock()                 % Unblocks only the main circuit
      %   obj.unBlock(recursive)        % Unblocks the main circuit and
      %                                   optionally subcircuits.
      %
      % Inputs:
      %   recursive - (optional) If true, unblock all subcircuits as well.
      %                          (Default: false).

      if nargin < 2
        recursive = false; % Default to unblocking only the main circuit
      end

      % Unblock the main circuit
      obj.block_ = false;

      % If recursive is true, unblock all subcircuits
      if recursive
        for i = 1:length(obj.objects)
          if isa(obj.objects(i), qclab.QCircuit)
            obj.subCircuits{i}.unBlock(true); % Recursively unblock subcircuits
          end
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
    function [varargout] = draw(obj, fid, parameter, offset)
      % draw - Draw the quantum circuit in the command window.
      %
      % Syntax:
      %   obj.draw()
      %   obj.draw(fid)
      %   obj.draw(fid, parameter)
      %   obj.draw(fid, parameter, offset)
      %
      % Inputs:
      %   fid      - file id to draw to:
      %              - 0  : return cell array with ascii characters as `out`
      %              - 1  : draw to command window (default)
      %              - >1 : draw to (open) file id
      %   parameter- Display parameter
      %              - 'N' don't print parameter (default),
      %              - 'S' print short parameter,
      %              - 'L' print long parameter.
      %   offset   - Offset applied to the qubit indices (default is 0).

      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      qclab.drawCommands ; % load draw commands
      if obj.block_ == false
        circuitCell = cell(3*obj.nbQubits,1); % cell array to store all strings
        circuitCell(:) = {''};
        charIndex = ones(obj.nbQubits, 1);    % most right character index for
        % every qubit
        for i = 1:obj.nbObjects
          % Get the qubits and draw strings for the current gate
          thisQubits = obj.objects_( i ).qubits ;
          thisQubits = min(thisQubits):max(thisQubits);
          thisObjectCell = obj.objects_( i ).draw( 0, parameter, 0 );

          % left-most character thisObjectCell can be drawn on
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

          % add thisObjectCell to circuitCell
          for q = thisQubits
            thisq = q - thisQubits(1);
            circuitCell{ 3*q + 1 }  = strcat( circuitCell{ 3*q + 1}, ...
              thisObjectCell{ 3*thisq + 1 } );
            circuitCell{ 3*q + 2 }  = strcat( circuitCell{ 3*q + 2}, ...
              thisObjectCell{ 3*thisq + 2 } );
            circuitCell{ 3*q + 3 }  = strcat( circuitCell{ 3*q + 3 }, ...
              thisObjectCell{ 3*thisq + 3 } );
          end

          % update the charIndex on thisQubits
          thisWidth = count( thisObjectCell{1}, '\x' ); % charwidth of thisGate
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
      else
        nbQubits = obj.nbQubits;
        circuitCell =  cell(3*nbQubits,1);
        label = obj.label ;
        width = length( label );
        if nbQubits == 1
          circuitCell{1} = [ space, ulc, repmat(h, 1, width), urc ];
          circuitCell{2} = [ h, vl, repmat(space, 1, width), vr ];
          circuitCell{3} =  [ space, blc, repmat(h, 1, width), brc ];
        end
        if nbQubits >= 2
          circuitCell{1} = [ space, ulc, repmat(h, 1, width), urc ];
          circuitCell{2} = [ h, vl, repmat(space, 1, width), vr ];
          circuitCell{3} = [ space, v, repmat(space, 1, width), v ];
          if nbQubits > 2
            for k = 2:nbQubits
              circuitCell{3*k-2} = [ space, v, repmat(space, 1, width), v ];
              circuitCell{3*k-1} = [ h, vl, repmat(space, 1, width), vr ];
              circuitCell{3*k} = [ space, v, repmat(space, 1, width), v ];
            end
          end
          circuitCell{end-2} = [ space, v, repmat(space, 1, width), v ];
          circuitCell{end-1} = [ h, vl, repmat(space, 1, width), vr];
          circuitCell{end} = [ space, blc, repmat(h, 1, width), brc ];
        end
        if mod(obj.nbQubits,2) == 0
          circuitCell{3*nbQubits/2} = [ space, v, label, v ];
        else
          circuitCell{ceil(3*nbQubits/2)} = [ h, vl, label, vr ];
        end
      end

      if fid > 0
        qclab.drawCellArray( fid, circuitCell, obj.qubits + offset );
        out = 0;
      else
        out = circuitCell ;
      end

      if nargout > 0
        varargout = {out};
      else
        varargout = {};
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
      % toTex - Save the quantum circuit to a TeX file.
      %
      % Syntax:
      %   obj.toTex(fid)
      %   obj.toTex(fid, parameter)
      %   obj.toTex(fid, parameter, offset)
      %
      % Inputs:
      %   fid      - File ID to save the TeX file.
      %              - 0  : return cell array with ascii characters as `out`
      %              - 1  : draw to command window (default)
      %              - >1 : draw to (open) file id
      %   parameter- Display parameter.
      %              - 'N' don't print parameter (default),
      %              - 'S' print short parameter,
      %              - 'L' print long parameter.
      %   offset   - Offset applied to the qubit indices (default: 0).
      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      circuitCell = cell(obj.nbQubits,1); % cell array to store all strings
      circuitCell(:) = {''};
      tabIndex = ones(obj.nbQubits, 1);   % most right tab index for every qubit
      if obj.block_ == false
        for i = 1:obj.nbObjects
          % Get the qubits and TeX strings for the current object
          thisQubits = obj.objects_( i ).qubits ;
          thisQubits = min(thisQubits):max(thisQubits);
          thisObjectCell = obj.objects_( i ).toTex( 0, parameter, 0 );

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
          for q = thisQubits
            thisq = q - thisQubits(1);
            circuitCell{ q + 1 }  = strcat( circuitCell{ q + 1 }, ...
              thisObjectCell{ thisq + 1 } );
          end

          % update tabIndex
          thisWidth = count(thisObjectCell{1},'&');
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
      else
        label = obj.label_;
        if obj.nbQubits == 1
          circuitCell = cell(1,1) ;
          circuitCell{1} = ['&\t\\gate{\\mathrm{', label,'}}\t'] ;
        else
          circuitCell{1} = ['&\t\\multigate{' int2str(obj.nbQubits-1) '}' ...
            '{\\mathrm{', label,'}}\t'] ;
          for i = 2:obj.nbQubits
            circuitCell{i} = ['&\t\\ghost{\\mathrm{', label,'}}\t'] ;
          end
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
      cp.objects_ = obj.objects() ;
    end

    %> Property groups
    function groups = getPropertyGroups(obj)
      import matlab.mixin.util.PropertyGroup
      props = struct();
      props.nbQubits = obj.nbQubits;
      props.nbObjects = obj.nbObjects;
      props.offset = obj.offset;
      groups = PropertyGroup(props);
    end
  end
end % class QCircuit
