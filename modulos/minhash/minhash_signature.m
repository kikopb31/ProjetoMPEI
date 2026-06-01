function signature = minhash_signature(shingles, H)
    numHashes = length(H);
    signature = inf(1, numHashes);  
    numShingles = numel(shingles);
    for i = 1:numShingles
        s = char(shingles(i));
        for h = 1:numHashes
            hashValue = H{h}(s);   
            if hashValue < signature(h)
                signature(h) = hashValue;
            end
        end
    end
end
