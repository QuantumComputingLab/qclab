classdef test_qclab_QAngle < matlab.unittest.TestCase
  methods (Test)
    function test_QAngle(test)
      angle = qclab.QAngle ;
      test.verifyEqual( angle.cos, 1.0 );          % cos
      test.verifyEqual( angle.sin, 0.0 );          % sin
      test.verifyEqual( angle.theta, 0.0 );        % theta
      
      % update(angle)
      new_angle = qclab.QAngle( 1 );
      angle.update( new_angle ) ;
      test.verifyEqual( angle.theta, 1.0, 'AbsTol', eps );
      test.verifyEqual( angle.cos, cos( 1 ), 'AbsTol', eps );
      test.verifyEqual( angle.sin, sin( 1 ), 'AbsTol', eps );
      
      % update(theta)
      angle.update( pi/2 );
      test.verifyEqual( angle.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( angle.cos, cos(pi/2), 'AbsTol', eps);
      test.verifyEqual( angle.sin, sin(pi/2), 'AbsTol', eps);
      
      % update(cos, sin)
      angle.update( cos(pi/3), sin(pi/3) );
      test.verifyEqual( angle.theta, pi/3, 'AbsTol', eps );
      test.verifyEqual( angle.cos, cos(pi/3), 'AbsTol', eps);
      test.verifyEqual( angle.sin, sin(pi/3), 'AbsTol', eps);
      
      % operators == and ~=
      test.verifyTrue( angle ~= new_angle );
      test.verifyFalse( angle == new_angle );
      new_angle.update( angle );
      test.verifyTrue( angle == new_angle );
      test.verifyFalse( angle ~= new_angle );
    end
  end
end