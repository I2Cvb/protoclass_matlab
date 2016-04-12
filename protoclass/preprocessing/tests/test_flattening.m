function tests = test_flattening
% TEST_FLATTENING Main test function to test the flattening
% function

    % Test array constructed from local functions in this file.
    tests = functiontests( localfunctions() );
    
end

function test_flattening_is_3d(testCase)
% TEST_FLATTENING_IS_3D Test either an error is raised if a 2D image is
% passed as argument

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Crop the volume using Srinivasan 2014
    method = 'srinivasan-2014';
    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()flattening_volume(vol(:, :, 1), method), ...
                         'flattening_volume:InputMustBe3D');
end

function test_flattening_narg_incorrect(testCase)
% TEST_FLATTENING_NARG_INCORRECT Test either if an error is raised when
% the number of parameters is incorrect

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Flatten the volume using Srinivasan 2014
    method = 'srinivasan-2014';
    rndarg = 1;
    % Check when the number of parameters is wrong
    testCase.verifyError(@()flattening_volume(vol, method, rndarg), ...
                         'flattening_volume:NArgInIncorrect');

end

function test_flattening_method_not_implemented(testCase)
% TEST_FLATTENING_METHOD_NOT_IMPLEMENTED Test either if an error is
% raised if the method required is not implemented

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Flatten the volume
    method = 'random';
    testCase.verifyError(@()flattening_volume(vol, method), ...
                         'flattening_volume:NotImplemented');
end

function test_flattening_srinivisan_2014(testCase)
% TEST_FLATTENING_SRINIVISAN_2014 Test the flattening of Srinivasan 2014

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Flatten the volume using BM3D
    method = 'srinivasan-2014';

    % Flatten the volume on 4 first images
    [baseline_vol, warped_vol] = flattening_volume(vol(:, :, 1:4), method);

    % Verify that the volume is what we are expecting
    load('./data/vol_flattening_srinivasan_2014.mat');
    verifyEqual(testCase, warped_vol, vol_gt, 'AbsTol', 1e-10);
    verifyEqual(testCase, baseline_vol, baseline_gt, 'AbsTol', 1e-10);
end

function test_flattening_liu_2011(testCase)
% TEST_FLATTENING_LIU_2011 Test the flattening of Liu 2011

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Flatten the volume using BM3D
    method = 'liu-2011';

    % Flatten the volume on 4 first images
    [baseline_vol, warped_vol] = flattening_volume(vol(:, :, 1:4), ...
                                                   method, 'ostu', true);

    % % Verify that the volume is what we are expecting
    % load('./data/vol_flattening_srinivasan_2014.mat');
    % verifyEqual(testCase, warped_vol, vol_gt, 'AbsTol', 1e-10);
    % verifyEqual(testCase, baseline_vol, baseline_gt, 'AbsTol', 1e-10);
end
