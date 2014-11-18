classdef TestSol13 < matlab.unittest.TestCase
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        options
        order
        carrier
        carriee
    end
    
    methods (TestClassSetup)
        function test_init(testCase)
            testCase.carrier(1).lwh = [19       2.7     100];
            testCase.carrier(1).type = 11;
            testCase.carrier(1).cost = 1;
            testCase.carrier(1).limit = Inf;
            testCase.carrier(2).lwh = [24.3     2.7     100];
            testCase.carrier(2).type = 12;
            testCase.carrier(2).cost = 1.4;
            testCase.carrier(2).limit = Inf;
            testCase.carrier(3).lwh = [19       4     100];
            testCase.carrier(3).type = 22;
            testCase.carrier(3).cost = 1.9;
            testCase.carrier(3).limit = 0;

            testCase.carriee.lwh = [4.61     1.7     1.51; 
                           3.615    1.605   1.394;
                           4.63     1.785   1.77];

            testCase.options = containers.Map;
            testCase.options('const15') = true;
            testCase.options('fullfill') = true;
            
            % Sol 16 - 2 T
            % Sol 11 - 2 vs 12 - 1
            % Sol 25 - 5 T
            testCase.order = [100  72  156;
                               68  52  102;
                                0   0   39];
        end

    end
    
    methods (Test)
        function Sol1Test(testCase)
            order = testCase.order(:,1);
            exp_used = [16 2 0];
            act_used = opti_loc(order, testCase.carrier, ...
                           testCase.carriee, testCase.options);
            testCase.verifyEqual(act_used, exp_used);        end
        function Sol2Test(testCase)
            order = testCase.order(:,2);
            exp_used = [11 2 0];
            act_used = opti_loc(order, testCase.carrier, ...
                           testCase.carriee, testCase.options);
            testCase.verifyEqual(act_used, exp_used);        end
        function Sol3Test(testCase)
            order = testCase.order(:,3);
            exp_used = [25 5 0];
            act_used = opti_loc(order, testCase.carrier, ...
                           testCase.carriee, testCase.options);
            testCase.verifyEqual(act_used, exp_used);
        end
        
    end
    
end

