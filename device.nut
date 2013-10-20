port0 <- hardware.uart57;
port0.configure(9600, 8, PARITY_NONE, 1, NO_CTSRTS);

class Screen {
    port = null;
    constructor(_port) {
        port = _port;
    }
    function set_size(_columns, _rows) {
        port.write(0xFE);
        port.write(0xD1);
        port.write(_columns);
        port.write(_rows);
        server.log("Set LCD: " + _columns + "x" + _rows);
    }
    function set_contrast(_value) {
        port.write(0xFE);
        port.write(0x50);
        port.write(_value);
        server.log("Contrast: " + _value);
    }
    function set_brightness(_value) {
        port.write(0xFE);
        port.write(0x99);
        port.write(_value);
        server.log("Brightness: " + _value);
    }
    function set_color(_red, _green, _blue) {
        port.write(0xFE);
        port.write(0xD0);
        port.write(_red);
        port.write(_green);
        port.write(_blue);
    }
    function cursor_off() {
        port.write(0xFE);
        port.write(0x4B);
        port.write(0xFE);
        port.write(0x54);
    }
    function clear_screen() {
        port.write(0xFE);
        port.write(0x58);
        server.log("Clear Screen");
    }
    function autoscroll_on() {
        port.write(0xFE);
        port.write(0x51);
    }
    function autoscroll_off() {
        port.write(0xFE);
        port.write(0x52);
    }
    function startup_message() {
        port.write(0xFE);
        port.write(0x40);
        port.write("**Your Startup*******Message****");
    }
    function cursor_at_line0() {
        port.write(0xFE);
        port.write(0x48);
    }
    function cursor_at_line1() {
        port.write(0xFE);
        port.write(0x47); 
        port.write(1);
        port.write(2);
    }
    function write_string(string) {
        foreach(i, char in string) {
            port.write(char);
        }
    }
}
imp.configure("Adafruit Serial LCD Class", [],[]);
    screen <- Screen(port0);
    screen.set_size(16, 2);
    screen.set_contrast(200);
    screen.set_brightness(255);
    screen.set_color(255, 20, 0); //Halloween orange
    screen.cursor_off();
    screen.clear_screen();
    screen.cursor_at_line0();
    screen.write_string(format("Signal: %ddBm", imp.rssi())); 
    screen.cursor_at_line1();
    screen.write_string(format("VREF: %.2fV", hardware.voltage()));
