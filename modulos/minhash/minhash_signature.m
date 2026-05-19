function signature = minhash_signature(shingles, H)
    numHashes = length(H);
    signature = inf(1, numHashes);  
    for i = 1:length(shingles)
        s = char(shingles(i));
        for h = 1:numHashes
            hashValue = H{h}(s);   
            if hashValue < signature(h)
                signature(h) = hashValue;
            end
        end
    end
end
