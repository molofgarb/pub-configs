// indent 0: changed
// indent 2: not changed but could be important

/* 0102: set startup page [SETUP-CHROME]
 * 0=blank, 1=home, 2=last visited page, 3=resume previous session
 * [NOTE] Session Restore is cleared with history (2811, 2820), and not used in Private Browsing mode
 * [SETTING] General>Startup>Restore previous session ***/
user_pref("browser.startup.page", 3);

/* 0201: use Mozilla geolocation service instead of Google if permission is granted [FF74+]
 * Optionally enable logging to the console (defaults to false) ***/
    user_pref("geo.provider.network.logging.enabled", true);

/* 0403: disable SB checks for downloads (remote)
 * To verify the safety of certain executable files, Firefox may submit some information about the
 * file, including the name, origin, size and a cryptographic hash of the contents, to the Google
 * Safe Browsing service which helps Firefox determine whether or not the file should be blocked
 * [SETUP-SECURITY] If you do not understand this, or you want this protection, then override this ***/
user_pref("browser.safebrowsing.downloads.remote.enabled", true);

/* 0801: disable location bar using search
 * Don't leak URL typos to a search engine, give an error message instead
 * Examples: "secretplace,com", "secretplace/com", "secretplace com", "secret place.com"
 * [NOTE] This does not affect explicit user action such as using search buttons in the
 * dropdown, or using keyword search shortcuts you configure in options (e.g. "d" for DuckDuckGo)
 * [SETUP-CHROME] Override this if you trust and use a privacy respecting search engine ***/
user_pref("keyword.enabled", true);

/* 0807: disable location bar contextual suggestions [FF92+]
 * [SETTING] Privacy & Security>Address Bar>Suggestions from...
 * [1] https://blog.mozilla.org/data/2021/09/15/data-and-firefox-suggest/ ***/
 user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", true); // [FF95+]

/* 0808: disable tab-to-search [FF85+]
 * Alternatively, you can exclude on a per-engine basis by unchecking them in Options>Search
 * [SETTING] Privacy & Security>Address Bar>When using the address bar, suggest>Search engines ***/
   user_pref("browser.urlbar.suggest.engines", true);

        /* 0820: disable coloring of visited links
        * [SETUP-HARDEN] Bulk rapid history sniffing was mitigated in 2010 [1][2]. Slower and more expensive
        * redraw timing attacks were largely mitigated in FF77+ [3]. Using RFP (4501) further hampers timing
        * attacks. Don't forget clearing history on exit (2811). However, social engineering [2#limits][4][5]
        * and advanced targeted timing attacks could still produce usable results
        * [1] https://developer.mozilla.org/docs/Web/CSS/Privacy_and_the_:visited_selector
        * [2] https://dbaron.org/mozilla/visited-privacy
        * [3] https://bugzilla.mozilla.org/1632765
        * [4] https://earthlng.github.io/testpages/visited_links.html (see github wiki APPENDIX A on how to use)
        * [5] https://lcamtuf.blogspot.com/2016/08/css-mix-blend-mode-is-bad-for-keeping.html ***/
          //  user_pref("layout.css.visited_links_enabled", false);
          
        /* 0905: limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources [FF41+]
        * hardens against potential credentials phishing
        * 0 = don't allow sub-resources to open HTTP authentication credentials dialogs
        * 1 = don't allow cross-origin sub-resources to open HTTP authentication credentials dialogs
        * 2 = allow sub-resources to open HTTP authentication credentials dialogs (default) ***/
        user_pref("network.auth.subresource-http-auth-allow", 1);

        /* 1241: disable insecure passive content (such as images) on https pages [SETUP-WEB] ***/
        // user_pref("security.mixed_content.block_display_content", true);

/* 1001: disable disk cache
 * [SETUP-CHROME] If you think disk cache helps perf, then feel free to override this
 * [NOTE] We also clear cache on exit (2811) ***/
user_pref("browser.cache.disk.enable", true);

/* 1601: control when to send a cross-origin referer
* 0=always (default), 1=only if base domains match, 2=only if hosts match
* [SETUP-WEB] Breakage: older modems/routers and some sites e.g banks, vimeo, icloud, instagram
* If "2" is too strict, then override to "0" and use Smart Referer extension (Strict mode + add exceptions) ***/
    user_pref("network.http.referer.XOriginPolicy", 2);
        /* 1602: control the amount of cross-origin information to send [FF52+]
        * 0=send full URI (default), 1=scheme+host+port+path, 2=scheme+host+port ***/
          user_pref("network.http.referer.XOriginTrimmingPolicy", 2);


        /* 2004: force exclusion of private IPs from ICE candidates [FF51+]
        * [SETUP-HARDEN] This will protect your private IP even in TRUSTED scenarios after you
        * grant device access, but often results in breakage on video-conferencing platforms ***/
        // user_pref("media.peerconnection.ice.no_host", true);


/* 2022: disable all DRM content (EME: Encryption Media Extension)
 * Optionally hide the setting which also disables the DRM prompt
 * [SETUP-WEB] e.g. Netflix, Amazon Prime, Hulu, HBO, Disney+, Showtime, Starz, DirectTV
 * [SETTING] General>DRM Content>Play DRM-controlled content
 * [TEST] https://bitmovin.com/demos/drm
 * [1] https://www.eff.org/deeplinks/2017/10/drms-dead-canary-how-we-just-lost-web-what-we-learned-it-and-what-we-need-do-next ***/
 user_pref("media.eme.enabled", false);
 // user_pref("browser.eme.ui.enabled", false);

