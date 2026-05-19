function t = process_text(text)
    t = lower(text);                     
    t = regexprep(t, '[^\w\s]', '');     
    t = regexprep(t, '\s+', ' ');       
end
