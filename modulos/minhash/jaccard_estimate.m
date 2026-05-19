function sim = jaccard_estimate(sig1, sig2)
    sim = sum(sig1 == sig2) / numel(sig1);
end
