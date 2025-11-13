/* labels.vala
 *
 * Copyright 2025 Nicola tudo75 Tudino
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
 */

namespace ValaBrotherLabel {

    public enum FormFactor : int {
        DIE_CUT = 1,
        ENDLESS = 2,
        ROUND_DIE_CUT = 3,
        PTOUCH_ENDLESS = 4,
    }

    public enum Color : int {
        BLACK_WHITE = 0,
        BLACK_RED_WHITE = 1,
    }

    public class Label : Object {
        public string[] identifiers { get; set; }
        public int[] tape_size { get; set; } // array di 2 interi: larghezza, altezza in mm
        public FormFactor form_factor { get; set; }
        public int[] dots_total { get; set; } // array di 2 interi: larghezza, altezza in dots
        public int[] dots_printable { get; set; } 
        public int offset_r { get; set; }
        public int feed_margin { get; set; }
        public Color color { get; set; }

        public Label(string[] identifiers, int[] tape_size, FormFactor form_factor,
                int[] dots_total, int[] dots_printable, int offset_r,
                int feed_margin = 0, Color color = Color.BLACK_WHITE) {
            this.identifiers = identifiers;
            this.tape_size = tape_size;
            this.form_factor = form_factor;
            this.dots_total = dots_total;
            this.dots_printable = dots_printable;
            this.offset_r = offset_r;
            this.feed_margin = feed_margin;
            this.color = color;
        }

        public bool works_with_model(string model) {
            // Implementare logica se serve, qui placeholder sempre True
            return true;
        }

        public string get_name() {
            string out;
            switch (form_factor) {
                case FormFactor.DIE_CUT:
                    out = "%dmm x %dmm die-cut".printf(tape_size[0], tape_size[1]);
                    break;
                case FormFactor.ROUND_DIE_CUT:
                    out = "%dmm round die-cut".printf(tape_size[0]);
                    break;
                default:
                    out = "%dmm endless".printf(tape_size[0]);
                    break;
            }
            if (color == Color.BLACK_RED_WHITE) {
                out += " (black/red/white)";
            }
            return out;
        }
    }
}
