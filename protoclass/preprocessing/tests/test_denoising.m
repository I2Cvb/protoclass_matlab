function tests = test_denoising
% TEST_DENOISING Main test function to test the denoising_volume
% function

    % Test array constructed from local functions in this file.
    tests = functiontests( localfunctions() );
    
end

function test_volume_is_3d(testCase)
% TEST_VOLUME_IS_3D Test either an error is raised if a 2D image is
% passed as argument

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Denoise the volume using BM3D
    method = 'bm3d';
    sigma = .2;
    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()denoising_volume(vol(:, :, 1), method, ...
                                             sigma), 'denoising_volume:InputMustBe3D');
end

function test_volume_narg_incorrect(testCase)
% TEST_VOLUME_NARG_INCORRECT Test either if an error is raised when
% the wrong number of parameter is incorrect

    % Method of bm3d
    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Denoise the volume using BM3D
    method = 'bm3d';
    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()denoising_volume(vol, method), ...
                         'denoising_volume:NArgInIncorrect');
end

function test_volume_method_not_implemented(testCase)
% TEST_VOLUME_METHOD_NOT_IMPLEMENTED Test either if an error is
% raised if the method required is not implemented

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Denoise the volume using BM3D
    method = 'random';
    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()denoising_volume(vol, method), ...
                         'denoising_volume:NotImplemented');
end

function test_volume_bm3d_float_range(testCase)
% TEST_VOLUME_METHOD_BM3D_FLOAT_RANGE Test either if an error is
% raised if the range of the float data is not between 0 and 1

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Denoise the volume using BM3D
    method = 'bm3d';
    sigma = .2;
    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()denoising_volume(vol, method, sigma), ...
                         'denoising_volume_bm3d:FloatRangeError');
    % Check if it grab when smaller than 0
    vol = max(vol(:)) - vol;
    testCase.verifyError(@()denoising_volume(vol, method, sigma), ...
                         'denoising_volume_bm3d:FloatRangeError');
end

function test_volume_bm3d_sigma_range(testCase)
% TEST_VOLUME_METHOD_BM3D_SIGMA_RANGE Test either if an error is
% raised if the range of the sigma is not between 0. and 1.

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);
    vol = vol / max(vol(:));

    % Denoise the volume using BM3D
    method = 'bm3d';
    sigma = 200.;
    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()denoising_volume(vol, method, sigma), ...
                         'denoising_volume_bm3d:SigmaNotInRange');
end

function test_volume_bm3d_with_float(testCase)
% TEST_VOLUME_BM3D Function to test the BM3D normal usage with
% float data

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);
    vol = vol / max(vol(:));

    % Denoise the volume using BM3D
    method = 'bm3d';
    sigma = .2;
    % Give only the first 4 slides
    vol_out = denoising_volume(vol(:, :, 1:4), method, sigma);
    
    % Verify that the volume is what we are expecting
    load('vol_out_bm3d_float.mat');
    verifyEqual(testCase, vol_out, vol_gt, 'AbsTol', 1e-10);
end

function test_volume_bm3d_with_int(testCase)
% TEST_VOLUME_BM3D Function to test the BM3D normal usage with
% float data

    % Read the volume
    vol = uint8(read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024));

    % Denoise the volume using BM3D
    method = 'bm3d';
    sigma = 190;
    % Give only the first 4 slides
    vol_out = denoising_volume(vol(:, :, 1:4), method, sigma);

    % Verify that the volume is what we are expecting
    load('vol_out_bm3d_int.mat');
    verifyEqual(testCase, vol_out, vol_gt, 'AbsTol', 1e-10);
end
