function H = hash_family(numHashes, maxValue)
    a = randi([1 maxValue], 1, numHashes);
    b = randi([0 maxValue], 1, numHashes);
    p = 2147483647; 
    H = cell(1, numHashes);
    for i = 1:numHashes
        H{i} = @(x) mod(a(i) * double(sum(x)) + b(i), p);
    end
end
