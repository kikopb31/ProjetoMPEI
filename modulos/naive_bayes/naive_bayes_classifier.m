function model = naive_bayes_classifier()
    model.vocab = {};
    model.p_words_original = [];
    model.p_words_plagio = [];
    model.p_original = 0.5;
    model.p_plagio = 0.5;
    model.train = @(docs_orig, docs_plag) train_model(docs_orig, docs_plag);
    model.classify = @(m, text) classify_text(m, text);
end


function model = train_model(docs_original, docs_plagio)
    all_docs = [docs_original, docs_plagio];
    all_words = {};
    for i = 1:length(all_docs)
        w = split(all_docs{i});
        all_words = [all_words; w(~cellfun('isempty', w))];
    end

    model.vocab = unique(all_words);
    V = length(model.vocab); 
    
    counts_original = zeros(1, V);
    counts_plagio = zeros(1, V);
    
    for i = 1:length(docs_original)
        w = split(docs_original{i});
        w = w(~cellfun('isempty', w)); 
        for j = 1:length(w)
            idx = find(strcmp(model.vocab, w{j}));
            if ~isempty(idx)
                counts_original(idx) = counts_original(idx) + 1;
            end
        end
    end
    

    for i = 1:length(docs_plagio)
        w = split(docs_plagio{i});
        w = w(~cellfun('isempty', w)); 
        for j = 1:length(w)
            idx = find(strcmp(model.vocab, w{j}));
            if ~isempty(idx)
                counts_plagio(idx) = counts_plagio(idx) + 1;
            end
        end
    end
    

    total_w_orig = sum(counts_original);
    total_w_plag = sum(counts_plagio);
    total_docs = length(docs_original) + length(docs_plagio);

    model.p_words_original = (counts_original + 1) / (total_w_orig + V);
    model.p_words_plagio = (counts_plagio + 1) / (total_w_plag + V);
    model.p_original = length(docs_original) / total_docs;
    model.p_plagio = length(docs_plagio) / total_docs;
end


function e_plagio = classify_text(model, text)
    words = split(text);
    words = words(~cellfun('isempty', words));
    
    log_p_orig = log(model.p_original);
    log_p_plag = log(model.p_plagio);
    
    V = length(model.vocab);
    p_omissao_orig = 1 / (V + 1);
    p_omissao_plag = 1 / (V + 1);
    
    for i = 1:length(words)
        idx = find(strcmp(model.vocab, words{i}));
        if ~isempty(idx)
            log_p_orig = log_p_orig + log(model.p_words_original(idx));
            log_p_plag = log_p_plag + log(model.p_words_plagio(idx));
        else
            log_p_orig = log_p_orig + log(p_omissao_orig);
            log_p_plag = log_p_plag + log(p_omissao_plag);
        end
    end
    
    e_plagio = log_p_plag > log_p_orig;
end