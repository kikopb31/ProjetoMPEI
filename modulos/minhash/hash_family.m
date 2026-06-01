function H = hash_family(numHashes)
    p = 10000019; 
    H = cell(1, numHashes);
    for i = 1:numHashes
        a = randi([1, p-1]);
        b = randi([0, p-1]);
        H{i} = @(x) feval(@(val) val, mod(a * hash_string(x) + b, p));
    end
end

function h = hash_string(str)
    h = 5381; 
    for j = 1:length(str)
        h = mod(h * 33 + double(str(j)), 1e9+7); % primo ~1e9
    end
end
