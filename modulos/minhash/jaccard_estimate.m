function sim = jaccard_estimate(sig1, sig2)
    sim = sum(sig1 == sig2) / length(sig1);
end
