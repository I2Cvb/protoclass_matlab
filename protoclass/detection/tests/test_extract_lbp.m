function tests = test_extract_lbp
% TEST_EXTRACT_LBP Main test function to test extraction of
% pyramidal LBP extraction

    % Test array constructed from local functions in this file.
    tests = functiontests( localfunctions() );
    
end

function test_extract_lbp_neg_pyr_lev(testCase)
% TEST_EXTRACT_LBP_NEG_PYR_LEV Test either an error is raised if
% the number of pyramid is incorrect

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % LBP parameters
    pyr_num_lev = -1;
    NumNeighbors = 8;
    Radius = 1;
    CellSize = [32 32];
    Upright = false;

    % Check that an error is thrown if not a 3d matrix if given
    testCase.verifyError(@()extract_lbp_volume( vol, pyr_num_lev, ...
                                          NumNeighbors, Radius, ...
                                          CellSize, Upright ), ...
                         'extract_lbp_volume:IncorrectNumPyr');
end

function test_extract_lbp_routine(testCase)
% TEST_EXTRACT_LBP_ROUTINE Test that the pyramidal extraction is working

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % LBP parameters
    pyr_num_lev = 3;
    NumNeighbors = 8;
    Radius = 1;
    CellSize = [32 32];
    Upright = false;

    % Compute LBP only for the 4 first images of the volume
    feature_mat_vol = extract_lbp_volume( vol(:, :, 1:4), pyr_num_lev, ...
                                          NumNeighbors, Radius, ...
                                          CellSize, Upright );

    % Verify that the volume is what we are expecting
    load('./data/lbp_feature_pyramid.mat');
    verifyEqual(testCase, feature_mat_vol, feature_mat_gt, 'AbsTol', 1e-10);
end