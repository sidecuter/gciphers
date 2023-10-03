/* atbash.vala
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

[GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/atbash.ui")]
public class GCiphers.Atbash : Adw.Bin {

    [GtkChild]
    private unowned Gtk.Entry text;

    [GtkChild]
    private unowned Gtk.Button encrypt;

    [GtkChild]
    private unowned Gtk.Button decrypt;

    public Atbash () {
        Object (
        );
    }

    construct {
        this.encrypt.clicked.connect (e => {
            unowned var letters = text.get_buffer ().get_text ();
            for (int i = 0; i < letters.char_count (); i++) {
                message(letters.get_char (i).to_string ());
            }
        });
    }
}
