function tests = test_metric_confusion_matrix
% TEST_METRIC_CONFUSION_MATRIX Main test function to test the
% metric related to the confusion matrix

    % Test array constructed from local functions in this file.
    tests = functiontests( localfunctions() );
end

function test_metric_confusion_matrix_wrong_label_size(testCase)
% TEST_METRIC_CONFUSION_MATRIX_WRONG_LABEL_SIZE Test either an
% error is raised when the size of the label vector is inconsistent

    % Create some synthetic data
    label_1 = [ones(10, 1) ; -1 * ones(10, 1)];
    label_2 = [ones(15, 1) ; -1 * ones(10, 1)];

    % Check if the error is raised
    testCase.verifyError(@()metric_confusion_matrix(label_1, ...
                                                    label_2), ...
                         'metric_confusion_matrix:InconsistentLabelSize');
    % Switch the label and check again
    testCase.verifyError(@()metric_confusion_matrix(label_2, ...
                                                    label_1), ...
                         'metric_confusion_matrix:InconsistentLabelSize');
end

function test_metric_confusion_matrix_unique_label(testCase)
% TEST_METRIC_CONFUSION_MATRIX_UNIQUE_LABEL Test either if an error
% is raised when their is more than 2 classes

    % Create some synthetic data
    label_1 = [ones(10, 1) ; -1 * ones(10, 1)];
    label_2 = [ones(5, 1) ; 2 * ones(5, 1) ; -1 * ones(10, 1)];

    % Check if the error is raised
    testCase.verifyError(@()metric_confusion_matrix(label_1, ...
                                                    label_2), ...
                         'metric_confusion_matrix:Need2Classes');
    % Switch the label and check again
    testCase.verifyError(@()metric_confusion_matrix(label_2, ...
                                                    label_1), ...
                         'metric_confusion_matrix:Need2Classes');

end

function test_metric_confusion_matrix_computation(testCase)
% TEST_METRIC_CONFUSION_MATRIX Test if the metric are properly computed

    % Create the synthetic data
    true_label = [-1 * ones(10, 1) ; ones(10, 1)];
    pred_label = [-1 * ones(5, 1) ; ones(5, 1) ; -1 * ones(5, 1) ; ones(5, 1)];

    % Compute the different metric and check the results
    [ sens, spec, prec, npv, acc, f1s, mcc, gmean, cm ] = ...
        metric_confusion_matrix( pred_label, true_label );

    % Check all the value
    verifyEqual(testCase, sens, .5, 'AbsTol', 1e-10);
    verifyEqual(testCase, spec, .5, 'AbsTol', 1e-10);
    verifyEqual(testCase, prec, .5, 'AbsTol', 1e-10);
    verifyEqual(testCase, npv, .5, 'AbsTol', 1e-10);
    verifyEqual(testCase, gmean, .5, 'AbsTol', 1e-10);
    verifyEqual(testCase, acc, .5, 'AbsTol', 1e-10);
    verifyEqual(testCase, mcc, 0, 'AbsTol', 1e-10);
    verifyEqual(testCase, sens, .5, 'AbsTol', 1e-10);
end