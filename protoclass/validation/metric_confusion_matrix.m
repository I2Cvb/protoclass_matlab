function [ sens, spec, prec, npv, acc, f1s, mcc, gmean, cm ] = metric_confusion_matrix( pred_label, true_label )
% METRIC_CONFUSION_MATRIX Function to compute the confusion matrix
% of a classification experiments and the associated metrics.
%     [ sens, spec, prec, npv, acc, f1s, mcc, gmean, cm ] =
%     metric_confusion_matrix( pred_label, true_label )
%
% Required arguments:
%     pred_label : 1D array, shape (n_samples, 1)
%         Labels predicted by the classifier experimented.
%
%     true_label : 1D array, shape (n_samples, 1)
%         Ground-truth labels.
%
% Return:
%     sens: double
%          Sensitivity.
%
%     spec: double
%          Specificity.
%
%     prec: double
%          Precision.
%
%     npv: double
%          Negative predictive value.
%
%     acc: double
%          Accuracy.
%
%     f1s: double
%          F1 score.
%
%     mcc: double
%          Matthew's correlation coefficient.
%
%     gmean: double
%          Geometric mean.
%
%     cm: 2D array, shape (n_classes, n_classes)
%          Confusion matrix.
%

    % Check that the size of the labels is consistent
    if length(pred_label) ~= length(true_label)
        error('metric_confusion_matrix:InconsistentLabelSize', ['The ' ...
                            'size of the prediction and ground-truth ' ...
                            'has to be identical.']);
    end
    % Check that there is only two classes inside the labels
    if (length(unique(pred_label)) > 2) || (length(unique(true_label)) > 2)
        error('metric_confusion_matrix:Need2Classes', ['The prediction ' ...
                            'or the ground-truth need to have two labels.']);
    end

    % Compute the confusion matrix
    cm = confusionmat( true_label, pred_label, 'order', [-1 1]);

    % Compute the sensitivity and specificity
    sens = cm(2, 2) / ( cm(2, 2) + cm(2, 1) );
    spec = cm(1, 1) / ( cm(1, 1) + cm(1, 2) );

    % Compute the precision and negative predictive value
    prec = cm(2, 2) / ( cm(2, 2) + cm(1, 2) );
    npv  = cm(1, 1) / ( cm(1, 1) + cm(2, 1) );

    % Compute accuracy
    acc = ( cm(1, 1) + cm(2, 2) ) / sum( cm(:) );

    % Compute the F1 score
    f1s = ( 2 * cm(2, 2) ) / ( 2 * cm(2, 2) + cm(1, 2) + cm(2, 1) );

    % Compute the Matthew correlation coefficient
    mcc = ( cm(1, 1) * cm(2, 2) - cm(1, 2) * cm(2, 1) ) / ( sqrt( ...
        ( cm(2, 2) + cm(1, 2) ) * ...
        ( cm(2, 2) + cm(2, 1) ) * ...
        ( cm(1, 1) + cm(1, 2) ) * ...
        ( cm(1, 1) + cm(2, 1) ) ) );

    % Compute the geometric mean
    gmean = sqrt( sens * spec );

end
