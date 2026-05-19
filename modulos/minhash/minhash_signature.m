function signature = minhash_signature(shingles, H)
    numHashes = length(H);
    signature = inf(1, numHashes);
    for i = 1:length(shingles)
        s = char(shingles(i));
        for h = 1:numHashes
            signature(h) = min(signature(h), H{h}(s));
        end
    end
end
