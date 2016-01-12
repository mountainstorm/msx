/*
 * Copyright (c) 2016 Mountainstorm
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to 
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
*/

package msx;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.Shape;
import openfl.display.BitmapData;
import openfl.system.System;


class Slider extends Entity {
    public var value(get, set):Float;

    public function new(x:Float, y:Float, xsize:Int, ysize:Int, min:Float, max:Float, ?callback:Dynamic->Void) {
        super(x, y);
        width = xsize;
        height = ysize;
        _min = min;
        _max = max;
        _callback = callback;

        _bitmap = HXP.createBitmap(width, height, true, 0x00000000);
        graphic = new Image(_bitmap);
    }

    override public function added() {
        redraw();
    }

    override public function update() {
        super.update();
        if (Input.mouseX >= x && Input.mouseX < x + width &&
            Input.mouseY >= y && Input.mouseY < y + height) {
            if (_over == false) {
                _over = true;
                redraw();
            }
            if (Input.mouseDown) {
                var val = (Input.mouseX - x) / width;
                if (val != _value) {
                    _value = val;
                    if (_callback != null) {
                        _callback(_value);
                    }
                    redraw();
                }
            }
        } else {
            if (_over == true) {
                _over = false;
                redraw();
            }
        }
    }

    function redraw() {
        var color = MSX.COLOR_CTL;
        if (_over) {
            color = MSX.COLOR_CTL_HIGHLIGHT;
        }
        _bitmap.fillRect(
            new Rectangle(0, 0, width, height),
            0x00000000
        );
        var sh = new Shape();
        sh.graphics.lineStyle(2, color);
        sh.graphics.moveTo(1, height-1);
        sh.graphics.lineTo(width-1, 1);
        sh.graphics.lineTo(width-1, height-1);
        sh.graphics.lineTo(1, height-1);
        // draw the current value
        var w = value * (width-1);
        var h = value * (width-1) * ((height-1) / (width-1));
        sh.graphics.beginFill(color);
        sh.graphics.moveTo(1, height-1);
        sh.graphics.lineTo(w, height-1 - h);
        sh.graphics.lineTo(w, height-1);
        sh.graphics.lineTo(1, height-1);        
        sh.graphics.endFill();
        _bitmap.draw(sh);
    }

    function get_value():Float {
        return _value;
    }

    function set_value(value:Float):Float {
        _value = value;
        redraw();
        return value;
    }

    var _value:Float;
    var _min:Float;
    var _max:Float;
    var _bitmap:BitmapData;
    var _over:Bool;
    var _callback:Dynamic->Void;
}
