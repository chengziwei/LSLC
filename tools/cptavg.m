function [ Avg_Result ] = cptavg( cvResult,repetitions )
    cvResult = cvResult./repetitions;
    Avg_Result      = zeros(16,2);
    Avg_Result(:,1) = mean(cvResult,2);
    Avg_Result(:,2) = std(cvResult,1,2);
end

