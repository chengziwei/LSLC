
function model = LSLC( X, Y, optmParameter)
% 
%    Syntax
%
%       [model] = LSML( X, Y, optmParameter)
%
%    Input
%       X               - a n by d data matrix, n is the number of instances and d is the number of features 
%       Y               - a n by l label matrix, n is the number of instances and l is the number of labels
%       optmParameter   - the optimization parameters for LSML, a struct variable with several fields, 
%
%    Output
%
%       model    -  a structure variable composed of the model coefficients

   %% optimization parameters
%     lambda1          = optmParameter.lambda1; % missing labels
%     lambda2          = optmParameter.lambda2; % regularization of W
%     lambda3          = optmParameter.lambda3; % regularization of C
%     lambda4          = optmParameter.lambda4; % regularization of graph laplacian
%     rho              = optmParameter.rho;
%     eta              = optmParameter.eta;
%     isBacktracking   = optmParameter.isBacktracking;
%     maxIter          = optmParameter.maxIter;
%     miniLossMargin   = optmParameter.minimumLossMargin;

    lambda1          = optmParameter.lambda1; % missing labels
    lambda2          = optmParameter.lambda2; % regularization of W
    lambda3          = optmParameter.lambda3; % regularization of C
    lambda4          = optmParameter.lambda4; % regularization of graph laplacian
    lambda5          = optmParameter.lambda5; %  regularization of second-order with positive label relationship
    lambda6          = optmParameter.lambda6; %  regularization of second-order with negative label relationship
    rho              = optmParameter.rho;
    eta              = optmParameter.eta;
    isBacktracking   = optmParameter.isBacktracking;
    maxIter          = optmParameter.maxIter;
    miniLossMargin   = optmParameter.minimumLossMargin;
    
    num_dim   = size(X,2);
    num_class = size(Y,2);
    XTX = X'*X;
    XTY = X'*Y;
    YTY = Y'*Y;
    
   %% initialization
    W   = (XTX + rho*eye(num_dim)) \ (XTY); %zeros(num_dim,num_class); % 

    W_1 = W; W_k = W;
    P = zeros(num_class,num_class); %eye(num_class,num_class);
    N = zeros(num_class,num_class); %eye(num_class,num_class);
    P_1 = P;
    N_1 = N;
    iter = 1; oldloss = 0;
    bk = 1; bk_1 = 1; 
    Lip1 = 5*norm(XTX)^2+5*norm(XTY)^2 + 3*norm((lambda4+1)*YTY)^2;
    Lip = sqrt(Lip1);
    while iter <= maxIter
       L_P = diag(sum(P,2)) - P;
       L_N = diag(sum(N,2)) + N;
       if isBacktracking == 0
           if lambda5>0
               Lip2_P = norm(lambda5*(L_P+L_P'));
           end
           if lambda6>0
               Lip2_N = norm(lambda6*(L_N+L_N'));
               Lip = sqrt( Lip1 + 6*Lip2_N^2 +5*Lip2_P^2);
           end
       else
            F_v = calculateF(W, XTX, XTY, YTY, P, N, lambda4, lambda5, lambda6);
            QL_v = calculateQ(W, XTX, XTY, YTY,P,N,lambda4,lambda5,lambda6, Lip,W_k);
           while F_v > QL_v
               Lip = eta*Lip;
               QL_v = calculateQ(W, XTX, XTY, YTY,P,N,lambda4,lambda5,lambda6, Lip,W_k);
           end
       end
      %% update P
       P_k  = P + (bk_1 - 1)/bk * (P - P_1);
       Gp_k = P_k - 1/Lip * gradientOfP(YTY,XTY,W,P_k,N, lambda4);
       P_1  = P;
       P    = softthres(Gp_k,lambda2/Lip); 
       P    = max(P,0);
      %% update N
       N_k  = N + (bk_1 - 1)/bk * (N - N_1);
       Gn_k = N_k - 1/Lip * gradientOfN(YTY,XTY,W,P,N_k, lambda4);
       N_1  = N;
       N    = softthres(Gn_k,lambda3/Lip); 
       N    = max(N,0);
       
      %% update W
       W_k  = W + (bk_1 - 1)/bk * (W - W_1);
       Gw_x_k = W_k - 1/Lip * gradientOfW(XTX,XTY,W_k,P,N,lambda5,lambda6);
       W_1  = W;
       W    = softthres(Gw_x_k,lambda1/Lip);
       
       bk_1   = bk;
       bk     = (1 + sqrt(4*bk^2 + 1))/2;
      
      %% Loss
       LS = X*W - Y*P - Y*N;
       DiscriminantLoss = trace(LS'* LS);
       LS = Y*P+Y*N - Y;
       CorrelationLoss  = trace(LS'*LS);
       CorrelationLoss2 = trace(W*L_P*W');
       CorrelationLoss3 = trace(W*L_N*W');
       sparesW    = sum(sum(W~=0));
       sparesP    = sum(sum(P~=0));
       sparesN    = sum(sum(N~=0));
       totalloss = DiscriminantLoss + lambda1*sparesW + lambda2*sparesP + lambda3*sparesN+lambda4*CorrelationLoss+lambda5*CorrelationLoss2+lambda6*CorrelationLoss3;
       loss(iter,1) = totalloss;
       if abs((oldloss - totalloss)/oldloss) <= miniLossMargin
           break;
       elseif totalloss <=0
           break;
       else
           oldloss = totalloss;
       end
       iter=iter+1;
    end
    model.W = W;
    model.P = P;
    model.N = N;
    model.loss = loss;
   
    model.optmParameter = optmParameter;
end

%% soft thresholding operator
function W = softthres(W_t,lambda)
    W = max(W_t-lambda,0) - max(-W_t-lambda,0);  
end

% function gradient = gradientOfW(XTX,XTY,W,C,lambda4)
function gradient = gradientOfW(XTX,XTY,W,P,N,lambda5,lambda6)
    L_P = diag(sum(P,2)) - P;
    L_N = diag(sum(N,2)) + N;
    gradient = XTX*W - XTY*P -XTY*N + lambda5*W*(L_P + L_P') + lambda6*W*(L_N + L_N');
end

function gradient = gradientOfP(YTY,XTY,W,P,N, lambda4)
    gradient = (lambda4+1)*YTY*P + (lambda4+1)*YTY*N- XTY'*W - lambda4*YTY;
end

function gradient = gradientOfN(YTY,XTY,W,P,N, lambda4)
    gradient = (lambda4+1)*YTY*P + (lambda4+1)*YTY*N- XTY'*W - lambda4*YTY;
end

% function F_v = calculateF(W, XTX, XTY, YTY, C, lambda1, lambda4)
function F_v = calculateF(W, XTX, XTY, YTY, P, N, lambda4, lambda5, lambda6)
% calculate the value of function F(\Theta)
    F_v = 0;     
    L_P = diag(sum(P,2)) - P;
    L_N = diag(sum(N,2)) + N;
    F_v = F_v + 0.5*trace(W'*XTX*W-2*W'*XTY*P -2*W'*XTY*N+ P'*YTY*P+2*P'*YTY*N+N'*YTY*N );
    F_v = F_v + 0.5*lambda4*trace(P'*YTY*P +2*P'*YTY*N -2*P'*YTY +N'*YTY*N-2*N'*YTY +YTY);
    F_v = F_v + lambda5*trace(W*L_P*W') + lambda6*trace(W*L_N*W');
end

function QL_v = calculateQ(W, XTX, XTY, YTY,P,N,lambda4,lambda5,lambda6, Lip,W_k)
% calculate the value of function Q_L(w_v,w_v_t)
    QL_v = 0;
    QL_v = QL_v + calculateF(W_k, XTX, XTY, YTY, P, N, lambda4, lambda5, lambda6);
    QL_v = QL_v + 0.5*Lip*norm(W - W_k,'fro')^2;
    QL_v = QL_v + trace((W - W_k)'*gradientOfW(XTX,XTY,W,P,N,lambda5,lambda6));
end
