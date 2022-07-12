function effect_size = effectSize(v_1, v_2, type)
% type = ['c']

if (type == 'c')
    
    [n_1, ~] = size(v_1);
    [n_2, ~] = size(v_2);
    
    m_1 = mean(v_1);
    m_2 = mean(v_2);
    
    var_1 = var(v_1);
    var_2 = var(v_2);
    
    pooled_sd = sqrt( ( ((n_1 - 1) * var_1) + ((n_2 - 1) * var_2) ) / n_1 + n_2 -2 );
    
    effect_size = (m_1 - m_2) / pooled_sd;
    
end

end