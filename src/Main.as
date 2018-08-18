package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;

    public class Main extends Sprite {
        private var shengs:Array = [];
        private var shis:Array = [];
        private var xians:Array = [];
        private var curSheng:String;
        private var curShi:String;
        private var curXian:String;

        public function Main() {
            var l:URLLoader = new URLLoader();
            l.dataFormat = URLLoaderDataFormat.TEXT;
            l.addEventListener(Event.COMPLETE, onLoadChina);
            //l.load(new URLRequest("China.json"));
            //湖北省,内蒙古自治区,山东省,辽宁省,上海市,陕西省,贵州省,西藏自治区,重庆市,安徽省,湖南省,海南省,福建省,澳门特别行政区,江苏省,宁夏回族自治区,江西省,青海省,广西壮族自治区,浙江省,香港特别行政区,山西省,台湾省,河北省,甘肃省,北京市,云南省,天津市,四川省,吉林省
            this.loadSheng("湖北省")
        }

        private function onLoadChina(event:Event):void {
            var s:String = event.currentTarget.data;
            var json:Object = JSON.parse(s)
            var features:Array = json.features;
            for (var i:int = 0; i < features.length; i++) {
                var feature:Object = features[i];
                var name:String = feature.properties.name;
                var id = feature.id;
                shengs.push(name);
            }
            trace(shengs)
            if (shengs.length > 0) {
                //loadSheng(shengs.pop());
            }
        }

        private function loadSheng(obj):void {
            curSheng = obj;
            mkdir(curSheng);
            var l:URLLoader = new URLLoader();
            l.dataFormat = URLLoaderDataFormat.TEXT;
            l.addEventListener(Event.COMPLETE, onLoadSheng);
            l.addEventListener(IOErrorEvent.IO_ERROR, onLoadShengError)
            l.load(new URLRequest("http://restapi.amap.com/v3/config/district?subdistrict=1&extensions=all&key=9d4f5c2078ba12cb9d9d09c4e81c95d0&s=rsv3&output=json&level=province&keywords=" + curSheng));
        }

        private function onLoadShengError(event:IOErrorEvent):void {
            trace("onLoadShengError", curSheng)
            if (shengs.length == 0) {
                trace("end sheng")
            } else {
                loadSheng(shengs.pop());
            }
        }

        private function onLoadSheng(event:Event):void {
            var s:String = event.currentTarget.data;
            saveSheng(s);
            var json:Object = JSON.parse(s);
            var districts:Array = json.districts[0].districts;
            for (var i:int = 0; i < districts.length; i++) {
                var feature:Object = districts[i];
                var name:String = feature.name;
                shis.push(name);
            }
            if (shis.length > 0) {
                loadShi(shis.pop());
            }else{
                if(shengs.length>0) {
                    loadSheng(shengs.pop())
                }else{
                    trace("end")
                }
            }
        }

        private function loadShi(pop:String):void {
            curShi = pop;
            mkdir(curSheng, curShi);
            var l:URLLoader = new URLLoader();
            l.dataFormat = URLLoaderDataFormat.TEXT;
            l.addEventListener(Event.COMPLETE, onLoadShi);
            l.addEventListener(IOErrorEvent.IO_ERROR, onLoadShiError)
            //
            l.load(new URLRequest("http://restapi.amap.com/v3/config/district?subdistrict=1&extensions=all&key=9d4f5c2078ba12cb9d9d09c4e81c95d0&s=rsv3&output=json&level=city&keywords=" + curShi));
        }

        private function onLoadShiError(event:IOErrorEvent):void {
            trace("onLoadShiError", curShi)
            if (shis.length == 0) {
                if (shengs.length == 0) {
                    trace("end")
                } else {
                    loadSheng(shengs.pop());
                }
            } else {
                loadShi(shis.pop())
            }
        }

        private function onLoadShi(event:Event):void {
            var s:String = event.currentTarget.data;
            saveShi(s);
            var json:Object = JSON.parse(s);
            var districts:Array = json.districts[0].districts;
            for (var i:int = 0; i < districts.length; i++) {
                var feature:Object = districts[i];
                var name:String = feature.name;
                xians.push(name);
            }
            if (xians.length > 0) {
                loadXian(xians.pop());
            }else{
                if(shis.length>0) {
                    loadShi(shis.pop());
                }else{
                    if(shengs!=null&&shengs.length>0) {
                        loadSheng(shengs.pop());
                    }else{
                        trace("end")
                    }
                }
            }
        }

        private function loadXian(pop:String):void {
            curXian = pop;
            mkdir(curSheng, curShi);
            var l:URLLoader = new URLLoader();
            l.dataFormat = URLLoaderDataFormat.TEXT;
            l.addEventListener(Event.COMPLETE, onLoadXian);
            l.addEventListener(IOErrorEvent.IO_ERROR, onLoadXianError)
            l.load(new URLRequest("http://restapi.amap.com/v3/config/district?subdistrict=1&extensions=all&key=9d4f5c2078ba12cb9d9d09c4e81c95d0&s=rsv3&output=json&level=district&keywords=" + curXian));
        }

        private function onLoadXianError(event:IOErrorEvent):void {
            trace("onLoadXianError", curXian)
            if (xians.length == 0) {
                if (shis.length == 0) {
                    if (shengs.length == 0) {
                        trace("end")
                    } else {
                        loadSheng(shengs.pop());
                    }
                } else {
                    loadShi(shis.pop())
                }
            } else {
                loadXian(xians.pop())
            }
        }

        private function onLoadXian(event:Event):void {
            var s:String = event.currentTarget.data;
            saveXian(s);
            if (xians.length == 0) {
                if (shis.length == 0) {
                    if (shengs.length == 0) {
                        trace("end")
                    } else {
                        loadSheng(shengs.pop());
                    }
                } else {
                    loadShi(shis.pop())
                }
            } else {
                loadXian(xians.pop())
            }
        }

        private function saveXian(s:String):void {
            var f:File = new File(File.applicationDirectory.nativePath + "/" + curSheng + "/" + curShi + "/" + curXian + ".json");
            trace("保存县地图:" + f.nativePath)
            var aa:FileStream = new FileStream();
            aa.open(f, FileMode.WRITE);
            aa.writeUTFBytes(s);
            aa.close();
        }

        private function saveShi(s:String):void {
            var f:File = new File(File.applicationDirectory.nativePath + "/" + curSheng + "/" + curShi + ".json");
            trace("保存市地图:" + f.nativePath)
            var aa:FileStream = new FileStream();
            aa.open(f, FileMode.WRITE);
            aa.writeUTFBytes(s);
            aa.close();
        }

        private function saveSheng(s:String):void {
            var f:File = new File(File.applicationDirectory.nativePath + "/" + curSheng + ".json");
            trace("保存省地图:" + f.nativePath)
            var aa:FileStream = new FileStream();
            aa.open(f, FileMode.WRITE);
            aa.writeUTFBytes(s);
            aa.close();
        }

        private function mkdir(sheng:String, shi:String = null, qu:String = null, xian:String = null):void {
            var f:File = new File(File.applicationDirectory.nativePath + "/" + sheng + (shi == null ? "" : ("/" + shi)) + (qu == null ? "" : ("/" + qu)) + (xian == null ? "" : ("/" + xian)));
            //trace(f.nativePath)
            f.createDirectory();
        }
    }
}
