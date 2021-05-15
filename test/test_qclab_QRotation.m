classdef test_qclab_QRotation < matlab.unittest.TestCase
  methods (Test)
    function test_QRotation(test)
      R = qclab.QRotation ;
      test.verifyFalse( R.fixed );             % fixed
      test.verifyEqual( R.cos, 1.0 );          % cos
      test.verifyEqual( R.sin, 0.0 );          % sin
      test.verifyEqual( R.theta, 0.0 );        % theta
      
      % fixed
      R.makeFixed();
      test.verifyTrue( R.fixed );
      R.makeVariable();
      test.verifyFalse( R.fixed );
      
      % update(angle)
      new_angle = qclab.QAngle( 0.5 );
      R.update( new_angle ) ;
      test.verifyEqual( R.theta, 1.0, 'AbsTol', eps );
      test.verifyEqual( R.cos, cos( 0.5 ), 'AbsTol', eps );
      test.verifyEqual( R.sin, sin( 0.5 ), 'AbsTol', eps );
      
      % update(theta)
      R.update( pi/2 );
      test.verifyEqual( R.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( R.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( R.sin, sin(pi/4), 'AbsTol', eps);
      
      % update(cos, sin)
      R.update( cos(pi/3), sin(pi/3) );
      test.verifyEqual( R.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( R.cos, cos(pi/3), 'AbsTol', eps);
      test.verifyEqual( R.sin, sin(pi/3), 'AbsTol', eps);
      
      % operators == and ~=
      R2 = qclab.QRotation( cos(pi/3), sin(pi/3) );
      test.verifyTrue( R == R2 );
      test.verifyFalse( R ~= R2 );
      R2.update( 1 );
      test.verifyTrue( R ~= R2 );
      test.verifyFalse( R == R2 );
    end
  end
end