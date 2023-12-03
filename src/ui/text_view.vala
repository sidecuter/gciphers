/* text_view.vala
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

 namespace UI {
    [GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/text_view.ui")]
    public class TextView : Gtk.TextView {

        [GtkChild]
        private unowned Gtk.TextBuffer text;

        public Gtk.TextBuffer get_text_buffer () {
            return this.text;
        }

    }
 }
 