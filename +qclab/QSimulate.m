% QSimulate - Class for representing a quantum simulation.
%
% QSimulate is the output of the simulate method of QCircuit. It stores and 
% manages the states, results, probabilities, and measurements of a quantum 
% simulation.
%
%   Note:
%     The QSimulate class is not meant to be instantiated directly by users.
%     It is created internally within the class QCircuit after the
%     execution of a quantum simulation.
%
% See also: qclab.QCircuit.simulate
%
% Example:
%   To perform a simulation, use the simulate method of the QCircuit class.
%
%   % Create a quantum circuit with 3 qubits
%   circuit = qclab.QCircuit(3);
%
%   % Fill the quantum circuit with gates and measurements
%
%   % Simulate the circuit on an initial state vector
%   simulation = circuit.simulate('000');
%
%   % Access the results etc. of the simulation via the QSimulate object 
%   simulation.results();
%
% Object Functions
%   <a href="matlab:help qclab.QSimulate.states">states</a>            - Return the quantum states belonging to the different results of the simulation.
%   <a href="matlab:help qclab.QSimulate.nbOutcomes">nbOutcomes</a>        - Return the number of outcomes in the simulation.
%   <a href="matlab:help qclab.QSimulate.results">results</a>           - Return the results of the simulation.
%   <a href="matlab:help qclab.QSimulate.resultsMid">resultsMid</a>        - Return the results of mid-circuit measurements.
%   <a href="matlab:help qclab.QSimulate.resultsEnd">resultsEnd</a>        - Return the results of end-circuit measurements.
%   <a href="matlab:help qclab.QSimulate.probabilities">probabilities</a>     - Return the probabilities of the simulation results.
%   <a href="matlab:help qclab.QSimulate.probabilitiesMid">probabilitiesMid</a>  - Return the probabilities of mid-circuit results.
%   <a href="matlab:help qclab.QSimulate.probabilitiesEnd">probabilitiesEnd</a>  - Return the probabilities of end-circuit results.
%   <a href="matlab:help qclab.QSimulate.counts">counts</a>            - Return the number of times each result was obtained for a given number of shots.
%   <a href="matlab:help qclab.QSimulate.countsMid">countsMid</a>         - Return the number of times each result was obtained for a given number of shots for mid-circuit results.
%   <a href="matlab:help qclab.QSimulate.countsEnd">countsEnd</a>         - Return the number of times each result was obtained for a given number of shots for end-circuit results.
%   <a href="matlab:help qclab.QSimulate.measuredQubits">measuredQubits</a>    - Return the qubits that were measured.
%   <a href="matlab:help qclab.QSimulate.measuredQubitsMid">measuredQubitsMid</a> - Return the qubits measured mid-circuit.
%   <a href="matlab:help qclab.QSimulate.measuredQubitsEnd">measuredQubitsEnd</a> - Return the qubits measured at the end of the circuit.
%   <a href="matlab:help qclab.QSimulate.densityMatrix">densityMatrix</a>     - Compute the density matrix of the whole quantum state.
%   <a href="matlab:help qclab.QSimulate.reducedStates">reducedStates</a>     - Compute the reduced states belonging to the qubits that haven't been measured in the end.
%   <a href="matlab:help qclab.QSimulate.basisChangeEnd">basisChangeEnd</a>    - Return the basis change for end-circuit measurements.
%   <a href="matlab:help qclab.QSimulate.equals">equals</a>            - Check if two QSimulate objects are equal.

