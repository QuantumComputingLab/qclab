classdef TestGateWrappers < matlab.unittest.TestCase
  methods (Test)

    function testHadamard(testCase)
      circuit = qclab.QCircuit(1);
      circuit.H(0);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.Hadamard');
      testCase.verifyEqual(gate.qubits, int64(0));
    end

    function testCNOT(testCase)
      circuit = qclab.QCircuit(2);
      circuit.CNOT(0, 1);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.CNOT');
      testCase.verifyEqual(gate.qubits, int64([0, 1]));
    end

    function testCPhase(testCase)
      circuit = qclab.QCircuit(2);
      circuit.CPhase(0, 1, pi);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.CPhase');
      testCase.verifyEqual(gate.qubits, int64([0, 1]));
    end

    function testCRX(testCase)
      circuit = qclab.QCircuit(2);
      circuit.CRX(0, 1, pi/2);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.CRotationX');
      testCase.verifyEqual(gate.qubits, int64([0, 1]));
    end

    function testCRY(testCase)
      circuit = qclab.QCircuit(2);
      circuit.CRY(0, 1, pi/3);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.CRotationY');
    end

    function testCRZ(testCase)
      circuit = qclab.QCircuit(2);
      circuit.CRZ(0, 1, pi/4);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.CRotationZ');
    end

    function testCU2(testCase)
      circuit = qclab.QCircuit(2);
      circuit.CU2(0, 1, 1, pi/5, pi/6);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.CU2');
    end

    function testCU3(testCase)
      circuit = qclab.QCircuit(2);
      circuit.CU3(0, 1, 1, pi/5, pi/6, pi/7);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.CU3');
    end

    function testCY(testCase)
      circuit = qclab.QCircuit(2);
      circuit.CY(0, 1);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.CY');
    end

    function testCZ(testCase)
      circuit = qclab.QCircuit(2);
      circuit.CZ(0, 1);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.CZ');
    end

    function testiSWAP(testCase)
      circuit = qclab.QCircuit(2);
      circuit.iSWAP(0, 1);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.iSWAP');
    end

    function testMG(testCase)
      circuit = qclab.QCircuit(2);
      U = [0 1; 1 0];
      circuit.MG([0], U);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.MatrixGate');
    end

    function testMCMG(testCase)
      circuit = qclab.QCircuit(3);
      U = eye(2);
      circuit.MCMG([0 1], 2, U);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.MCMatrixGate');
    end

    function testMCRX(testCase)
      circuit = qclab.QCircuit(3);
      circuit.MCRX([0 1], 2, [1 0], pi/2);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.MCRotationX');
    end

    function testMCRY(testCase)
      circuit = qclab.QCircuit(3);
      circuit.MCRY([0 1], 2, [1 1], pi/3);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.MCRotationY');
    end

    function testMCRZ(testCase)
      circuit = qclab.QCircuit(3);
      circuit.MCRZ([0 1], 2, [0 1], pi/4);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.MCRotationZ');
    end

    function testMCX(testCase)
      circuit = qclab.QCircuit(3);
      circuit.MCX([0 1], 2);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.MCX');
    end

    function testMCY(testCase)
      circuit = qclab.QCircuit(3);
      circuit.MCY([0 1], 2);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.MCY');
    end

    function testMCZ(testCase)
      circuit = qclab.QCircuit(3);
      circuit.MCZ([0 1], 2);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.MCZ');
    end

    function testPauliX(testCase)
      circuit = qclab.QCircuit(1);
      circuit.X(0);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.PauliX');
    end

    function testPauliY(testCase)
      circuit = qclab.QCircuit(1);
      circuit.Y(0);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.PauliY');
    end

    function testPauliZ(testCase)
      circuit = qclab.QCircuit(1);
      circuit.Z(0);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.PauliZ');
    end

    function testPhase(testCase)
      circuit = qclab.QCircuit(1);
      circuit.Phase(0, pi/8);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.Phase');
    end

    function testPhase45(testCase)
      circuit = qclab.QCircuit(1);
      circuit.Phase45(0);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.Phase45');
    end

    function testT(testCase)
      circuit = qclab.QCircuit(1);
      circuit.T(0);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.Phase45');
    end

    function testPhase90(testCase)
      circuit = qclab.QCircuit(1);
      circuit.Phase90(0);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.Phase90');
    end

    function testS(testCase)
      circuit = qclab.QCircuit(1);
      circuit.S(0);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.Phase90');
    end

    function testRX(testCase)
      circuit = qclab.QCircuit(1);
      circuit.RX(0, pi/2);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.RotationX');
    end

    function testRXX(testCase)
      circuit = qclab.QCircuit(2);
      circuit.RXX([0 1], pi/2);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.RotationXX');
    end

    function testRY(testCase)
      circuit = qclab.QCircuit(1);
      circuit.RY(0, pi/3);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.RotationY');
    end

    function testRYY(testCase)
      circuit = qclab.QCircuit(2);
      circuit.RYY([0 1], pi/3);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.RotationYY');
    end

    function testRZ(testCase)
      circuit = qclab.QCircuit(1);
      circuit.RZ(0, pi/4);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.RotationZ');
    end

    function testRZZ(testCase)
      circuit = qclab.QCircuit(2);
      circuit.RZZ([0 1], pi/4);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.RotationZZ');
    end

    function testSWAP(testCase)
      circuit = qclab.QCircuit(2);
      circuit.SWAP(0, 1);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.SWAP');
    end

    function testU2(testCase)
      circuit = qclab.QCircuit(1);
      circuit.U2(0, pi/3, pi/4);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.U2');
    end

    function testU3(testCase)
      circuit = qclab.QCircuit(1);
      circuit.U3(0, pi/5, pi/6, pi/7);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.U3');
    end

      function testCNOTWithControlState0(testCase)
      circuit = qclab.QCircuit(2);
      circuit.CNOT(0, 1, 0);
      gate = circuit.objects(1);
      testCase.verifyEqual(gate.controlState, int64(0));
    end

    function testMultipleGatesInCircuit(testCase)
      circuit = qclab.QCircuit(2);
      circuit.H(0);
      circuit.CNOT(0, 1);
      objects = circuit.objects;
      testCase.verifyEqual(numel(objects), 2);
      testCase.verifyClass(objects(1), 'qclab.qgates.Hadamard');
      testCase.verifyClass(objects(2), 'qclab.qgates.CNOT');
    end

    function testEmptyMatrixGateLabel(testCase)
      circuit = qclab.QCircuit(1);
      U = [0 1; 1 0];
      circuit.MG(0, U);
      gate = circuit.objects(1);
      testCase.verifyEqual(gate.label, ' U ');
    end

    function testCustomLabelMatrixGate(testCase)
      circuit = qclab.QCircuit(1);
      U = [1 0; 0 -1];
      circuit.MG(0, U, 'Z');
      gate = circuit.objects(1);
      testCase.verifyEqual(gate.label, ' Z ');
    end

    function testMCMGWithControlStates(testCase)
      circuit = qclab.QCircuit(3);
      U = [1 0; 0 -1];
      circuit.MCMG([0 1], 2, U, [1 0]);
      gate = circuit.objects(1);
      testCase.verifyEqual(gate.controlStates, int64([1 0]));
    end

    function testRXDefaultQubit(testCase)
      circuit = qclab.QCircuit(1);
      circuit.RX();
      gate = circuit.objects(1);
      testCase.verifyEqual(gate.qubits, int64(0));
    end

    function testRYWithQAngle(testCase)
      circuit = qclab.QCircuit(1);
      angle = qclab.QAngle(pi/2);
      circuit.RY(0, angle);
      gate = circuit.objects(1);
      testCase.verifyEqual(gate.theta, pi);
    end

    function testCU3WithAngleVector(testCase)
      circuit = qclab.QCircuit(2);
      angles = {pi/6, pi/4, pi/3};
      circuit.CU3(0, 1, 1, angles{:});
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.CU3');
    end

    function testCRZWithComplexAngle(testCase)
      circuit = qclab.QCircuit(2);
      theta = complex(1/sqrt(2), 1/sqrt(2));
      circuit.CRZ(0, 1, theta);
      gate = circuit.objects(1);
      testCase.verifyClass(gate, 'qclab.qgates.CRotationZ');
    end

    function testU2WithDefaultArgs(testCase)
      circuit = qclab.QCircuit(1);
      circuit.U2();
      gate = circuit.objects(1);
      testCase.verifyEqual(gate.qubits, int64(0));
    end

    function testMCZWithControlState0(testCase)
      circuit = qclab.QCircuit(3);
      circuit.MCZ([0 1], 2, [0 1]);
      gate = circuit.objects(1);
      testCase.verifyEqual(gate.controlStates, int64([0 1]));
    end

    function testPhaseWithAngleObject(testCase)
      circuit = qclab.QCircuit(1);
      theta = qclab.QAngle(pi/8);
      circuit.Phase(0, theta);
      gate = circuit.objects(1);
      testCase.verifyLessThanOrEqual(abs(gate.theta- pi/8),1e-15);
    end
  
  end

end
