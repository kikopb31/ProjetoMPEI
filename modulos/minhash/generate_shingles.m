function shingles = generate_shingles(text, k)
    words = split(lower(text));
    words = words(~cellfun('isempty', words));
    n = length(words);
    numShingles = n - k + 1;
    shingles = strings(1, numShingles);
    for i = 1:numShingles
        shingles(i) = strjoin(words(i:i+k-1));
    end
end
