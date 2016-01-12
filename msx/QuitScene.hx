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

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Data;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.text.TextFormatAlign;


class QuitScene extends Scene {
    public function new(complete:Bool->Void, ?optionsMusic:Sfx) {
        super();
        _complete = complete;

        var options = null;
        if (optionsMusic != null) {
            options = new Button(
                0,
                0,
                'Options',
                function(button:Button) {
                    // OPTIONS
                    HXP.engine.pushScene(new OptionsScene(optionsMusic));
                }
            );
        }
        var cancel = new Button(
            MSX.PADX,
            0,
            'Cancel',
            function(button:Button) {
                _complete(false);
            }
        );
        var quit = new Button(
            MSX.PADX + cancel.width + MSX.PADCTL,
            0,
            'Quit',
            function(button:Button) {
                _complete(true);
            }
        );
        var w = MSX.PADX + cancel.width + MSX.PADCTL + quit.width + MSX.PADX;
        var h = cancel.height;
        if (options != null) {
            h += MSX.PADY + options.height;
            cancel.y += MSX.PADY + options.height;
            quit.y += MSX.PADY + options.height;
        }
        var l = (HXP.width / 2) - (w / 2);
        var t = (HXP.height / 2) - (h / 2);
        cancel.x += l;
        cancel.y += t;
        quit.x += l;
        quit.y += t;
        if (options != null) {
            options.x += (HXP.width - options.width) / 2;
            options.y += t;
            add(options);
        }
        addList([quit, cancel]);
    }

    override public function update() {
        super.update();
        if (Input.pressed(Key.ESCAPE)) {
            _complete(false);
        }
    }

    var _complete:Bool->Void;
}
