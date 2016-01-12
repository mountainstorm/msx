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


class FlashButton extends Button {
    public function new(x:Float, y:Float, label:String, clicked:Button->Void, options:Dynamic) {
        super(x, y, label, clicked, options);
        _state = 0;
        _time = 0.0;
        _options = options; // Note: won't have entries added in Button
    }

    public override function update() {
        super.update();
        _time += HXP.elapsed;
        if (_state == 0 && _time > _options.showDuration) {
            _time -= _options.showDuration;
            _state = 1;
            graphic = null;
        } else if (_state == 1 && _time > _options.hideDuration) {
            _time -= _options.hideDuration;
            _state = 0;
            graphic = _text;
        }
    }

    var _state:Int;
    var _time:Float;
    var _options:Dynamic;
}
