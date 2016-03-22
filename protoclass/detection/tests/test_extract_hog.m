function tests = test_extract_hog
% TEST_EXTRACT_HOG Main test function to test extraction of
% pyramidal HOG extraction

    % Test array constructed from local functions in this file.
    tests = functiontests( localfunctions() );
    
end

function test_extract_hog_neg_pyr_lev(testCase)
% TEST_EXTRACT_HOG_NEG_PYR_LEV Test either an error is raised if
% the number of pyramid is incorrect

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % HOG parameters
    pyr_num_lev = -1;
    CellSize = [4 4];
    BlockSize = [2 2];
    BlockOverlap = [1 1];
    NumBins = 9;

    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()extract_hog_volume( vol, pyr_num_lev, ...
                                                CellSize, BlockSize, ...
                                                BlockOverlap, NumBins ...
                                                ), ...
                         'extract_hog_volume:IncorrectNumPyr');
end

function test_extract_hog_routine(testCase)
% TEST_EXTRACT_HOG_ROUTINE Test that the pyramidal extraction is working

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % HOG parameters
    pyr_num_lev = 3;
    CellSize = [4 4];
    BlockSize = [2 2];
    BlockOverlap = [1 1];
    NumBins = 9;
    
    % Compute HOG only for the 4 first images of the volume
    feature_mat_vol = extract_hog_volume( vol(:, :, 1:4), pyr_num_lev, CellSize, ...
                                          BlockSize, BlockOverlap, NumBins ...
                                          );

    % Verify that the volume is what we are expecting
    load('./data/hog_feature_pyramid.mat');
    verifyEqual(testCase, feature_mat_vol, feature_mat_gt, 'AbsTol', 1e-10);
end