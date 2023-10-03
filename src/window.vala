/* window.vala
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

[GtkTemplate (ui = "/com/github/sidecuter/gciphers/window.ui")]
public class GCiphers.Window : Adw.ApplicationWindow {

    [GtkChild]
    private unowned Adw.OverlaySplitView split_view;

    public Window (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        ActionEntry[] action_entries = {
            { "show_sidebar", this.on_show_sidebar_action }
        };
        this.add_action_entries (action_entries, this);
    }

    private void on_show_sidebar_action () {
        this.split_view.set_show_sidebar (!this.split_view.get_show_sidebar ());
    }
}

