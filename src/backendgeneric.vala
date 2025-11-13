/* backendgeneric.vala
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

    public class BackendGeneric : Object {
        // Devices for writing and reading
        protected Object? write_dev = null;
        protected Object? read_dev = null;

        // Define an error domain quark for this class
        private static GLib.Quark error_quark = GLib.Quark.from_string("brotherql-backend-error");

        // Define error codes
        public enum BackendError {
            NOT_IMPLEMENTED = 1
        }

        // Constructor accepting a device specifier (string or object)
        public BackendGeneric (Object device_specifier) throws GLib.Error {
            // The constructor expects subclass implementation
            //throw new ValaBrotherLabel.BrotherQLError.NOT_IMPLEMENTED("Not implemented");
            throw new GLib.Error.literal (error_quark, (int) BackendError.NOT_IMPLEMENTED, "Not implemented");
        }

        // Protected virtual write method to be overridden
        protected virtual void _write (uint8[] data) {
            // Example: assuming write_dev has method 'write'
            // In real implementation, downcast and call method accordingly
            // (write_dev as YourDeviceClass).write(data);
        }

        // Protected virtual read method to be overridden
        protected virtual uint8[] _read (int length = 32) {
            // Example: assuming read_dev has method 'read'
            // Return bytes read from device
            // return (read_dev as YourDeviceClass).read(length);
            return new uint8[0]; // placeholder
        }

        // Public write wrapper with debug logging
        public void write (uint8[] data) {
            // TODO logging message
            stdout.printf("Writing %d bytes.\n", data.length);
            _write(data);
        }

        // Public read wrapper with debug logging and exception handling
        public uint8[] read (int length = 32) {
            try {
                uint8[] ret_bytes = _read(length);
                if (ret_bytes.length > 0) {
                    // TODO logging message
                    stdout.printf("Read %d bytes.\n", ret_bytes.length);
                }
                return ret_bytes;
            } catch (Error e) {
                stdout.printf("Error reading... %s\n", e.message);
            }
        }
    }
}