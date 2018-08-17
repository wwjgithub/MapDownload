package {

import flash.display.Sprite;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

public class Main extends Sprite {
    private var shengs:Array=[];
    private var shis:Array=[];
    private var qus:Array=[];
    private var xians:Array=[];
    private var curSheng:String;
    public function Main() {
        var l:URLLoader = new URLLoader();
        l.dataFormat = URLLoaderDataFormat.TEXT;
        l.addEventListener(Event.COMPLETE, onLoadChina);
        l.load(new URLRequest("China.json"));
    }

    private function onLoadChina(event:Event):void {
        var s:String = event.currentTarget.data;
        var json:Object = JSON.parse(s)
        var features:Array=json.features;
        for (var i:int = 0; i < features.length; i++) {
            var feature:Object = features[i];
            var name:String=feature.properties.name;
            var id=feature.id;
            shengs.push(name);
        }
        if(shengs.length>0){
            loadSheng(shengs.pop());
        }
    }

    private function loadSheng(obj):void {
        curSheng=obj;
        mkdir(curSheng);
        var l:URLLoader = new URLLoader();
        l.dataFormat = URLLoaderDataFormat.TEXT;
        l.addEventListener(Event.COMPLETE, onLoadSheng);
        l.load(new URLRequest("http://restapi.amap.com/v3/config/district?subdistrict=1&extensions=all&key=9d4f5c2078ba12cb9d9d09c4e81c95d0&s=rsv3&output=json&level=province&keywords="+curSheng));
    }

    private function onLoadSheng(event:Event):void {
        var s:String = event.currentTarget.data;
        saveSheng(s);
        var json:Object = JSON.parse(s);

        var districts:Array=json.districts[0].districts;
        for (var i:int = 0; i < districts.length; i++) {
            var feature:Object = districts[i];
            var name:String=feature.name;
            shis.push(name);
        }
        if(shis.length>0){
            loadShi(shis.pop());
        }
    }

    private function saveSheng(s:String):void {
        var f:File = new File(File.applicationDirectory.nativePath + "/" +curSheng+"/"+curSheng+".json");
        var aa:FileStream = new FileStream();
        aa.open(f, FileMode.WRITE);
        aa.writeUTFBytes(s);
        aa.close();
    }

    private function loadShi(pop:Object):void {
        curSheng=obj;
        mkdir(curSheng);
        var l:URLLoader = new URLLoader();
        l.dataFormat = URLLoaderDataFormat.TEXT;
        l.addEventListener(Event.COMPLETE, onLoadSheng);
        l.load(new URLRequest("http://restapi.amap.com/v3/config/district?subdistrict=1&extensions=all&key=9d4f5c2078ba12cb9d9d09c4e81c95d0&s=rsv3&output=json&level=province&keywords="+curSheng));
    }

    private function mkdir(sheng:String,shi:String=null,qu:String=null,xian:String=null):void {
        var f:File = new File(File.applicationDirectory.nativePath + "/" +sheng + (shi == null ? "" : ("/" + shi)) + (qu == null ? "" : ("/" + qu)) + (xian == null ? "" : ("/" + xian)));
        trace(f.nativePath)
        f.createDirectory();
    }

}
}
