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
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;

import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.display.BitmapData;
import openfl.text.TextFormatAlign;
import openfl.geom.ColorTransform;
import openfl.Assets;


class LevelIntroScene extends Scene {
    public function new(no:Int, level:Dynamic, startText:String) {
        super();

        var title = new Text('Level ' + no + ' - ' + level.title, 0, 0, HXP.width, 0, {
            align: TextFormatAlign.CENTER,
            font: MSX.FONT,
            size: MSX.FONT_SIZE_TITLE
        });
        var description = new Text(level.description, 0, 0, HXP.width, 0, {
            align: TextFormatAlign.CENTER,
            font: MSX.FONT,
            size: 40            
        });

        var dy = (HXP.height - (title.height + MSX.PADY + description.height)) / 2;
        title.y = dy;
        description.y = dy + title.height + MSX.PADY;
        add(new Entity(title));
        add(new Entity(description));

        add(new FlashButton(
            HXP.width / 2,
            HXP.height - 90,
            startText,
            function(button:Button) {
                HXP.engine.popScene(); // pop us
                HXP.engine.pushScene(playScene(level)); // put the play scene on
            }, {
                align: TextFormatAlign.CENTER,
                size: 50,
                showDuration: 2.0,
                hideDuration: 0.5
            }
        ));
    }

    public function playScene(level:Dynamic) {
        return null;
    }

}
