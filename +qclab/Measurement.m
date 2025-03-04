% Measurement - Class for quantum measurement.
%
% Measurement is a class that represents a single-qubit quantum measurement, 
% including the qubit to be measured, the basis in which the measurement is 
% performed, and an optional label.
%
% Creation
%   Syntax:
%     M = qclab.Measurement()
%     M = qclab.Measurement(qubit)
%     M = qclab.Measurement(qubit, basisChange)
%     M = qclab.Measurement(qubit, basisChange, label)
%     M = qclab.Measurement(qubit, 'z')
%     M = qclab.Measurement(qubit, 'x')
%     M = qclab.Measurement(qubit, 'y')
%
%   Input Arguments:
%     qubit       - Qubit to be measured (integer).
%                   (default: 0)
%     basisChange - (optional) Basis change operation for the measurement,  
%                              allowing for one or several 1-qubits gates.
%                              (default: Z-basis measurement (no basis
%                              change))
%     label       - (optional) Label for the measurement (string).
%                              (default: '' (no label))
%
%   Preset basisChange and label Configurations
%                 - 'z': Z-basis measurement (no basis change, label = 'z')
%                 - 'x': X-basis measurement (qclab.qgates.Hadamard, label = 'x')
%                 - 'y': Y-basis measurement ([qclab.qgates.Phase90'; qclab.qgates.Hadamard], label = 'y')
%
%   Output:
%     M - A Measurement object representing a single-qubit measurement.
%
%   Example:
%   Create a measurement on qubit 0 in the X basis:
%     M = qclab.Measurement(0, 'x');
%
% Object Functions
%   <a href="matlab:help qclab.Measurement.qubit">qubit</a>           - Return the qubit on which the measurement is performed.
%   <a href="matlab:help qclab.Measurement.setQubit">setQubit</a>        - Set the qubit for the measurement.
%   <a href="matlab:help qclab.Measurement.basisChange">basisChange</a>     - Return the basis change for the measurement.
%   <a href="matlab:help qclab.Measurement.label">label</a>           - Return the label of the measurement.
%   <a href="matlab:help qclab.Measurement.matrix">matrix</a>          - Return the matrix representation of the basis change of the measurement.
%   <a href="matlab:help qclab.Measurement.ctranspose">ctranspose</a>      - Return the measurement with its basis change replaced by its conjugate transpose.
%   <a href="matlab:help qclab.Measurement.apply">apply</a>           - Apply the measurement to a state.
%   <a href="matlab:help qclab.Measurement.toQASM">toQASM</a>          - Write the QASM code for this measurement to a file.
%   <a href="matlab:help qclab.Measurement.equals">equals</a>          - Check if the Measurement is equal to another object.
%   <a href="matlab:help qclab.Measurement.draw">draw</a>            - Draw the measurement in the command window.
%   <a href="matlab:help qclab.Measurement.toTex">toTex</a>           - Save the measurement as a LaTeX file.

%> @file Measurement.m
%> @brief Implements Measurement class.
% ==============================================================================
%> @class Measurement
%> @brief Class for quantum measurement
%
% (C) Copyright Sophia Keip, Daan Camps and Roel Van Beeumen 2025.
% ==============================================================================
classdef Measurement < qclab.QObject
  properties (Access = protected)
    %> Qubit of this 1-qubit measurement.
    qubit_(1,1)  int32
    %> BasisChange of this 1-qubit measurement.
    basisChange_ 
    %> Label of this 1-qubit measurement.
    label_ char
  end

  methods
    % Class constructor  =======================================================
    %> @brief Constructor for quantum measurement
    %>
    %> The Measurement constructor can be used in three ways:
    %>
    %> 1. `Measurement()` : default constructor, sets to qubit_ to 0,
    %> basisChange to [] and label to ''.
    %> 2. `Measurement(qubit)` : sets the qubit_ to qubit, basisChange to
    %> [] and label to ''.
    %> 3. `Measurement(qubit,basisChange)` : sets the qubit_ to qubit,
    %> basisChange_ to basisChange and label to 'U'.
    %> 4. `Measurement(qubit,basisChange,label)` : sets the qubit_ to qubit,
    %> basisChange_ to basisChange and label_ to label.
    %
    %> If basisChange is 'z', 'x' or 'y' basisChange is set to the
    %> corresponding basis change which is used to measure in Z, X or Y
    %> basis and label is set to 'z', 'x' or 'y'.
    % ==========================================================================
    function obj = Measurement( qubit, basisChange, label )
      if nargin == 0, qubit = 0; basisChange = qclab.qgates.QGate1.empty; 
        label = ''; end
      if nargin == 1, basisChange = qclab.qgates.QGate1.empty; 
        label = ''; end
      if nargin == 2, label = 'U'; end

      if strcmp(basisChange,'z'), basisChange = qclab.qgates.QGate1.empty;
        label = 'z'; end
      if strcmp(basisChange,'x'), basisChange = qclab.qgates.Hadamard;
        label = 'x'; end
      if strcmp(basisChange,'y') 
        basisChange = ...
        [ctranspose(qclab.qgates.Phase90) ; qclab.qgates.Hadamard];
        label = 'y'; 
      end

      assert( qclab.isNonNegInteger( qubit ) ) ;
      assert( any(strcmp(superclasses( basisChange ), ...
        'qclab.qgates.QGate1')) || isa( basisChange, 'qclab.qgates.QGate1'));
      assert( ischar( label ) ) ;

      obj.qubit_ = qubit ;
      obj.basisChange_ = basisChange ;
      obj.label_ = label ;
    end

    function [basisChange] = basisChange(obj,pos)
      % basisChange - Return the basis change for this measurement. One or
      % multiple 1-qubit gates may perform the basis change. 
      %
      % Syntax:
      %   basisChange = obj.basisChange()
      %   basisChange = obj.basisChange(pos)
      %
      % Inputs:
      %   pos - (optional) Index of the part of the basis change to return. 
      %
      % Outputs:
      %   basisChange - Basis change applied to the qubit before
      %                 measurement. (One or multiple 1-qubit gates)
      basisChange = obj.basisChange_;
      if nargin == 2
        assert(qclab.isNonNegIntegerArray(pos - 1));
        basisChange = obj.basisChange_(pos);
      end
    end

    function [qubit] = qubit(obj)
      % qubit - Return the qubit on which the measurement is performed.
      %
      % Syntax:
      %   qubit = obj.qubit()
      %
      % Outputs:
      %   qubit - The qubit being measured.
      qubit = obj.qubit_;
    end

    function setQubit(obj,qubit)
      % setQubit - Set the qubit for the measurement.
      %
      % Syntax:
      %   obj.setQubit(qubit)
      %
      % Inputs:
      %   qubit - Integer representing the qubit to set.
      assert( qclab.isNonNegInteger( qubit ) );
      obj.qubit_ = qubit ;
    end

    function [qubits] = qubits(obj)
      qubits = [obj.qubit_]; 
    end

    function setQubits(obj,qubits)
      assert(qclab.isNonNegInteger( qubits(1) ) );
      obj.qubit_ = qubits(1) ;
    end

    function [label] = label(obj, parameter, tex)
      % label - Return the label for the measurement.
      %
      % Syntax:
      %   label = obj.label()
      %
      % Outputs:
      %   label - The label string for this measurement.
      label = obj.label_;
    end

    function [mat] = matrix(obj)
      % matrix - Return the matrix representation of the basis change of the 
      %          measurement.
      %
      % Syntax:
      %   mat = obj.matrix()
      %
      % Outputs:
      %   mat - Unitary matrix representation of the basis change.
      basisChange = obj.basisChange;
      mat = [1,0;0,1];
      for i = 1:length(basisChange)
        mat = mat*basisChange(i).matrix;
      end
    end

    function [outprime] = ctranspose(obj)
      % ctranspose - Return the measurement with its basis change replaced by 
      %              its conjugate transpose.
      %
      % Syntax:
      %   outprime = obj.ctranspose()
      %
      % Outputs:
      %   outprime - Measurement object with conjugate transposed basis change.
      basisChangeNew = qclab.qgates.QGate1.empty;
      for i = length(obj.basisChange):-1:1
        basisChangeNew(length(obj.basisChange)-i+1) = ...
        ctranspose(obj.basisChange(i));
      end
      outprime = qclab.Measurement(obj.qubit, basisChangeNew, obj.label);
    end

    function [out] = toQASM(obj, fid, offset)
      % toQASM - Write the QASM code for this measurement.
      %
      % Syntax:
      %   out = obj.toQASM(fid)
      %   out = obj.toQASM(fid, offset)
      %
      % Inputs:
      %   fid    - File identifier for the QASM output.
      %   offset - Optional offset to apply to the qubit index (default: 0).
      %
      % Outputs:
      %   out - 0 on successful completion.
      if nargin == 2, offset = 0; end
      basisChange = obj.basisChange;
      for i = 1:length( basisChange )
        toQASM( basisChange(i), fid, offset )
      end
      qclab.IO.qasmMeasurement( fid, obj.qubit + offset);
      for i = length( basisChange ):-1:1
        toQASM( ctranspose(basisChange(i)), fid, offset )
      end
      out = 0;
    end

    function [bool] = equals(obj, other)
      % equals - Check if the Measurement is equal to another objects.
      %
      % Syntax:
      %   bool = obj.equals(other)
      %
      % Inputs:
      %   other - Another object to compare with.
      %
      % Outputs:
      %   bool - True if the objects are equal, false otherwise.
      if isa(other, 'qclab.Measurement')
        bool = (obj.qubit == other.qubit) && isequal(obj.matrix, ...
          other.matrix);
      else
        bool = false;
      end
    end

    function [current] = apply(obj, ~, ~, nbQubits, current, offset)
      % apply - Apply the measurement to a state vector.
      %
      % Syntax:
      %   current = obj.apply(~, ~, nbQubits, current)
      %   current = obj.apply(~, ~, nbQubits, current, offset)
      %
      % Inputs:
      %   nbQubits  - Number of qubits represented by the current state.
      %   current   - State to apply the measurement to. (array or struct)
      %   offset    - Offset applied to the qubit index (default: 0).
      %
      % Outputs:
      %   current - Updated struct containing measurement results,
      %             probabilities and collapsed state vectors
      if nargin == 5, offset = 0; end
      assert( nbQubits >= 1);
      qubit = obj.qubit + offset ;
      assert( qubit < nbQubits ) ;
      basisChange = obj.basisChange;
      tol = 1e-10;

      symb_0 = '0';
      symb_1 = '1';

      if isa(current, 'double') %check if it is a single state vector or a
        % struct
        assert( size(current,1) == 2^nbQubits);
        assert( size(current,2) == 1);
        %measuring
        [probability_1,statevector_0, statevector_1] = ...
          qclab.measureStatevector(current, qubit, nbQubits, basisChange, tol);
        %introduce a struct
        if abs(probability_1 - 1) < tol
          current = struct;
          current.res = {symb_1};
          current.prob = probability_1;
          current.states = {statevector_1;};
        elseif abs(probability_1) < tol
          current = struct;
          current.res = {symb_0};
          current.prob = 1-probability_1;
          current.states = {statevector_0;};
        else
          current = struct;
          current.res = {symb_0; symb_1};
          current.prob = [1-probability_1; probability_1];
          current.states = {statevector_0; statevector_1};
        end

      else
        assert( length(current.states{1}) == 2^nbQubits );
        n = length(current.states);
        statevectors = current.states;
        probabilities = current.prob;
        results = current.res;
        j = 1;
        for i = 1:n
          statevector = statevectors{i};
          probability = probabilities(i);
          [probability_1,statevector_0, statevector_1] = ...
            qclab.measureStatevector(statevector, qubit, nbQubits, ...
            basisChange, tol);
          if abs(probability_1 - 1) < tol
            %store new state vector and probability when 1 is measured
            current.states{j,1} = statevector_1;
            current.prob(j,1) = (probability_1)*probability;
            current.res{j,1} = append(results{i},symb_1);
            j = j+1;
          elseif abs(probability_1) < tol
            %store new state vector and probability when 0 is measured
            current.states{j,1} = statevector_0;
            current.prob(j,1) = (1-probability_1)*probability;
            current.res{j,1} = append(results{i},symb_0);
            j = j+1;
          else %case when both results are measured with non zero probability
            current_res = results{i};
            %store new state vector and probability when 0 is measured
            current.states{j,1} = statevector_0;
            current.prob(j,1) = (1-probability_1)*probability;
            current.res{j,1} = append(current_res,symb_0);
            %store new state vector and probability when 1 is measured
            current.states{j+1,1} = statevector_1;
            current.prob(j+1,1) = (probability_1)*probability;
            current.res{j+1,1} = append(current_res,symb_1);
            j = j+2;
          end
        end
      end
    end

    function [out] = draw(obj, fid, parameter, offset)
      % draw - Draw the measurement in the command window or a file.
      %
      % Syntax:
      %   out = obj.draw(fid)
      %   out = obj.draw(fid, parameter)
      %   out = obj.draw(fid, parameter, offset)
      %
      % Inputs:
      %   fid      - file id to draw to:
      %              - 0  : return cell array with ascii characters as `out`
      %              - 1  : draw to command window (default)
      %              - >1 : draw to (open) file id
      %   parameter - Display parameter (default: 'N').
      %              - 'N' no parameter,
      %              - 'S' short parameter, 
      %              - 'L' long parameter.
      %   offset   - Qubit offset (default: 0).
      %
      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      qclab.drawCommands ; % load draw commands
      gateCell = cell(3, 1);
      if strcmp(obj.label_,'')
        label = 'M';
      else
      label = ['M_',obj.label_];
      end
      width = length( label );
      gateCell{1} = [ space, ulc, repmat(h, 1, width), urc ];
      gateCell{2} = [ h, vl, label, vr ];
      gateCell{3} = [ space, blc, repmat(h, 1, width), brc ];
      if fid > 0
        qubit = obj.qubit + offset ;
        qclab.drawCellArray( fid, gateCell, qubit );
        out = 0;
      else
        out = gateCell;
      end
    end

    function [out] = toTex(obj, fid, parameter, offset)
      % toTex - Save the measurement as a LaTeX file.
      %
      % Syntax:
      %   out = obj.toTex(fid)
      %   out = obj.toTex(fid, parameter)
      %   out = obj.toTex(fid, parameter, offset)
      %
      % Inputs:
      %   fid      - File identifier for the TeX output.
      %              - 0: return a cell array with ASCII characters as `out`.
      %              - 1: draw to the command window (default).
      %              - >1: draw to an open file identifier.
      %   parameter - Display parameter (default: 'N').
      %              - 'N': no parameter,
      %              - 'S': short parameter, 
      %              - 'L': long parameter.
      %   offset   - Offset applied to the qubit (default: 0).
      %
      % Outputs:
      %   out - if fid > 0 then out == 0 on succesfull completion, otherwise out contains a cell array with the drawing info.
      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      label = obj.label_;
      gateCell = cell(1,1) ;
      if strcmp(label , '')
        gateCell{1} = ['&\t\\meter\t'] ;
      else
        gateCell{1} = ['&\t\\meterB{',label,'}\t'] ;
      end
      if fid > 0
        qubit = obj.qubit + offset ;
        qclab.toTexCellArray( fid, gateCell, qubit );
        out = 0;
      else
        out = gateCell;
      end
    end

  end

  methods (Static)
    function [nbQubits] = nbQubits
      nbQubits = int32(1);
    end

    function [bool] = controlled
      bool = false;
    end

    function [bool] = fixed
      bool = false;
    end
  end

end % class Measurement
