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


class Checkbox extends Entity {
    public var checked(get, set):Bool;

    public function new(x:Float, y:Float, size:Int, ?callback:Dynamic->Void) {
        super(x, y);
        width = size;
        height = size;
        _callback = callback;

        _bitmap = HXP.createBitmap(size, size, true, 0x00000000);
        graphic = new Image(_bitmap);
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
            if (Input.mousePressed) {
                _checked = !_checked;
                if (_callback != null) {
                    _callback(_checked);
                }
                redraw();
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
        sh.graphics.moveTo(1, 1);
        sh.graphics.lineTo(width-2, 1);
        sh.graphics.lineTo(width-2, height-2);
        sh.graphics.lineTo(1, height-2);
        sh.graphics.lineTo(1, 1);
        if (_checked) {
            sh.graphics.moveTo(1, 1);
            sh.graphics.lineTo(width-2, height-2);
            sh.graphics.moveTo(width-2, 1);
            sh.graphics.lineTo(1, height-2);
        }
        _bitmap.draw(sh);
    }

    function get_checked():Bool {
        return _checked;
    }

    function set_checked(b:Bool):Bool {
        _checked = b;
        redraw();
        return b;
    }

    var _checked:Bool;
    var _bitmap:BitmapData;
    var _over:Bool;
    var _callback:Dynamic->Void;
}