%> @file QSimulate.m
%> @brief Implements QSimulate class.
% ==============================================================================
%> @class QSimulate
%> @brief Class for representing a quantum simulation.
%
%> This class stores the results, probabilities, and states of a
%> quantum simulation.
%
% (C) Copyright Sophia Keip, Daan Camps and Roel Van Beeumen 2025.
% ==============================================================================
classdef QSimulate < handle & ...
                     matlab.mixin.Copyable & ...
                     matlab.mixin.CustomDisplay

  properties (Access = protected)
    %> States of the quantum simulation.
    states_ cell
    %> Results of the quantum simulation.
    results_
    %> Probabilities of the quantum simulation.
    probabilities_ double
    %> Measurements of the quantum simulation.
    measurements_ cell
    %> seed of the quantum simulation.
    seed_ int32
  end

  % Constructor only accessible to QCircuit and tests
  methods (Access = {?qclab.QCircuit,?matlab.unittest.TestCase})
    %> @brief Constructor for quantum simulation
    %>
    %> Constructs a QSimulate object with the given states, results, 
    %> probabilities, and measurements.
    %>
    %> @param states A cell array of quantum states (vectors).
    %> @param results A cell array of results (binary strings).
    %> @param probabilities An array of doubles representing the probabilities 
    %>                      of the results.
    %> @param measurements A cell array of qclab.Measurement objects 
    %>                     representing measurements during the simulation.
    function obj = QSimulate(states, results, probabilities, measurements, seed)
      obj.states_ = states;
      obj.results_ = results;
      obj.probabilities_ = probabilities;
      obj.measurements_ = measurements;
      obj.seed_ = seed;
    end
  end

  methods
    %> @brief Return the quantum states of the simulation.
    %>
    %> @param obj Instance of QSimulate.
    %> @param pos Optional position index for a specific state.
    %> @retval states Quantum state(s) of the simulation.
    function states = states(obj, pos)
      % states - Return the state vectors belonging to the different
      %          results of the simulation.
      %
      % Syntax:
      %   states = obj.states()
      %   states = obj.states(pos)
      %
      % Inputs:
      %   pos - (optional) Index of the state vectors to return.
      %
      % Outputs:
      %   states - state vectors belonging to the different results of the 
      %            simulation. (cell array of vectors)
      if nargin < 2
        if numel(obj.states_) == 1
          states = obj.states_{1};
        else
          states = obj.states_;
        end
      else
        assert(qclab.isNonNegIntegerArray(pos - 1));
        states = obj.states_{pos};
      end
    end

    %> @brief Return the number of outcomes in the simulation.
    %>
    %> @param obj Instance of QSimulate.
    %> @retval nbOutcomes Number of results (states) in the simulation.
    function nbOutcomes = nbOutcomes(obj)
      % nbOutcomes - Return the number of outcomes of the simulation.
      %
      % Syntax:
      %   nbOutcomes = obj.nbOutcomes()
      %
      % Outputs:
      %   nbOutcomes - Number of outcomes (results) in the simulation.
      nbOutcomes = numel(obj.states_);
    end

    %> @brief Return the results of the simulation.
    %>
    %> @param obj Instance of QSimulate.
    %> @param pos Optional position index for specific result.
    %> @retval results Results of the simulation.
    function results = results(obj, pos)
      % results - Return the results of the simulation.
      %
      % Syntax:
      %   results = obj.results()
      %   results = obj.results(pos)
      %
      % Inputs:
      %   pos - (optional) Index of the result to return.
      %
      % Outputs:
      %   results - Results of the simulation (cell array of binary strings).
      if nargin < 2
        results = obj.results_;
      else
        assert(qclab.isNonNegIntegerArray(pos - 1));
        results = obj.results_{pos};
      end
    end

    %> @brief Return the results of mid-circuit measurements.
    %>
    %> @param obj Instance of QSimulate.
    %> @param pos Optional position index for specific mid-circuit result.
    %> @retval resultsMid Results of mid-circuit measurements.
    %> @retval idx indices of results with the same mid-circuit result.
    function [resultsMid, idx] = resultsMid(obj, pos)
      % resultsMid - Return the results of mid-circuit measurements.
      %
      % Syntax:
      %   resultsMid = obj.resultsMid()
      %   resultsMid = obj.resultsMid(pos)
      %
      % Inputs:
      %   pos - (optional) Index of the mid-circuit result to return.
      %
      % Outputs:
      %   resultsMid - Results of mid-circuit measurements (cell array).
      nbOutcomes = obj.nbOutcomes;
      resultsMid = cell(nbOutcomes, 1);
      if isempty(obj.measuredQubitsMid)
        resultsMid = {};
        idx = [];
      elseif isempty(obj.measuredQubitsEnd)
        resultsMid = obj.results_;
        idx = 1:length(resultsMid);
      else
        for i = 1:nbOutcomes
          result = obj.results_{i};
          measuredQubits = obj.measuredQubits();
          measuredQubitsEnd = obj.measuredQubitsEnd();
          indexEnd = arrayfun(@(x) find(measuredQubits == x, 1, 'last'), ...
                                        measuredQubitsEnd);
          resultsMid{i} = result(setdiff(1:length(measuredQubits), indexEnd));
        end
        % idx important to sum up probabilities in probabilitiesMid
        [resultsMid, ~, idx] = unique(resultsMid);
      end
      if nargin == 2
        assert(qclab.isNonNegIntegerArray(pos - 1));
        resultsMid = resultsMid{pos};
      end
    end

    %> @brief Return the results of end-circuit measurements.
    %>
    %> @param obj Instance of QSimulate.
    %> @param pos Optional position index for specific end-circuit result.
    %> @retval resultsEnd Results of end-circuit measurements.
    %> @retval idx indices of results with the same end-circuit result.
    function [resultsEnd, idx] = resultsEnd(obj, pos)
      % resultsEnd - Return the results of end-circuit measurements.
      %
      % Syntax:
      %   resultsEnd = obj.resultsEnd()
      %   resultsEnd = obj.resultsEnd(pos)
      %
      % Inputs:
      %   pos - (optional) Index of the end-circuit result to return.
      %
      % Outputs:
      %   resultsEnd - Results of end-circuit measurements (cell array).
      nbOutcomes = obj.nbOutcomes;
      resultsEnd = cell(nbOutcomes, 1);
      if isempty(obj.measuredQubits)
        resultsEnd = obj.results;
      elseif isempty(obj.measuredQubitsEnd)
        resultsEnd = {};
        idx = [];
      elseif isempty(obj.measuredQubitsMid)
        resultsEnd = obj.results_;
        idx = 1:length(resultsEnd);
      else
        for i = 1:nbOutcomes
          result = obj.results_{i};
          measuredQubits = obj.measuredQubits();
          measuredQubitsEnd = obj.measuredQubitsEnd();
          resultsEnd{i} = arrayfun(@(x) result( ...
            find(measuredQubits == x, 1, 'last')), measuredQubitsEnd);
        end
        % idx important to sum up probabilities in probabilitiesEnd
        [resultsEnd, ~, idx] = unique(resultsEnd);
      end
      if nargin == 2
        assert(qclab.isNonNegIntegerArray(pos - 1));
        resultsEnd = resultsEnd{pos};
      end
    end

    %> @brief Return the probabilities of the simulation results.
    %>
    %> @param obj Instance of QSimulate.
    %> @param pos Optional position index for specific probability.
    %> @retval probabilities Probabilities associated with each result.
    function probabilities = probabilities(obj, pos)
      % probabilities - Return the probabilities of the simulation results.
      %
      % Syntax:
      %   probabilities = obj.probabilities()
      %   probabilities = obj.probabilities(pos)
      %
      % Inputs:
      %   pos - (optional) Index of the probability to return.
      %
      % Outputs:
      %   probabilities - Probabilities of the results (array of doubles).
      if nargin < 2
        probabilities = obj.probabilities_;
      else
        assert(qclab.isNonNegIntegerArray(pos - 1));
        probabilities = obj.probabilities_(pos);
      end
    end

    %> @brief Return the probabilities of mid-circuit results.
    %>
    %> @param obj Instance of QSimulate.
    %> @param pos Optional position index for specific mid-circuit probability.
    %> @retval probabilitiesMid Probabilities associated with mid-circuit results.
    function probabilitiesMid = probabilitiesMid(obj, pos)
      % probabilitiesMid - Return the probabilities of mid-circuit results.
      %
      % Syntax:
      %   probabilitiesMid = obj.probabilitiesMid()
      %   probabilitiesMid = obj.probabilitiesMid(pos)
      %
      % Inputs:
      %   pos - (optional) Index of the mid-circuit probability to return.
      %
      % Outputs:
      %   probabilitiesMid - Probabilities of mid-circuit results 
      %                      (array of doubles).
      if isempty(obj.measuredQubitsMid)
        probabilitiesMid = [];
      else
        [resultsMid, idx] = obj.resultsMid;
        probabilitiesMid = zeros(size(resultsMid, 1), 1);
        for i = 1:length(obj.probabilities)
          probabilitiesMid(idx(i)) = probabilitiesMid(idx(i)) + ...
                                     obj.probabilities(i);
        end
      end
      if nargin == 2
        assert(qclab.isNonNegIntegerArray(pos - 1));
        probabilitiesMid = probabilitiesMid(pos);
      end
    end

    %> @brief Return the probabilities of end-circuit results.
    %>
    %> @param obj Instance of QSimulate.
    %> @param pos Optional position index for specific end-circuit probability.
    %> @retval probabilitiesEnd Probabilities associated with end-circuit results.
    function probabilitiesEnd = probabilitiesEnd(obj, pos)
      % probabilitiesEnd - Return the probabilities of end-circuit results.
      %
      % Syntax:
      %   probabilitiesEnd = obj.probabilitiesEnd()
      %   probabilitiesEnd = obj.probabilitiesEnd(pos)
      %
      % Inputs:
      %   pos - (optional) Index of the end-circuit probability to return.
      %
      % Outputs:
      %   probabilitiesEnd - Probabilities of end-circuit results 
      %                      (array of doubles).
      if isempty(obj.measuredQubitsEnd)
        probabilitiesEnd = [];
      else
        [resultsEnd, idx] = obj.resultsEnd;
        probabilitiesEnd = zeros(size(resultsEnd, 1), 1);
        for i = 1:length(obj.probabilities)
          probabilitiesEnd(idx(i)) = probabilitiesEnd(idx(i)) + obj.probabilities(i);
        end
      end
      if nargin == 2
        assert(qclab.isNonNegIntegerArray(pos - 1));
        probabilitiesEnd = probabilitiesEnd(pos);
      end
    end

    %> @brief Return the number of times each result was obtained for a given 
    %> number of shots.
    %>
    %> @param obj Instance of QSimulate.
    %> @param shots Number of shots (trials) to simulate.
    %> @retval counts Number of occurrences for each result.
    function counts = counts(obj, shots)
      % counts - Return the number of times each result was obtained for a given
      %          number of shots (trials).
      %
      % Syntax:
      %   counts = obj.counts(shots)
      %
      % Inputs:
      %   shots - Number of shots (trials) to simulate.
      %
      % Outputs:
      %   counts - Array of counts for each result
      %            (array of integers).
      prob = obj.probabilities_;
      counts = zeros(length(obj.results_), 1);
      cumprob = cumsum(prob);
      rng(obj.seed_) %setting seed
      for i = 1:shots
        rnd = rand;
        res_shot = find(cumprob >= rnd, 1);
        counts(res_shot) = counts(res_shot) + 1;
      end
    end

    %> @brief Return the number of times each mid-circuit result was obtained 
    %>        for a given number of shots.
    %>
    %> @param obj Instance of QSimulate.
    %> @param shots Number of shots (trials) to simulate.
    %> @retval countsMid Number of occurrences for each mid-circuit result.
    function countsMid = countsMid(obj, shots)
      % countsMid - Return the number of times each mid-circuit result was 
      %             obtained for a given number of shots (trials).
      %
      % Syntax:
      %   countsMid = obj.countsMid(shots)
      %
      % Inputs:
      %   shots - Number of shots (trials) to simulate.
      %
      % Outputs:
      %   countsMid - Array of counts for mid-circuit results
      %               (array of integers).
      if isempty(obj.measuredQubitsMid)
        countsMid = [];
      else
        [resultsMid, idx] = obj.resultsMid;
        countsMid = zeros(size(resultsMid, 1), 1);
        counts = obj.counts(shots);
        for i = 1:length(counts)
          countsMid(idx(i)) = countsMid(idx(i)) + counts(i);
        end
      end
    end

    %> @brief Return the number of times each end-circuit result was obtained 
    %>        for a given number of shots.
    %>
    %> @param obj Instance of QSimulate.
    %> @param shots Number of shots (trials) to simulate.
    %> @retval countsEnd Number of occurrences for each end-circuit result.
    function countsEnd = countsEnd(obj, shots)
      % countsEnd - Return the number of times each end-circuit result was 
      %             obtained for a given number of shots (trials).
      %
      % Syntax:
      %   countsEnd = obj.countsEnd(shots)
      %
      % Inputs:
      %   shots - Number of shots (trials) to simulate.
      %
      % Outputs:
      %   countsEnd - Array of counts for end-circuit results
      %               (array of integers).
      if isempty(obj.measuredQubitsEnd)
        countsEnd = [];
      else
        [resultsEnd, idx] = obj.resultsEnd;
        countsEnd = zeros(size(resultsEnd, 1), 1);
        counts = obj.counts(shots);
        for i = 1:length(counts)
          countsEnd(idx(i)) = countsEnd(idx(i)) + counts(i);
        end
      end
    end

    %> @brief Return the qubits that were measured.
    %>
    %> @param obj Instance of QSimulate.
    %> @param pos Optional position index for specific measured qubit.
    %> @retval measuredQubits Qubits that were measured during the simulation.
    function measuredQubits = measuredQubits(obj, pos)
      % measuredQubits - Return the qubits that were measured during simulation.
      %
      % Syntax:
      %   measuredQubits = obj.measuredQubits()
      %   measuredQubits = obj.measuredQubits(pos)
      %
      % Inputs:
      %   pos - (optional) Index of the measured qubit to return.
      %
      % Outputs:
      %   measuredQubits - Measured qubits during the simulation 
      %                    (array of integers).
      if nargin < 2
        measuredQubits = arrayfun(@(x) x.qubit, obj.measurements_{1});
      else
        assert(qclab.isNonNegIntegerArray(pos - 1));
        measuredQubits = arrayfun(@(x) x.qubit, obj.measurements_{1}(pos));
      end
    end

    %> @brief Return the qubits measured mid-circuit.
    %>
    %> @param obj Instance of QSimulate.
    %> @param pos Optional position index for specific mid-circuit qubit.
    %> @retval measuredQubitsMid Qubits measured during mid-circuit.
    function measuredQubitsMid = measuredQubitsMid(obj, pos)
      % measuredQubitsMid - Return the qubits measured mid-circuit.
      %
      % Syntax:
      %   measuredQubitsMid = obj.measuredQubitsMid()
      %   measuredQubitsMid = obj.measuredQubitsMid(pos)
      %
      % Inputs:
      %   pos - (optional) Index of the mid-circuit measured qubit to return.
      %
      % Outputs:
      %   measuredQubitsMid - Measured qubits during mid-circuit 
      %                       (array of integers).
      if nargin < 2
        measuredQubitsMid = arrayfun(@(x) x.qubit, obj.measurements_{2});
      else
        assert(qclab.isNonNegIntegerArray(pos - 1));
        measuredQubitsMid = arrayfun(@(x) x.qubit, obj.measurements_{2}(pos));
      end
    end

    %> @brief Return the qubits measured at the end of the circuit.
    %>
    %> @param obj Instance of QSimulate.
    %> @param pos Optional position index for specific end-circuit qubit.
    %> @retval measuredQubitsEnd Qubits measured at the end of the circuit.
    function measuredQubitsEnd = measuredQubitsEnd(obj, pos)
      % measuredQubitsEnd - Return the qubits measured at the end of the circuit.
      %
      % Syntax:
      %   measuredQubitsEnd = obj.measuredQubitsEnd()
      %   measuredQubitsEnd = obj.measuredQubitsEnd(pos)
      %
      % Inputs:
      %   pos - (optional) Index of the end-circuit measured qubit to return.
      %
      % Outputs:
      %   measuredQubitsEnd - Measured qubits at the end of the circuit 
      %                       (array of integers).
      if nargin < 2
        measuredQubitsEnd = arrayfun(@(x) x.qubit, obj.measurements_{3});
      else
        assert(qclab.isNonNegIntegerArray(pos - 1));
        measuredQubitsEnd = arrayfun(@(x) x.qubit, obj.measurements_{3}(pos));
      end
    end

    %> @brief Compute the density matrix of the whole quantum state.
    %>
    %> @param obj Instance of QSimulate.
    %> @retval rho Density matrix of the quantum state.
    function rho = densityMatrix(obj)
      % densityMatrix - Compute the density matrix of the whole quantum state.
      %
      % Syntax:
      %   rho = obj.densityMatrix()
      %
      % Outputs:
      %   rho - Density matrix of the whole quantum state (double).
      if obj.nbOutcomes == 1
        rho = obj.states * obj.states';
      else
        rho = zeros(length(obj.states_{1}));
        for i = 1:obj.nbOutcomes
          rho = rho + obj.probabilities(i) * (obj.states(i) * obj.states(i)');
        end
      end
    end

    %> @brief Compute the reduced states of the qubits that haven't been measured.
    %>
    %> @param obj Instance of QSimulate.
    %> @param pos Optional position index for specific reduced state.
    %> @retval reducedStates Reduced quantum states for unmeasured qubits.
    function reducedStates = reducedStates(obj, pos)
      % reducedStates - Compute the reduced states for qubits, that have not 
      %                 been measured in the end of the circuit.
      %
      % Syntax:
      %   reducedStates = obj.reducedStates()
      %   reducedStates = obj.reducedStates(pos)
      %
      % Inputs:
      %   pos - (optional) Index of the reduced state to return.
      %
      % Outputs:
      %   reducedStates - Reduced state vectors for qubits, that have not 
      %                   been measured in the end (cell array of vectors).
      nbOutcomes = obj.nbOutcomes;
      reducedStates = cell(nbOutcomes, 1);
      if isempty(obj.measuredQubitsEnd)
        reducedStates = obj.states;
      else
        [resultsEnd, idx] = obj.resultsEnd;
        for i = 1:nbOutcomes
          statevector = obj.states(i);
          reducedStates{i} = qclab.reducedStatevector(statevector, ...
            obj.measuredQubitsEnd, resultsEnd(idx(i)), obj.basisChangeEnd);
        end
      end
      if nargin == 2
        assert(qclab.isNonNegIntegerArray(pos - 1));
        reducedStates = reducedStates{pos};
      end
    end

    %> @brief Return the basis change for end-circuit measurements.
    %>
    %> @param obj Instance of QSimulate.
    %> @param pos Optional position index for specific basis change.
    %> @retval basisChangeEnd Basis change for end-circuit measurements.
    function basisChangeEnd = basisChangeEnd(obj, pos)
      % basisChangeEnd - Return the basis change for end-circuit measurements.
      %
      % Syntax:
      %   basisChangeEnd = obj.basisChangeEnd()
      %   basisChangeEnd = obj.basisChangeEnd(pos)
      %
      % Inputs:
      %   pos - (optional) Index of the end-circuit basis change to return.
      %
      % Outputs:
      %   basisChangeEnd - Basis change for end-circuit measurements (cell array).
      if nargin < 2
        basisChangeEnd = arrayfun(@(x) x.basisChange, obj.measurements_{3}, ...
          'UniformOutput', false);
      else
        assert(qclab.isNonNegIntegerArray(pos - 1));
        basisChangeEnd = obj.measurements_{3}(pos).basisChange;
      end
    end

    %> @brief Check if a QSimulate object is equal to another object.
    %>
    %> @param obj Instance of QSimulate.
    %> @param other Another object to compare.
    %> @retval bool True if the two objects are equal, false otherwise.
    function [bool] = equals(obj, other)
      % equals - Check if a QSimulate object is equal to another object.
      %
      % Syntax:
      %   bool = obj.equals(other)
      %
      % Inputs:
      %   other - Another QSimulate object to compare.
      %
      % Outputs:
      %   bool - True if the objects are equal, false otherwise.
      if ~isa(other, 'qclab.QSimulate')
        bool = false;
        return;
      end

      if obj.nbOutcomes() ~= other.nbOutcomes()
        bool = false;
        return;
      end

      for i = 1:obj.nbOutcomes()
        state1 = obj.states(i);
        state2 = other.states(i);
        if max(abs(state1(:) - state2(:))) > 5 * eps
          bool = false;
          return;
        end
      end

      if ~isequal(obj.results(), other.results()) || ...
         max(abs(obj.probabilities() - other.probabilities())) > 5 * eps || ...
         ~isequal(obj.measurements_, other.measurements_)
        bool = false;
        return;
      end

      bool = true;
    end
  end

   methods ( Access = protected )
    %> display Heterogeneous header
    function header = getHeader(obj)
         object = matlab.mixin.CustomDisplay.getClassNameForHeader(obj);
         headerStr = [object ' with properties '];
         header =  sprintf('%s\n',headerStr);
    end
    
    %> Property groups
    function groups = getPropertyGroups(obj)
     import matlab.mixin.util.PropertyGroup
     props = struct();
     props.nbOutcomes = obj.nbOutcomes;  
     props.measuredQubits = obj.measuredQubits;  
     props.results = obj.results;
     props.probabilities = obj.probabilities;
     props.states = obj.states;
     groups = PropertyGroup(props);
    end
  end
end % class QSimulate
