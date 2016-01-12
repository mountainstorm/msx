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

import openfl.text.TextFormatAlign;


class Button extends Entity {
    public function new(x:Float, y:Float, label:String, clicked:Button->Void, ?options:Dynamic) {
        super(x, y);
        if (options != null) {
            if (!Reflect.hasField(options, 'font')) options.font = MSX.FONT;
            if (!Reflect.hasField(options, 'size')) options.size = MSX.FONT_SIZE_CTL;
            if (!Reflect.hasField(options, 'color')) options.color = MSX.COLOR_CTL;
        } else {
            options = {
                font: MSX.FONT,
                size: MSX.FONT_SIZE_CTL,
                color: MSX.COLOR_CTL
            }
        }
        setLabel(label, options);
        _clicked = clicked;
    }

    public function setLabel(label:String, options:Dynamic) {
        _text = new Text(label, 0, 0, 0, 0, options);
        graphic = _text;
        width = _text.width;
        height = _text.height;
        _originalColor = _text.color;
        // move origin based on align
        if (Reflect.hasField(options, 'align')) {
            if (options.align == TextFormatAlign.RIGHT) {
                x -= width;
            } else if (options.align == TextFormatAlign.CENTER) {
                x -= Math.floor(width / 2);
            }
        }
    }

    override public function update() {
        super.update();
        if (Input.mouseX >= x && Input.mouseX < x + width &&
            Input.mouseY >= y && Input.mouseY < y + height) {
            _text.color = MSX.COLOR_CTL_HIGHLIGHT;
            if (Input.mousePressed) {
                if (_clicked != null) {
                    _clicked(this);
                }
            }
        } else {
            _text.color = _originalColor;
        }
    }

    var _text:Text;
    var _originalColor:Int;
    var _clicked:Button->Void;
}
