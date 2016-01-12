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


class ScoreSaveScene extends Scene {
    public static var CHAR_CYCLE = 'ABCDEFGHIJKLMNOPQRSUVWXYZ01234567890_';

    static var TICK = 0.5;
    static var NAMELEN = 10;

    public function new(score:Dynamic, ?charCycle:String) {
        super();

        var title = new Text('Congratulations', 0, 0, HXP.width, 0, {
            align: TextFormatAlign.CENTER,
            font: MSX.FONT,
            size: MSX.FONT_SIZE_TITLE
        });
        var inst = new Text('Enter your name', 0, 0, HXP.width, 0, {
            align: TextFormatAlign.CENTER,
            font: MSX.FONT,
            size: 40
        });

        _charsToEnter = 3;
        _name = '';
        _nameDone = false;
        _charCycle = charCycle;
        _score = score;
        
        var score = new Text(MSX.SCORE_FORMATER(_score) + ' - ' + getName(), 0, 0, 0, 0, {
            align: TextFormatAlign.CENTER,
            font: MSX.FONT,
            size: 40            
        });
        _scoreX = score.x = (HXP.width - score.width) / 2;

        var dy = (HXP.height - (title.height + MSX.PADY + inst.height + MSX.PADY + score.height)) / 2;
        title.y = dy;
        inst.y =  dy + title.height + MSX.PADY;
        _scoreY = score.y = dy + title.height + MSX.PADY + inst.height + MSX.PADY;
        add(new Entity(title));
        add(new Entity(inst));
        _scoreEntity = new Entity(score);
        add(_scoreEntity);
    }

    override public function update() {
        super.update();
        _duration += HXP.elapsed;
        if (_duration > TICK || Input.pressed(Key.ANY)) {
            _duration = 0.0;
            if (_name.length < NAMELEN && _nameDone == false) {
                if ((Input.lastKey >= Key.DIGIT_0 && Input.lastKey <= Key.Z) || 
                    Input.lastKey == Key.SPACE) {
                    _name += String.fromCharCode(Input.lastKey);
                    Input.lastKey = 0;
                } else if (Input.lastKey == Key.ENTER) {
                    _nameDone = true;
                    Input.lastKey = 0;
                } else if (Input.lastKey == Key.BACKSPACE) {
                    if (_name.length > 0) {
                        _name = _name.substr(0, _name.length-1);
                    }
                    Input.lastKey = 0;
                }
            } else {
                MSX.setScore(_score, _name);
                HXP.engine.popScene(); // remove this scene
                HXP.engine.pushScene(scoreScene());
            }
            var score = new Text(Utils.scoreFormat(_score) + ' - ' + getName(), 0, 0, 0, 0, {
                align: TextFormatAlign.CENTER,
                font: MSX.FONT,
                size: 40            
            });
            score.x = _scoreX;
            score.y = _scoreY;
            _scoreEntity.graphic = score;
        }
    }

    function getName():String {
        var name = _name;
        if (_nameDone == false) {
            if (_charCycle != null && name.length < NAMELEN) {
                name += _charCycle.charAt(0);
            }
            for (i in name.length...NAMELEN) {
                name += '_';
            }
        }
        // cycle key 
        if (_charCycle != null) {
            var tmp = _charCycle.charAt(0);
            _charCycle = _charCycle.substr(1) + tmp;        
        }
        return name;
    }

    public function scoreScene() {
        return new ScoreScene(5);
    }

    var _charsToEnter:Int;
    var _name:String;
    var _nameDone:Bool;
    var _duration:Float;
    var _charCycle:String;
    var _scoreX:Float;
    var _scoreY:Float;
    var _score:Dynamic;
    var _scoreEntity:Entity;
}
