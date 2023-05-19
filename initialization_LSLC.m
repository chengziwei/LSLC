% The folow parameter settings are suggested to reproduct most of the 
% experimental results of LSLC, and a better performance will be obtained 
% by tuning the parameters.
% -------------------------------------------------------------------------
% Parameters : lambda1, lambda2, lambda3, lambda4 rho
% -------------------------------------------------------------------------
% languagelog       : 10^2, 10^-5, 10^-3, 10^-5, 2
% medical           : 10^2, 10^-5, 10^-3, 10^-5, 1
% rcv1subset1       : 10^2, 10^-5, 10^-3, 10^-5, 8 
% rcv1subset2       : 10^2, 10^-5, 10^-3, 10^-5, 2
% bibtex            : 10^2, 10^-5, 10^-3, 10^-5, 4
% pascal07          : 10^2, 10^-5, 10^-3, 10^-5, 1
% delicious         : 10^2, 10^-5, 10^-3, 10^-5, 8
% Eurlex(sm)        : 10^2, 10^-5, 10^-3, 10^-5, 8    
% bookmark          : 10^2, 10^-5, 10^-3, 10^-5, 8
% nuswide           : 10^2, 10^-5, 10^-3, 10^-5, 8
% tmc2007           : 10^2, 10^-5, 10^-3, 10^-5, 8
% stackex-chemistry : 10^2, 10^-5, 10^-3, 10^-5, 8
% stackex-chess     : 10^2, 10^-5, 10^-3, 10^-5, 2
% stackex-cooking   : 10^2, 10^-5, 10^-3, 10^-5, 4
% stackex-cs        : 10^2, 10^-5, 10^-3, 10^-5, 4
% stackex-philosophy: 10^2, 10^-5, 10^-3, 10^-5, 4
% -------------------------------------------------------------------------
% =======================================================================================
function [optmParameter, modelparameter] =  initialization_LSLC
%     optmParameter.lambda1   = 10^2;  %  missing labels
%     optmParameter.lambda2   = 10^-5; %  regularization of W
%     optmParameter.lambda3   = 10^-3; %  regularization of C 
%     optmParameter.lambda4   = 10^-5; %  regularization of second-order
%     optmParameter.rho       = 1;     % 2^{0,1,2,3}
%     optmParameter.isBacktracking    = 1; % 0 - LSML, 1 - LSML-P
    
    
    optmParameter.lambda1   = 10^-5; %  regularization of W
    optmParameter.lambda2   = 10^-3; %  regularization of P 
    optmParameter.lambda3   = 10^-3; %  regularization of N 
    optmParameter.lambda4   = 10^2;  %  missing labels with positive and negative label relationship
    optmParameter.lambda5   = 10^-5; %  regularization of second-order with positive label relationship
    optmParameter.lambda6   = 10^-5; %  regularization of second-order with negative label relationship
    
    optmParameter.rho       = 1;     % 2^{0,1,2,3}
    optmParameter.isBacktracking    = 0; % 0 - LSLC, 1 - LSLC-P
    optmParameter.eta       = 10;
    optmParameter.maxIter           = 30;
    optmParameter.minimumLossMargin = 0.01;
    optmParameter.tuneParaOneTime   = 1;
    
   %% Model Parameters
    modelparameter.cv_num             = 5;
    modelparameter.repetitions        = 1;
end



