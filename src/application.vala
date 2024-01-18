/* application.vala
 *
 * Copyright 2023 Alexander Svobodov
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace GCiphers {
    public class Application : Adw.Application {
        public Application () {
            Object (application_id: "com.github.sidecuter.gciphers", flags: ApplicationFlags.DEFAULT_FLAGS);
        }

        construct {
            ActionEntry[] action_entries = {
                { "about", this.on_about_action },
                { "preferences", this.on_preferences_action },
                { "quit", this.quit }
            };
            this.add_action_entries (action_entries, this);
            this.set_accels_for_action ("app.quit", {"<primary>q"});
            Intl.setlocale (LocaleCategory.ALL, "");
            var envs = Environ.get();
            string? origin = null;
            if (Environment.get_os_info (OsInfoKey.NAME) == "Windows") {
                origin = Environ.get_variable (envs, "GCAD");
            }
            else {
                origin = Environ.get_variable (envs, "ORIGIN");
            }
            if (origin != null) {
                Intl.bindtextdomain (
                    Config.GETTEXT_PACKAGE,
                    Path.build_path (Path.DIR_SEPARATOR_S,
                        origin,
                        "usr",
                        Config.GNOMELOCALEDIR
                    )
                );
            }
            else {
                Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.GNOMELOCALEDIR);
            }
            Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");
            Intl.textdomain (Config.GETTEXT_PACKAGE);
        }

        public override void activate () {
            base.activate ();
            var win = this.active_window;
            if (win == null) {
                win = new GCiphers.Window (this);
            }
            win.present ();
            var provider = new Gtk.CssProvider ();
		    provider.load_from_resource ("/com/github/sidecuter/gciphers/styles/style.css");
		    Gtk.StyleContext.add_provider_for_display (
			    win.get_display (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
			);
        }

        private void on_about_action () {
            string[] developers = { "Alexander Svobodov" };
            var about = new Adw.AboutWindow () {
                transient_for = this.active_window,
                application_name = Config.APP_NAME,
                application_icon = Config.APP_ID,
                developer_name = "Alexander Svobodov",
                version = Config.VERSION,
                license_type = GPL_3_0,
                developers = developers,
                copyright = "© 2023 Alexander Svobodov",
            };
            about.present ();
        }

        private void on_preferences_action () {
            message ("app.preferences action activated");
        }
    }
}
