function [Y,A,W] = FxFastICA(g_FastICA_mixedsig)
    [g_FastICA_mixedsig, g_FastICA_mixedmean] = remmean(g_FastICA_mixedsig);
    [g_FastICA_pca_E, g_FastICA_pca_D] = pcamat(g_FastICA_mixedsig, 1, size(g_FastICA_mixedsig,1), 'off', 'on');
    [g_FastICA_white_sig, g_FastICA_white_wm, g_FastICA_white_dwm] = whitenv(g_FastICA_mixedsig, g_FastICA_pca_E, g_FastICA_pca_D, 'on');
    [g_FastICA_ica_A,g_FastICA_ica_W]=fpica(g_FastICA_white_sig,g_FastICA_white_wm,g_FastICA_white_dwm);
    g_FastICA_ica_sig = g_FastICA_ica_W * g_FastICA_mixedsig + (g_FastICA_ica_W * g_FastICA_mixedmean) * ones(1,size(g_FastICA_mixedsig, 2));
    Y = g_FastICA_ica_sig;
    A = g_FastICA_ica_A;
    W = g_FastICA_ica_W;
end