classdef test_qclab_QSimulate < matlab.unittest.TestCase
  methods (Test)
    function test_QSimulate_states_nbOutcomes(test)
      % no measurements
      sim = qclab.QSimulate({[1/sqrt(2);0;1/sqrt(2);0]},{'00';'10'},[0.5;0.5]...
        ,{[qclab.Measurement(0),qclab.Measurement(1)],[],...
        [qclab.Measurement(0),qclab.Measurement(1)]},1);
      % states
      test.verifyEqual(sim.states(),[1/sqrt(2);0;1/sqrt(2);0])
      test.verifyEqual(sim.states(1),[1/sqrt(2);0;1/sqrt(2);0])

      % nbOutcomes
      test.verifyEqual(sim.nbOutcomes,1)

      % just end circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0];...
        [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
        {[qclab.Measurement],[],[qclab.Measurement]},1);

      % states
      test.verifyEqual(sim.states(),{[1/sqrt(2);1/sqrt(2);0;0];...  
                      [0;0;1/sqrt(2);1/sqrt(2)]})
      test.verifyEqual(sim.states(1),[1/sqrt(2);1/sqrt(2);0;0])
      states = sim.states();
      test.verifyEqual(numel(states),2)

      % nbOutcomes
      test.verifyEqual(sim.nbOutcomes,2)

      % just mid circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0];...
                            [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
        {[qclab.Measurement(0)], ...
        [qclab.Measurement(0)],[]},1);

      % states
      test.verifyEqual(sim.states(),{[1/sqrt(2);1/sqrt(2);0;0];...
                      [0;0;1/sqrt(2);1/sqrt(2)]})
      test.verifyEqual(sim.states(1),[1/sqrt(2);1/sqrt(2);0;0])
      states = sim.states();
      test.verifyEqual(numel(states),2)

      % nbOutcomes
      test.verifyEqual(sim.nbOutcomes,2)

      % mid and end circuit measurements
      sim = qclab.QSimulate({[0;1;0;0];[0;0;0;1]},{'01';'11'},[0.4;0.6], ...
        {[qclab.Measurement, qclab.Measurement(1)], ...
        [qclab.Measurement],[qclab.Measurement(1)]},1);

      % states
      test.verifyEqual(sim.states(),{[0;1;0;0];[0;0;0;1]})
      test.verifyEqual(sim.states(1),[0;1;0;0])
      states = sim.states();
      test.verifyEqual(numel(states),2)

      % nbOutcomes
      test.verifyEqual(sim.nbOutcomes,2)

      %qubit circuit
      sim = qclab.QSimulate({[1;0];[0;1]},{'0';'1'},[0.4;0.6], ...
        {[qclab.Measurement(0)],[],[qclab.Measurement(0)]},1);

      % states
      test.verifyEqual(sim.states(),{[1;0];[0;1]})
      test.verifyEqual(sim.states(1),[1;0])
      states = sim.states();
      test.verifyEqual(numel(states),2)

      % nbOutcomes
      test.verifyEqual(sim.nbOutcomes,2)

      %3 qubit circuit
      sim = qclab.QSimulate({[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [0.5;0.5;-0.5;-0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;0.5;0.5;-0.5;-0.5];[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [-0.5;-0.5;0.5;0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;-0.5;-0.5;0.5;0.5]}, ...
        {'00000';'00001';'00010';'00011';'00100';'00101';'00110';'00111'}, ...
        [0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250], ...
        {[qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1),qclab.Measurement(0),qclab.Measurement(1,'x')], ...
        [qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1)],[qclab.Measurement(0),qclab.Measurement(1,'x')]},1);
 
      % states
      test.verifyEqual(sim.states(),{[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [0.5;0.5;-0.5;-0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;0.5;0.5;-0.5;-0.5];[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [-0.5;-0.5;0.5;0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;-0.5;-0.5;0.5;0.5]})
      test.verifyEqual(sim.states(1),[0.5;0.5;0.5;0.5;0;0;0;0])
      states = sim.states();
      test.verifyEqual(numel(states),8)

      % nbOutcomes
      test.verifyEqual(sim.nbOutcomes,8)

    end


    function test_QSimulate_results_mid_end(test)
      % no measurements
      sim = qclab.QSimulate({[1/sqrt(2);0;1/sqrt(2);0]},{'00';'10'},...
                    [0.5;0.5],{[qclab.Measurement(0),qclab.Measurement(1)],...
                    [],[qclab.Measurement(0),qclab.Measurement(1)]},1);

      % results
      test.verifyEqual(sim.results(),{'00';'10'})
      test.verifyEqual(sim.results(1),'00')
      results = sim.results();
      test.verifyEqual(numel(results),2)

      % resultsMid
      test.verifyEqual(sim.resultsMid(),{})

      % resultsEnd
      test.verifyEqual(sim.resultsEnd(),{'00';'10'})
      test.verifyEqual(sim.resultsEnd(1),'00')
      resultsEnd = sim.resultsEnd();
      test.verifyEqual(length(resultsEnd),2)

      % just end circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0];...
                    [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
                    {[qclab.Measurement],[],[qclab.Measurement]},1);

      % results
      test.verifyEqual(sim.results(),{'0';'1'})
      test.verifyEqual(sim.results(1),'0')
      results = sim.results();
      test.verifyEqual(numel(results),2)

      % resultsMid
      test.verifyEqual(sim.resultsMid(),{})

      % resultsEnd
      test.verifyEqual(sim.resultsEnd(),{'0';'1'})
      test.verifyEqual(sim.resultsEnd(1),'0')
      resultsEnd = sim.resultsEnd();
      test.verifyEqual(length(resultsEnd),2)

      % just mid circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0]; ...
              [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
              {[qclab.Measurement(0)],[qclab.Measurement(0)],[]},1);

      % results
      test.verifyEqual(sim.results(),{'0';'1'})
      test.verifyEqual(sim.results(1),'0')
      results = sim.results();
      test.verifyEqual(numel(results),2)

      % resultsEnd
      test.verifyEqual(sim.resultsEnd(),{})

      % resultsMid
      test.verifyEqual(sim.resultsMid(),{'0';'1'})
      test.verifyEqual(sim.resultsMid(1),'0')
      resultsMid = sim.resultsMid();
      test.verifyEqual(length(resultsMid),2)

      % mid and end circuit measurements
      sim = qclab.QSimulate({[0;1;0;0];[0;0;0;1]},{'01';'11'},[0.4;0.6], ...
        {[qclab.Measurement, qclab.Measurement(1)], ...
        [qclab.Measurement],[qclab.Measurement(1)]},1);

      % results
      test.verifyEqual(sim.results(),{'01';'11'})
      test.verifyEqual(sim.results(1),'01')
      results = sim.results();
      test.verifyEqual(numel(results),2)

      % resultsMid
      test.verifyEqual(sim.resultsMid(),{'0';'1'})
      test.verifyEqual(sim.resultsMid(1),'0')
      resultsMid = sim.resultsMid();
      test.verifyEqual(length(resultsMid),2)

      % resultsEnd
      test.verifyEqual(sim.resultsEnd(),{'1'})
      test.verifyEqual(sim.resultsEnd(1),'1')
      resultsEnd = sim.resultsEnd();
      test.verifyEqual(length(resultsEnd),1)

      %1 qubit circuit
      sim = qclab.QSimulate({[1;0];[0;1]},{'0';'1'},[0.4;0.6], ...
        {[qclab.Measurement],[],[qclab.Measurement()]},1);

      % results
      test.verifyEqual(sim.results(),{'0';'1'})
      test.verifyEqual(sim.results(1),'0')
      results = sim.results();
      test.verifyEqual(numel(results),2)

      % resultsMid
      test.verifyEqual(sim.resultsMid(),{})
      resultsMid = sim.resultsMid();
      test.verifyEqual(length(resultsMid),0)

      % resultsEnd
      test.verifyEqual(sim.resultsEnd(),{'0';'1'})
      test.verifyEqual(sim.resultsEnd(1),'0')
      resultsEnd = sim.resultsEnd();
      test.verifyEqual(length(resultsEnd),2)

      %3 qubit circuit
      sim = qclab.QSimulate({[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [0.5;0.5;-0.5;-0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;0.5;0.5;-0.5;-0.5];[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [-0.5;-0.5;0.5;0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;-0.5;-0.5;0.5;0.5]}, ...
        {'00000';'00001';'00010';'00011';'00100';'00101';'00110';'00111'}, ...
        [0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250], ...
        {[qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1),qclab.Measurement(0),qclab.Measurement(1,'x')], ...
        [qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1)],[qclab.Measurement(0),qclab.Measurement(1,'x')]},1);
      
      % results
      test.verifyEqual(sim.results(),{'00000';'00001';'00010';'00011'; ...
        '00100';'00101';'00110';'00111'})
      test.verifyEqual(sim.results(1),'00000')
      results = sim.results();
      test.verifyEqual(numel(results),8)

      % resultsMid
      test.verifyEqual(sim.resultsMid(),{'000';'001'})
      test.verifyEqual(sim.resultsMid(1),'000')
      resultsMid = sim.resultsMid();
      test.verifyEqual(length(resultsMid),2)

      % resultsEnd
      test.verifyEqual(sim.resultsEnd(),{'00';'01';'10';'11'})
      test.verifyEqual(sim.resultsEnd(1),'00')
      resultsEnd = sim.resultsEnd();
      test.verifyEqual(length(resultsEnd),4)
    end


    function test_QSimulate_probabilities_mid_end(test)
      % no measurements
      sim = qclab.QSimulate({[1/sqrt(2);0;1/sqrt(2);0]},{'00';'10'},[0.5;0.5],...
                  {[qclab.Measurement(0),qclab.Measurement(1)],[],...
                  [qclab.Measurement(0),qclab.Measurement(1)]},1);
      
      % probabilities
      test.verifyEqual(sim.probabilities(),[0.5;0.5])
      test.verifyEqual(sim.probabilities(1),0.5)
      probabilities = sim.probabilities();
      test.verifyEqual(length(probabilities),2)

      % probabilities mid
      test.verifyEqual(sim.probabilitiesMid(),[])
      probabilitiesMid = sim.probabilitiesMid();
      test.verifyEqual(length(probabilitiesMid),0)

      % probabilities end
      test.verifyEqual(sim.probabilitiesEnd(),[0.5;0.5])
      test.verifyEqual(sim.probabilitiesEnd(1),0.5)
      probabilitiesEnd = sim.probabilitiesEnd();
      test.verifyEqual(length(probabilitiesEnd),2)

      % just end circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0];...
                [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
                {[qclab.Measurement],[],[qclab.Measurement]},1);

      % probabilities
      test.verifyEqual(sim.probabilities(),[0.5;0.5])
      test.verifyEqual(sim.probabilities(1),0.5)
      probabilities = sim.probabilities();
      test.verifyEqual(length(probabilities),2)

      % probabilities mid
      test.verifyEqual(sim.probabilitiesMid(),[])
      probabilitiesMid = sim.probabilitiesMid();
      test.verifyEqual(length(probabilitiesMid),0)

      % probabilities end
      test.verifyEqual(sim.probabilitiesEnd(),[0.5;0.5])
      test.verifyEqual(sim.probabilitiesEnd(1),0.5)
      probabilitiesEnd = sim.probabilitiesEnd();
      test.verifyEqual(length(probabilitiesEnd),2)

      % just mid circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0];...
                    [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
                    {[qclab.Measurement(0)],[qclab.Measurement(0)],[]},1);

      % probabilities
      test.verifyEqual(sim.probabilities(),[0.5;0.5])
      test.verifyEqual(sim.probabilities(1),0.5)
      probabilities = sim.probabilities();
      test.verifyEqual(length(probabilities),2)

      % probabilities mid
      test.verifyEqual(sim.probabilitiesMid(),[0.5;0.5])
      test.verifyEqual(sim.probabilitiesMid(1),0.5)
      probabilitiesMid = sim.probabilitiesMid();
      test.verifyEqual(length(probabilitiesMid),2)

      % probabilities end
      test.verifyEqual(sim.probabilitiesEnd(),[])
      probabilitiesEnd = sim.probabilitiesEnd();
      test.verifyEqual(length(probabilitiesEnd),0)

      % mid and end circuit measurements
      sim = qclab.QSimulate({[0;1;0;0];[0;0;0;1]},{'01';'11'},[0.4;0.6], ...
        {[qclab.Measurement, qclab.Measurement(1)], ...
        [qclab.Measurement],[qclab.Measurement(1)]},1);

      % probabilities
      test.verifyEqual(sim.probabilities(),[0.4;0.6])
      test.verifyEqual(sim.probabilities(1),0.4)
      probabilities = sim.probabilities();
      test.verifyEqual(length(probabilities),2)

      % probabilities mid
      test.verifyEqual(sim.probabilitiesMid(),[0.4;0.6])
      test.verifyEqual(sim.probabilitiesMid(1),0.4)
      probabilitiesMid = sim.probabilitiesMid();
      test.verifyEqual(length(probabilitiesMid),2)

      % probabilities end
      test.verifyEqual(sim.probabilitiesEnd(),[1])
      test.verifyEqual(sim.probabilitiesEnd(1),1)
      probabilitiesEnd = sim.probabilitiesEnd();
      test.verifyEqual(length(probabilitiesEnd),1)

      %1 qubit circuit
      sim = qclab.QSimulate({[1;0];[0;1]},{'0';'1'},[0.4;0.6], ...
        {[qclab.Measurement],[],[qclab.Measurement()]},1);

      % probabilities
      test.verifyEqual(sim.probabilities(),[0.4;0.6])
      test.verifyEqual(sim.probabilities(1),0.4)
      probabilities = sim.probabilities();
      test.verifyEqual(length(probabilities),2)

      % probabilities mid
      test.verifyEqual(sim.probabilitiesMid(),[])
      probabilitiesMid = sim.probabilitiesMid();
      test.verifyEqual(length(probabilitiesMid),0)

      % probabilities end
      test.verifyEqual(sim.probabilitiesEnd(),[0.4;0.6])
      test.verifyEqual(sim.probabilitiesEnd(1),0.4)
      probabilitiesEnd = sim.probabilitiesEnd();
      test.verifyEqual(length(probabilitiesEnd),2)

      sim = qclab.QSimulate({[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [0.5;0.5;-0.5;-0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;0.5;0.5;-0.5;-0.5];[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [-0.5;-0.5;0.5;0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;-0.5;-0.5;0.5;0.5]}, ...
        {'00000';'00001';'00010';'00011';'00100';'00101';'00110';'00111'}, ...
        [0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250], ...
        {[qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1),qclab.Measurement(0),qclab.Measurement(1,'x')], ...
        [qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1)],[qclab.Measurement(0),qclab.Measurement(1,'x')]},1);

      % probabilities
      test.verifyEqual(sim.probabilities(),[0.1250;0.1250;0.1250;0.1250; ...
        0.1250;0.1250;0.1250;0.1250])
      test.verifyEqual(sim.probabilities(1),0.125)
      probabilities = sim.probabilities();
      test.verifyEqual(length(probabilities),8)

      % probabilities mid
      test.verifyEqual(sim.probabilitiesMid(),[0.5;0.5])
      test.verifyEqual(sim.probabilitiesMid(1),0.5)
      probabilitiesMid = sim.probabilitiesMid();
      test.verifyEqual(length(probabilitiesMid),2)

      % probabilities end
      test.verifyEqual(sim.probabilitiesEnd(),[0.25;0.25;0.25;0.25])
      test.verifyEqual(sim.probabilitiesEnd(1),0.25)
      probabilitiesEnd = sim.probabilitiesEnd();
      test.verifyEqual(length(probabilitiesEnd),4)

    end

    function test_QSimulate_counts_end_mid(test)
      
      shots = 1000;
      % no measurements
      sim = qclab.QSimulate({[1/sqrt(2);0;1/sqrt(2);0]},{'00';'10'},...
                  [0.5;0.5],{[qclab.Measurement(0),qclab.Measurement(1)],...
                  [],[qclab.Measurement(0),qclab.Measurement(1)]},1);
      
      % counts
      rng(1)
      test.verifyEqual(sim.counts(shots),[494;506])
      counts = sim.counts(shots);
      test.verifyEqual(length(counts),2)

      % counts mid
      rng(1)
      test.verifyEqual(sim.countsMid(shots),[])
      countsMid = sim.countsMid(shots);
      test.verifyEqual(length(countsMid),0)

      % counts end
      rng(1)
      test.verifyEqual(sim.countsEnd(shots),[494;506])
      countsEnd = sim.countsEnd(shots);
      test.verifyEqual(length(countsEnd),2)

      % just end circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0];...
                    [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
                    {[qclab.Measurement],[],[qclab.Measurement]},1);

      % counts
      rng(1)
      test.verifyEqual(sim.counts(shots),[494;506])
      counts = sim.counts(shots);
      test.verifyEqual(length(counts),2)

      % counts mid
      rng(1)
      test.verifyEqual(sim.countsMid(shots),[])
      countsMid = sim.countsMid(shots);
      test.verifyEqual(length(countsMid),0)

      % counts end
      rng(1)
      test.verifyEqual(sim.countsEnd(shots),[494;506])
      countsEnd = sim.countsEnd(shots);
      test.verifyEqual(length(countsEnd),2)

      % just mid circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0]; ...
                    [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
                    {[qclab.Measurement(0)],[qclab.Measurement(0)],[]},1);

      % counts
      rng(1)
      test.verifyEqual(sim.counts(shots),[494;506])
      counts = sim.counts(shots);
      test.verifyEqual(length(counts),2)

      % counts mid
      rng(1)
      test.verifyEqual(sim.countsMid(shots),[494;506])
      countsMid = sim.countsMid(shots);
      test.verifyEqual(length(countsMid),2)

      % counts end
      rng(1)
      test.verifyEqual(sim.countsEnd(shots),[])
      countsEnd = sim.countsEnd(shots);
      test.verifyEqual(length(countsEnd),0)

      % mid and end circuit measurements
      sim = qclab.QSimulate({[0;1;0;0];[0;0;0;1]},{'01';'11'},[0.4;0.6], ...
        {[qclab.Measurement, qclab.Measurement(1)], ...
        [qclab.Measurement],[qclab.Measurement(1)]},1);

      % counts
      rng(1)
      test.verifyEqual(sim.counts(shots),[389;611])
      counts = sim.counts(shots);
      test.verifyEqual(length(counts),2)

      % counts mid
      rng(1)
      test.verifyEqual(sim.countsMid(shots),[389;611])
      countsMid = sim.countsMid(shots);
      test.verifyEqual(length(countsMid),2)

      % counts end
      rng(1)
      test.verifyEqual(sim.countsEnd(shots),[1000])
      countsEnd = sim.countsEnd(shots);
      test.verifyEqual(length(countsEnd),1)

      %1 qubit circuit
      sim = qclab.QSimulate({[1;0];[0;1]},{'0';'1'},[0.4;0.6], ...
        {[qclab.Measurement],[],[qclab.Measurement()]},1);

      % counts
      rng(1)
      test.verifyEqual(sim.counts(shots),[389;611])
      counts = sim.counts(shots);
      test.verifyEqual(length(counts),2)

      % counts mid
      rng(1)
      test.verifyEqual(sim.countsMid(shots),[])
      countsMid = sim.countsMid(shots);
      test.verifyEqual(length(countsMid),0)

      % counts end
      rng(1)
      test.verifyEqual(sim.countsEnd(shots),[389;611])
      countsEnd = sim.countsEnd(shots);
      test.verifyEqual(length(countsEnd),2)
      
      %3 qubits
      sim = qclab.QSimulate({[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [0.5;0.5;-0.5;-0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;0.5;0.5;-0.5;-0.5];[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [-0.5;-0.5;0.5;0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;-0.5;-0.5;0.5;0.5]}, ...
        {'00000';'00001';'00010';'00011';'00100';'00101';'00110';'00111'}, ...
        [0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250], ...
        {[qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1),qclab.Measurement(0),qclab.Measurement(1,'x')], ...
        [qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1)],[qclab.Measurement(0),qclab.Measurement(1,'x')]},1);

      % counts
      rng(1)
      test.verifyEqual(sim.counts(shots),[119;130;117;128;134;118;130;124])
      counts = sim.counts(shots);
      test.verifyEqual(length(counts),8)

      % counts mid
      rng(1)
      test.verifyEqual(sim.countsMid(shots),[494;506])
      countsMid = sim.countsMid(shots);
      test.verifyEqual(length(countsMid),2)

      % counts end
      rng(1)
      test.verifyEqual(sim.countsEnd(shots),[253;248;247;252])
      countsEnd = sim.countsEnd(shots);
      test.verifyEqual(length(countsEnd),4)
    end
    
    function test_QSimulate_measuredQubits_mid_end(test)
      % no measurements
      sim = qclab.QSimulate({[1/sqrt(2);0;1/sqrt(2);0]},{'00';'10'},[0.5;0.5], ...
        {[qclab.Measurement(0),qclab.Measurement(1)],[],[qclab.Measurement(0), ...
        qclab.Measurement(1)]},1);

       % measuredQubits
      test.verifyEqual(sim.measuredQubits(),int32([0,1]))
      test.verifyEqual(sim.measuredQubits(1),int32(0))
      measuredQubits = sim.measuredQubits();
      test.verifyEqual(length(measuredQubits),2)

      % measuredQubitsMid
      test.verifyEqual(sim.measuredQubitsMid(),[])
      measuredQubitsMid = sim.measuredQubitsMid();
      test.verifyEqual(length(measuredQubitsMid),0)

      % measuredQubitsEnd
      test.verifyEqual(sim.measuredQubitsEnd(),int32([0,1]))
      test.verifyEqual(sim.measuredQubitsEnd(1),int32(0))
      measuredQubitsEnd = sim.measuredQubitsEnd();
      test.verifyEqual(length(measuredQubitsEnd),2)

      % just end circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0];...
                      [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
                      {[qclab.Measurement],[],[qclab.Measurement]},1);

       % measuredQubits
      test.verifyEqual(sim.measuredQubits(),int32(0))
      test.verifyEqual(sim.measuredQubits(1),int32(0))
      measuredQubits = sim.measuredQubits();
      test.verifyEqual(length(measuredQubits),1)

      % measuredQubitsMid
      test.verifyEqual(sim.measuredQubitsMid(),[])
      measuredQubitsMid = sim.measuredQubitsMid();
      test.verifyEqual(length(measuredQubitsMid),0)

      % measuredQubitsEnd
      test.verifyEqual(sim.measuredQubitsEnd(),int32(0))
      test.verifyEqual(sim.measuredQubitsEnd(1),int32(0))
      measuredQubitsEnd = sim.measuredQubitsEnd();
      test.verifyEqual(length(measuredQubitsEnd),1)

      % just mid circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0];...
                      [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
                      {[qclab.Measurement(0)],[qclab.Measurement(0)],[]},1);

      % measuredQubits
      test.verifyEqual(sim.measuredQubits(),int32(0))
      test.verifyEqual(sim.measuredQubits(1),int32(0))
      measuredQubits = sim.measuredQubits();
      test.verifyEqual(length(measuredQubits),1)

      % measuredQubitsMid
      test.verifyEqual(sim.measuredQubitsMid(),int32(0))
      test.verifyEqual(sim.measuredQubitsMid(1),int32(0))
      measuredQubitsMid = sim.measuredQubitsMid();
      test.verifyEqual(length(measuredQubitsMid),1)

      % measuredQubitsEnd
      test.verifyEqual(sim.measuredQubitsEnd(),[])
      measuredQubitsEnd = sim.measuredQubitsEnd();
      test.verifyEqual(length(measuredQubitsEnd),0)

      % mid and end circuit measurements
      sim = qclab.QSimulate({[0;1;0;0];[0;0;0;1]},{'01';'11'},[0.4;0.6], ...
        {[qclab.Measurement, qclab.Measurement(1)], ...
        [qclab.Measurement],[qclab.Measurement(1)]},1);

      % measuredQubits
      test.verifyEqual(sim.measuredQubits(),int32([0,1]))
      test.verifyEqual(sim.measuredQubits(1),int32(0))
      measuredQubits = sim.measuredQubits();
      test.verifyEqual(length(measuredQubits),2)

      % measuredQubitsMid
      test.verifyEqual(sim.measuredQubitsMid(),int32(0))
      test.verifyEqual(sim.measuredQubitsMid(1),int32(0))
      measuredQubitsMid = sim.measuredQubitsMid();
      test.verifyEqual(length(measuredQubitsMid),1)

      % measuredQubitsEnd
      test.verifyEqual(sim.measuredQubitsEnd(),int32(1))
      test.verifyEqual(sim.measuredQubitsEnd(1),int32(1))
      measuredQubitsEnd = sim.measuredQubitsEnd();
      test.verifyEqual(length(measuredQubitsEnd),1)

      %1 qubit circuit
      sim = qclab.QSimulate({[1;0];[0;1]},{'0';'1'},[0.4;0.6], ...
        {[qclab.Measurement],[],[qclab.Measurement()]},1);

      % measuredQubits
      test.verifyEqual(sim.measuredQubits(),int32(0))
      test.verifyEqual(sim.measuredQubits(1),int32(0))
      measuredQubits = sim.measuredQubits();
      test.verifyEqual(length(measuredQubits),1)

      % measuredQubitsMid
      test.verifyEqual(sim.measuredQubitsMid(),[])
      measuredQubitsMid = sim.measuredQubitsMid();
      test.verifyEqual(length(measuredQubitsMid),0)

      % measuredQubitsEnd
      test.verifyEqual(sim.measuredQubitsEnd(),int32(0))
      test.verifyEqual(sim.measuredQubitsEnd(1),int32(0))
      measuredQubitsEnd = sim.measuredQubitsEnd();
      test.verifyEqual(length(measuredQubitsEnd),1)

      % 3 qubits
      sim = qclab.QSimulate({[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [0.5;0.5;-0.5;-0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;0.5;0.5;-0.5;-0.5];[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [-0.5;-0.5;0.5;0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;-0.5;-0.5;0.5;0.5]}, ...
        {'00000';'00001';'00010';'00011';'00100';'00101';'00110';'00111'}, ...
        [0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250], ...
        {[qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1),qclab.Measurement(0),qclab.Measurement(1,'x')], ...
        [qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1)],[qclab.Measurement(0),qclab.Measurement(1,'x')]},1);

      % measuredQubits
      test.verifyEqual(sim.measuredQubits(),int32([1,0,1,0,1]))
      test.verifyEqual(sim.measuredQubits(1),int32(1))
      measuredQubits = sim.measuredQubits();
      test.verifyEqual(length(measuredQubits),5)

      % measuredQubitsMid
      test.verifyEqual(sim.measuredQubitsMid(),int32([1,0,1]))
      test.verifyEqual(sim.measuredQubitsMid(1),int32(1))
      measuredQubitsMid = sim.measuredQubitsMid();
      test.verifyEqual(length(measuredQubitsMid),3)

      % measuredQubitsEnd
      test.verifyEqual(sim.measuredQubitsEnd(),int32([0,1]))
      test.verifyEqual(sim.measuredQubitsEnd(1),int32(0))
      measuredQubitsEnd = sim.measuredQubitsEnd();
      test.verifyEqual(length(measuredQubitsEnd),2)

    end

    function test_QSimulate_densityMatrix(test)
      
      % no measurements
      sim = qclab.QSimulate({[1/sqrt(2);0;1/sqrt(2);0]},{'00';'10'},...
                      [0.5;0.5],{[qclab.Measurement(0),qclab.Measurement(1)],...
                      [],[qclab.Measurement(0), qclab.Measurement(1)]},1);

      dens = [1/sqrt(2);0;1/sqrt(2);0]*[1/sqrt(2);0;1/sqrt(2);0]';
      test.verifyEqual( sim.densityMatrix, dens, 'AbsTol', eps )

      % just end circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0];...
                      [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
                      {[qclab.Measurement],[],[qclab.Measurement]},1);

      dens = 0.5 * [1/sqrt(2);1/sqrt(2);0;0]*[1/sqrt(2);1/sqrt(2);0;0]' ...
            + 0.5 * [0;0;1/sqrt(2);1/sqrt(2)]*[0;0;1/sqrt(2);1/sqrt(2)]';
      test.verifyEqual( sim.densityMatrix, dens, 'AbsTol', eps )

      % just mid circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0];...
                      [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
                      {[qclab.Measurement(0)],[qclab.Measurement(0)],[]},1);
      dens = 0.5 * [1/sqrt(2);1/sqrt(2);0;0]*[1/sqrt(2);1/sqrt(2);0;0]' ...
            + 0.5 * [0;0;1/sqrt(2);1/sqrt(2)]*[0;0;1/sqrt(2);1/sqrt(2)]';
      test.verifyEqual( sim.densityMatrix, dens, 'AbsTol', eps )

      % mid and end circuit measurements
      sim = qclab.QSimulate({[0;1;0;0];[0;0;0;1]},{'01';'11'},[0.4;0.6], ...
        {[qclab.Measurement, qclab.Measurement(1)], ...
        [qclab.Measurement],[qclab.Measurement(1)]},1);

      dens = 0.4 * [0;1;0;0]*[0;1;0;0]' + 0.6 * [0;0;0;1]*[0;0;0;1]';
      test.verifyEqual( sim.densityMatrix, dens, 'AbsTol', eps )

      %1 qubit circuit
      sim = qclab.QSimulate({[1;0];[0;1]},{'0';'1'},[0.4;0.6], ...
        {[qclab.Measurement],[],[qclab.Measurement(1)]},1);

      dens = 0.4 * [1;0]*[1;0]' + 0.6 * [0;1]*[0;1]';
      test.verifyEqual( sim.densityMatrix, dens, 'AbsTol', eps )

       % 3 qubits
      sim = qclab.QSimulate({[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [0.5;0.5;-0.5;-0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;0.5;0.5;-0.5;-0.5];[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [-0.5;-0.5;0.5;0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;-0.5;-0.5;0.5;0.5]}, ...
        {'00000';'00001';'00010';'00011';'00100';'00101';'00110';'00111'}, ...
        [0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250], ...
        {[qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1),qclab.Measurement(0),qclab.Measurement(1,'x')], ...
        [qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1)],[qclab.Measurement(0),qclab.Measurement(1,'x')]},1);

      dens = 0.125*[0.5;0.5;0.5;0.5;0;0;0;0]*[0.5;0.5;0.5;0.5;0;0;0;0]'+ ...
        0.125*[0.5;0.5;-0.5;-0.5;0;0;0;0]*[0.5;0.5;-0.5;-0.5;0;0;0;0]'+ ...
        0.125*[0;0;0;0;0.5;0.5;0.5;0.5]*[0;0;0;0;0.5;0.5;0.5;0.5]'+ ...
        0.125*[0;0;0;0;0.5;0.5;-0.5;-0.5]*[0;0;0;0;0.5;0.5;-0.5;-0.5]'+ ...
        0.125*[0.5;0.5;0.5;0.5;0;0;0;0]*[0.5;0.5;0.5;0.5;0;0;0;0]'+ ...
        0.125*[-0.5;-0.5;0.5;0.5;0;0;0;0]*[-0.5;-0.5;0.5;0.5;0;0;0;0]'+ ...
        0.125*[0;0;0;0;0.5;0.5;0.5;0.5]*[0;0;0;0;0.5;0.5;0.5;0.5]'+ ...
        0.125*[0;0;0;0;-0.5;-0.5;0.5;0.5]*[0;0;0;0;-0.5;-0.5;0.5;0.5]';

        test.verifyEqual( sim.densityMatrix, dens, 'AbsTol', eps )
    end

    function test_QSimulate_reducedStates(test)
      % no measurements
      sim = qclab.QSimulate({[1/sqrt(2);0;1/sqrt(2);0]},{'00';'10'},...
                      [0.5;0.5],{[qclab.Measurement(0),qclab.Measurement(1)],...
                      [],[qclab.Measurement(0),qclab.Measurement(1)]},1);

      test.verifyEqual(sim.reducedStates(),{[]})
      reducedStates = sim.reducedStates();
      test.verifyEqual(length(reducedStates),1)

      % just end circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0]; ...
                      [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
                      {[qclab.Measurement],[],[qclab.Measurement]},1);

      % reduced states
      test.verifyEqual(sim.reducedStates(),{[1/sqrt(2);1/sqrt(2)];...
                        [1/sqrt(2);1/sqrt(2)]})
      test.verifyEqual(sim.reducedStates(1),[1/sqrt(2);1/sqrt(2)])
      reducedStates = sim.reducedStates();
      test.verifyEqual(length(reducedStates),2)

      % just mid circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0];...
                      [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
                      {[qclab.Measurement(0)],[qclab.Measurement(0)],[]},1);

      test.verifyEqual(sim.reducedStates(),{[1/sqrt(2);1/sqrt(2);0;0];...
                            [0;0;1/sqrt(2);1/sqrt(2)]})
      test.verifyEqual(sim.reducedStates(1),[1/sqrt(2);1/sqrt(2);0;0])
      reducedStates = sim.reducedStates();
      test.verifyEqual(length(reducedStates),2)

      % mid and end circuit measurements
      sim = qclab.QSimulate({[0;1;0;0];[0;0;0;1]},{'01';'11'},[0.4;0.6], ...
        {[qclab.Measurement, qclab.Measurement(1)], ...
        [qclab.Measurement],[qclab.Measurement(1)]},1);

      % reduced states
      test.verifyEqual(sim.reducedStates(),{[1;0];[0;1]})
      test.verifyEqual(sim.reducedStates(1),[1;0])
      reducedStates = sim.reducedStates();
      test.verifyEqual(length(reducedStates),2)

      %1 qubit circuit
      sim = qclab.QSimulate({[1;0];[0;1]},{'0';'1'},[0.4;0.6], ...
        {[qclab.Measurement],[],[qclab.Measurement()]},1);

      % reduced states
      test.verifyEqual(sim.reducedStates(),{[];[]})
      test.verifyEqual(sim.reducedStates(1),[])
      reducedStates = sim.reducedStates();
      test.verifyEqual(length(reducedStates),2)

      sim = qclab.QSimulate({[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [0.5;0.5;-0.5;-0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;0.5;0.5;-0.5;-0.5];[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [-0.5;-0.5;0.5;0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;-0.5;-0.5;0.5;0.5]}, ...
        {'00000';'00001';'00010';'00011';'00100';'00101';'00110';'00111'}, ...
        [0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250], ...
        {[qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1),qclab.Measurement(0),qclab.Measurement(1,'x')], ...
        [qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1)],[qclab.Measurement(0),qclab.Measurement(1,'x')]},1);
        
      % reduced states
      test.verifyEqual(sim.reducedStates(),{[1/sqrt(2);1/sqrt(2)]; ...
        [1/sqrt(2);1/sqrt(2)];[1/sqrt(2);1/sqrt(2)]; ...
        [1/sqrt(2);1/sqrt(2)];[1/sqrt(2);1/sqrt(2)]; ...
        [-1/sqrt(2);-1/sqrt(2)];[1/sqrt(2);1/sqrt(2)]; ...
        [-1/sqrt(2);-1/sqrt(2)]})
      test.verifyEqual(sim.reducedStates(1),[1/sqrt(2);1/sqrt(2)])
      reducedStates = sim.reducedStates();
      test.verifyEqual(length(reducedStates),8)

    end

    function test_QSimulate_basisChangeEnd(test)
      % no measurements
      sim = qclab.QSimulate({[1/sqrt(2);0;1/sqrt(2);0]},{'00';'10'},...
                      [0.5;0.5],{[qclab.Measurement(0),qclab.Measurement(1)],...
                      [],[qclab.Measurement(0),qclab.Measurement(1)]},1);

      test.verifyEqual(sim.basisChangeEnd(),{qclab.qgates.QGate1.empty,...
                        qclab.qgates.QGate1.empty})
      test.verifyEqual(sim.basisChangeEnd(1),qclab.qgates.QGate1.empty)
      basisChangeEnd = sim.basisChangeEnd();
      test.verifyEqual(length(basisChangeEnd),2)

      % just end circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0];...
                      [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
                      {[qclab.Measurement],[],[qclab.Measurement]},1);

      % basisChangeEnd
      test.verifyEqual(sim.basisChangeEnd(),{qclab.qgates.QGate1.empty})
      test.verifyEqual(sim.basisChangeEnd(1),qclab.qgates.QGate1.empty)
      basisChangeEnd = sim.basisChangeEnd();
      test.verifyEqual(length(basisChangeEnd),1)

      % just mid circuit measurements
      sim = qclab.QSimulate({[1/sqrt(2);1/sqrt(2);0;0];...
                      [0;0;1/sqrt(2);1/sqrt(2)]},{'0';'1'},[0.5;0.5], ...
                      {[qclab.Measurement(0)],[qclab.Measurement(0)],[]},1);

      % basisChangeEnd
      test.verifyEqual(sim.basisChangeEnd(),{})
      basisChangeEnd = sim.basisChangeEnd();
      test.verifyEqual(length(basisChangeEnd),0)

      % mid and end circuit measurements
      sim = qclab.QSimulate({[0;1;0;0];[0;0;0;1]},{'01';'11'},[0.4;0.6], ...
        {[qclab.Measurement, qclab.Measurement(1)], ...
        [qclab.Measurement],[qclab.Measurement(1)]},1);

      % basisChangeEnd
      test.verifyEqual(sim.basisChangeEnd(),{qclab.qgates.QGate1.empty})
      test.verifyEqual(sim.basisChangeEnd(1),qclab.qgates.QGate1.empty)
      basisChangeEnd = sim.basisChangeEnd();
      test.verifyEqual(length(basisChangeEnd),1)

      %1 qubit circuit
      sim = qclab.QSimulate({[1;0];[0;1]},{'0';'1'},[0.4;0.6], ...
        {[qclab.Measurement],[],[qclab.Measurement]},1);

      % basisChangeEnd
      test.verifyEqual(sim.basisChangeEnd(),{qclab.qgates.QGate1.empty})
      test.verifyEqual(sim.basisChangeEnd(1),qclab.qgates.QGate1.empty)
      basisChangeEnd = sim.basisChangeEnd();
      test.verifyEqual(length(basisChangeEnd),1)

      sim = qclab.QSimulate({[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [0.5;0.5;-0.5;-0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;0.5;0.5;-0.5;-0.5];[0.5;0.5;0.5;0.5;0;0;0;0]; ...
        [-0.5;-0.5;0.5;0.5;0;0;0;0];[0;0;0;0;0.5;0.5;0.5;0.5]; ...
        [0;0;0;0;-0.5;-0.5;0.5;0.5]}, ...
        {'00000';'00001';'00010';'00011';'00100';'00101';'00110';'00111'}, ...
        [0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250;0.1250], ...
        {[qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1),qclab.Measurement(0),qclab.Measurement(1,'x')], ...
        [qclab.Measurement(1,'x'),qclab.Measurement(0,'y'), ...
        qclab.Measurement(1)],[qclab.Measurement(0),qclab.Measurement(1,'x')]},1);

      % basisChangeEnd
      test.verifyEqual(sim.basisChangeEnd(),{qclab.qgates.QGate1.empty,...
                        qclab.qgates.Hadamard})
      test.verifyEqual(sim.basisChangeEnd(1),qclab.qgates.QGate1.empty)
      basisChangeEnd = sim.basisChangeEnd();
      test.verifyEqual(length(basisChangeEnd),2)
    end



    


  end
end
