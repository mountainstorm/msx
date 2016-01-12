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
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Tween;
import com.haxepunk.tweens.misc.Alarm;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.text.TextFormatAlign;


class TitleScene extends Scene {
    public function new(?scenes:Array<Scene>) {
        super();
        _scenes = scenes;
        _music = new Sfx(MSX.MUSIC_TITLE);
        _first = true;
    }

    override public function begin() {
        super.begin();
        if (_music.playing == false) {
            var userConfig = MSX.userConfig();
            _music.loop(userConfig.musicVolume);
        }
    }

    override public function update() {
        super.update();
        if (Input.pressed(Key.ESCAPE)) {
            _music.stop();
            if (_sceneSwap != null) {
                _sceneSwap.cancel();
            }
            HXP.engine.pushScene(quitScene());
        }
    }
   
    public function pause(b:Bool) {
        if (b) {
            _music.stop();
            HXP.engine.paused = true;
        } else {
            _music.resume();
            HXP.engine.paused = false;
        }
    }

    public function ready(?wait:Float) {
        if (_first) {
            add(new Button(
                HXP.width - MSX.PADX,
                MSX.PADY,
                'Options',
                function(button:Button) {
                    // OPTIONS
                    _sceneSwap.cancel();
                    HXP.engine.pushScene(optionsScene());
                }, {
                    align: TextFormatAlign.RIGHT,
                    size: 50
                }
            ));

            add(new FlashButton(
                HXP.width / 2,
                HXP.height - 90,
                'Click to Start',
                function(button:Button) {
                    // START GAME
                    _music.stop();
                    _sceneSwap.cancel();
                    HXP.engine.pushScene(gameScene());
                }, {
                    align: TextFormatAlign.CENTER,
                    size: 50,
                    showDuration: 2.0,
                    hideDuration: 0.5
                }
            ));
        }
        _first = false;

        // timer to rotate to high score board
        if (wait != null && _scenes.length > 0) {
            // we have scenes to transition and we're asked to do it
            // the idea is we wait x seconds then show the next scene.
            // once that returns our ready will be called again and we'll
            // wait and do it all again
            _sceneSwap = new Alarm(wait, function(t:Dynamic) {
                showNextScene();
            }, TweenType.OneShot);
            addTween(_sceneSwap, true);
        }
    }

    public function showNextScene() {
        var next = _scenes.shift();
        _scenes.push(next); // move it to the end        
        HXP.engine.pushScene(next);
    }

    public function quitScene():Scene {
        return new QuitScene(function(quit) {
            if (quit) {
                #if (!html5)
                #if (flash)
                    System.exit(1);
                #else
                    Sys.exit(1);
                #end
                #end
            } else {
                HXP.engine.popScene();
            }
        });        
    }

    public function optionsScene():Scene {
        return new OptionsScene(_music);
    }

    public function gameScene():Scene {
        return null;
    }

    var _first:Bool;
    var _sceneSwap:Alarm;
    var _music:Sfx;
    var _scenes:Array<Scene>;
}
