function [ tmpResult,modelLSLC ] = lslc_main( train_data,train_target,test_data,test_target )
 %% Set parameter    
    [optmParameter, ~] =  initialization_LSLC;% parameter settings for LSLC
    optmParameter_LSLC = optmParameter;
 %% Training
    modelLSLC  = LSLC( train_data, train_target,optmParameter_LSLC); 
 %% Prediction and evaluation LSLC
    Outputs = (test_data*modelLSLC.W)';
    fscore                 = (train_data*modelLSLC.W)';
    [ tau,  ~] = TuneThreshold( fscore, train_target', 1, 2);
    Pre_Labels             = LSMLPN_Predict(Outputs,tau);
    fprintf('-- Evaluation LSLC\n');
    tmpResult = EvaluationAll(Pre_Labels,Outputs,test_target');
end

