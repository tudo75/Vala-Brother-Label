/* backendusb.vala
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

    public class BackendUSB {
        private LibUSB.Device? dev;
        private int read_timeout = 10;    // ms
        private int write_timeout = 15000; // ms
        private string strategy = "try_twice";

        public static LibUSB.Device[] list_available_devices() {

            // declare objects
            LibUSB.Context context;
            LibUSB.Device[] devices;

            // initialize LibUSB and get the device list
            LibUSB.Context.init (out context);
            devices = context.get_device_list ();

            stdout.printf ("\n USB Device List\n---------------\n");

            // iterate through the list
            int i = 0;
            while (devices[i] != null)
            {
                var dev = devices[i];

                // we print all values in hexadecimal here

                stdout.printf ("\n Bus number : %04x", dev.get_bus_number ());
                stdout.printf ("\n Address : %04x", dev.get_device_address ());

                LibUSB.DeviceDescriptor desc = LibUSB.DeviceDescriptor (dev);
                stdout.printf ("\n Vendor ID : %04x",  desc.idVendor);
                stdout.printf ("\n Product ID : %04x", desc.idProduct);
                stdout.printf ("\n iSerialNumber : %10x", desc.iSerialNumber);
                stdout.printf ("\n iProduct : %10x", desc.iProduct);
                stdout.printf ("\n bDeviceProtocol : %10x", desc.bDeviceProtocol);
                stdout.printf ("\n bDeviceClass : %10x", desc.bDeviceClass);
                stdout.printf ("\n bDescriptorType : %10x", desc.bDescriptorType);
                stdout.printf ("\n bcdDevice : %10x", desc.bcdDevice);

                stdout.printf ("\n");
                i++;
            }

            return devices;
        }


        public BackendUSB() {
            list_available_devices();
        }
    }
}
/*
        public construct (object device_specifier) {
            this.dev = null;

            if (device_specifier is string) {
                string devstr = (string) device_specifier;
                if (devstr.has_prefix("usb://"))
                    devstr = devstr.substring(6);

                string[] parts = devstr.split('/');
                string[] vidpid = parts.length > 0 ? parts[0].split(':') : null;
                string? serial = parts.length > 1 ? parts[1] : null;

                int vendor = int.parse(vidpid[0], 16);
                int product = int.parse(vidpid[1], 16);

                foreach (var d in list_available_devices()) {
                    var printer = (Device) d["instance"];
                    var desc = printer.getDeviceDescriptor();
                    if ((desc.idVendor == vendor && desc.idProduct == product) ||
                        (serial != null && printer.getStringDescriptor(desc.iSerialNumber) == serial)) {
                        this.dev = printer;
                        break;
                    }
                }
                if (this.dev == null) {
                    throw new Error.FAILED("Device not found");
                }
            } else if (device_specifier is Device) {
                this.dev = (Device) device_specifier;
            } else {
                throw new Error.NOT_SUPPORTED("Device specifier must be string or Device");
            }

            // Detach kernel driver if active (if supported)
            try {
                if (this.dev.isKernelDriverActive(0)) {
                    this.dev.detachKernelDriver(0);
                    this.was_kernel_driver_active = true;
                }
            } catch (Error) {
                this.was_kernel_driver_active = false;
            }

            this.dev.setConfiguration();

            var cfg = this.dev.getActiveConfiguration();
            this.intf = cfg.findInterface(0);

            this.ep_in = this.intf.findEndpoint(e => e.direction == EndpointDirection.IN);
            this.ep_out = this.intf.findEndpoint(e => e.direction == EndpointDirection.OUT);

            if (this.ep_in == null || this.ep_out == null)
                throw new Error.FAILED("Could not find required endpoints");
        }

        private GLib.Bytes raw_read(int length) {
            return this.ep_in.read(length, this.read_timeout);
        }

        public GLib.Bytes read(int length = 32) {
            if (this.strategy == "try_twice") {
                GLib.Bytes data = raw_read(length);
                if (data.get_data().length > 0) return data;
                else {
                    Thread.usleep(this.read_timeout * 1000);
                    return raw_read(length);
                }
            } else if (this.strategy == "select") {
                GLib.Bytes data = new GLib.Bytes();
                double start = GLib.get_monotonic_time() / 1000.0;

                while (data.get_data().length == 0 && GLib.get_monotonic_time()/1000.0 - start < this.read_timeout) {
                    // In Vala, select-like behavior isn't trivial; simplified here
                    data = raw_read(length);
                    if (data.get_data().length > 0) break;
                    Thread.usleep(1000);
                }
                if (data.get_data().length == 0)
                    return raw_read(length);
                else
                    return data;
            } else {
                throw new Error.NOT_SUPPORTED("Unknown strategy");
            }
        }

        public void write(GLib.Bytes data) {
            this.ep_out.write(data, this.write_timeout);
        }

        public void dispose() {
            if (this.dev != null) {
                // Release resources
                if (this.was_kernel_driver_active)
                    this.dev.attachKernelDriver(0);

                this.dev = null;
                this.ep_in = null;
                this.ep_out = null;
                this.intf = null;
            }
        }
*/