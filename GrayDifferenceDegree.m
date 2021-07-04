function GDD = GrayDifferenceDegree(X, Y)
    % X = input image
    % Y = scrambled image
    % E_X = E
    % E_Y = E'

    GD_X = GrayDifference(X);
    GD_Y = GrayDifference(Y);
    M = size(X,1);
    N = size(X,2);
    
    sum_X = 0;
    sum_Y = 0;
    
    for i=2:M-1
        for j=2:N-1
            sum_X = sum_X + GD_X(i,j);
            sum_Y = sum_Y + GD_Y(i,j);
        end
    end
    
    E_X = sum_X / ((M-2)*(N-2));
    E_Y = sum_Y / ((M-2)*(N-2));
    
    GDD = (E_Y - E_X) / (E_Y + E_X);
    
end

