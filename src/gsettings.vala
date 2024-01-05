/* gsettings.vala
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
    [SingleInstance]
    class GSettings : Object {
        private Settings? settings;

        public GSettings () {
            Object();
        }

        construct {
            try {
                string origin;
                foreach (unowned string env in Environ.get()) {
                    var temp = env.split ("=");
                    if (temp[0] == "ORIGIN")
                        origin = temp[1];
                }
                string settings_dir;
                if (origin != null)
                    settings_dir = Path.build_path (
                        Path.DIR_SEPARATOR_S,
                        origin,
                        "usr",
                        Config.DATADIR,
                        "glib-2.0/schemas"
                    );
                else 
                    settings_dir = Path.build_path (Path.DIR_SEPARATOR_S, Config.DATADIR, "glib-2.0/schemas");
                SettingsSchemaSource sss = new SettingsSchemaSource.from_directory (settings_dir, null, false);
                SettingsSchema schema = sss.lookup (Config.APP_ID, false);
                if (schema != null) {
                    this.settings = new Settings.full (schema, null, null);
                }
            }
            catch (Error e) {
                warning (e.message);
            }
        }

        public void set_new_window_resolution (int width, int height) {
            settings?.set_int ("width", width);
            settings?.set_int ("height", height);
        }

        public void get_current_window_resolution (ref int width, ref int height) {
            width = settings == null ? width : settings.get_int ("width");
            height = settings == null ? height : settings.get_int ("height");
        }
    }
}