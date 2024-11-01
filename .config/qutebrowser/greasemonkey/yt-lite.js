// ==UserScript==
// @name         Optimizer Youtube script
// @namespace    https://github.com/limaon
// @version      1.0
// @description  Remove some elemets
// @author       Alvaro Oliveira
// @match        *://www.youtube.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    const seletores = [
        '#comments',
        //'#related',
        'ytd-merch-shelf-renderer',
        'ytd-companion-slot-renderer',
        '.ytd-compact-promoted-video-renderer',
        '#guide-button',
        '#end',
    ];

    function removerElementos() {
        seletores.forEach(seletor => {
            document.querySelectorAll(seletor).forEach(el => el.remove());
        });
    }

    window.addEventListener('load', removerElementos);

    const observador = new MutationObserver(removerElementos);
    observador.observe(document.body, { childList: true, subtree: true });
})();
