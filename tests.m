% This file has to be called to run the unit test
import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin

% First call the setup
setup;

% Call the different test

% Pre-processing tests
preprocessing_folder=fullfile(pwd, 'protoclass/preprocessing/tests');
suite = matlab.unittest.TestSuite.fromFolder(preprocessing_folder);
runner = TestRunner.withTextOutput;
runner.addPlugin(CodeCoveragePlugin.forFolder(preprocessing_folder));
result = runner.run(suite);