port0 <- hardware.uart57;
port0.configure(9600, 8, PARITY_NONE, 1, NO_CTSRTS);

class Screen {
    port = null;
    lines = null;
    positions = null;
    red = 0;
    green = 0;
    blue = 0;
    constructor(_port) {
        port = _port;
        lines = ["Initializing...", ""];
        positions = [0, 0];
    }
    function set0(line) {
        lines[0] = line;
    }
    
    function set1(line) {
        lines[1] = line;
    }
    function set_size() {
        port.write(0xFE);
        port.write(0xD1);
        port.write(16);
        port.write(2);
        server.log("Set LCD 16x2");
    }
    function set_contrast() {
        port.write(0xFE);
        port.write(0x50);
        port.write(200);
        server.log("Set Contrast = 200");
    }
    function set_brightness() {
        port.write(0xFE);
        port.write(0x99);
        port.write(255);
        server.log("Set Brightness = 255(100%)");
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
    
    function cursor_at_line0() {
        port.write(0xFE);
        port.write(0x48);
    }
    function cursor_at_line1() {
        port.write(0xFE);
        port.write(0x48); // Not sure what position this is.
    }
    function write_string(string) {
        foreach(i, char in string) {
            port.write(char);
        }
        //server.log("Wrote string.");
    }
    function red() {
        red = 75;
        port.write(0xFE);
        port.write(0xD0);
        port.write(red);
    }
    function green() {
        green = 255;
        port.write(0xFE);
        port.write(0xD0);
        port.write(green);   
    }
    function blue() {
        blue = 255;
        port.write(0xFE);
        port.write(0xD0);
        port.write(blue);
    }
    function start() {
        update_screen();
    }
    function update_screen() {
        imp.wakeup(0.4, update_screen.bindenv(this));
        
        cursor_at_line0();
        display_message(0);
        
        cursor_at_line1();
        display_message(1);
    }
    
    function display_message(idx) {  
        local message = lines[idx];
        
        local start = positions[idx];
        local end   = positions[idx] + 16;
        
    
        if (end > message.len()) {
            end = message.len();
        }
    
        local string = message.slice(start, end);
        for (local i = string.len(); i < 16; i++) {
            string  = string + " ";
        }
    
        write_string(string);
    
        if (message.len() > 16) {
            positions[idx]++;
            if (positions[idx] > message.len() - 1) {
                positions[idx] = 0;
            }
        }
    }
}

imp.configure("Adafruit Serial LCD", [],[]);
    screen <- Screen(port0);
    screen.set_size();
    screen.set_contrast();
    screen.set_brightness();
    screen.cursor_off();
    screen.clear_screen();
    //screen.start();
    screen.red();
    //screen.green();
    //screen.blue();
    screen.cursor_at_line0();
    //screen.start();
    //screen.rgb();
    //screen.set0("Testing......");
    screen.write_string(format("%ddBm", imp.rssi())); 
    //screen.write_string("Hello!");
