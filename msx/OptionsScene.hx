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
import com.haxepunk.graphics.Text;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.text.TextFormatAlign;


class OptionsScene extends Scene {
    var MPAD:Float;

    public function new(music:Sfx) {
        super();
        MPAD = (3 * MSX.PADX);
        _userConfig = Reflect.copy(MSX.userConfig());
        _music = music;
        _sound = new Sfx('audio/sample.ogg', function() {
            if (_replaySound) {
                _sound.play();
                _replaySound = false;
            }
        });

        var title = new Text('Options', 0, MSX.PADY_TITLE, 0, 0, {
            align: TextFormatAlign.CENTER,
            font: MSX.FONT,
            size: MSX.FONT_SIZE_TITLE
        });
        title.x = (HXP.width / 2) - (title.width / 2);
        add(new Entity(title));

        settings(title.height);
        cancelSave();
    }

    override public function update() {
        super.update();
        if (Input.pressed(Key.ESCAPE)) {
            cancel();
        }
    }

    public function cancel() {
        var userConfig = MSX.userConfig();
        HXP.fullscreen = userConfig.fullscreen;
        _music.volume = userConfig.musicVolume;
        HXP.engine.popScene();
    }

    public function save() {
        MSX.setUserConfig(_userConfig);
        HXP.engine.popScene();
    }

    function settings(titleHeight:Int) {
        var y = MSX.PADY_TITLE + titleHeight + MSX.PADY_TITLE;
        var w = Math.floor((HXP.width / 2) - (MSX.PADCTL / 2));
        var musicTitle = new Text('Music Volume', 0, y, w, 0, {
            align: TextFormatAlign.RIGHT,
            font: MSX.FONT,
            size: MSX.FONT_SIZE_CTL
        });
        y += musicTitle.height + MSX.PADCTL;
        var soundTitle = new Text('Sound Volume', 0, y, w, 0, {
            align: TextFormatAlign.RIGHT,
            font: MSX.FONT,
            size: MSX.FONT_SIZE_CTL
        });
        y += soundTitle.height + MSX.PADCTL;
        var fullscreenTitle = new Text('Fullscreen', 0, y, w, 0, {
            align: TextFormatAlign.RIGHT,
            font: MSX.FONT,
            size: MSX.FONT_SIZE_CTL            
        });
        // position them vertically
        y += fullscreenTitle.height;
        add(new Entity(musicTitle));
        add(new Entity(soundTitle));
        add(new Entity(fullscreenTitle));

        // add controls
        settingsControls(titleHeight, musicTitle.height);
    }

    function settingsControls(titleHeight:Int, dy:Int) {
        var y = MSX.PADY_TITLE + titleHeight + MSX.PADY_TITLE;
        var w = Math.floor((HXP.width / 2) + (MSX.PADCTL / 2));
        var music = new Slider(w, y, 200, dy, 0.0, 1.0, function (val:Dynamic) {
            _music.volume = _userConfig.musicVolume = val;            
        });
        music.value = _userConfig.musicVolume;
        y += music.height + MSX.PADCTL;
        var sound = new Slider(w, y, 200, dy, 0.0, 1.0, function (val:Dynamic) {
            _userConfig.soundVolume = val;
            _sound.volume = val;
            if (_sound.playing == true) {
                _replaySound = true;
            } else {
                _sound.play();
            }
        });
        sound.value = _userConfig.soundVolume;
        y += sound.height + MSX.PADCTL;
        var fullscreen = new Checkbox(w, y, dy, function (val:Dynamic) {
            HXP.fullscreen = _userConfig.fullscreen = val;
        });
        fullscreen.checked = _userConfig.fullscreen;
        y += fullscreen.height;
        add(music);
        add(sound);
        add(fullscreen);        
    }

    function cancelSave() {
        var cancel = new Button(MSX.PADX, 0, 'Cancel', function(button:Button) {
            cancel();
        });
        var save = new Button(
            MSX.PADX + cancel.width + (MSX.PADCTL),
            0,
            'Save',
            function(button:Button) {
                save();
            }

        );
        var w = MSX.PADX + cancel.width + MSX.PADCTL + save.width + MSX.PADX;
        var l = (HXP.width / 2) - (w / 2);
        cancel.x += l;
        cancel.y += HXP.height - MSX.PADY_TITLE;
        save.x += l;
        save.y += HXP.height - MSX.PADY_TITLE;
        addList([cancel, save]);        
    }

    var _userConfig:Dynamic;
    var _music:Sfx;
    var _sound:Sfx;
    var _replaySound:Bool;
}
