function obj = bloom_filter(n, k)
    obj.n = n;
    obj.k = k;
    obj.vetor = zeros(1, n); 
    obj.primos = [33, 65, 127, 251, 503, 1019, 2027, 4049, 8101, 16223];
    
    if k > length(obj.primos)
        error('O número de hashes (k) ultrapassa a lista de primos disponíveis.');
    end
    
    obj.add = @(str, current_bf) add_element(current_bf, str);
    obj.check = @(str, current_bf) check_element(current_bf, str);
end


function bf_atualizado = add_element(bf, str)
    bf_atualizado = bf;
    for i = 1:bf.k
        idx = hash_string_bloom(str, bf.primos(i), bf.n);
        bf_atualizado.vetor(idx) = 1;
    end
end


function existe = check_element(bf, str)
    existe = true;
    for i = 1:bf.k
        idx = hash_string_bloom(str, bf.primos(i), bf.n);
        if bf.vetor(idx) == 0
            existe = false;
            return; 
        end
    end
end


function idx = hash_string_bloom(str, p, n)
    h = 5381;
    for j = 1:length(str)
        h = mod(h * p + double(str(j)), 1e9+7);
    end
    idx = mod(h, n) + 1;
end