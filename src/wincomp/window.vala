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

[GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/window.ui")]
public class GCiphers.Window : Adw.ApplicationWindow {
    private string[] labels = {
        "Atbash",
        "Caesar"
    };

    [GtkChild]
    private unowned Adw.ToastOverlay toast;

    [GtkChild]
    private unowned Adw.OverlaySplitView split_view;

    [GtkChild]
    private unowned Adw.ViewStack stack;

    [GtkChild]
    private unowned Gtk.ToggleButton show_sidebar_button;

    [GtkChild]
    private unowned Gtk.ListBox list_rows;

    public Window (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        for (int i = 0; i < labels.length; i++) {
            list_rows.append (new GCiphers.Menu_entry(labels[i]));
        }
        this.show_sidebar_button.set_active (true);
        this.show_sidebar_button.toggled.connect (e => {
            this.split_view.set_show_sidebar (!this.split_view.get_show_sidebar ());
        });
        stack.add_named (new GCiphers.Atbash (toast), labels[0]);
        list_rows.row_selected.connect (row => {
            this.set_title (labels [row.get_index ()]);
            stack.set_visible_child (stack.get_child_by_name (this.get_title ()));
        });
        list_rows.select_row (list_rows.get_row_at_index (0));
    }
}
