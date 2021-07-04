function GD = GrayDifference(R)
    h = size(R,1);
    w = size(R,2);
    GD = zeros(h, w);
    for i=2:h-1
        for j=2:w-1
            GD(i,j) = 1/4 * ((R(i,j)-R(i-1,j))^2 + ...
                             (R(i,j)-R(i+1,j))^2 + ...
                             (R(i,j)-R(i,j-1))^2 + ...
                             (R(i,j)-R(i,j+1))^2);
        end
    end
end