function tests = test_cropping
% TEST_DENOISING Main test function to test the denoising_volume
% function

    % Test array constructed from local functions in this file.
    tests = functiontests( localfunctions() );
    
end

function test_crop_is_3d(testCase)
% TEST_CROP_IS_3D Test either an error is raised if a 2D image is
% passed as argument

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Crop the volume using srinivisan
    method = 'srinivasan-2014';
    h_over_rpe = 325;
    h_under_rpe = 30;
    width_crop = 340;
    baseline_vol = ones(4, 1) * 300;
    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()crop_volume(vol(:, :, 1), method, ...
                                        baseline_vol, h_over_rpe, ...
                                        h_under_rpe, width_crop), ...
                         'crop_volume:InputMustBe3D');
end

function test_crop_narg_incorrect(testCase)
% TEST_CROP_NARG_INCORRECT Test either if an error is raised when
% the wrong number of parameter is incorrect

    % Method of bm3d
    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Crop the volume using srinivisan
    method = 'srinivasan-2014';
    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()crop_volume(vol, method), ...
                         'crop_volume:NArgInIncorrect');

end

function test_crop_method_not_implemented(testCase)
% TEST_CROP_METHOD_NOT_IMPLEMENTED Test either if an error is
% raised if the method required is not implemented

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Crop the volume
    method = 'random';
    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()crop_volume(vol, method), ...
                         'crop_volume:NotImplemented');
end

function test_crop_srinivisan_2014(testCase)
% TEST_CROP_SRINIVISAN_2014 Test the cropping of Srinivasan 2014

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Crop the volume using BM3D
    method = 'srinivasan-2014';
    h_over_rpe = 325;
    h_under_rpe = 30;
    width_crop = 340;
    baseline_vol = ones(4, 1) * 600;

    % Crop the volume on 4 first images
    vol_out = crop_volume(vol(:, :, 1:4), method, baseline_vol, h_over_rpe, ...
                          h_under_rpe, width_crop);

    % Verify that the volume is what we are expecting
    load('./data/vol_crop_srinivasan_2014.mat');
    verifyEqual(testCase, vol_out, vol_gt, 'AbsTol', 1e-10);
end

function test_crop_srinivasan_2014_wrong_size(testCase)
% TEST_CROP_SRINIVASAN_2014_WRONG_SIZE Test either if an error is
% raised with inconsitent sizing

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Crop the volume using BM3D
    method = 'srinivasan-2014';
    h_over_rpe = -10;
    h_under_rpe = 30;
    width_crop = 340;
    baseline_vol = ones(4, 1) * 300;
    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()crop_volume(vol(:, :, 1:4), method, ...
                                        baseline_vol, h_over_rpe, ...
                                        h_under_rpe, width_crop), ...
                         'crop_volume:CropSizeWrong');

    h_over_rpe = 325;
    h_under_rpe = -30;
    width_crop = 340;
    baseline_vol = ones(4, 1) * 300;
    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()crop_volume(vol(:, :, 1:4), method, ...
                                        baseline_vol, h_over_rpe, ...
                                        h_under_rpe, width_crop), ...
                         'crop_volume:CropSizeWrong');

    h_over_rpe = 325;
    h_under_rpe = 30;
    width_crop = -340;
    baseline_vol = ones(4, 1) * 300;
    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()crop_volume(vol(:, :, 1:4), method, ...
                                        baseline_vol, h_over_rpe, ...
                                        h_under_rpe, width_crop), ...
                         'crop_volume:CropSizeWrong');

    h_over_rpe = 325;
    h_under_rpe = 30;
    width_crop = 10000;
    baseline_vol = ones(4, 1) * 300;
    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()crop_volume(vol(:, :, 1:4), method, ...
                                        baseline_vol, h_over_rpe, ...
                                        h_under_rpe, width_crop), ...
                         'crop_volume:CropSizeWrong');
end

%It is needed why the warning is not up
% function test_crop_srinivisan_2014_warning_resizing(testCase)
% % TEST_CROP_SRINIVISAN_2014_WARNING_RESIZING Test the cropping of
% % Srinivasan 2014 and see if a warning is raised by resizing the
% % cropping dimension.

%     % Read the volume
%     vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

%     % Crop the volume using BM3D
%     method = 'srinivasan-2014';
%     h_over_rpe = 325;
%     h_under_rpe = 30;
%     width_crop = 340;
%     baseline_vol = ones(4, 1) * 300;

%     % Crop the volume on 4 first images
%     testCase.verifyWarning(@()crop_volume(vol(:, :, 1:4), method, ...
%                                           baseline_vol, h_over_rpe, ...
%                                           h_under_rpe, width_crop), ...
%                            'crop_volume:ModifyCropSize');

%     % Crop the volume using BM3D
%     method = 'srinivasan-2014';
%     h_over_rpe = 325;
%     h_under_rpe = 30;
%     width_crop = 340;
%     baseline_vol = ones(4, 1) * 1000;

%     % Crop the volume on 4 first images
%     testCase.verifyWarning(@()crop_volume(vol(:, :, 1:4), method, ...
%                                           baseline_vol, h_over_rpe, ...
%                                           h_under_rpe, width_crop), ...
%                            'crop_volume:ModifyCropSize');

% end