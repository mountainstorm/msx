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

import com.haxepunk.Engine;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Data;
import com.haxepunk.HXP.defaultFont;


class MSX {
    public static var PADX = 10;
    public static var PADY = 10;
    public static var PADCTL = 30; // x distance between controls
    public static var PADY_TITLE = 90; // distance from top of screen to title

    public static var FONT = defaultFont;
    public static var FONT_SIZE_CTL = 40;
    public static var FONT_SIZE_TITLE = 60;
    public static var FONT_SIZE_SCORE = 40;

    public static var COLOR_CTL = 0xFFFFFFFF;
    public static var COLOR_CTL_HIGHLIGHT = 0xFFFF0000;

    public static var MUSIC_TITLE = 'audio/title.ogg';

    public static var SETTINGS = 'settings';
    public static var USER_CONFIG = 'userConfig';
    public static var SCOREBOARD = 'scoreboard';
    public static var SCOREBOARD_MAX = 10;

    public static var SCORE_FORMATER = function(score:Dynamic):String {
        return Std.string(score);
    }

    public static var SCORE_COMPARE = function(score:Dynamic, existingScore:Dynamic):Bool {
        return score > existingScore;
    }

    inline public static function userConfig():Dynamic {
        return Data.read(USER_CONFIG);
    }

    public static function setUserConfig(config:Dynamic) {
        Data.write(USER_CONFIG, config);
        Data.save(SETTINGS, true);
    }

    inline public static function scoreboard():Array<Dynamic> {
        return Data.read(SCOREBOARD);
    }

    public static function setScore(score:Dynamic, ?name:String) {
        var top10 = false;
        var scores = MSX.scoreboard();
        // find the location for this score
        var i = 0;
        for (s in scores) {
            if (SCORE_COMPARE(score, s.score)) {
                break;
            }
            i++;
        }
        if (i < scores.length) {
            scores.insert(i, { score: score, name: name });
            top10 = true;
        }
        // ensure we dont fill up forever
        if (scores.length > SCOREBOARD_MAX) {
            scores.splice(SCOREBOARD_MAX, scores.length - SCOREBOARD_MAX);
        }

        Data.write(SCOREBOARD, scores);
        Data.save(SETTINGS, true);
        return top10;
    }

    public static function init(?overrides:Dynamic, ?defaultScore:Int->Dynamic) {
        // overrride values specified
        if (overrides != null) {
            for (key in Reflect.fields(overrides)) {
                Reflect.setField(MSX, key, Reflect.field(overrides, key));
            }
        }

        // load the settings and make sure there are some defaults
        Data.load(SETTINGS);
        var userConfig = Data.read(USER_CONFIG, { 
            'musicVolume': 1.0,
            'soundVolume': 1.0,
            'fullscreen': false
        });
        // write them back as it allows us to call Data.read without default
        Data.write(USER_CONFIG, userConfig);

        // do the same with the scores
        var defaultScoreboard = [];
        for (i in 0...SCOREBOARD_MAX) {
            var score = 0;
            if (defaultScore != null) {
                score = defaultScore(i);
            }
            defaultScoreboard.push({ score: score, name: 'AAA' });
        }
        var scoreboard = Data.read(SCOREBOARD, defaultScoreboard);
        Data.write(SCOREBOARD, scoreboard);
        Data.save(SETTINGS, true);

        // set fullscreen if its required
        HXP.fullscreen = userConfig.fullscreen;
    }
}
