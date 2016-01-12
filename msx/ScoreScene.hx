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
import com.haxepunk.utils.Data;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.text.TextFormatAlign;


class ScoreScene extends Scene {
    public function new(?wait:Float) {
        super();
        if (wait != null) { 
            _returnAlarm = new Alarm(wait, function(t:Dynamic) {
                HXP.engine.popScene();
            }, TweenType.Persist);
        }

        var title = new Text('Scoreboard', 0, MSX.PADY_TITLE, 0, 0, {
            align: TextFormatAlign.CENTER,
            font: MSX.FONT,
            size: MSX.FONT_SIZE_TITLE
        });
        title.x = (HXP.width / 2) - (title.width / 2);
        add(new Entity(title));

        // display scores
        var scores = [];
        var max = { pos: 0, score: 0, name: 0, total: 0 };
        var p = 1;
        for (entry in MSX.scoreboard()) {
            var pos = new Text(Std.string(p), 0, 0, 0, 0, {
                font: MSX.FONT,
                size: MSX.FONT_SIZE_SCORE
            });
            var score = new Text(MSX.SCORE_FORMATER(entry.score), 0, 0, 0, 0, {
                font: MSX.FONT,
                size: MSX.FONT_SIZE_SCORE
            });
            var name = new Text(entry.name, 0, 0, 0, 0, {
                font: MSX.FONT,
                size: MSX.FONT_SIZE_SCORE
            });
            scores.push({ pos: pos, score: score, name: name });
            // figure out the sizing
            if (pos.width > max.pos) max.pos = pos.width;
            if (score.width > max.score) max.score = score.width;
            if (name.width > max.name) max.name = name.width;
            var totalWidth = pos.width + score.width + name.width;
            if (totalWidth > max.pos) max.total = totalWidth;
            p++;
        }

        // now space them and add them
        var y = MSX.PADY_TITLE + title.height + MSX.PADY_TITLE;
        var dy = MSX.PADY + scores[0].name.height;
        var x = (HXP.width - (max.total + (2 * MSX.PADCTL))) / 2;
        for (entry in scores) {
            entry.pos.y += y;
            entry.pos.x += x;
            entry.score.y += y;
            entry.score.x += x + MSX.PADCTL + max.pos;
            entry.name.y += y;
            entry.name.x += x + MSX.PADCTL + max.pos + MSX.PADCTL + max.score;
            addList([new Entity(entry.pos), new Entity(entry.score), new Entity(entry.name)]);
            y += dy;
        }
    }

    override public function begin() {
        if (_returnAlarm != null) {
            addTween(_returnAlarm, true);
        }
    }

    override public function end() {
        if (_returnAlarm != null) {
            _returnAlarm.cancel();
        }
    }

    override public function update() {
        if (_returnAlarm != null) {
            // in display mode
            if (Input.pressed(Key.ANY)) {
                _returnAlarm.cancel();
                HXP.engine.popScene();
            }
        }
    }

    var _returnAlarm:Alarm;
}
