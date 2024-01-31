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

namespace GCiphers {

    int timeout = 2;
    
    public delegate void spawn_toast (string message);

    public delegate string get_alphabet ();

    [GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/window.ui")]
    public class Window : Adw.ApplicationWindow {

        private string[] labels = {
            _("Atbash"),
            _("Caesar"),
            _("Polybius"),
            _("Trithemium"),
            _("Belazo"),
            _("Vigenere"),
            _("Vertical"),
            _("VigenereII"),
            _("Matrix"),
            _("Playfair"),
            _("Scrambler"),
            _("Shenon"),
        };

        private List<Adw.Bin> pages;
        
        [GtkChild]
        private unowned Adw.ToastOverlay toast;

        [GtkChild]
        private unowned Adw.OverlaySplitView split_view;

        [GtkChild]
        private unowned Adw.ViewStack stack;

        [GtkChild]
        private unowned Gtk.ListBox list_rows;

        [GtkChild]
        private unowned Gtk.DropDown dropdown;

        [GtkCallback]
        private void on_sidebar_button_toggle (Gtk.ToggleButton self) {
            this.split_view.set_show_sidebar (!this.split_view.get_show_sidebar ());
        }

        [GtkCallback]
        private void on_row_selected (Gtk.ListBoxRow? row) {
            if (row != null) {
                this.set_title (labels [row.get_index ()]);
                stack.set_visible_child (stack.get_child_by_name (pages.nth (row.get_index ()).data.name));
            }
        }

        public Window (Gtk.Application app) {
            Object (application: app);
        }

        construct {
            pages.append (new GCiphers.Atbash (this.toaster));
            pages.append (new GCiphers.Caesar (this.toaster));
            pages.append (new GCiphers.Polybius (this.toaster));
            pages.append (new GCiphers.Trithemium (this.toaster));
            pages.append (new GCiphers.Belazo (this.toaster));
            pages.append (new GCiphers.Vigenere (this.toaster));
            pages.append (new GCiphers.Vertical (this.toaster));
            pages.append (new GCiphers.Vigenereii (this.toaster));
            pages.append (new GCiphers.Matrix (this.toaster));
            pages.append (new GCiphers.Playfair (this.toaster));
            pages.append (new GCiphers.Scrambler (this.toaster));
            pages.append (new GCiphers.Shenon (this.toaster));
            for (int i = 0; i < labels.length; i++) {
                list_rows.append (new GCiphers.Menu_entry (labels[i]));
            }
            pages.foreach ((page) => { stack.add_named (page, page.name); });
            list_rows.select_row (list_rows.get_row_at_index (0));
            var settings = new GSettings ();
            int width = 0, height = 0;
            settings.get_current_window_resolution (ref width, ref height);
            set_default_size (width, height);
            close_request.connect (e => {
                settings.set_new_window_resolution (get_width (), get_height ());
                return false;
            });
        }

        public void toaster (string message) {
            Adw.Toast toast_message = new Adw.Toast (message);
            toast_message.set_timeout (timeout);
            toast.add_toast (toast_message);
        }
    }
}
