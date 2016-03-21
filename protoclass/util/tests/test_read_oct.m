function tests = test_read_oct
% TEST_READ_OCT Main test function to test the IO function for OCT volume

    % Test array constructed from local functions in this file.
    tests = functiontests( localfunctions() );
end

function test_read_oct_unknown_format(testCase)
% TEST_READ_OCT_UNKNOWN_FORMAT Test either an error is raised if
% the data format is unknown

    % Read the volume
    testCase.verifyError(@()read_oct_volume('some_file.rnd', 512, ...
                                            128, 1024), ...
                         'read_oct_volume:NotImplemented');
end

function test_read_oct_img_read(testCase)
% TEST_READ_OCT_IMG_READ Test if the IMG image a read properly

    % Read the volume
    vol = read_oct_volume('./data/PCS57635OS.img', 512, 128, 1024);

    % Check that the volume is properly read
    load('./data/vol_read_img.mat');
    verifyEqual(testCase, vol, vol_gt, 'AbsTol', 1e-10);
end