/* 2030: disable autoplay of HTML5 media [FF63+]
 * 0=Allow all, 1=Block non-muted media (default), 5=Block all
 * [NOTE] You can set exceptions under site permissions
 * [SETTING] Privacy & Security>Permissions>Autoplay>Settings>Default for all websites ***/
   user_pref("media.autoplay.default", 5);

        /* 2619: use Punycode in Internationalized Domain Names to eliminate possible spoofing
        * [SETUP-WEB] Might be undesirable for non-latin alphabet users since legitimate IDN's are also punycoded
        * [TEST] https://www.xn--80ak6aa92e.com/ (www.apple.com)
        * [1] https://wiki.mozilla.org/IDN_Display_Algorithm
        * [2] https://en.wikipedia.org/wiki/IDN_homograph_attack
        * [3] https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=punycode+firefox
        * [4] https://www.xudongz.com/blog/2017/idn-phishing/ ***/
        user_pref("network.IDN_show_punycode", true);

        /* 2701: enable ETP Strict Mode [FF86+]
        * ETP Strict Mode enables Total Cookie Protection (TCP)
        * [NOTE] Adding site exceptions disables all ETP protections for that site and increases the risk of
        * cross-site state tracking e.g. exceptions for SiteA and SiteB means PartyC on both sites is shared
        * [1] https://blog.mozilla.org/security/2021/02/23/total-cookie-protection/
        * [SETTING] to add site exceptions: Urlbar>ETP Shield
        * [SETTING] to manage site exceptions: Options>Privacy & Security>Enhanced Tracking Protection>Manage Exceptions ***/
        user_pref("browser.contentblocking.category", "strict");

        /* 2810: enable Firefox to clear items on shutdown (2811)
        * [SETTING] Privacy & Security>History>Custom Settings>Clear history when Firefox closes ***/
        user_pref("privacy.sanitize.sanitizeOnShutdown", true);

/* 2811: set/enforce what items to clear on shutdown (if 2810 is true) [SETUP-CHROME]
 * These items do not use exceptions, it is all or nothing (1681701)
 * [NOTE] If "history" is true, downloads will also be cleared
 * [NOTE] "sessions": Active Logins: refers to HTTP Basic Authentication [1], not logins via cookies
 * [NOTE] "offlineApps": Offline Website Data: localStorage, service worker cache, QuotaManager (IndexedDB, asm-cache)
 * [SETTING] Privacy & Security>History>Custom Settings>Clear history when Firefox closes>Settings
 * [1] https://en.wikipedia.org/wiki/Basic_access_authentication ***/
user_pref("privacy.clearOnShutdown.history", false);   // [DEFAULT: true]
user_pref("privacy.clearOnShutdown.sessions", false);  // [DEFAULT: true]

/* 4504: enable RFP letterboxing [FF67+]
 * Dynamically resizes the inner window by applying margins in stepped ranges [2]
 * If you use the dimension pref, then it will only apply those resolutions.
 * The format is "width1xheight1, width2xheight2, ..." (e.g. "800x600, 1000x1000")
 * [SETUP-WEB] This is independent of RFP (4501). If you're not using RFP, or you are but
 * dislike the margins, then flip this pref, keeping in mind that it is effectively fingerprintable
 * [WARNING] DO NOT USE: the dimension pref is only meant for testing
 * [1] https://bugzilla.mozilla.org/1407366
 * [2] https://hg.mozilla.org/mozilla-central/rev/6d2d7856e468#l2.32 ***/
 user_pref("privacy.resistFingerprinting.letterboxing", false); // [HIDDEN PREF]

 /* 4520: disable WebGL (Web Graphics Library)
 * [SETUP-WEB] If you need it then override it. RFP still randomizes canvas for naive scripts ***/
user_pref("webgl.disabled", false);

/* 5010: disable location bar suggestion types
 * [SETTING] Privacy & Security>Address Bar>When using the address bar, suggest ***/
   user_pref("browser.urlbar.suggest.history", false);
   // user_pref("browser.urlbar.suggest.bookmark", false);
   // user_pref("browser.urlbar.suggest.openpage", false);
   user_pref("browser.urlbar.suggest.topsites", false); // [FF78+]

// 9000

/* UPDATES ***/
   user_pref("app.update.auto", false); // [NON-WINDOWS] disable auto app updates
      // [NOTE] You will still get prompts to update, and should do so in a timely manner
      // [SETTING] General>Firefox Updates>Check for updates but let you choose to install them

/* APPEARANCE ***/
user_pref("ui.systemUsesDarkTheme", 1); // [FF67+] [HIDDEN PREF]
      // 0=light, 1=dark: with RFP this only affects chrome

// Other Overrides
// https://github.com/peternrdstrm/Arkenfox-Overrides/blob/main/user-overrides.js

//Section 3: Misc changes (mostly personal prefrence)
user_pref("browser.compactmode.show", true); //compact mode is displayed by default
user_pref("privacy.spoof_english", 2); //spoofs english by default
user_pref("network.trr.mode", 2); //set DoH to custom adress
user_pref("network.trr.custom_uri", "https://dns.quad9.net/dns-query"); //custom adress 
user_pref("network.trr.uri", "https://dns.quad9.net/dns-query"); //custom adress 

// temp files
user_pref("browser.download.start_downloads_in_tmp_dir", true); 

