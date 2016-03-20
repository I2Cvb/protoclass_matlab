function tests = test_denoising
% TEST_DENOISING Main test function to test the denoising_volume
% function
    
% Test array constructed from local functions in this file.
    tests = functiontests( localfunctions() );
    
end

function test_volume_bm3d(testCase)
% TEST_VOLUME_BM3D Function to test the BM3D normal usage

    addpath('./data');
    addpath('../denoising_volume.m')
    addpath('../../util/read_oct_volume.m');

    % Read the volume
    vol = read_oct_volume('PCS57635OS.img', 512, 128, 1024);

    % Denoise the volume using BM3D
    method = 'bm3d';
    sigma = 190.;
    vol_out = denoising_volume(vol, method, sigma);

    % Verify that the volume is what we are expecting
    vol_gt = load('PCS57635OS_denoised_bm3d.img')
    verifyEqual(testCase, vol_out, vol_gt, 'AbsTol', 1e-10)
end