{
	config,
	lib,
	pkgs,
	...
}:
{
	config = lib.mkIf config.workstations.declarativeHome {
		environment.sessionVariables = {
			MOZ_USE_XINPUT2 = "1";
			XDG_CURRENT_DESKTOP = "sway";
		};
	
		programs.firefox = {
			enable = true;

			policies = {
				DisablePocket = true;
				SearchBar = "unified";
				NoDefaultBookmarks = true;
				OfferToSaveLogins = false;
				PasswordManagerEnabled = false;

				Preferences.browser.newtabpage.activity-stream = {
					showSponsored = lock-false;
					system.showSponsored = lock-false;
					showSponsoredTopSites = lock-false;
				};

				EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          EmailTracking = true;
          Fingerprinting = true;
        };
			};
			
			profiles = {
				"default" = {
					id = 0;

					extensions = with inputs.firefox-addons.packages.${pkgs.system}; {
						
					};

					settings = {
						extensions.autoDisableScopes = 0;
						browser.search = {
							region = "GB";
							isUS = false;
						};
						distribution.searchplugins.defaultLocale = "en-GB";
					  general.useragent.locale = "en-GB";
					};

					search = {
						force = true;
						default = "DuckDuckGo";
						privateDefault = "DuckDuckGo";
						engines = {
							"DuckDuckGo" = {
								urls = [{
									template = "https://duckduckgo.com";
									params = [
										{
											name = "q";
											value = "{searchTerms}";
										}
									];
								}];

								definedAliases = [ "@d" ];
							};
							"Nix Packages" = {
								urls = [{
									template = "https://search.nixos.org/packages";
									params = [
										{
											name = "type";
											value = "packages";
										}
										{
											name = "channel";
											value = "unstable";
										}
										{
											name = "query";
											value = "{searchTerms}";
										}
									];
									
									icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
							    definedAliases = [ "@pkgs" ];
								}];
							};
							"Nix Options" = {
								urls = [{
									template = "https://search.nixos.org/options";
									params = [
										{
											name = "type";
											value = "packages";
										}
										{
											name = "channel";
											value = "unstable";
										}
										{
											name = "query";
											value = "{searchTerms}";
										}
									];
									
									icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
							    definedAliases = [ "@opts" ];
								}];
							};
							"NixOS Wiki" = {
						    urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; }];
						    iconUpdateURL = "https://wiki.nixos.org/favicon.png";
						    updateInterval = 24 * 60 * 60 * 1000; # every day
						    definedAliases = [ "@nw" ];
						  };
						};
					};
				};
			};
		};
	};
}
