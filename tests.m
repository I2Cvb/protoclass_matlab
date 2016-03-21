% This file has to be called to run the unit test
import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin

% First call the setup
setup;

% Call the different test

% Pre-processing tests
preprocessing_folder=fullfile(pwd, 'protoclass/preprocessing');
suite = matlab.unittest.TestSuite.fromFolder(fullfile(preprocessing_folder, ...
                                                  'tests'));
runner = TestRunner.withTextOutput;
runner.addPlugin(CodeCoveragePlugin.forFolder(preprocessing_folder));
result = runner.run(suite);
% Util tests
util_folder=fullfile(pwd, 'protoclass/util');
suite = matlab.unittest.TestSuite.fromFolder(fullfile(util_folder, ...
                                                  'tests'));
runner = TestRunner.withTextOutput;
runner.addPlugin(CodeCoveragePlugin.forFolder(util_folder));
result = runner.run(suite);