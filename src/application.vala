/* application.vala
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

    public class Application {

        private const string APP_NAME = Constants.PROJECT_NAME;
        private const string VERSION = Constants.VERSION;
        private const string APP_ID = Constants.PROJECT_NAME;
        private const string APP_LANG_DOMAIN = Constants.GETTEXT_PACKAGE;
        private const string APP_INSTALL_PREFIX = Constants.PREFIX;

        private static bool version = false;
        private static bool debug = false;

        private static string help;

        private const GLib.OptionEntry[] entries = {
            // --version
            { "version", 'v', GLib.OptionFlags.NONE, GLib.OptionArg.NONE, ref version, "Display app version number", null },
            { "debug", 's', GLib.OptionFlags.NONE, GLib.OptionArg.NONE, ref debug, "Enable output of the debug messages.", null },
            { null }
        };

        public static int main (string[] args) {
            GLib.OptionGroup options;
            GLib.OptionContext context;

            try {
                options = Gst.init_get_option_group ();
                context = new GLib.OptionContext ("");
                context.add_main_entries (entries, APP_ID);
                context.add_group (options);
                context.set_help_enabled (true);
                context.parse (ref args);
                help = context.get_help (true, null);
            } catch (GLib.Error e) {
                printerr (_("Couldn't parse command-line options: %s\n"), e.message);
                print ("%s\n", context.get_help (true, null));
                return -1;
            }

            if (version) {
                print (_("Version: %s\n"), VERSION);
                return 0;
            }

            if (debug) {
                print (_("Debug messages activated.\n"));
            }

            Posix.fcntl (stdout.fileno (), Posix.F_SETFL, Posix.O_NONBLOCK);
/*
            if (filenames == null || filenames[0] == null || filenames[1] == null) {
                print ("%s\n", help);
                return -1;
            }
*/
            try {
                Application app = new Application ();
            } catch (Error e) {
                printerr ("%s\n", e.message);
                //print ("%s\n", help);
                return -1;
            }

            return 0;
        }

        public Application() {
            // Initialize the CLI application
            print("Welcome to the Vala CLI Application!\n");
            BackendUSB.list_available_devices ();
        }
    }
}