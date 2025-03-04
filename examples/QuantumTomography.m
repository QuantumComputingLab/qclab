%> @file QuantumTomography.m
%> @brief Implements an example for 1-qubit quantum tomography.
% ==============================================================================
%
%> Reference: 
%>
%>    Section 8.2 of Quantum Computation and Quantum Information. 
%>    M. Nielsen, and I. L. Chuang.
%>
%>    https://research.physics.illinois.edu/QI/Photonics/tomography-files/
%>    tomo_chapter_2004.pdf
%> 
%> Quantum tomography reconstructs a quantum state by performing measurements 
%> in various bases. It determines all properties of the state, including 
%> amplitudes. Here we apply it to a one qubit state and reconstruct its 
%> density matrix using the formula
%> 
%>          rho = 1/2 * (S0 * I + S1 * X + S2 * Y + S3 * Z)
%>
%> where the coefficients are estimated by the measurements in different
%> bases, and X, Y, and Z are the Pauli matrices.
%
% (C) Copyright Sophia Keip, Daan Camps and Roel Van Beeumen 2025.
% ==============================================================================

% State to be estimated
% ------------------------------------------------------------------------------
v = rand(2,1)+1i*rand(2,1);
v = v/norm(v);

% Three different circuits for measuring in different basis
% ------------------------------------------------------------------------------
M = @qclab.Measurement;

mes_z = qclab.QCircuit(1);
mes_z.push_back(M( 0,'z' ));
mes_z.draw;
mes_x = qclab.QCircuit(1);
mes_x.push_back(M( 0,'x' ));
mes_x.draw;
mes_y = qclab.QCircuit(1);
mes_y.push_back(M( 0,'y' ));
mes_y.draw;

% Measuring the state in different basis
% ------------------------------------------------------------------------------
res_z = mes_z.simulate(v);
res_x = mes_x.simulate(v);
res_y = mes_y.simulate(v);

% Sample shots times and get estimates of the probabilities
% ------------------------------------------------------------------------------
shots = 10000;
prob_est_z = res_z.counts(shots)./shots;
prob_est_x = res_x.counts(shots)./shots;
prob_est_y = res_y.counts(shots)./shots;

% Get coefficients
% ------------------------------------------------------------------------------
S0 = prob_est_z(1) + prob_est_z(2);
S1 = prob_est_x(1) - prob_est_x(2);
S2 = prob_est_y(1) - prob_est_y(2);
S3 = prob_est_z(1) - prob_est_z(2);

% Define matrices
% ------------------------------------------------------------------------------
I = eye(2);
X = [0,1;1,0];
Y = [0,-1i;1i,0];
Z = [1,0; 0,-1];

% Compare estimate and real density matrix
% ------------------------------------------------------------------------------

% Density matrix estimate

rho_est = 1/2*(S0*I + S1*X + S2*Y + S3*Z);

% Real density matrix

rho  = v*v';

fprintf( 1, '\n The proper density matrix of the state is:\n' );

disp(rho)

fprintf( 1, '\n Quantum tomography gives the following estimate:\n' );

disp(rho_est)

fprintf( 1, '\n The trace distance between the two density matrices is:\n' );
disp(1/2*trace(abs(rho-rho_est)))